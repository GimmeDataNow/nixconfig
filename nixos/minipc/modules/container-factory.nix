# /etc/nixos/modules/container-factory.nix
#
# This module acts as a factory for creating NixOS containers declaratively.
# It reads a list of service definitions and generates:
# 1. The full configuration for each container.
# 2. Port forwarding from the host to the container.
# 3. Firewall rules on the host to allow traffic to the containers.

{ config, lib, pkgs, ... }:

with lib;

let
  # Get the custom options defined below.
  cfg = config.services.containerFactory;

  # This function takes a container definition from your list and transforms it
  # into a full NixOS container configuration attribute set.
  buildContainer = containerDef:
    let
      # --- Input Validation ---
      # Ensure each definition has the required attributes.
      requiredAttrs = [ "name" "service" "hostPort" ];
      missingAttrs = filter (attr: !hasAttr attr containerDef) requiredAttrs;
    in
    if missingAttrs != []
    then throw "Container definition is missing required attributes: ${toString missingAttrs}"
    else
      # --- Configuration Generation ---
      nameValuePair containerDef.name {
        # Start this container automatically on boot.
        autoStart = true;

        # Use a private network for communication between the host and container.
        privateNetwork = true;

        # We generate a unique IP address for each container based on its port
        # to avoid collisions. This is a simple but effective trick.
        hostAddress = "10.233.${toString (containerDef.hostPort % 254 + 1)}.${toString (containerDef.hostPort / 254)}";
        localAddress = "10.233.${toString (containerDef.hostPort % 254 + 1)}.${toString (containerDef.hostPort / 254 + 1)}";

        # Forward the specified port from the host to the same port inside the container.
        forwardPorts = [
          {
            hostPort = containerDef.hostPort;
            containerPort = containerDef.hostPort;
          }
        ];

        # This is the actual NixOS configuration for the system running *inside* the container.
        # We pass the `containerDef` attrset down to the container's modules
        # so they can access things like the port number.
        specialArgs = { inherit containerDef; };
        config = {
          # Import the specific service module for this container.
          # The path is constructed from the `service` attribute (e.g., "suwayomi" -> ./services/suwayomi.nix).
          imports = [ (./. + "/services/${containerDef.service}.nix") ];

          # Basic container configuration.
          system.stateVersion = config.system.stateVersion; # Inherit state version from host.

          # Disable the container's own firewall, as the host manages access.
          networking.firewall.enable = false;

          # Allow logging in as root without a password for easy debugging.
          # Use `nixos-container login <name>` to get a shell.
          users.users.root.initialHashedPassword = "";

          # Allow unfree packages if needed by the service within the container.
          nixpkgs.config.allowUnfree = true;
        };
      };

in {
  # --- Custom Options ---
  # We define a new set of options under `services.containerFactory` to make the configuration clean.
  options.services.containerFactory = {
    enable = mkEnableOption "declarative NixOS container factory";

    containersList = mkOption {
      type = types.listOf (types.submoduleWith {
        modules = [
          ({ ... }: {
            options = {
              name = mkOption {
                type = types.str;
                description = "The unique name for the container (e.g., 'suwayomi-main').";
              };
              service = mkOption {
                type = types.str;
                description = "The type of service this container runs (e.g., 'suwayomi'), which maps to a file in ./services/";
              };
              hostPort = mkOption {
                type = types.port;
                description = "The port on the host machine that will be forwarded to the container.";
              };
            };
          })
        ];
      });
      default = [];
      description = "A list of attribute sets defining the containers to be built.";
      example = literalExample ''
        [
          { name = "paperless"; service = "paperless"; hostPort = 8080; }
          { name = "suwayomi"; service = "suwayomi"; hostPort = 4567; }
        ]
      '';
    };
  };

  # --- System Configuration ---
  # This section applies the generated configurations to your actual system.
  config = mkIf cfg.enable {
    # Generate the `containers` attribute set by mapping our build function
    # over the user-provided list and converting the result to an attribute set.
    containers = listToAttrs (map buildContainer cfg.containersList);

    # Automatically open the firewall ports on the host for each container.
    # This reads the `hostPort` from the same list, ensuring the firewall
    # is always in sync with your containers.
    networking.firewall.allowedTCPPorts = map (c: c.hostPort) cfg.containersList;
  };
}
