#!/bin/sh
set -eu

IMAGE="${1:-}"

if [ -z "$IMAGE" ]; then
  echo "Usage: sh /work/scripts/inspect-image.sh <image:tag>"
  exit 1
fi

echo "== docker image inspect =="
docker image inspect "$IMAGE" | jq '.[0] | {
  id: .Id,
  repoTags: .RepoTags,
  created: .Created,
  architecture: .Architecture,
  os: .Os,
  size: .Size,
  rootfs: .RootFS,
  config: {
    env: .Config.Env,
    entrypoint: .Config.Entrypoint,
    cmd: .Config.Cmd,
    workingDir: .Config.WorkingDir
  }
}'

echo
echo "== docker history =="
docker history --no-trunc "$IMAGE"
