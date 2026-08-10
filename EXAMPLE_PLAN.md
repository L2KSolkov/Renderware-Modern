# RenderWare examples — GNU make → CMake (Win32)

## Context

The SDK migration is done and committed on `feature/cmake-migration` (8 commits, `d20f75d`…`50ca65a`): `RWSDK/` builds 74 libraries through CMake, exports a `RenderWare` package with `RenderWare::` targets, and the legacy GNU make system is gone. `examples/` is the last untracked tree and still on GNU make.

`examples/` holds **66 example programs** — 59 demos plus 7 under `Tutorials/` — 156 MB across 1,410 files. Every one of them is dead in the water today: the makefiles `include $(RWGDIR)/shared/makeopt` and `$(RWGDIR)/shared/maketarg`, and compile `$(SKEL)/skeleton.c`, `$(COMMON)/camera.c`, `$(COMMON)/menu.c` from a `shared/` tree that was missing from the drop. **That tree has now been supplied** (46 files at `D:\RW_372_src\shared\`), so the blocker is cleared and the port can proceed.

The outcome: one CMake build that configures the SDK and the examples together, produces 66 runnable `.exe` files with their assets staged beside them, and carries the same option surface the SDK already exposes — with every Visual Studio remnant, prebuilt binary, and CodeWarrior project removed.

### What `shared/` provides

| Path | Role |
|---|---|
| `shared/skel/skeleton.c`, `skeleton.h`, `platform.h`, `events.h` | The `Rs*` application harness every example's `main.c` implements against |
| `shared/skel/win/win.c`, `win.h`, `win.rc`, `resource.h`, `splash.c/h` | Win32 entry point, message pump, device-selection dialog resource |
| `shared/skel/metrics.c/h`, `vecfont.c/h` | On-screen metrics overlay, compiled only when `RWMETRICS` |
| `shared/skel/mouse.c/h` | Non-Windows only — win builds get `-URWMOUSE` (`examples/impick/makefile:52–57`) |
| `shared/democom/camera.c/h`, `menu.c/h`, `ptrdata.h` | Shared camera and menu helpers |
| `shared/makeopt`, `shared/maketarg`, `shared/makeincl/rwos/win/{makeskel,rwcmplr/*/makecom}` | The make build system being replaced |

### Decisions taken

| Decision | Choice |
|---|---|
| Cleanup | Remove all VS remnants (73 `.dsp`, 73 `.vcproj`), 173 prebuilt `.exe` (85.7 MB), 172 CodeWarrior `.mcp`, and the 68 makefiles + `examples/options.mak` |
| Scope | Win32 only, matching the SDK; default target `d3d9` |
| Integration | Root superbuild configures `RWSDK` + `examples` together; `examples/` also stands alone via `find_package(RenderWare)` |

---

## Phase 1 — Cleanup and import

One commit, before any CMake lands, so the diff that follows is only the new build.

- `git add examples/ shared/` — both trees are currently untracked.
- Delete in the same commit: `examples/**/*.dsp`, `examples/**/*.vcproj` (223 → here 146 VS files; `Version="7.00"`, VS2002-era), `examples/**/*.exe` (173 files, 85.7 MB), `examples/**/*.mcp` (172 files).
- Keep `shared/makeopt`, `shared/maketarg`, `shared/makeincl/`, and all 68 makefiles **for now** — they are the specification for the port. They go in a final commit once parity is demonstrated, exactly how the SDK migration sequenced it.
- Extend the root `.gitignore` for the examples' own outputs: `examples/**/obj/`, `examples/**/*.exe`, `examples/**/*.ilk`, `examples/**/*.pdb`.

Net effect: the tree drops from 156 MB to roughly 45 MB, of which 42.8 MB is model and texture assets that must stay.

---

## Phase 2 — Superbuild root and option surface

**`CMakeLists.txt` (new, repo root).** There is no root `CMakeLists.txt` today — `RWSDK/CMakeLists.txt` is the project root. Add a thin superbuild that declares the project, `add_subdirectory(RWSDK)`, then `add_subdirectory(examples)` when `RW_BUILD_EXAMPLES` is on (default ON). `RWSDK/CMakePresets.json` keeps working for SDK-only configures; a new root `CMakePresets.json` mirrors its presets for the combined build.

**`examples/CMakeLists.txt`.** Dual-mode, so the tree is usable either way:

```cmake
if(NOT TARGET rwcore)                     # standalone: consume an installed SDK
  find_package(RenderWare REQUIRED)
endif()
```

In-tree it links the live targets (`rwcore`, `rpworld`, `rt*`, `rp*`); standalone it links the exported `RenderWare::` ones. An `RW_EXAMPLE_LIB_PREFIX` variable set once resolves which spelling to use, so the per-example lists stay identical.

**`examples/cmake/RWExampleOptions.cmake`** ports `shared/makeopt`. Most of it is already covered by `RWSDK/cmake/RWOptions.cmake` — reuse `RW_TARGET`, `RW_OS`, `RW_DEBUG`, `RW_METRICS`, `RW_MEMDEBUG`, `RW_VERBOSE`, `RW_SUPPRESS_INLINE`, `RW_SUPPRESS_OPTIMIZATION_PRAGMAS`, `RW_FULL_PLATFORM`, `RW_OUTPUT`, `RW_31_DIRS` rather than redeclaring them. Genuinely new, from `shared/makeopt:153–160` and `shared/makeincl/rwos/win/makeskel`:

| Option | make var | Default | Effect |
|---|---|---|---|
| `RW_EXAMPLES_LOGO` | `RWLOGO` | ON | `-DRWLOGO`, links `rplogo` |
| `RW_EXAMPLES_SPLASH` | `RWSPLASH` | OFF | `-DRWSPLASH`, adds `shared/skel/win/splash.c`, links `vfw32` |
| `RW_EXAMPLES_STAGE_ASSETS` | — | ON | Copies each example's assets beside its exe (see Phase 5) |

`examples/options.mak` sets `RWLOGO=1` while the recursive `examples/makefile:38–40` defaults it to 0; ON matches the per-example default and the shipped `.exe` names.

Also ported: `-DRWTARGET_$(RWPLATFORMEXE)` (so `-DRWTARGET_d3d9`, or `-DRWTARGET_win_visualc_d3d9` under `RW_FULL_PLATFORM`) from `shared/makeopt:169–171`.

**Executable naming** follows `shared/makeopt:63–121`: `<demo>_<platform>[suffix].exe`, suffix `m` metrics / `d` debug / `p` profile / `wst` MSWST / none release — `camera_d3d9.exe`, `camera_d3d9d.exe`. Reproduce with `OUTPUT_NAME` plus the config genex the SDK already computes (`RW_CONFIG_SUFFIX_GENEX` in `RWSDK/CMakeLists.txt:102`).

---

## Phase 3 — The shared framework as a library

`shared/CMakeLists.txt` builds one static library, **`rwskel`**, replacing what `shared/maketarg:44–51` compiled into every example's object dir. Every example compiles the framework with identical flags on Win32 — the only per-example divergence, `RWMOUSE`, is off for all win builds — so a single library is correct and cuts 66 redundant compiles.

Sources: `shared/skel/skeleton.c`, `shared/skel/win/win.c`, `shared/democom/camera.c`, `shared/democom/menu.c`; plus `vecfont.c` + `metrics.c` when `RW_METRICS`, and `win/splash.c` when `RW_EXAMPLES_SPLASH`.

`shared/skel/win/win.rc` compiles as a resource and must propagate to every executable — `SKELOBJ = $(SKELPS)/win.res` in `shared/makeincl/rwos/win/makeskel:10` links it into each demo. Add the `.rc` to `rwskel` and mark it `INTERFACE_SOURCES` on the exe side, or attach it per-example; a static library will otherwise drop the resource at link time.

**Expected fix:** `win.rc` includes `afxres.h`, which ships only with MFC and is absent from a stock VS Build Tools install. The file already guards a `winresrc.h` alternative for GCC (`shared/skel/win/win.rc:7–11`); widen that to prefer `winresrc.h` whenever `afxres.h` is unavailable. This is the one source edit the port is likely to need.

`rwskel` publishes `shared/skel`, `shared/skel/win`, `shared/democom` as `PUBLIC` include dirs and links `rwcore`, `rpworld`, `rtcharse`, `rtfsyst` — the four every example needs (`shared/makeopt:162–167`).

---

## Phase 4 — Example targets

`examples/cmake/RWAddExample.cmake` provides `rw_add_example()`, the analogue of `shared/maketarg`. It mirrors the shape of the SDK's existing `rw_add_plugin()` (`RWSDK/cmake/RWAddPlugin.cmake`) — same argument-parsing idiom, same per-target source selection — so the two read alike:

```cmake
rw_add_example(camera
  SOURCES       src/main.c src/camexamp.c src/viewer.c src/win/events.c
  RW_LIBS       rtpng rtbmp
  ASSET_DIRS    models)
```

The function adds `src/`, links `rwskel` (which drags in the four baseline libs), applies the naming and asset rules, and sets `VS_DEBUGGER_WORKING_DIRECTORY`.

Three examples restrict their targets and must be skipped with a status message rather than failing, matching the `override TARGET := unsupported` blocks:

- `normmap` — d3d9 and xbox only (`examples/normmap/makefile:44–52`)
- `vshader`, `pshader` — d3d8, d3d9, xbox only; each selects a per-target source (`vshaderD3D8.c` vs `vshaderD3D9.c`) and the **d3d8** variant alone needs `d3dx8.lib`/`d3dx8dt.lib` from a legacy DX SDK. The d3d9 path needs nothing extra, so both build under the default preset.

Per-example source lists come straight from the `CSRC` in each makefile. Two source-tree details to respect: some examples carry `src/d3d8`, `src/d3d9`, `src/opengl` subdirectories selected by target, and `examples/vshader/src/rainbowD3D9.H` has an uppercase extension that a case-sensitive glob will miss. `Tutorials/Tutorial{5,6,7}` include `"rpaname.h"` while shipping `RpAName.h` — fine on Windows, worth a note but not a change.

`examples/Tutorials/CMakeLists.txt` adds the seven tutorials the same way.

---

## Phase 5 — Assets and running

Examples load assets by **relative path** — `RsPathnameCreate(RWSTRING("models/clump.dff"))` in `examples/camera/src/main.c:168–172` — and the make build sidestepped this by writing the exe into the example's own directory. CMake builds out of tree, so:

- Each exe goes to `${CMAKE_BINARY_DIR}/examples/<name>/`.
- When `RW_EXAMPLES_STAGE_ASSETS`, a `POST_BUILD` step copies that example's `models/`, `textures/`, `fonts/` beside it (`copy_directory_if_different`). Total across all 66 is 42.8 MB, the largest single example being `normmap` at 11.6 MB — cheap enough per target.
- `VS_DEBUGGER_WORKING_DIRECTORY` is set to the staging dir so F5 works in Visual Studio.

---

## Phase 6 — Presets and docs

- Root `CMakePresets.json` mirroring `RWSDK/CMakePresets.json`: `win32-d3d9-debug`, `win32-d3d9-release`, `win32-d3d8-release`, `win32-opengl-release`, `win32-null-release`, `win32-d3d9-metrics`, each pinning `architecture: Win32`.
- Extend the root `README.md` with an examples section: how to build, where exes land, the `RW_EXAMPLES_*` options, and the three target-restricted examples.
- Final commit: delete the 68 makefiles, `examples/options.mak`, `shared/makeopt`, `shared/maketarg`, and `shared/makeincl/`.

---

## Verification

1. **Configure.** Root superbuild configures clean on `win32-d3d9-release`; `examples/` alone configures against an installed SDK via `find_package(RenderWare)`. `RW_BUILD_EXAMPLES=OFF` still builds the SDK by itself.
2. **`rwskel` first.** It builds before any example and the `win.rc` resource links — the `afxres.h` fallback is the likely first failure, so fix it here rather than 66 times over.
3. **Full build.** `win32-d3d9-release` produces **66 of 66** exes — d3d9 satisfies all three restricted examples. `win32-opengl-release` produces **63**, with `normmap`, `vshader` and `pshader` reported skipped at configure time. That difference is the check that the target-restriction logic works.
4. **Naming parity.** Exe names match the deleted prebuilt set — `camera_d3d9.exe`, `camera_opengl.exe` — recorded from `git show HEAD~n` before the cleanup commit. This is the cheapest check that the platform/config suffix logic is right.
5. **Run.** Launch `camera_d3d9.exe` from its staging dir: the device-selection dialog appears (proving the `.rc` linked), the clump loads (proving asset staging), and the logo renders (proving `RW_EXAMPLES_LOGO`). Then `imagetex` and `hanim1` for texture and animation paths.
6. **Option sweep.** `RW_DEBUG=ON` yields `camera_d3d9d.exe` linked against `lib/d3d9/debug`; `RW_METRICS=ON` yields `camera_d3d9m.exe` with the overlay compiled in; `RW_EXAMPLES_LOGO=OFF` drops `rplogo` from the link line.
7. **d3d8.** `win32-d3d8-release` builds with a legacy DX SDK present, and `vshader`/`pshader` pick up `d3dx8.lib`. Without one, configure fails with the existing `FindDX8SDK` message rather than at link.

## Out of scope

Non-Windows examples (the `sky2`/`gcn`/`xbox` branches in the makefiles, `shared/cwcommon/` CodeWarrior compatibility shims, `pblaster/src/sky/`); the xbox shader-assembly step (`xsasm`) that generates `rainbow.h` / `blurpshader.h`; x64.