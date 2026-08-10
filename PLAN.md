# RenderWare 3.7.2 — GNU make → CMake migration (Win32)

## Context

`D:\RW_372_src` holds a RenderWare Graphics 3.7.2 SDK drop with **no version control** and two parallel trees:

- **`RWSDK/`** — the canonical tree. 559 `.c`, 610 `.h`, the complete GNU make build system (`makefile`, `makeincl/`, ~100 per-library makefiles), the `buildtools/` sources, `dllsrc/`, every `rperror.def`, and the MASM includes.
- **`RenderWare/`** — a mechanically flattened one-directory-per-library copy of the same sources, carrying **223 Visual Studio 2022 files** (1 `.sln`, 74 `.vcxproj`, 74 `.filters`, 74 `.user`, all `PlatformToolset v143`) plus a snapshot of generated public headers in `inc/`.

The GNU make system is unbuildable on a modern box: it shells out to bundled Cygwin binaries (`RWSDK/bin/sh.exe`, `sed.exe`, `make.exe`, `dlltool.exe`), hardcodes `SHELL = ./bin/sh.exe`, dispatches compiler flags through 11 hand-written `makecom` files for compilers that no longer exist (`visualc`, `net`, `intel50`, `vectorc`, `cwpc`), and drives everything from a hand-edited `options.mak`. The VS2022 solution is not a viable replacement either — **every one of its 74 projects has an empty compile ItemGroup**; it is an unpopulated scaffold, not a build.

The outcome: a single CMake build rooted at `RWSDK/`, producing the same 74 static libraries and the optional amalgamated DLL, exposing every option the make system exposed, targeting Win32 only, with the other platforms present as explicit, discoverable stubs — under git from the first commit.

### Verified tree comparison (md5 of all 3,774 files)

Do **not** assume `RenderWare/` is a pure duplicate. It is not:

