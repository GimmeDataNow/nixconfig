This project contains the configurations for all of my nixos machines.

## Project Structure
`tree -a -I '.git'`
```
.
├── flake.lock
├── flake.nix
├── hosts
│   ├── desktop
│   │   ├── configuration.nix
│   │   └── hardware.nix
│   ├── laptop
│   │   ├── configuration.nix
│   │   └── hardware.nix
│   ├── minipc
│   │   ├── configuration.nix
│   │   └── hardware.nix
│   └── vps
│       └── configuration.nix
├── modules
│   ├── home
│   │   ├── desktop.nix
│   │   ├── hyprland
│   │   │   └── default.nix
│   │   ├── shell.nix
│   │   ├── spicetify.nix
│   │   └── wayland.nix
│   └── nixos
│       ├── common
│       │   ├── boot.nix
│       │   ├── common.nix
│       │   └── location.nix
│       ├── desktop
│       │   ├── backlight.nix
│       │   ├── fonts.nix
│       │   ├── gpu-amd.nix
│       │   ├── hyprland.nix
│       │   ├── networking.nix
│       │   ├── power.nix
│       │   ├── printer.nix
│       │   ├── programs
│       │   │   ├── cli.nix
│       │   │   ├── communication.nix
│       │   │   ├── gaming.nix
│       │   │   ├── gui.nix
│       │   │   └── programs.nix
│       │   ├── programs-cli.nix
│       │   ├── programs-gui.nix
│       │   ├── programs.nix
│       │   ├── security.nix
│       │   └── sound.nix
│       └── server
│           ├── common.nix
│           ├── paperless
│           │   ├── docker-compose.yml
│           │   └── service.nix
│           └── portainer
│               ├── docker-compose.yml
│               └── service.nix
└── README.md
```

## Project utilites

### compose2nix
`nix run github:aksiksi/compose2nix -- -inputs=docker-compose.yml -output=compose.nix -env_files=.env -include_env_files=true -check_bind_mounts=true -use_upheld_by=true -runtime=docker -project=paperless -root_path /home/hallow/paperless`
