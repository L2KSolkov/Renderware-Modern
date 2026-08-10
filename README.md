# RenderWare 3.7.2 - GNU make to CMake migration (Win32)

`D:\RW_372_src` is a RenderWare Graphics 3.7.2 SDK drop. The legacy GNU make
build (`RWSDK/makefile`, ~100 per-library makefiles, bundled Cygwin binaries)
is unbuildable on a modern box. This repository replaces it with a single
CMake build rooted at `RWSDK/` that produces the same 74 static libraries and
the optional amalgamated `rwg<target>[d].dll`, targeting Win32 only. The
other platforms are present as explicit, discoverable stubs.

## Prerequisites

- Visual Studio 2022 or newer (MSVC x86 toolchain, MASM `ml.exe`)
- CMake 3.21+
- For `RW_TARGET=d3d9` or `d3d8`: the legacy DirectX SDK (June 2010) for
  `d3dx9.h`/`d3dx9.lib` (d3d9) and `d3d8.h`/`d3d8.lib`/`dxguid.lib` (d3d8).
  Point `RW_DXSDK_DIR` at it (or set `DXSDK_DIR`; the presets read
  `$env{DXSDK_DIR}`). This matches the original build, where `DXSDK` was
  mandatory for the D3D targets. `opengl` and `null` need nothing extra.

## Building

```bat
cmake --preset win32-d3d9-release
cmake --build --preset win32-d3d9-release
```

Presets: `win32-d3d9-debug`, `win32-d3d9-release`, `win32-d3d8-release`,
`win32-opengl-release`, `win32-null-release`, `win32-d3d9-metrics`,
`win32-d3d9-dll`. Each pins `-A Win32`.

`cmake --install build/win32-d3d9-release` (or the equivalent binary dir)
materialises the make-system layout for existing consumers. The install
prefix defaults to the SDK root (`RW_INSTALL_PREFIX`); point it elsewhere if
you do not want the trees written next to the sources:

```text
RWSDK/lib/<platform>/<output>/<metrics|debug|profile|mswst|release>/*.lib
RWSDK/include/<platform>/<generated headers and .rpe files>
RWSDK/dll/<platform>/.../rwg<target>[d].dll   (RW_DLL=ON)
```

`rw-headers` and `rw-equate` reproduce `make header` and `make equate`.

## Option surface

Every `options.mak` variable maps to a CMake cache entry (see
`RWSDK/cmake/RWOptions.cmake` for the exact definitions and defaults):

| CMake option | make var | Define emitted |
|---|---|---|
| `RW_DEBUG` | `RWDEBUG` | `RWDEBUG` |
| `RW_VALIDATE_PARAM` (defaults to `RW_DEBUG`) | `RWVALIDATEPARAM` | `RWVALIDATEPARAM` |
| `RW_TRACE` | `RWTRACE` | `RWTRACE` |
| `RW_METRICS` | `RWMETRICS` | `RWMETRICS` |
| `RW_MEMDEBUG` | `RWMEMDEBUG` | `RWMEMDEBUG` |
| `RW_VERBOSE` | `RWVERBOSE` | `RWVERBOSE` |
| `RW_STACK_DEPTH_CHECKING` | `RWSTACKDEPTHCHECKING` | `RWSTACKDEPTHCHECKING` |
| `RW_EVALUATION` | `RWEVALUATION` | `RWEVALUATION` |
| `RW_USE_SPF` | `RW_USE_SPF` | `RW_USE_SPF` |
| `RW_SUPPRESS_INLINE` | `RWSUPPRESSINLINE` | `RWSUPPRESSINLINE` |
| `RW_SUPPRESS_OPTIMIZATION_PRAGMAS` | `RWSUPPRESSOPTIMIZATIONPRAGMAS` | `RWSUPPRESSOPTIMIZATIONPRAGMAS` |
| `RW_IBM_CHAR` | `_IBM_CHAR` | `_IBM_CHAR` |
| `RW_ONLY_PLCORE` | `RWONLYPLCORE` | `RWONLYPLCORE`; only `rwplcore` + `rtfsyst` build |
| `RW_SW15` | `RWSW15` | `FB1555` (also to MASM) |
| `RW_COLOUR_DMA` | `COLOURDMA` | `DMA_COLOUR` (PS2 stub) |
| `RW_PS2MANAGER` | `PS2MANAGER` | `PS2MANAGER` (PS2 stub) |
| `RW_NOASM` | `NOASM` | `NOASM`; drops the MASM sources and `ssematml.c` |
| `RW_NOSSEASM` | `NOSSEASM` | `NOSSEASM` (OpenGL only, as in the makefiles) |
| `RW_FULL_PLATFORM` | `RWFULLPLATFORM` | `lib/<os>/<compiler>/<target>` layout |
| `RW_31_DIRS` | `RW31DIRS` | flat RW3.1 output directories |
| `RW_MSWST` | `MSWST` | Working Set Tuner flag set, `mswst` dir |
| `RW_OUTPUT` | `RWOUTPUT` | extra path component |
| `RW_LIB_PREFIX` / `RW_LIB_SUFFIX` | `LIBPREFIX` / `OPTEXT` | library name prefix/suffix |
| `RW_DLL` | `RWDLL` | amalgamated DLL; forces `/MD` on every static lib |
| `RW_VCAT_RUNTIME_VARIANTS` | `OPTEXT=md`/`mt` | extra `rtvcatmd`/`rtvcatmt` libs (null only) |
| `RW_PLUGINS` / `RW_TOOLKITS` | `PLUGINS` / `TOOLKITS` | semicolon lists; empty means all |
| `RW_DXSDK_DIR` | `DXSDK` | legacy DirectX SDK path |
| `RW_OGL_LIB_PATH` | `OGLLIBPATH` | OpenGL library path |

