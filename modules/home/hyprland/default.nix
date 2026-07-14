{ inputs, pkgs, lib, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    package = null;

    settings = {
      "$mainMod" = "SUPER";

      input = {
        kb_layout = "de";
        kb_options = "caps:swapescape";
        follow_mouse = 1;
        sensitivity = -0.15;
        touchpad.natural_scroll = true;
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
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

 
      # windowrulev2 goes in a list (like bind)
      # windowrulev2 = [
        # "opacity 0.8 0.8, class:^(kitty)$"
      # ];
      windowrule = [
        "match:class ^(kitty)$, opacity 0.8 0.8"
      ];

      # animations becomes a nested set
      animations = {
        enabled = "yes";
        # Beziers and animations are lists within the set
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

      # Keybinds
      bind = [
        "$mainMod, RETURN, exec, kitty"
        "$mainMod SHIFT, Q, killactive"
        "$mainMod, R, exec, rofi -show drun"
        "$mainMod, F, fullscreen"
        "$mainMod, V, togglefloating"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
     
        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ] ++ [
        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
      ] ++ [
        # Special workspaces
        "$mainMod, S, togglespecialworkspace, spotify"
        "$mainMod SHIFT, S, movetoworkspace, special:spotify"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      binde = [
      # Volume control
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@" # mute
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" # decrease volume
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+" # increase volume

      # Spotify control
      ", XF86AudioPlay, exec, playerctl -p spotify play-pause # play-pause"
      ", XF86AudioPrev, exec, playerctl -p spotify previous # previous"
      ", XF86AudioNext, exec, playerctl -p spotify next # next"
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

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
    
    # This is the line that fixes the warning:
    config.common.default = "*"; 
    
    config.hyprland.default = [ "hyprland" "gtk" ];
  };
}
