nix run github:aksiksi/compose2nix -- \
-inputs=docker-compose.yml \
-output=compose.nix \
-include_env_files=false \
-check_bind_mounts=true \
-use_upheld_by=true \
-runtime=docker \
-project=suwayomi \
-root_path=/home/hallow/containers/suwayomi
