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
