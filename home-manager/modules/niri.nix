{ config, pkgs, ... }:

{
  programs.niri = {
    enable = true;

    settings = {
      # ===== Входные устройства =====
      input = {
        keyboard = {
          xkb = {
            layout = "us,ru";
            options = "grp:win_space_toggle";
          };
          # numlock включён по умолчанию, можно оставить как есть
        };

        touchpad = {
          tap = true;
          accel-speed = 0.1;
          accel-profile = "adaptive";
        };

        mouse = {
          # отключено (закомментировано в оригинале)
        };

        trackpoint = {
          # отключено
        };

        focus-follows-mouse = {
          max-scroll-amount = "0%";
        };
      };

      # ===== Оформление и геометрия =====
      layout = {
        gaps = 16;
        center-focused-column = "never";

        preset-column-widths = [
          { proportion = 0.5; }
          { proportion = 0.66; }
          { proportion = 0.33; }
        ];

        preset-window-heights = [
          { proportion = 0.5; }
          { proportion = 1.0; }
        ];

        default-column-width = { proportion = 0.5; };

        # Вставка из ayu-dark.kdl
        focus-ring = {
          off = false; # по умолчанию включено
          width = 5;
          active-gradient = {
            from = "#eba54d";
            to = "#80ab24";
            angle = 135;
          };
          inactive-color = "#212733"; # из темы
        };

        border = {
          width = 5;
          active-gradient = {
            from = "#eba54d";
            to = "#80ab24";
            angle = 135;
          };
          inactive-color = "#212733"; # из темы
          urgent-color = "#e7666a";
        };

        shadow = {
          off = true; # отключено
        };
      };

      # ===== Автозапуск =====
      spawn-at-startup = [
        "hypridle"
        "swww-daemon"
        { spawn-sh = "swww img ~/Pictures/wp.png"; }
        "xwayland-satellite"
        { spawn-sh = "waybar -c ~/.config/waybar/config_niri.json"; }
        { spawn = [ "wl-paste" "--type" "text" "--watch" "cliphist" "store" ]; }
        { spawn = [ "wl-paste" "--type" "image" "--watch" "cliphist" "store" ]; }
      ];

      # ===== Разное =====
      hotkey-overlay = {
        # skip-at-startup = true; # раскомментировать при желании
      };

      prefer-no-csd = true; # соответствует "prefer-no-csd" в KDL
      screenshot-path = "~/screens/Screenshot from %Y-%m-%d %H-%M-%S.png";

      # ===== Анимации =====
      animations = {
        # off = true; # если нужно отключить
        workspace-switch = {
          spring = {
            damping-ratio = 1.0;
            stiffness = 1000;
            epsilon = 0.0001;
          };
        };
        window-open = {
          duration-ms = 150;
          curve = "ease-out-quad";
        };
        window-close = {
          duration-ms = 150;
          curve = "ease-out-quad";
        };
        horizontal-view-movement = {
          spring = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };
        window-movement = {
          spring = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };
        window-resize = {
          spring = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };
        config-notification-open-close = {
          spring = {
            damping-ratio = 0.6;
            stiffness = 1000;
            epsilon = 0.001;
          };
        };
        exit-confirmation-open-close = {
          spring = {
            damping-ratio = 0.6;
            stiffness = 500;
            epsilon = 0.01;
          };
        };
        screenshot-ui-open = {
          duration-ms = 200;
          curve = "ease-out-quad";
        };
        overview-open-close = {
          spring = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };
        recent-windows-close = {
          spring = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.001;
          };
        };
      };

      # ===== Рабочие столы =====
      workspaces = [
        "1" "2" "3" "4" "5" "6" "7" "8"
        # "9" закомментирован в оригинале
      ];

      # ===== Правила для окон =====
      window-rules = [
        {
          match = {
            app-id = "obsidian";
          };
          open-on-workspace = "3";
        }
        {
          match = {
            app-id = "org.telegram.desktop";
          };
          open-on-workspace = "5";
        }
        {
          match = {
            app-id = "vesktop";
          };
          open-on-workspace = "5";
        }
        {
          match = {
            app-id = "one.alynx.showmethekey";
          };
          open-floating = true;
          open-focused = false;
          default-floating-position = {
            x = 990;
            y = 28;
            relative-to = "top-left";
          };
          min-width = 900;
          min-height = 170;
          border = {
            off = true;
          };
        }
        {
          match = {
            app-id = "^(mpv|imv|anki|showmethekey-gtk|Emulator|Android Emulator|blueman-manager)$";
          };
          open-floating = true;
        }
        {
          match = {
            app-id = r#"^org\.wezfurlong\.wezterm$"#;
          };
          default-column-width = { }; # пустой блок
        }
        {
          match = {
            app-id = r#"firefox$"#;
            title = "^Picture-in-Picture$";
          };
          open-floating = true;
        }
        # закомментированный пример с блокировкой захвата экрана
        # {
        #   match = {
        #     app-id = r#"^org\.keepassxc\.KeePassXC$"#;
        #   };
        #   block-out-from = "screen-capture";
        # }
      ];

      # ===== Горячие клавиши =====
      binds = {
        # Отображение справки
        "Mod+Shift+Slash".show-hotkey-overlay = null;

        # Запуск приложений
        "Mod+Shift+Return" = {
          spawn = "alacritty";
          hotkey-overlay-title = "Open a Terminal: alacritty";
        };
        "Mod+D" = {
          spawn = "fuzzel";
          hotkey-overlay-title = "Run an Application: fuzzel";
        };
        "Mod+N" = {
          spawn-sh = "swaync-client -t";
          hotkey-overlay-title = "Notification center";
        };
        "Super+Alt+L" = {
          spawn = "hyprlock";
          hotkey-overlay-title = "Lock the Screen: hyprlock";
        };

        # Аудио
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        # Медиа
        "XF86AudioPlay" = {
          allow-when-locked = true;
          spawn-sh = "playerctl play-pause";
        };
        "XF86AudioStop" = {
          allow-when-locked = true;
          spawn-sh = "playerctl stop";
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          spawn-sh = "playerctl previous";
        };
        "XF86AudioNext" = {
          allow-when-locked = true;
          spawn-sh = "playerctl next";
        };

        # Яркость (привязано к Mod+Shift+Bracket...)
        "Mod+Shift+BracketRight" = {
          allow-when-locked = true;
          spawn = [ "brightnessctl" "--class=backlight" "set" "+10%" ];
        };
        "Mod+Shift+BracketLeft" = {
          allow-when-locked = true;
          spawn = [ "brightnessctl" "--class=backlight" "set" "10%-" ];
        };

        # Обзор
        "Mod+O" = {
          repeat = false;
          toggle-overview = null;
        };

        # Закрыть окно
        "Mod+Shift+C" = {
          repeat = false;
          close-window = null;
        };

        # Навигация
        "Mod+h".focus-column-left = null;
        "Mod+j".focus-window-down = null;
        "Mod+k".focus-window-up = null;
        "Mod+l".focus-column-right = null;

        # Перемещение окон
        "Mod+Shift+Left".move-column-left = null;
        "Mod+Shift+Down".move-window-down = null;
        "Mod+Shift+Up".move-window-up = null;
        "Mod+Shift+Right".move-column-right = null;

        # Крайние позиции
        "Mod+Home".focus-column-first = null;
        "Mod+End".focus-column-last = null;
        "Mod+Ctrl+Home".move-column-to-first = null;
        "Mod+Ctrl+End".move-column-to-last = null;

        # Мониторы
        "Mod+Ctrl+Left".focus-monitor-left = null;
        "Mod+Ctrl+Down".focus-monitor-down = null;
        "Mod+Ctrl+Up".focus-monitor-up = null;
        "Mod+Ctrl+Right".focus-monitor-right = null;

        "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = null;
        "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = null;
        "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = null;
        "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = null;
        "Mod+Shift+Ctrl+H".move-column-to-monitor-left = null;
        "Mod+Shift+Ctrl+J".move-column-to-monitor-down = null;
        "Mod+Shift+Ctrl+K".move-column-to-monitor-up = null;
        "Mod+Shift+Ctrl+L".move-column-to-monitor-right = null;

        # Рабочие столы (перемещение)
        "Mod+Shift+Page_Down".move-workspace-down = null;
        "Mod+Shift+Page_Up".move-workspace-up = null;
        "Mod+Shift+U".move-workspace-down = null;
        "Mod+Shift+I".move-workspace-up = null;

        # Скролл колёсиком
        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          focus-workspace-down = null;
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          focus-workspace-up = null;
        };
        "Mod+Ctrl+WheelScrollDown" = {
          cooldown-ms = 150;
          move-column-to-workspace-down = null;
        };
        "Mod+Ctrl+WheelScrollUp" = {
          cooldown-ms = 150;
          move-column-to-workspace-up = null;
        };

        "Mod+WheelScrollRight".focus-column-right = null;
        "Mod+WheelScrollLeft".focus-column-left = null;
        "Mod+Ctrl+WheelScrollRight".move-column-right = null;
        "Mod+Ctrl+WheelScrollLeft".move-column-left = null;

        "Mod+Shift+WheelScrollDown".focus-column-right = null;
        "Mod+Shift+WheelScrollUp".focus-column-left = null;
        "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = null;
        "Mod+Ctrl+Shift+WheelScrollLeft".move-column-left = null;

        # Переключение рабочих столов по индексу
        "Mod+1".focus-workspace = 1;
        "Mod+2".focus-workspace = 2;
        "Mod+3".focus-workspace = 3;
        "Mod+4".focus-workspace = 4;
        "Mod+5".focus-workspace = 5;
        "Mod+6".focus-workspace = 6;
        "Mod+7".focus-workspace = 7;
        "Mod+8".focus-workspace = 8;
        "Mod+9".focus-workspace = 9;

        "Mod+Shift+1".move-column-to-workspace = 1;
        "Mod+Shift+2".move-column-to-workspace = 2;
        "Mod+Shift+3".move-column-to-workspace = 3;
        "Mod+Shift+4".move-column-to-workspace = 4;
        "Mod+Shift+5".move-column-to-workspace = 5;
        "Mod+Shift+6".move-column-to-workspace = 6;
        "Mod+Shift+7".move-column-to-workspace = 7;
        "Mod+Shift+8".move-column-to-workspace = 8;
        "Mod+Shift+9".move-column-to-workspace = 9;

        # Consume/Expel
        "Mod+BracketLeft".consume-or-expel-window-left = null;
        "Mod+BracketRight".consume-or-expel-window-right = null;
        "Mod+Comma".consume-window-into-column = null;
        "Mod+Period".expel-window-from-column = null;

        # Размеры
        "Mod+R".switch-preset-column-width = null;
        "Mod+Shift+R".switch-preset-window-height = null;
        "Mod+Ctrl+R".reset-window-height = null;
        "Mod+F".maximize-column = null;
        "Mod+Shift+F".fullscreen-window = null;
        "Mod+M".maximize-window-to-edges = null;
        "Mod+Ctrl+F".expand-column-to-available-width = null;
        "Mod+C".center-column = null;
        "Mod+Ctrl+C".center-visible-columns = null;

        "Mod+Minus" = {
          set-column-width = "-5%";
        };
        "Mod+Equal" = {
          set-column-width = "+5%";
        };
        "Mod+Shift+Minus" = {
          set-window-height = "-5%";
        };
        "Mod+Shift+Equal" = {
          set-window-height = "+5%";
        };

        # Плавающий режим
        "Mod+V".toggle-window-floating = null;
        "Mod+Shift+V".switch-focus-between-floating-and-tiling = null;

        # Вкладки
        "Mod+W".toggle-column-tabbed-display = null;

        # Скриншоты
        "Print".screenshot = null;
        "Ctrl+Print".screenshot-screen = null;
        "Alt+Print".screenshot-window = null;

        # Ингибитор клавиш
        "Mod+Escape" = {
          allow-inhibiting = false;
          toggle-keyboard-shortcuts-inhibit = null;
        };

        # Выход
        "Mod+Shift+E".quit = null;
        "Ctrl+Alt+Delete".quit = null;

        # Выключение мониторов
        "Mod+Shift+P".power-off-monitors = null;
      };
    };
  };
}
