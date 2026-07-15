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
```
  nix run github:aksiksi/compose2nix -- \
  -inputs=docker-compose.yml \
  -output=compose.nix \
  -include_env_files=true \
  -check_bind_mounts=true \
  -use_upheld_by=true \
  -runtime=docker \
  -project=paperless \
  -root_path=/home/hallow/containers/paperless \
  -env_files=/home/hallow/nixos/modules/nixos/server/paperless/.env,/home/hallow/nixos/modules/nixos/server/paperless/docker-compose.env
```

# Remote
## Remote Hardware Config
nix run github:nix-community/nixos-anywhere -- \
  --flake .#vps \
  --generate-hardware-config nixos-generate-config ./hosts/vps/hardware-configuration.nix \
  root@31.56.233.116
## Remote Rebuild
nixos-rebuild switch \
  --flake .#vps \
  --target-host hallow@31.56.233.116 \
  --build-host hallow@31.56.233.116 \
  --use-remote-sudo \
  --ask-sudo-password
