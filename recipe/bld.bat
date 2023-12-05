rm -rf C:/hostedtoolcache/windows/Python

mkdir build
cd build

if "%FEATURE_DEBUG%"=="1" (
      set BUILD_TYPE="Debug"
      echo "#! building debug package !#") else (
      set BUILD_TYPE="Release")


set "CFLAGS= "
set "CXXFLAGS= "
set "LDFLAGS_SHARED= ucrt.lib"

cmake -G "Ninja" ^
      -D BUILD_WITH_CONDA:BOOL=ON ^
      -D CMAKE_BUILD_TYPE=%BUILD_TYPE% ^
      -D FREECAD_LIBPACK_USE:BOOL=OFF ^
      -D CMAKE_INSTALL_PREFIX:FILEPATH="%LIBRARY_PREFIX%" ^
      -D CMAKE_PREFIX_PATH:FILEPATH="%LIBRARY_PREFIX%" ^
      -D CMAKE_INCLUDE_PATH:FILEPATH="%LIBRARY_PREFIX%/include" ^
      -D CMAKE_LIBRARY_PATH:FILEPATH="%LIBRARY_PREFIX%/lib" ^
      -D CMAKE_INSTALL_LIBDIR:FILEPATH="%LIBRARY_PREFIX%/lib" ^
      -D BUILD_FEM_NETGEN:BOOL=ON ^
      -D OCC_INCLUDE_DIR:FILEPATH="%LIBRARY_PREFIX%/include/opencascade" ^
      -D OCC_LIBRARY_DIR:FILEPATH="%LIBRARY_PREFIX%/lib" ^
      -D OCC_LIBRARIES:FILEPATH="%LIBRARY_PREFIX%/lib" ^
      -D FREECAD_USE_OCC_VARIANT="Official Version" ^
      -D OCC_OCAF_LIBRARIES:FILEPATH="%LIBRARY_PREFIX%/lib" ^
      -D BUILD_REVERSEENGINEERING:BOOL=ON ^
      -D USE_BOOST_PYTHON:BOOL=OFF ^
      -D FREECAD_USE_PYBIND11:BOOL=ON ^
      -D SMESH_INCLUDE_DIR:FILEPATH="%LIBRARY_PREFIX%/include/smesh" ^
      -D SMESH_LIBRARY:FILEPATH="%LIBRARY_PREFIX%/lib/SMESH.lib" ^
      -D FREECAD_USE_EXTERNAL_SMESH:BOOL=ON ^
      -D FREECAD_USE_EXTERNAL_FMT:BOOL=OFF ^
      -D BUILD_FLAT_MESH:BOOL=ON ^
      -D BUILD_SHIP:BOOL=OFF ^
      -D OCCT_CMAKE_FALLBACK:BOOL=ON ^
      -D PYTHON_EXECUTABLE:FILEPATH="%PREFIX%/python" ^
      -D Python3_EXECUTABLE:FILEPATH="%PREFIX%/python" ^
      -D BUILD_DYNAMIC_LINK_PYTHON:BOOL=ON ^
      -D Boost_NO_BOOST_CMAKE:BOOL=ON ^
      -D FREECAD_USE_PCH:BOOL=OFF ^
      -D FREECAD_USE_CCACHE:BOOL=OFF ^
      -D FREECAD_USE_PCL:BOOL=ON ^
      -D INSTALL_TO_SITEPACKAGES:BOOL=ON ^
      -D LZMA_LIBRARY:FILEPATH="%LIBRARY_PREFIX%/lib/liblzma.lib" ^
      -D COIN3D_LIBRARY_RELEASE:FILEPATH="%LIBRARY_PREFIX%/lib/Coin4.lib" ^
      -D ENABLE_DEVELOPER_TESTS:BOOL=OFF ^
      ..

if errorlevel 1 exit 1
ninja install
if errorlevel 1 exit 1

rmdir /s /q "%LIBRARY_PREFIX%\doc"
ren %LIBRARY_PREFIX%\bin\FreeCAD.exe freecad.exe
ren %LIBRARY_PREFIX%\bin\FreeCADCmd.exe freecadcmd.exe

:: Ondsel branding
move ..\branding\branding.xml %LIBRARY_PREFIX%\bin\
ren ..\branding Ondsel
mkdir %LIBRARY_PREFIX%\share\Gui
move ..\Ondsel %LIBRARY_PREFIX%\share\Gui\