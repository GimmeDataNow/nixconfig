{ inputs, pkgs, lib, ... }: 

let
  # Helper to make raw Lua code injections cleaner to write
  lua = lib.generators.mkLuaInline;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua"; # Enables the modern Lua generator
    package = null;

    settings = {
      mod = { _var = "SUPER"; };

      # monito r = [
      #   { output = ""; mode = "preferred"; position = "auto"; scale = 1; }
      #   { output = ""; mode = "preferred"; position = "auto"; scale = 1; }

      #   # { _args = [ { output = "HDMI-A-1"; mode = "preferred"; position = "auto"; scale = 1; } ]; }
      #  # { _args = [ { output = "HDMI-A-2"; mode = "preferred"; position = "auto"; scale = 1; } ]; }
      # ];
      monitor = lib.mkForce [
        {
          _args = [
            {
              output = "";
              mode = "preferred";
              position = "auto";
              scale = 1;
            }
          ];
        }
      ];

      config = {
        input = {
          kb_layout = "de";
          kb_options = "caps:swapescape";
          follow_mouse = 1;
          sensitivity = -0.15;
          touchpad = {
            natural_scroll = true;
          };
        };

        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 2;
          col = {
            active_border = "rgba(546484ff)";
            inactive_border = "rgba(434c5eff)";
          };
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        animations = {
          enabled = true;
          bezier = [
            "myBezier, 0.05, 0.9, 0.1, 1.05"
          ];
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
            "specialWorkspace, 1, 6, default, slidefadevert 50%"
          ];
        };
      };

      window_rule = [
        {
          _args = [
            {
              match = { class = "^(kitty)$"; };
              opacity = "0.8 0.8";
            }
          ];
        }
      ];

      # 4. Bindings (Maps to: hl.bind(keys, dispatcher))
      bind = [
        # Terminal & Core binds
        { _args = [ (lua "mod .. \" + RETURN\"") (lua "hl.dsp.exec_cmd(\"kitty\")") ]; }
        { _args = [ (lua "mod .. \" + SHIFT + Q\"") (lua "hl.dsp.window.close()") ]; }
        { _args = [ (lua "mod .. \" + R\"") (lua "hl.dsp.exec_cmd(\"rofi -show drun\")") ]; }
        { _args = [ (lua "mod .. \" + F\"") (lua "hl.dsp.window.fullscreen()") ]; }
        { _args = [ (lua "mod .. \" + V\"") (lua "hl.dsp.window.float({ action = \"toggle\" })") ]; }

        # Focus commands (using Lua's standard focus dispatchers)
        { _args = [ (lua "mod .. \" + left\"") (lua "hl.dsp.focus({ direction = \"l\" })") ]; }
        { _args = [ (lua "mod .. \" + right\"") (lua "hl.dsp.focus({ direction = \"r\" })") ]; }
        { _args = [ (lua "mod .. \" + up\"") (lua "hl.dsp.focus({ direction = \"u\" })") ]; }
        { _args = [ (lua "mod .. \" + down\"") (lua "hl.dsp.focus({ direction = \"d\" })") ]; }

        # Mouse workspace scrolls
        { _args = [ (lua "mod .. \" + mouse_down\"") (lua "hl.dsp.focus({ workspace = \"e+1\" })") ]; }
        { _args = [ (lua "mod .. \" + mouse_up\"") (lua "hl.dsp.focus({ workspace = \"e-1\" })") ]; }

        # Workspaces
        { _args = [ (lua "mod .. \" + 1\"") (lua "hl.dsp.focus({ workspace = \"1\" })") ]; }
        { _args = [ (lua "mod .. \" + 2\"") (lua "hl.dsp.focus({ workspace = \"2\" })") ]; }
        { _args = [ (lua "mod .. \" + 3\"") (lua "hl.dsp.focus({ workspace = \"3\" })") ]; }
        { _args = [ (lua "mod .. \" + 4\"") (lua "hl.dsp.focus({ workspace = \"4\" })") ]; }
        { _args = [ (lua "mod .. \" + 5\"") (lua "hl.dsp.focus({ workspace = \"5\" })") ]; }
        { _args = [ (lua "mod .. \" + 6\"") (lua "hl.dsp.focus({ workspace = \"6\" })") ]; }
        { _args = [ (lua "mod .. \" + 7\"") (lua "hl.dsp.focus({ workspace = \"7\" })") ]; }
        { _args = [ (lua "mod .. \" + 8\"") (lua "hl.dsp.focus({ workspace = \"8\" })") ]; }
        { _args = [ (lua "mod .. \" + 9\"") (lua "hl.dsp.focus({ workspace = \"9\" })") ]; }

        { _args = [ (lua "mod .. \" + SHIFT + 1\"") (lua "hl.dsp.window.move({ workspace = \"1\" })") ]; }
        { _args = [ (lua "mod .. \" + SHIFT + 2\"") (lua "hl.dsp.window.move({ workspace = \"2\" })") ]; }
        { _args = [ (lua "mod .. \" + SHIFT + 3\"") (lua "hl.dsp.window.move({ workspace = \"3\" })") ]; }
        { _args = [ (lua "mod .. \" + SHIFT + 4\"") (lua "hl.dsp.window.move({ workspace = \"4\" })") ]; }
        { _args = [ (lua "mod .. \" + SHIFT + 5\"") (lua "hl.dsp.window.move({ workspace = \"5\" })") ]; }
        { _args = [ (lua "mod .. \" + SHIFT + 6\"") (lua "hl.dsp.window.move({ workspace = \"6\" })") ]; }
        { _args = [ (lua "mod .. \" + SHIFT + 7\"") (lua "hl.dsp.window.move({ workspace = \"7\" })") ]; }
        { _args = [ (lua "mod .. \" + SHIFT + 8\"") (lua "hl.dsp.window.move({ workspace = \"8\" })") ]; }
        { _args = [ (lua "mod .. \" + SHIFT + 9\"") (lua "hl.dsp.window.move({ workspace = \"9\" })") ]; }

        # Mouse Controls

        { _args = [ (lua "mod .. \" + mouse:272\"") (lua "hl.dsp.window.drag()") { mouse = true; } ]; }

        # Resize windows with click and drag (Right Mouse Button)
        { _args = [ (lua "mod .. \" + mouse:273\"") (lua "hl.dsp.window.resize()") { mouse = true; } ]; }

        # Special Workspaces
        { _args = [ (lua "mod .. \" + S\"") (lua "hl.dsp.workspace.toggle_special(\"spotify\")") ]; }
        { _args = [ (lua "mod .. \" + SHIFT + S\"") (lua "hl.dsp.window.move({ workspace = \"special:spotify\" })") ]; }
      ];

      on = [
        {
          _args = [
            "hyprland.start"
            (lua ''
              function()
                hl.exec_cmd("sh ~/.config/.scripts/start.sh")
                hl.exec_cmd("spotify", { workspace = "special:spotify silent" })
              end
            '')
          ];
        }
      ];
    };

  };
}
