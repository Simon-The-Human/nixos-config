{ pkgs, inputs, ... }: {
  imports = [ inputs.niri.homeModules.niri ];
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

        default-column-width = {
          proportion = 0.5;
        };

        focus-ring = {
          enable = true;
          width = 5;
          active.gradient = {
            from = "#eba54d";
            to = "#80ab24";
            angle = 135;
          };
          inactive.color = "#212733";
        };

        border = {
          width = 5;
          active.gradient = {
            from = "#eba54d";
            to = "#80ab24";
            angle = 135;
          };
          inactive.color = "#212733"; # из темы
          urgent.color = "#e7666a";
        };

        shadow = {
          enable = false; # отключено
        };
      };

      # ===== Автозапуск =====
      spawn-at-startup = [
        { sh = "xwayland-satellite"; }
        { sh = "waybar -c ~/.config/waybar/config_niri.json"; }
        {
          argv = [
            "wl-paste"
            "--type"
            "text"
            "--watch"
            "cliphist"
            "store"
          ];
        }
        {
          argv = [
            "wl-paste"
            "--type"
            "image"
            "--watch"
            "cliphist"
            "store"
          ];
        }
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
          kind.spring = {
            damping-ratio = 1.0;
            stiffness = 1000;
            epsilon = 0.0001;
          };
        };
        window-open = {
          kind.easing = {
            duration-ms = 150;
            curve = "ease-out-quad";
          };
        };
        window-close = {
          kind.easing = {
            duration-ms = 150;
            curve = "ease-out-quad";
          };
        };
        horizontal-view-movement = {
          kind.spring = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };
        window-movement = {
          kind.spring = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };
        window-resize = {
          kind.spring = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };
        config-notification-open-close = {
          kind.spring = {
            damping-ratio = 0.6;
            stiffness = 1000;
            epsilon = 0.001;
          };
        };
        exit-confirmation-open-close = {
          kind.spring = {
            damping-ratio = 0.6;
            stiffness = 500;
            epsilon = 0.01;
          };
        };
        screenshot-ui-open = {
          kind.easing = {
            duration-ms = 200;
            curve = "ease-out-quad";
          };
        };
        overview-open-close = {
          kind.spring = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };
      };

      # ===== Рабочие столы =====
      # workspaces = [
      # ];

      # ===== Правила для окон =====
      window-rules = [
        {
          matches = [
            {
              app-id = "obsidian";
            }
          ];
          open-on-workspace = "3";
        }
        {
          matches = [
            {
              app-id = "org.telegram.desktop";
            }
          ];
          open-on-workspace = "5";
        }
        {
          matches = [
            {
              app-id = "vesktop";
            }
          ];
          open-on-workspace = "5";
        }
        {
          matches = [
            {
              app-id = "one.alynx.showmethekey";
            }
          ];
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
            enable = false;
          };
        }
        {
          matches = [
            {
              app-id = "^(mpv|imv|anki|showmethekey-gtk|Emulator|Android Emulator|blueman-manager)$";
            }
          ];
          open-floating = true;
        }
        {
          matches = [
            {
              app-id = "^org\\.wezfurlong\\.wezterm$";
            }
          ];
          default-column-width = { }; # пустой блок
        }
        {
          matches = [
            {
              app-id = "firefox$";
            }
            {
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
        # закомментированный пример с блокировкой захвата экрана
        # {
        #   matches = {
        #     app-id = r#"^org\.keepassxc\.KeePassXC$"#;
        #   };
        #   block-out-from = "screen-capture";
        # }
      ];

      # ===== Горячие клавиши =====
      binds = {
        # Отображение справки
        "Mod+Shift+Slash".action.show-hotkey-overlay = null;

        # Запуск приложений
        "Mod+Return" = {
          action.spawn = "alacritty";
          hotkey-overlay.title = "Open a Terminal: alacritty";
        };
        "Mod+D" = {
          action.spawn = "fuzzel";
          hotkey-overlay.title = "Run an Application: fuzzel";
        };
        "Mod+N" = {
          action.spawn = "swaync-client -t";
          hotkey-overlay.title = "Notification center";
        };
        # "Super+Alt+L" = {
        #   action.spawn = "hyprlock";
        #   hotkey-overlay.title = "Lock the Screen: hyprlock";
        # };

        # Аудио
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action.spawn = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        # Медиа
        "XF86AudioPlay" = {
          allow-when-locked = true;
          action.spawn = "playerctl play-pause";
        };
        "XF86AudioStop" = {
          allow-when-locked = true;
          action.spawn = "playerctl stop";
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          action.spawn = "playerctl previous";
        };
        "XF86AudioNext" = {
          allow-when-locked = true;
          action.spawn = "playerctl next";
        };

        # Яркость (привязано к Mod+Shift+Bracket...)
        "Mod+Shift+BracketRight" = {
          allow-when-locked = true;
          action.spawn = [
            "brightnessctl"
            "--class=backlight"
            "set"
            "+10%"
          ];
        };
        "Mod+Shift+BracketLeft" = {
          allow-when-locked = true;
          action.spawn = [
            "brightnessctl"
            "--class=backlight"
            "set"
            "10%-"
          ];
        };

        # Обзор
        "Mod+O" = {
          repeat = false;
          action.toggle-overview = null;
        };

        # Закрыть окно
        "Mod+Shift+C" = {
          repeat = false;
          action.close-window = null;
        };

        # Навигация
        "Mod+H".action.focus-column-left = null;
        "Mod+J".action.focus-window-down = null;
        "Mod+K".action.focus-window-up = null;
        "Mod+L".action.focus-column-right = null;

        # Перемещение окон
        "Mod+Shift+H".action.move-column-left = null;
        "Mod+Shift+J".action.move-window-down = null;
        "Mod+Shift+K".action.move-window-up = null;
        "Mod+Shift+L".action.move-column-right = null;

        # Крайние позиции
        "Mod+Home".action.focus-column-first = null;
        "Mod+End".action.focus-column-last = null;
        "Mod+Ctrl+Home".action.move-column-to-first = null;
        "Mod+Ctrl+End".action.move-column-to-last = null;

        # Мониторы
        "Mod+Ctrl+H".action.focus-monitor-left = null;
        "Mod+Ctrl+J".action.focus-monitor-down = null;
        "Mod+Ctrl+K".action.focus-monitor-up = null;
        "Mod+Ctrl+L".action.focus-monitor-right = null;

        "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = null;
        "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = null;
        "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = null;
        "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = null;

        # Рабочие столы (перемещение)
        "Mod+Shift+Page_Down".action.move-workspace-down = null;
        "Mod+Shift+Page_Up".action.move-workspace-up = null;
        "Mod+Shift+U".action.move-workspace-down = null;
        "Mod+Shift+I".action.move-workspace-up = null;

        # Скролл колёсиком
        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-workspace-down = null;
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-workspace-up = null;
        };
        "Mod+Ctrl+WheelScrollDown" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-down = null;
        };
        "Mod+Ctrl+WheelScrollUp" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-up = null;
        };

        "Mod+WheelScrollRight".action.focus-column-right = null;
        "Mod+WheelScrollLeft".action.focus-column-left = null;
        "Mod+Ctrl+WheelScrollRight".action.move-column-right = null;
        "Mod+Ctrl+WheelScrollLeft".action.move-column-left = null;

        "Mod+Shift+WheelScrollDown".action.focus-column-right = null;
        "Mod+Shift+WheelScrollUp".action.focus-column-left = null;
        "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = null;
        "Mod+Ctrl+Shift+WheelScrollLeft".action.move-column-left = null;

        # Переключение рабочих столов по индексу
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;

        # Consume/Expel
        "Mod+BracketLeft".action.action.consume-or-expel-window-left = null;
        "Mod+BracketRight".action.action.consume-or-expel-window-right = null;
        "Mod+Comma".action.action.consume-window-into-column = null;
        "Mod+Period".action.action.expel-window-from-column = null;

        # Размеры
        "Mod+R".action.action.switch-preset-column-width = null;
        "Mod+Shift+R".action.action.switch-preset-window-height = null;
        "Mod+Ctrl+R".action.action.reset-window-height = null;
        "Mod+F".action.action.maximize-column = null;
        "Mod+Shift+F".action.action.fullscreen-window = null;
        "Mod+M".action.action.maximize-window-to-edges = null;
        "Mod+Ctrl+F".action.action.expand-column-to-available-width = null;
        "Mod+C".action.action.center-column = null;
        "Mod+Ctrl+C".action.action.center-visible-columns = null;

        "Mod+Minus" = {
          action.set-column-width = "-5%";
        };
        "Mod+Equal" = {
          action.set-column-width = "+5%";
        };
        "Mod+Shift+Minus" = {
          action.set-window-height = "-5%";
        };
        "Mod+Shift+Equal" = {
          action.set-window-height = "+5%";
        };

        # Плавающий режим
        "Mod+V".action.toggle-window-floating = null;
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = null;

        # Вкладки
        "Mod+W".action.toggle-column-tabbed-display = null;

        # Скриншоты
        "Print".action.screenshot = null;
        "Ctrl+Print".action.screenshot-screen = null;
        "Alt+Print".action.screenshot-window = null;

        # Ингибитор клавиш
        "Mod+Escape" = {
          allow-inhibiting = false;
          action.toggle-keyboard-shortcuts-inhibit = null;
        };

        # Выход
        "Mod+Q".action.quit.skip-confirmation = true;

        # Выключение мониторов
        "Mod+Shift+P".action.power-off-monitors = null;
      };
    };
  };
}
