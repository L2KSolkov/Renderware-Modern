# RenderWare 3.7.2 CMake configuration reference

Every option is a CMake cache variable on the `RWSDK/` build tree. Set them
with `-D<NAME>=<value>` on the configure command line, or use one of the
presets in `RWSDK/CMakePresets.json`:

```bat
cd RWSDK
cmake --preset win32-d3d9-release
cmake --build --preset win32-d3d9-release
```

All options below are OFF / empty by default unless stated otherwise. The
legacy make-system variable each one replaces is shown in parentheses, and
the `-D` define (if any) it adds to every compile is listed too - this is the
complete `options.mak` surface with nothing silently dropped. The one
deliberate removal is `RWDEPEND`: CMake tracks header dependencies natively.

---

## Feature flags

| Flag | make var | Define | Purpose |
|---|---|---|---|
| `RW_DEBUG` | `RWDEBUG` | `RWDEBUG` | Turn on RenderWare debug code paths (asserts, debug error/debugger support). Also switches `RW_VALIDATE_PARAM` to ON unless overridden, selects the `debug` output directory, and switches to the debug runtime (`/MTd` or `/MDd` under `RW_DLL`). |
| `RW_VALIDATE_PARAM` | `RWVALIDATEPARAM` | `RWVALIDATEPARAM` | Parameter validation in public API entry points. Defaults to `RW_DEBUG` (i.e. ON in Debug builds) but can be set independently. |
| `RW_TRACE` | `RWTRACE` | `RWTRACE` | Function-call trace messages to the RenderWare debug log. Note: the shipped `plugin/hanim/stdkey.c` does not use the `RWFUNCTION` entry macro the trace machinery requires, so a full `RW_TRACE` build fails to compile that file - an upstream defect the original make build hits identically. |
| `RW_METRICS` | `RWMETRICS` | `RWMETRICS` | Performance metrics support; adds the target-specific metric sources (e.g. `driver/d3d9/d3d9metric.c`) and selects the `metrics` output directory (highest config-dir precedence). |
| `RW_MEMDEBUG` | `RWMEMDEBUG` | `RWMEMDEBUG` | Memory-debug instrumentation; marked internal/CSL use in the original makefiles. |
| `RW_VERBOSE` | `RWVERBOSE` | `RWVERBOSE` | Verbose debug instrumentation; internal/CSL use. |
| `RW_STACK_DEPTH_CHECKING` | `RWSTACKDEPTHCHECKING` | `RWSTACKDEPTHCHECKING` | Stack-depth checks on non-`RWTRACE` builds (not thread safe, per the original comment). |
| `RW_EVALUATION` | `RWEVALUATION` | `RWEVALUATION` | Evaluation build; adds `src/bacamval.c` to `rwcore` and defines `RWEVALUATION`. |
| `RW_USE_SPF` | `RW_USE_SPF` | `RW_USE_SPF` | Single-precision floating-point maths. |
| `RW_SUPPRESS_INLINE` | `RWSUPPRESSINLINE` | `RWSUPPRESSINLINE` | Suppress RenderWare's own inlining. |
| `RW_SUPPRESS_OPTIMIZATION_PRAGMAS` | `RWSUPPRESSOPTIMIZATIONPRAGMAS` | `RWSUPPRESSOPTIMIZATIONPRAGMAS` | Suppress the optimization pragmas RenderWare emits. |
| `RW_IBM_CHAR` | `_IBM_CHAR` | `_IBM_CHAR` | IBM character-set compatibility mode. |
| `RW_ONLY_PLCORE` | `RWONLYPLCORE` | `RWONLYPLCORE` | Build only `rwplcore` plus the `rtfsyst` toolkit (the make system's `makefile:49-66` prune); everything else is skipped. |
| `RW_SW15` | `RWSW15` | `FB1555` | 15-bit rasterisation; also passes `-DFB1555` to the MASM sources. |
| `RW_COLOUR_DMA` | `COLOURDMA` | `DMA_COLOUR` | PS2 colour-DMA support. PS2 is a stub in this port; kept for surface parity. |
| `RW_PS2MANAGER` | `PS2MANAGER` | `PS2MANAGER` | PS2 manager support. PS2 is a stub; kept for surface parity. |
| `RW_NOASM` | `NOASM` | `NOASM` | Use C implementations instead of assembler: drops the three MASM objects (`baprocfp.asm`, `x86matml.asm`, `x86matvc.asm`), the `ssematml.c` driver source (d3d8/d3d9), and disables `baequate.i` generation. |
| `RW_NOSSEASM` | `NOSSEASM` | `NOSSEASM` | Do not compile the SSE assembler helper (`ssematml.c`); only consulted by the OpenGL target, exactly as in the makefiles. |

## Platform, target and pipeline

| Flag | make var | Values | Purpose |
|---|---|---|---|
| `RW_OS` | `RWOS` | `win` (implemented); `mac` `linux` `sky` `gcn` `xbox` | Operating system. The non-`win` values are explicit stubs: configure fails with the name of the `.cmake` file to fill in. |
| `RW_TARGET` | `RWTARGET` | `d3d9` (default), `d3d8`, `opengl`, `null` (implemented); `sky2` `gcn` `xbox` `softras` `nullsky` `nullxbox` `nullgcn` | Render target / driver. Implemented targets come from `cmake/targets/<target>.cmake`; the rest fail configure with a pointer to the stub file. |
| `RW_PIPETYPE` | `PIPETYPE` | `p2` (only one in the tree); `generic` reserved | PowerPipe generation. `generic` fails configure (no generic pipeline sources ship in this drop). |
| `RW_COMPILER` | `RWCOMPILER` | derived, always `visualc` | Read-only. The CMake toolchain is detected; this exists only so output paths and the configure banner match the make system. The 11 `makecom` files for other compilers are not ported - only MSVC is supported (configure rejects other compilers). |

## Output layout

The library directory is `RWSDK/lib/<platform>/[<output>/]<config>`, the
include directory is `RWSDK/include/<platform>`, and the DLL directory is
`RWSDK/dll/<platform>/[<output>/]<config>`.

| Flag | make var | Purpose |
|---|---|---|
| `RW_FULL_PLATFORM` | `RWFULLPLATFORM` | Use `lib/<os>/<compiler>/<target>/...` instead of `lib/<target>/...`. |
| `RW_OUTPUT` | `RWOUTPUT` | Extra path component between the platform dir and the config dir (e.g. a build name). |
| `RW_31_DIRS` | `RW31DIRS` | RW3.1-style flat directories: drops the config suffix entirely (`lib/<platform>`, `include/<platform>`). |
| `RW_LIB_PREFIX` | `LIBPREFIX` | Prefix prepended to every library name (default empty). |
| `RW_LIB_SUFFIX` | `OPTEXT` | Suffix appended to every library name, e.g. `md`, `mt`, `cw` (default empty). |

Config-directory precedence follows the make system exactly:
`metrics` → `debug` → `profile` → `mswst` → flat (`RW31_DIRS`) → `release`.
`RW_METRICS` always wins and selects `metrics`; otherwise the CMake
configuration maps to the suffix (below), unless `RW_31_DIRS` flattens it.

## Build configuration mapping

The old `CDEBUG` / `COPTIMIZE` / `CPROFILE` / `SMALLCODE` switches collapse
into the standard `CMAKE_BUILD_TYPE`:

| `CMAKE_BUILD_TYPE` | make equivalent | Flags | Runtime | Output dir |
|---|---|---|---|---|
| `Debug` | `CDEBUG=1` | `/Od /Ob0 /Oy- /Zi /D_DEBUG` | `/MTd` (`/MDd` under `RW_DLL`) | `debug` |
| `Release` | `COPTIMIZE=1` | `/O2 /Ob2 /DNDEBUG` | `/MT` (`/MD` under `RW_DLL`) | `release` |
| `RelWithDebInfo` | `CPROFILE=1` | `/O2 /Zi /DNDEBUG` | `/MT` | `profile` |
| `MinSizeRel` | `SMALLCODE=1` | `/O1 /Ob2 /DNDEBUG` | `/MD` | `release` |

Legacy flags mapped to modern equivalents: `/ML(/d)` single-threaded runtime
becomes `/MT(/d)`; `/GX` becomes `/EHsc`; the combined `-Oity`/`-Ob0gity`
forms are replaced by their plain modern forms. Every compile also carries
the base flag set from `makecom` (`/nologo /W3 /Zl`) and the base defines
(`WIN32 _WINDOWS _MBCS __MSC__ VC_EXTRALEAN WIN32_EXTRA_LEAN
WIN32_LEAN_AND_MEAN`).

| Flag | make var | Purpose |
|---|---|---|
| `RW_MSWST` | `MSWST` | Microsoft Working Set Tuner build: the distinct flag set (`/DNDEBUG /EHsc /Gh /Gs /O2 /Ob1 /Zi` + `wst.lib` in the original) and its own `mswst` output directory. |

### Decoupled compile-mode flags

The four switches the table above derives from `CMAKE_BUILD_TYPE` are also
exposed directly as `AUTO`/`ON`/`OFF` cache options. `AUTO` keeps the
derivation from the build type; setting any one of them to `ON` or `OFF`
switches the whole group to manual mode, where the remaining `AUTO` entries
resolve to their make-system defaults (`0`) and everything - compile flags,
runtime, output directory, DLL `d` suffix - follows the resolved switches.

| Flag | make var | AUTO resolution | ON |
|---|---|---|---|
| `RW_CDEBUG` | `CDEBUG` | Debug config | `/Zi /D_DEBUG /UNDEBUG`, debug CRT (`/MTd`, `/MDd` under `RW_DLL`), `debug` output dir, DLL `d` suffix |
| `RW_CPROFILE` | `CPROFILE` | RelWithDebInfo config | `/O2 /Zi /U_DEBUG /DNDEBUG` (+ `/Ob0` when `RW_COPTIMIZE=OFF`), `/MT`, `profile` output dir |
| `RW_COPTIMIZE` | `COPTIMIZE` | OFF when `RW_CDEBUG`/`RW_CPROFILE`/`RW_MSWST` are on, else ON | `/O2 /Ob2` (or `/O1 /Ob2` with `RW_SMALLCODE`); OFF gives `/Od /Ob0 /Oy-` |
| `RW_SMALLCODE` | `SMALLCODE` | MinSizeRel config | `/O1 /Ob2` and `/MD` runtime |

`RW_MSWST` stays a plain `ON`/`OFF` option and participates in the same
resolution (it implies `RW_COPTIMIZE` AUTO = OFF, and its own flag set and
`mswst` output dir win unless `RW_CDEBUG`/`RW_CPROFILE` are on).

Examples:

```bat
:: unoptimised release build (make's COPTIMIZE=0)
cmake -S RWSDK -B build/noopt -A Win32 -DRW_TARGET=null -DRW_COPTIMIZE=OFF

:: debug flags under a Release-style build, output in lib/<target>/debug
cmake -S RWSDK -B build/dbg -A Win32 -DRW_TARGET=null -DRW_CDEBUG=ON

:: profiling build independent of the build type
cmake -S RWSDK -B build/prof -A Win32 -DRW_TARGET=null -DRW_CPROFILE=ON

:: optimised debug (make's CDEBUG=1 with COPTIMIZE=1)
cmake -S RWSDK -B build/optdbg -A Win32 -DRW_TARGET=null ^
      -DRW_CDEBUG=ON -DRW_COPTIMIZE=ON
```

## Library form

| Flag | make var | Purpose |
|---|---|---|
| `RW_DLL` | `RWDLL` | Build the amalgamated `rwg<target>[d].dll` (e.g. `rwgd3d9.dll`, `rwgnull.dll`; `d` suffix for Debug). Forces `/MD` on every static library, matching `makecom`, and defers target driver libs to the DLL link. Only `null`, `d3d8`, `d3d9`, `opengl` are allowed (rejected otherwise, as in `makedll`). |
| `RW_VCAT_RUNTIME_VARIANTS` | `OPTEXT=md`/`mt` | Also build `rtvcatmd` and `rtvcatmt` (the exporter runtime variants from `tool/vcat/makefile`). Null target only. |

## Selection

| Flag | make var | Purpose |
|---|---|---|
| `RW_PLUGINS` | `PLUGINS` | Semicolon list of plugins to build; empty means all. Entries may be directory names or primary library names (`skin2` or `rpskin`). A subset must include every plugin whose generated header is included by the selected ones (e.g. `rpskin` pulls in `rphanim`, `rptoon`, `rpmatfx`; `rphanim` pulls in `rtquat`/`rtanim`). |
| `RW_TOOLKITS` | `TOOLKITS` | Semicolon list of toolkits to build; empty means all. Same directory-or-library-name matching (`2d` or `rt2d`). |
| `RW_BUILD_PLUGINS` | - | Master switch for the whole plugin tree (default ON). |
| `RW_BUILD_TOOLKITS` | - | Master switch for the whole toolkit tree (default ON). |
| `RW_BUILD_BUILDTOOLS` | - | Build `incgen` / `inline` / `findsyms` / `cwpath` from source (default ON). |
| `RW_ARCHIVE_PLUGINS` | `APLUGINS` | Archive plugins; `makeaplg` is ported but no archive plugin ships in this drop, so configuring it ON only emits a warning. |

The `rtfsyst` headers are always generated even when `RW_TOOLKITS` excludes
the toolkit, because `src/plcore/bastream.c` includes `rtfsyst.h`
unconditionally.

## External SDK paths

| Flag | make var | Purpose |
|---|---|---|
| `RW_DXSDK_DIR` | `DXSDK` | Legacy DirectX SDK root. Required for `d3d8` (`d3d8.h`, `d3d8.lib`, `dxguid.lib`) and for `d3d9` (`d3dx9.h`, `d3dx9.lib` - the D3D9 pipeline uses `D3DXAssembleShader`). Falls back to the `DXSDK_DIR` environment variable, then common install locations. Configure fails with an explicit message when the needed headers/libs are absent. Only the D3D headers are staged into the include path so the legacy SDK's stale system headers cannot shadow the modern Windows SDK. |
| `RW_OGL_LIB_PATH` | `OGLLIBPATH` | Directory containing `opengl32.lib` for the OpenGL target; when empty, CMake resolves `opengl32` from the toolchain. |
| `RW_APPLEGL_SDK_PATH` | `APPLEGLSDKPATH` | Apple OpenGL SDK path (stub; the mac platform is not implemented). |
| `RW_IOP_PATH` | `IOPPATH` | PS2 IOP modules path (stub). |
| `RW_XBOX_SDK` | `XBOXSDK` | Xbox SDK path (stub). |

## Docs and QA

| Flag | make var | Purpose |
|---|---|---|
| `RW_BUILD_DOCS` | `doxy`/`doc` | The Doxygen/hhc documentation chain. The `doxy`/`doc` targets exist but print a warning and skip: `doxycfg`, `doxygen` and `hhc` are not portable here. Default OFF. |
| `RW_BUILD_QA_TARGETS` | `verify`/`longline`/`tabs`/`defgroup`/`csrc`/`maintainers` | Optional no-op custom targets reproducing the make QA surface (the underlying `rwcheck`/`egrep` tools are not available). Default ON. |

## Derived values (read-only)

These are computed during configure and describe the build; they are shown in
the configure banner (`Building RenderWare target - ...`, `Using compiler -
...`, `Using operating system - ...`) and used for install paths:

| Variable | Meaning |
|---|---|
| `RW_COMPILER` | Always `visualc` (toolchain-derived). |
| `RW_PLATFORM` | `lib` path segment: `<target>` or `<os>/<compiler>/<target>` with `RW_FULL_PLATFORM`. |
| `RW_SDK_LIBDIR` / `RW_SDK_DLLDIR` / `RW_SDK_INCDIR` | The make-style output locations under `RWSDK/` (used for install). |
| `RW_INSTALL_PREFIX` | Where `cmake --install` writes the layout; defaults to the SDK root (`RWSDK/`), reproducing `lib/`, `include/`, `dll/` next to the sources. |

## Configure-time validation

- x64 (`-A x64`): rejected with a fatal error - the MASM sources and the
  inline `__asm` in `cpuext.c`, `ssematml.c`, `ptank*.c`, `ssematbl.c`,
  `x86matbl.c` and `ostypes.h` are 32-bit only.
- Non-MSVC compilers: rejected (only `visualc` is ported).
- Unimplemented `RW_OS` / `RW_TARGET` / `RW_PIPETYPE` values: rejected with a
  message naming the stub `.cmake` file to fill in.
- `RW_DLL` with a target outside `null|d3d8|d3d9|opengl`: rejected
  (matches `makedll:17-28`).
- `d3d8`/`d3d9` without a usable legacy DirectX SDK: rejected with the
  missing file names and the recommended `RW_DXSDK_DIR` setting.

## Quick examples

```bat
:: null release with C fallbacks (no MASM, no equate generation)
cmake -S RWSDK -B build/null -A Win32 -DRW_TARGET=null -DRW_NOASM=ON

:: d3d9 debug with validation and metrics, custom output folder
cmake -S RWSDK -B build/dbg -A Win32 -DRW_TARGET=d3d9 -DRW_DEBUG=ON ^
      -DRW_METRICS=ON -DRW_OUTPUT=nightly

:: only the world plugin and the BMP toolkit
cmake -S RWSDK -B build/sub -A Win32 -DRW_TARGET=null ^
      -DRW_PLUGINS=rpworld -DRW_TOOLKITS=rtbmp

:: amalgamated DLL against a June 2010 DirectX SDK
cmake -S RWSDK -B build/dll -A Win32 -DRW_TARGET=d3d9 -DRW_DLL=ON ^
      "-DRW_DXSDK_DIR=C:/Program Files (x86)/Microsoft DirectX SDK (June 2010)"
```