Configuration mapping: `Debug` ~= `CDEBUG=1` (`/Od /Ob0 /Oy- /Zi /D_DEBUG`,
`/MTd`), `Release` ~= `COPTIMIZE=1` (`/O2 /Ob2 /DNDEBUG`, `/MT`),
`RelWithDebInfo` ~= `CPROFILE=1` (`/O2 /Zi`), `MinSizeRel` ~= `SMALLCODE`
(`/O1 /Ob2 /MD`). The legacy `/ML(/d)` single-threaded runtime maps to
`/MT(/d)`; `/GX` maps to `/EHsc`; the combined `-Oity`/`-Ob0gity` forms are
replaced by their modern equivalents. `RWDEPEND` is dropped; CMake tracks
header dependencies natively.

`RW_OS` accepts `win` (implemented) and `mac`/`linux`/`sky`/`gcn`/`xbox`
(stubs that fail configure with the file to fill in). `RW_TARGET` accepts
`d3d9` (default), `d3d8`, `opengl` and `null`; the console targets are stubs.
Configure-time validation rejects x64 and unimplemented combinations with the
same spirit as `checkopt`.

## Code generation

- `.rpe` files: `cl /EP` over `src/plcore/rperror.h` with the plugin's include
  dir on the path (62 plugin/toolkit error files).
- Public headers: `incgen` for `rwplcore.h`/`rwcore.h`/`rpworld.h`;
  `inline` for the `PLUGINAPI` plugins (skin, matfx, patch, toon, ptank,
  prtstd, prtadv, dmorph, collis, fsyst, ltmap, normmap); plain copies
  otherwise. All land in the build-tree include dir.
- `baequate.i`: `cl /Fa` over `driver/common/baequ.c`, then `findsyms
  -Aml`. The make system wrote this into the source tree; the CMake build
  writes it into the build tree (the MASM include path points there) so the
  worktree stays clean.

Parity: `reference/check-header-parity.ps1` diffs the generated include dir
against `reference/generated-headers-3.7.2/` (the original build's output),
normalising the machine path prefix and the `incgen` timestamp header. The
d3d9 build matches 133/133 files.

## DLL

`RW_DLL=ON` builds `rwg<target>[d].dll` from the explicit lib list in
`makedll`. The bundled Cygwin `dlltool`+`sed` pipeline is replaced by
`dumpbin /LINKERMEMBER:1` plus `RWSDK/cmake/rw-gendef.cmake`, which applies
the exact `rwgdllfx.sed` rules. Two modern-linker workarounds are documented
there: `/WHOLEARCHIVE` (the VS2003-era linker pulled archive members to
satisfy `.def` exports; current `link.exe` does not) and explicit CRT import
libraries (the static libs are built with `/Zl` as the make system did). The
generated def is a strict subset of the bundled `dlltool`'s output: it only
omits non-exportable compiler artifacts (`_xmm@` constants, RTTI
`_CT`/`_TI`/`_CTA` descriptors, MASM segment pseudo-symbols, archive header
fields) that cannot link.

## Layout notes and deviations

- `plugin/userdata` produces `rpusrdat.lib` (its makefile's `PLUGIN`), and the
  skin family produces `rpskin.lib`; the deleted VS2022 scaffold named those
  projects `rpuserdat`/`rpskin2` after their directories. The library set is
  otherwise identical to the scaffold's 74 names
  (`reference/vcxproj-library-names.txt`).
- `barwasmm.asm` is not built (its `bamacros.i`/`barwasmg.i` includes are not
  in the tree and no makefile references it).
- The Doxygen/hhc documentation chain is exposed as `doxy`/`doc` custom
  targets that print a warning and skip; `verify`/`longline`/`tabs`/
  `defgroup`/`csrc`/`maintainers` are optional no-op targets.
- Option-sweep notes, all matching the make system's own behaviour:
  - `RW_ONLY_PLCORE=ON` builds only `rwplcore` and `rtfsyst`.
  - Plugin/toolkit subsets (`RW_PLUGINS`/`RW_TOOLKITS`) must include the
    transitive headers each library includes (e.g. `rpskin` needs `rphanim`,
    `rptoon`, `rpmatfx`, ...; `rphanim` needs the `rtquat`/`rtanim` headers).
    The `rtfsyst` headers are always generated because `src/plcore/bastream.c`
    includes `rtfsyst.h` unconditionally.
  - `RW_TRACE=ON` fails to compile `plugin/hanim/stdkey.c`: the file uses
    `RWRETURN` without the `RWFUNCTION` entry macro that the `RWTRACE`
    machinery in `rpdbgerr.h` requires. This is an upstream source defect that
    the make build hits identically.
- The legacy makefiles stay in-tree as the specification and historical
  reference (`RWSDK/options.mak.sample` included).