| Direction | Content |
|---|---|
| In `RenderWare/`, absent from `RWSDK/` | **`tool/rttiff/libtiff/tif_rw.c`** — a real source file (323 lines, RenderWare-specific TIFF stream I/O). `RWSDK/tool/tiff/makefile:35` **references it**, so `rttiff` cannot build from `RWSDK` alone. Also 11 generated public headers (`rwcore.h`, `rwplcore.h`, `rpworld.h`, `rpskin.h`, `rpmatfx.h`, `rppatch.h`, `rptoon.h`, `rpptank.h`, `rpprtstd.h`, `rpprtadv.h`, `rpdmorph.h`) and 62 `.rpe` files — all build outputs. Plus the 223 VS2022 files. |
| In `RWSDK/`, absent from `RenderWare/` | All `buildtools/` sources (`incgen` main.c/main.h/lexer.c/lexer.l, `inline.cpp`, `findsyms.c`, `cwpath/main.c`), all of `dllsrc/` (`rwgdllep.c`, `resource.h`, `rwgdll.rc`, `rwgdllfx.sed`), every `rperror.def`, `makeincl/rwos/win/masm/macros.i`, `nasm/nasm.i`, all makefiles, `bin/`, `docs/`. |
| Differing content, same file | Only `skind3d9matfxtoon.c` (`../toon/` → `../rptoon/` include paths, an artefact of the flattening — `RWSDK`'s copy is correct for its layout) and the 4 `inc/` headers that shadow identical plugin-local sources. |

`RenderWare/rwcore/` and `RenderWare/rwplcore/` are byte-identical copies of each other and of `RWSDK/src/`.

### Decisions taken

| Decision | Choice |
|---|---|
| Build source | `RWSDK/`; harvest `tif_rw.c`, snapshot `RenderWare/inc/` as a golden reference, then delete `RenderWare/` |
| Generated headers | Build `incgen` / `inline` / `findsyms` from source as CMake host tools; generate at build time |
| Default render target | `d3d9` (Windows SDK only); `d3d8` gated behind a legacy DX SDK find-module |
| Architecture | x86 / Win32 only; hard configure error on x64 |

---

## Phase 0 — Source control and tree surgery

Nothing else starts until this is committed.

1. `git init` at `D:\RW_372_src` (`main`).
2. Write `.gitignore`: `build*/`, `out/`, `.vs/`, `CMakeUserPresets.json`, `RWSDK/lib/`, `RWSDK/include/`, `RWSDK/dll/`, `RWSDK/obj/`, `RWSDK/dep/`, `RWSDK/autodocs/`, `*.user`, `*.suo`, `*.sdf`, `*.ncb`, `*.aps`.
3. Add `.gitattributes`: `* text=auto eol=crlf`, plus `-text` for `*.exe *.dll *.pdf *.chm *.sit *.pdx` (the tree ships 65MB with 24 prebuilt `.exe` and 3 `.dll` under `RWSDK/bin/` and `RWSDK/buildtools/`). 65MB / 3,774 files — no LFS needed.
4. **Commit 1 — pristine import.** The tree exactly as received, both trees intact, zero edits. This is the recoverable baseline.
5. **Commit 2 — harvest and prune**, in this order:
   - `RenderWare/tool/rttiff/libtiff/tif_rw.c` → `RWSDK/tool/tiff/libtiff/tif_rw.c`
   - `RenderWare/inc/` → `reference/generated-headers-3.7.2/` (73 files: 11 headers + 62 `.rpe`, used later to diff CMake-generated output against known-good)
   - Delete `RenderWare/` entirely. This removes all 223 VS2022 files. **Removal criterion:** any `.sln` with `Format Version 12.00` or a `.vcxproj` whose `<PlatformToolset>` is `v141`/`v142`/`v143` (VS2017/2019/2022) is a modern project and goes; nothing in this tree predates that, so the whole set is removed. Confirm none survive with `git ls-files | grep -Ei '\.(sln|vcxproj|vcxproj\.filters|vcxproj\.user|suo)$'` returning empty.
6. Branch `feature/cmake-migration` for everything below. Keep the legacy makefiles in-tree throughout the port — they are the specification, and deleting them is a separate final commit only after parity is demonstrated.

---

## Phase 1 — Option surface (`cmake/RWOptions.cmake`)

Replaces `RWSDK/makeincl/makeopt` and `options.mak.sample`. Every make variable maps to a cache entry; nothing is silently dropped.

**Feature defines** (each appends one `-D` exactly as `makeopt` lines 276–349 do):

| CMake option | make var | Default | Define emitted |
|---|---|---|---|
| `RW_DEBUG` | `RWDEBUG` | OFF | `RWDEBUG` |
| `RW_VALIDATE_PARAM` | `RWVALIDATEPARAM` | =`RW_DEBUG` | `RWVALIDATEPARAM` |
| `RW_TRACE` | `RWTRACE` | OFF | `RWTRACE` |
| `RW_METRICS` | `RWMETRICS` | OFF | `RWMETRICS` |
| `RW_MEMDEBUG` | `RWMEMDEBUG` | OFF | `RWMEMDEBUG` |
| `RW_VERBOSE` | `RWVERBOSE` | OFF | `RWVERBOSE` |
| `RW_STACK_DEPTH_CHECKING` | `RWSTACKDEPTHCHECKING` | OFF | `RWSTACKDEPTHCHECKING` |
| `RW_EVALUATION` | `RWEVALUATION` | OFF | `RWEVALUATION` |
| `RW_USE_SPF` | `RW_USE_SPF` | OFF | `RW_USE_SPF` |
| `RW_SUPPRESS_INLINE` | `RWSUPPRESSINLINE` | OFF | `RWSUPPRESSINLINE` |
| `RW_SUPPRESS_OPTIMIZATION_PRAGMAS` | `RWSUPPRESSOPTIMIZATIONPRAGMAS` | OFF | `RWSUPPRESSOPTIMIZATIONPRAGMAS` |
| `RW_IBM_CHAR` | `_IBM_CHAR` | OFF | `_IBM_CHAR` |
| `RW_ONLY_PLCORE` | `RWONLYPLCORE` | OFF | `RWONLYPLCORE` (also prunes all targets but `rwplcore` + `rtfsyst`, per `RWSDK/makefile:49–66`) |
| `RW_SW15` | `RWSW15` | OFF | `FB1555` (also `-DFB1555` to MASM) |
| `RW_COLOUR_DMA` | `COLOURDMA` | OFF | `DMA_COLOUR` (PS2 only — stub) |
| `RW_PS2MANAGER` | `PS2MANAGER` | OFF | `PS2MANAGER` (PS2 only — stub) |
| `RW_NOASM` | `NOASM` | OFF | `NOASM`; drops `GENERICDRVASMSRC` and `ssematml.c` |
| `RW_NOSSEASM` | `NOSSEASM` | OFF | `NOSSEASM` |

**Platform / target selection:**

- `RW_OS` (`RWOS`) — `win` (implemented); `mac` `linux` `sky` `gcn` `xbox` accepted and stubbed.
- `RW_TARGET` (`RWTARGET`) — **default `d3d9`**; `d3d8` `opengl` `null` implemented; `sky2` `gcn` `xbox` `softras` `nullsky` `nullxbox` `nullgcn` stubbed.
- `RW_PIPETYPE` (`PIPETYPE`) — default `p2` (the only pipeline in the tree); `generic` reserved.
- `RW_COMPILER` (`RWCOMPILER`) — **derived, read-only**. CMake detects the toolchain; this is exported only so output paths and the banner match the make system. The 11 `makeincl/rwos/win/rwcmplr/*/makecom` files are not ported; only MSVC is supported.

**Output layout** (reproduces `makeopt` lines 155–248):

- `RW_FULL_PLATFORM` (`RWFULLPLATFORM`, OFF) — `lib/<os>/<compiler>/<target>` vs `lib/<target>`.
- `RW_OUTPUT` (`RWOUTPUT`, empty) — extra path component.
- `RW_31_DIRS` (`RW31DIRS`, OFF) — RW3.1-style flat directories.
- `RW_LIB_PREFIX` (`LIBPREFIX`, empty), `RW_LIB_SUFFIX` (`OPTEXT`, empty).
- Config suffix follows the make precedence exactly: `metrics` → `debug` → `profile` → `mswst` → flat → `release`.

**Configuration mapping.** `CDEBUG` / `COPTIMIZE` / `CPROFILE` / `SMALLCODE` collapse into `CMAKE_BUILD_TYPE`: `Debug` (`-Od -Ob0 -Oy- -Zi -D_DEBUG /MLd`→`/MTd`), `Release` (`-O2 -Ob2 -DNDEBUG`), `RelWithDebInfo` (≈`CPROFILE`, `-O2 -Zi /fixed:no`), `MinSizeRel` (≈`SMALLCODE`, `-O1 -Ob2 /MD`). `RW_MSWST` (`MSWST`) stays a separate option since it is a distinct flag set (`-GX -Gh -Gs -O2 -Ob1 -Oity` + `wst.lib`) and its own output directory.

**Library form:**

- `RW_DLL` (`RWDLL`, OFF) — builds the amalgamated `rwg<target>[d].dll`; forces `/MD` on every static lib, matching `makecom:14–16`.
- `RW_VCAT_RUNTIME_VARIANTS` (`OPTEXT=md`/`mt`) — the extra `rtvcatmd`/`rtvcatmt` libs from `tool/vcat/makefile:56–65`, null-target only.

**Selection:**

- `RW_PLUGINS` / `RW_TOOLKITS` — semicolon lists; empty means all (matches `RWSDK/makefile:33–41`).
- `RW_BUILD_PLUGINS`, `RW_BUILD_TOOLKITS`, `RW_BUILD_BUILDTOOLS` — ON.
- `RW_ARCHIVE_PLUGINS` (`APLUGINS`) — OFF; `makeincl/makeaplg` is ported but no archive plugin ships in this drop.

**External SDK paths:** `RW_DXSDK_DIR` (`DXSDK`), `RW_OGL_LIB_PATH` (`OGLLIBPATH`), and stubs `RW_APPLEGL_SDK_PATH`, `RW_IOP_PATH`, `RW_XBOX_SDK`.

**Documentation / QA:** `RW_BUILD_DOCS` (OFF — the `doxy`/`doc` chain needs `bin/doxycfg`, `hhc`, and `sed`, none of which are portable; port as custom targets that skip with a warning if the tools are absent). `verify` / `longline` / `tabs` / `defgroup` / `csrc` / `maintainers` become optional custom targets. `RWDEPEND` is **dropped** — CMake tracks header dependencies natively.

Configure-time validation replaces the `checkopt` rule: reject non-x86 (`CMAKE_SIZEOF_VOID_P EQUAL 8` → `FATAL_ERROR`, since the MASM sources and the inline `__asm` in `cpuext.c`, `ssematml.c`, `ptank*.c`, `ssematbl.c`, `x86matbl.c`, `ostypes.h` are 32-bit only and MSVC rejects inline asm on x64), reject unimplemented `RW_OS`/`RW_TARGET` combinations with a message naming the stub file to fill in, and print the `Building RenderWare target / Using compiler / Using operating system` banner from `RWSDK/makefile:27–31`.

---

## Phase 2 — Host build tools (`RWSDK/buildtools/CMakeLists.txt`)

Four executables, compiled from source, excluded from `all` install:

- **`incgen`** — `buildtools/incgen/{main.c,main.h,lexer.c}`. Use the checked-in `lexer.c`; do **not** require flex (`lexer.l` is kept for reference only).
- **`inline`** — `buildtools/inline/inline.cpp`.
- **`findsyms`** — `buildtools/findsyms/findsyms.c`.
- **`cwpath`** — `buildtools/cwpath/main.c`. Built for completeness; unused on the MSVC path.

Since the build is x86-only and hosted on Windows, these compile for the host directly — no cross-compile export/import dance. Guard for that as a documented future concern only.

---

## Phase 3 — Code generation (`cmake/RWCodegen.cmake`)

Three generators, each an `add_custom_command` fronted by a function. These replace the pattern rules in `makeopt:512–536`, `makecore:184–195`, `makeplug:119–124`, and `makewrld:78–88`.

- **`rw_generate_rpe(<plugin>)`** — preprocess `src/plcore/rperror.h` with `cl /EP` and the plugin's include dir on the path, so the plugin's own `rpplugin.h` and `rperror.def` are picked up, producing `<incdir>/<plugin>.rpe`. 62 of these.
- **`rw_generate_public_header(...)`** — two flavours:
  - `incgen` for `rwplcore.h` / `rwcore.h` (`makecore:184–195`, driven by the `HPLCORE` / `HCORE` lists derived from the `.c` lists) and for `rpworld.h` (`makewrld:78–88`, with `-grwcore.h`).
  - `inline` for plugins declaring `PLUGINAPI` (e.g. `skinapi.h`, `matfxapi.h`, `toonapi.h`, `patchapi.h`) → `headers/<plugin>.<target>.h`, then copied to the include dir (`makeplug:119–124`). Plugins without `PLUGINAPI` just copy their local `rp<name>.h`.
- **`rw_generate_equate()`** — only when `RW_NOASM` is OFF. Compile `driver/common/baequ.c` to assembly (`cl /Fa`), run `findsyms -Fi<baequ.s> -Fo<driver/<target>/baequate.i> -Aml`. Required: `x86matml.asm:17` and `x86matvc.asm:17` both `include baequate.i`, and only `driver/null/baequate.i` is checked in — `d3d9`/`d3d8`/`opengl` must generate theirs.

All generated headers land in a single per-config include dir (`SDKINCDIR` equivalent) that every target consumes via `target_include_directories`. `COREHFILES` (`rwversion.h`, `rpcriter.h`, `rpdbgerr.c`, `rpdbgerr.h`, `rperror.h`, `errcom.def`, `errcore.def`) are copied there as in `makecore:166–176`.

A `rw-headers` aggregate target reproduces `make header`, and `rw-equate` reproduces `make equate`.

---

## Phase 4 — Core libraries

`RWSDK/src/CMakeLists.txt` ports `src/makefile` + `makeincl/makecore`, producing two libraries from one source set (the split is the whole point of `makecore`):

- **`rwplcore`** — `PLCOREINITCSRC` (`plcore/baplcore.c`) + `STUBDRVCSRC` (`driver/stub/sbdevice.c`) + `PLCORECSRC` (18 files from `src/plcore/` per `src/makefile:8–26`) + `os/win/osintf.c`.
- **`rwcore`** — `rwplcore`'s objects plus `CSRC` (14 files in `src/`), `PIPECSRC` (11 files from `src/pipe/p2/`, per `makeincl/rwtarget/pipe/p2/maketarg`), `PIPEPSCSRC` (target-specific pipe files), the driver sources, and the MASM objects. Model `rwplcore` as an `OBJECT` library so `rwcore` links its objects without duplicating compilation, matching `makecore:156–164` where both archives are cut from overlapping object sets.

`RWSDK/world/CMakeLists.txt` ports `world/makefile` + `makeincl/makewrld` → **`rpworld`** (11 `.c` in `world/` + `world/pipe/p2/bapipew.c` + the target-specific `wrldpipe.c`/`native.c`), with its `incgen`-generated `rpworld.h`.

Enable `ASM_MASM` at the top level. MASM sources (`driver/common/{baprocfp,x86matml,x86matvc}.asm`) need `-I driver/<target>`, `-I makeincl/rwos/win/masm`, `-I src`, and flags `-c -W2 -Cp -Zm -DBCC -DSTACK -coff` from `makecom:84–94`. `barwasmm.asm` is **not** built — it includes `bamacros.i`/`barwasmg.i`, which do not exist in the tree, and no makefile references it.

---

## Phase 5 — Plugins and toolkits

`cmake/RWAddPlugin.cmake` and `cmake/RWAddToolkit.cmake` provide `rw_add_plugin()` / `rw_add_toolkit()`, the direct analogues of `makeincl/makeplug` and `makeincl/maketool` (which are near-identical — one shared implementation with a docs-directory parameter). Each handles: the implicit `<plugin>.c`, the `u<plugin>.obj` unique-name copy of `rpdbgerr.c` when `RW_DEBUG` is on (`makeplug:44–46`), `.rpe` + public-header generation, per-target source selection, and library naming (`LIBNAME` ≠ `PLUGIN` for variants).

**Per-target source selection** is the key mechanic: makefiles declare `d3d8CSRC` / `d3d9CSRC` / `openglCSRC` / `nullCSRC` / `genericCSRC` and `makeplug:63–67` picks `$(RWTARGET)CSRC`, falling back to `genericCSRC`. In CMake this becomes a `RW_TARGET_SOURCES` / `RW_GENERIC_SOURCES` argument pair resolved inside the function.

**34 plugin libraries from 27 directories.** Variants share sources and differ only by `LIBNAME` and extra per-target files — `plugin/skin2/` alone yields `rpskin`, `rpskinmatfx`, `rpskintoon`, `rpskinmatfxtoon` via `makefile.shared{skin,skin2,matfx,matfx2}` (see `plugin/skin2/makefile.skinmatfx:15–18,92–95`); `plugin/patch/` yields `rppatch`, `rppatchmatfx`, `rppatchskin`, `rppatchskinmatfx`; `plugin/normmap/` yields `rpnormmap`, `rpnormmapskin` (both gated on `RW_TARGET STREQUAL d3d9` per `makefile.normmap:68`). Note `plugin/userdata/` → `rpusrdat`.

**37 toolkit libraries from 34 directories** — `tool/mipmapk/` yields `rtmipk`, `rtmipkmatfx`, `rtmipkpatch`, `rtmipkpatchmatfx`. Name mismatches to watch: `brycntrc`→`rtbary`, `gencpipe`→`rtgncpip`, `geomcond`→`rtgcond`, `sknsplit`→`rtskinsp`, `2d`→`rt2d`.

**Bundled third-party**, built as private `OBJECT` libraries consumed by their owner:

- `tool/tiff/libtiff/` — 31 files listed in `tool/tiff/makefile:10–43`, `-DTIF_PLATFORM_CONSOLE`. **Includes the harvested `tif_rw.c`.** The 11 other `.c` present but unreferenced (`tif_win32.c`, `tif_unix.c`, `tif_apple.c`, `mkg3states.c`, …) stay out — `tif_rw.c` is RenderWare's replacement for the platform I/O module.
- `tool/png/lpng1012/` and `tool/png/zlib113/` — consumed by `rtpng`.

`rtvcat` compiles `xbstrip.cpp` (the only C++ in the library set) and needs `/GX-` on win (`tool/vcat/makefile:32–34`).

---

## Phase 6 — DLL (`RWSDK/dllsrc/CMakeLists.txt`)

Ports `makeincl/makedll`, gated on `RW_DLL` and rejected for targets outside `null|d3d8|d3d9|opengl` (`makedll:17–28`). The original pipeline is: `dlltool --export-all-symbols` over the 60-odd static libs → `.def` → `sed -f rwgdllfx.sed` → link.

`dlltool.exe` and `sed.exe` are bundled Cygwin binaries. **Replace them**: use `dumpbin /SYMBOLS` (or `llvm-nm`) plus a small CMake-script filter that applies the same rules `dllsrc/rwgdllfx.sed` encodes, so the build has no Cygwin dependency. Read `rwgdllfx.sed` first and reproduce its transforms exactly.

The lib list is explicit and picks the most-combined variant of each family to avoid duplicate symbols (`makedll:62–151`), plus target-conditional entries (`rplogo` for non-null, `rpnormmapskin` for null/d3d9, `rtvcatmd` vs `rtvcat`). Compile `rwgdllep.c`, compile `rwgdll.rc` with `rc`, link with `/dll /fixed:no /largeaddressaware /incremental:no /def:...` and `MSVCRT[d].lib`. Output `rwg<target>[d].dll`.

This phase is **optional for parity** — land it after Phase 8 if the static libs need to ship first.

---

## Phase 7 — Platform and target stubs

Two directories of small include files, each either implementing or refusing clearly:

`cmake/platforms/` — `win.cmake` (implemented; ports `makeincl/rwos/win/makeos` and the MSVC parts of `rwcmplr/visualc/makecom`), plus `mac.cmake`, `linux.cmake`, `sky.cmake`, `gcn.cmake`, `xbox.cmake`. Each stub sets the variables it would need, comments the source lists already discoverable in the makefiles, and ends with `message(FATAL_ERROR "RW_OS=<x> is not implemented. Fill in cmake/platforms/<x>.cmake.")`.

`cmake/targets/` — `d3d9.cmake`, `d3d8.cmake`, `opengl.cmake`, `null.cmake` implemented from `makeincl/rwtarget/*/maketarg`; `sky2.cmake`, `gcn.cmake`, `xbox.cmake`, `softras.cmake` stubbed the same way. Each implemented file declares `GENERICDRVCSRC`, `SPECIFICDRVCSRC`, `DRVLIB`, `DRVINC`, `DRVDEF` exactly as its `maketarg` does.

`cmake/FindDX8SDK.cmake` locates `d3d8.h` / `d3d8.lib` / `dxguid.lib` from `RW_DXSDK_DIR` or `DXSDK_DIR`, and fails configure with an explicit message when `RW_TARGET=d3d8` and no legacy SDK is present. `d3d9` resolves against the Windows SDK with no extra input; `opengl` links `opengl32` + `gdi32`; `null` needs nothing.

---

## Phase 8 — Install, export, presets

- `install()` the 74 libs, the generated public headers, and (when `RW_DLL`) the DLL, into the `SDKLIBDIR`/`SDKINCDIR` layout computed in Phase 1, so existing consumers of `rwsdk/lib/<target>/<config>/` keep working.
- Export a `RenderWareConfig.cmake` with namespaced `RenderWare::rwcore`, `RenderWare::rpworld`, … targets.
- `CMakePresets.json` at repo root: `win32-d3d9-debug`, `win32-d3d9-release`, `win32-d3d8-release`, `win32-opengl-release`, `win32-null-release`, `win32-d3d9-metrics`, `win32-d3d9-dll`, each pinning `-A Win32`.
- Root `README.md` documenting the option table and the `options.mak` → CMake mapping. `RWSDK/options.mak.sample` stays in-tree as the historical reference.

---

## Verification

Parity, in order — each step must pass before the next:

1. **Configure matrix.** All seven presets configure clean. `-A x64` fails with the intended message. `RW_TARGET=d3d8` without a DX SDK fails with the intended message.
2. **Generated-header parity.** Diff CMake output against `reference/generated-headers-3.7.2/`: `rwcore.h`, `rwplcore.h`, `rpworld.h`, and the 8 `inline`-produced plugin headers, plus all 62 `.rpe`. Expect byte-identical or whitespace-only differences; investigate anything else — this is the single strongest signal that `incgen`/`inline` are being driven correctly.
3. **Full build.** `cmake --build --preset win32-d3d9-release` produces all 74 `.lib`. Confirm the count and names against the 74 `.vcxproj` names recorded before deletion (they enumerate exactly the same library set — a useful independent cross-check).
4. **Assembly path.** With `RW_NOASM=OFF`, confirm `driver/d3d9/baequate.i` is generated and the three MASM objects link into `rwcore`. Then confirm `RW_NOASM=ON` builds clean and drops them.
5. **Option sweep.** Build `RW_DEBUG=ON`, `RW_METRICS=ON`, `RW_TRACE=ON`, `RW_ONLY_PLCORE=ON` (expect only `rwplcore` + `rtfsyst`), and `RW_PLUGINS=rpworld;rpskin` (expect the subset only). Verify each lands in its own output directory per the Phase 1 layout rules.
6. **Link smoke test.** A minimal `RwEngineInit` / `RwEngineOpen` / `RwEngineStart` console program linked against `rwplcore` + `rwcore` + `rpworld` under `RW_TARGET=null`, run headless. This is the first proof the libraries are actually usable, not merely well-formed archives.
7. **DLL** (if Phase 6 landed): `rwgd3d9.dll` builds, exports a plausible symbol count, and `dumpbin /EXPORTS` shows the `Rw`/`Rp`/`Rt` prefixes with no leaked third-party symbols.

Commit per phase on `feature/cmake-migration`. Delete the legacy makefiles only in a final commit, after step 6 passes.

## Out of scope

x64 (`RW_NOASM` fallbacks exist throughout but have never been exercised there); non-Windows platforms beyond the stubs; the Doxygen/`hhc` documentation chain beyond an optional skipping target; replacing the bundled `RWSDK/bin/` Cygwin binaries for anything other than the DLL `.def` step.