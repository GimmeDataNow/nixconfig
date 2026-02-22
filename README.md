This project contains the configurations for all of my nixos machines.

## Project Structure
`tree -a -I '.git'`
```.
├── pkgs
├── modules
│   ├── nixos
│   │   ├── server
│   │   │   └── common.nix
│   │   ├── desktop
│   │   │   ├── fonts.nix
│   │   │   ├── security.nix
│   │   │   ├── sound.nix
│   │   │   ├── printer.nix
│   │   │   ├── networking.nix
│   │   │   ├── hyprland.nix
│   │   │   ├── programs-cli.nix
│   │   │   ├── programs-gui.nix
│   │   │   ├── gpu-amd.nix
│   │   │   ├── programs.nix
│   │   │   ├── programs
│   │   │   │   ├── programs.nix
│   │   │   │   ├── gaming.nix
│   │   │   │   ├── communication.nix
│   │   │   │   ├── cli.nix
│   │   │   │   └── gui.nix
│   │   │   ├── power.nix
│   │   │   └── backlight.nix
│   │   └── common
│   │       ├── common.nix
│   │       ├── boot.nix
│   │       └── location.nix
│   └── home
│       ├── wayland.nix
│       ├── shell.nix
│       ├── spicetify.nix
│       ├── desktop.nix
│       └── hyprland
│           └── default.nix
├── flake.lock
├── flake.nix
└── hosts
    ├── minipc
    ├── laptop
    │   ├── hardware.nix
    │   └── configuration.nix
    ├── vps
    │   └── configuration.nix
    └── desktop
        ├── hardware.nix
        └── configuration.nix
```
