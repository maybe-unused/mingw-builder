## Сборка контейнера
Для начала необходимо создать профиль buildx:
```sh
docker buildx create --use --name sus --config ./buildkitd.toml --driver docker-container
```

Далее команда для сборки и помещения в локальный репозиторий
```sh
docker buildx build -t mingw-conan-rust --builder sus --load  .
```

## Запуск и сборка проекта

Для моментальной сборки `conan` проекта можно использовать следующую команду
```sh
PATH_TO_PROJECT=/local/path/to/project
docker container run -it -v $PATH_TO_PROJECT:/custom/projects/myproject -w /custom/projects/myproject mingw-conan-rust conan build . --build=missing --settings=build_type=Debug --profile:host=conan-mingw --profile:build=default
```

Для моментальной сборки `cargo` проекта можно использовать следующую команду
```sh
PATH_TO_PROJECT=/local/path/to/project
docker container run -it -v $PATH_TO_PROJECT:/custom/projects/myproject -w /custom/projects/myproject mingw-conan-rust cargo build --target=x86_64-pc-windows-gnu
```

Для моментальной сборки `CMake` проекта можно использовать следующую команду
```sh
PATH_TO_PROJECT=/local/path/to/project
docker container run -it -v $PATH_TO_PROJECT:/custom/projects/myproject -w /custom/projects/myproject mingw-conan-rust /bin/bash -c "cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE=/root/.conan2/profiles/mingw_conan.cmake; cmake --build build"
```

## Container available commands

Эта команда нужна чтобы кросс компилировать конан проект в контейнере для винды
```sh
conan build . -pr:a=conan-mingw --build=missing -o"*:shared=True"
```

Аналогично только на расте
```sh
cargo build --target=x86_64-pc-windows-gnu
```

Для сборки простого проекта с CMakeLists.txt можно использовать следующую команду
```sh
cmake -S .. -B . -DCMAKE_TOOLCHAIN_FILE=/custom/cmake/mingw-w64-x86_64.cmake
```

## Прочее
На момент написания инструкции собранный qt5 находится по пути 
```sh
/custom/libs/mxe/usr/x86_64-w64-mingw32.shared/qt5
```

Следующие пути добавлены в PATH:
- `/custom/venv/bin` - путь к виртуальному окружению питона, нужен для команд `conan`, `mako` и прочих
- `$CUSTOM_MXE_TARGET_PATH/bin` - путь к утилитам mxe
- `$CUSTOM_MXE_PATH/usr/bin` - путь к кросс компилятору w64-mingw32.shared
- `$CUSTOM_QT_PATH/bin` - путь к утилитам qt
- `$CUSTOM_MXE_TARGET_PATH/lib` - путь к библиотекам mxe
- `/root/.cargo/bin` - путь к утилитам cargo

Профиль conan `conan-mingw` располагается в `~/.conan2/profiles/conan-mingw`

Cmake toolchain file `mingw-w64-x86_64.cmake` располагается в
```sh
/custom/cmake/mingw-w64-x86_64.cmake
```

You might want to link your project to `ucrt` library in case you have a dependency on msvcr.
Add these lines in your `CMakeLists.txt`:
```cmake
if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Linux" AND (MINGW OR CYGWIN))
  message(STATUS "[${PROJECT_FULL_NAME}] using universal C runtime library")
  foreach(LANG C CXX)
        set(CMAKE_${LANG}_STANDARD_LIBRARIES "${CMAKE_${LANG}_STANDARD_LIBRARIES} -lucrt")
        message(STATUS "CMAKE_${LANG}_STANDARD_LIBRARIES: ${CMAKE_${LANG}_STANDARD_LIBRARIES}")
    endforeach()
endif()
```

If your project depends on `ws_32` library (which is usually the case for projects that use `winsock` on windows), you should link your target to `ws2_32` library.
You can do this by adding the following line to your `CMakeLists.txt`:
```cmake
if(MINGW OR CYGWIN)
  message(STATUS "[${PROJECT_FULL_NAME}] mingw detected, adding ws2_32 and wsock32 to standard libraries")
  foreach(LANG C CXX)
    set(CMAKE_${LANG}_STANDARD_LIBRARIES "${CMAKE_${LANG}_STANDARD_LIBRARIES} -lws2_32 -lwsock32")
    message(STATUS "CMAKE_${LANG}_STANDARD_LIBRARIES: ${CMAKE_${LANG}_STANDARD_LIBRARIES}")
  endforeach()
endif()
```


## Команды для деплоя
```sh
# qml directory
cp -r /custom/libs/mxe/usr/x86_64-w64-mingw32.shared/qt5/qml/ .

# qml plugins
cp -r /custom/libs/mxe/usr/x86_64-w64-mingw32.shared/qt5/plugins/ .

# qt core dlls
cp -r /custom/libs/mxe/usr/x86_64-w64-mingw32.shared/qt5/bin/* .

# mingw dll libraries
cp -r /custom/libs/mxe/usr/x86_64-w64-mingw32.shared/bin/* .
```