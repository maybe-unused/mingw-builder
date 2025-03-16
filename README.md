## Сборка контейнера
Для начала необходимо создать профиль buildx:
```
docker buildx create --use --name sus --config ./buildkitd.toml --driver docker-container
```

Далее команда для сборки и помещения в локальный репозиторий
```
docker buildx build -t mingw-conan-rust --builder sus --load  .
```

## Запуск и сборка проекта

Для моментальной сборки проекта можно использовать следующую команду
```
docker container run -it -v /local/path/to/project:/custom/projects/myproject -w /custom/projects/myproject mingw-conan-rust conan build . -pr:a=conan-mingw --build=missing -o"*:shared=True"
```

## Container available commands

Эта команда нужна чтобы кросс компилировать конан проект в контейнере для винды
```
conan build . -pr:a=conan-mingw --build=missing -o"*:shared=True"
```

Аналогично только на расте
```
cargo build --target=x86_64-pc-windows-gnu
```

## Прочее
На момент написания инструкции собранный qt5 находится по пути 
```
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
