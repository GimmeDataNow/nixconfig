{ pkgs, lib, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    # Use xwayland from our previous discussion
    # xwayland.enable = true;
    package = null;

    settings = {
      "$mainMod" = "SUPER";

      # Basic Input
      input = {
        kb_layout = "de";
        kb_options = "caps:swapescape";
        follow_mouse = 1;
        sensitivity = -0.15;
        touchpad.natural_scroll = "no";
      };

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgba(546484ff)";
        "col.inactive_border" = "rgba(434c5eff)";
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

      # Keybinds
      bind = [
        "$mainMod, RETURN, exec, kitty"
        "$mainMod SHIFT, Q, killactive"
        "$mainMod, R, exec, rofi -show drun"
        "$mainMod, F, fullscreen"
        "$mainMod, V, togglefloating"
        
        # Workspaces and focus (Shortened for brevity, include all yours here)
        "$mainMod, left, movefocus, l"
        "$mainMod, 1, workspace, 1"
        # ... add your 1-0 binds ...
      ] ++ [
        # Media keys
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ];

      # Environment Variables (merged from your list)
      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland;xcb"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];

      # Startup
      "exec-once" = [
        "sh ~/.config/.scripts/start.sh"
        "[workspace special:spotify silent] spotify"
      ];
    };
  };
}
