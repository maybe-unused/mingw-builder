# Toolchain file for cross-compiling to Windows with MinGW

# Set the target system to Windows
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_VERSION 1)

# Set the compilers for C and C++
set(CMAKE_C_COMPILER x86_64-w64-mingw32.shared-gcc)
set(CMAKE_CXX_COMPILER x86_64-w64-mingw32.shared-g++)

# Set other cross-compilation tools
set(CMAKE_LINKER x86_64-w64-mingw32.shared-ld)
set(CMAKE_STRIP x86_64-w64-mingw32.shared-strip)
set(CMAKE_AR x86_64-w64-mingw32.shared-ar)
set(CMAKE_RANLIB x86_64-w64-mingw32.shared-ranlib)
set(CMAKE_RC_COMPILER x86_64-w64-mingw32.shared-windres)

# Add the suffix for executable files (Windows .exe)
set(CMAKE_EXECUTABLE_SUFFIX .exe)

# Specify how to search for libraries and includes
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
