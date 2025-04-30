# Snake

Classic Snake game built with Godot Engine 4.4.

## Table of Contents
1. [Features](#features)
2. [Requirements](#requirements)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Controls](#controls)
6. [Configuration & Settings](#configuration--settings)
7. [Project Structure](#project-structure)
8. [Contributing](#contributing)
9. [License](#license)

---

## Features
- Smooth grid-based movement
- Typed GDScript 2.0 (`var speed: int = 5`)
- Configurable settings via `Settings` autoload
- Audio for food, game over, and background music
- Deferred body segment management to avoid iteration conflicts

## Requirements
- Godot Engine **4.4** or higher
- Desktop platform (Windows, macOS, Linux)

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/FreddyUllis/Snake.git
   ```
2. Open Godot and import the `project.godot` file.
3. Ensure `Other/Scripts/settings.gd` is autoloaded under the name `Settings`.

## Usage
- Press **Play** in Godot to run the game.
- The main scene is located at `Main/Scenes/main.tscn`.

## Controls
| Key        | Action           |
|------------|------------------|
| W / ↑      | Move Up          |
| S / ↓      | Move Down        |
| A / ←      | Move Left        |
| D / →      | Move Right       |
| Space      | Pause / Resume   |

## Configuration & Settings
Global settings are exposed via the `Settings` autoload script (`Other/Scripts/settings.gd`):
```gdscript
# Example of typed GDScript properties
@export var speed: int = 5
@export var volume_music: float = 0.5
@export var grid_size: Vector2i = Vector2i(20, 20)
```
Adjust in the **Project Settings** under **Autoload → Settings** or directly in the script.

## Project Structure
```
/                          # Root
├── Main/                  # Main scene and logic
│   ├── Scenes/main.tscn   # Entry point
│   └── Scripts/main.gd    # Game state manager
├── SnakeHead/             # Head movement logic
├── SnakeSegment/          # Body segment scenes and scripts
├── Food/                  # Food scene and logic
├── HUD/                   # UI elements (score, menus)
├── Other/                 # Helpers and settings
│   └── Scripts/
│       ├── settings.gd                # Autoload for global settings
│       ├── constants_collection.gd    # Collection-related constants
│       ├── constants_num.gd           # Numeric constants (grid size, speed)
│       ├── constants_path_scene.gd    # Scene path constants
│       └── constants_str.gd           # String constants (UI labels)
└── LICENSE.md             # MIT License
```

## Contributing
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/YourFeature`
3. Commit your changes: `git commit -m "Add awesome feature"`
4. Push to branch: `git push origin feature/YourFeature`
5. Open a Pull Request

Please follow Godot style conventions and include typed annotations where appropriate.

## License
This project is licensed under the MIT License. See [LICENSE.md](LICENSE.md) for details.

-----------------

# Snake

Классическая игра «Змейка», созданная с помощью Godot Engine 4.4.

## Содержание
1. [Особенности](#особенности)
2. [Требования](#требования)
3. [Установка](#установка)
4. [Использование](#использование)
5. [Управление](#управление)
6. [Конфигурация и настройки](#конфигурация-и-настройки)
7. [Структура проекта](#структура-проекта)
8. [Содействие](#содействие)
9. [Лицензия](#лицензия)

---

## Особенности
- Плавное движение по сетке
- Строгая типизация в GDScript 2.0 (`var speed: int = 5`)
- Настраиваемые параметры через автозагрузку `Settings`
- Звуки еды, окончания игры и фоновая музыка
- Отложенное управление сегментами тела для избежания конфликтов при итерации

## Требования
- Godot Engine **4.4** или выше
- Платформа для ПК (Windows, macOS, Linux)

## Установка
1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/FreddyUllis/Snake.git
   ```
2. Откройте Godot и импортируйте файл `project.godot`.
3. Убедитесь, что скрипт `Other/Scripts/settings.gd` подключен в автозагрузке под именем `Settings`.

## Использование
- Нажмите **Play** в Godot для запуска игры.
- Основная сцена находится в `Main/Scenes/main.tscn`.

## Управление
| Клавиша      | Действие            |
|--------------|---------------------|
| W / ↑        | Вверх               |
| S / ↓        | Вниз                |
| A / ←        | Влево               |
| D / →        | Вправо              |
| Space        | Пауза / Возобновить |

## Конфигурация и настройки
Глобальные параметры доступны через автозагрузку `Settings` (`Other/Scripts/settings.gd`):
```gdscript
# Пример свойств с типизацией в GDScript
@export var speed: int = 5
@export var volume_music: float = 0.5
@export var grid_size: Vector2i = Vector2i(20, 20)
```
Настройте в **Project Settings → Autoload → Settings** или непосредственно в скрипте.

## Структура проекта
```
/                          # Корневая папка
├── Main/                  # Главная сцена и логика
│   ├── Scenes/main.tscn   # Точка входа
│   └── Scripts/main.gd    # Менеджер состояния игры
├── SnakeHead/             # Логика движения головы
├── SnakeSegment/          # Сцены и скрипты сегментов тела
├── Food/                  # Сцена и логика еды
├── HUD/                   # Элементы интерфейса (очки, меню)
├── Other/                 # Вспомогательные скрипты и настройки
│   └── Scripts/
│       ├── settings.gd                # Автозагрузка глобальных настроек
│       ├── constants_collection.gd    # Константы для коллекций
│       ├── constants_num.gd           # Числовые константы (размер сетки, скорость)
│       ├── constants_path_scene.gd    # Константы путей к сценам
│       └── constants_str.gd           # Строковые константы (тексты интерфейса)
└── LICENSE.md             # Лицензия MIT
```

## Содействие
1. Форкните репозиторий
2. Создайте ветку: `git checkout -b feature/YourFeature`
3. Сделайте коммит: `git commit -m "Add awesome feature"`
4. Запушьте ветку: `git push origin feature/YourFeature`
5. Откройте Pull Request

Следуйте стилю Godot и используйте строгую типизацию там, где это уместно.

## Лицензия
Этот проект распространяется на условиях лицензии MIT. Подробнее см. [LICENSE.md](LICENSE.md).
