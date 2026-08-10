#!/bin/bash
set -o errexit
set -o xtrace

# Process config as root because `/run_command` must stay root-controlled.
# Use sudoers `env_keep` instead of `sudo -E`.
sudo kolla_set_configs
CMD=$(cat /run_command)
ARGS=""

# Install custom CA certificates
sudo kolla_copy_cacerts

if [[ ! "${!KOLLA_SKIP_EXTEND_START[@]}" ]]; then
    # Run additional commands if present
    . kolla_extend_start
fi

echo "Running command: '${CMD}${ARGS:+ $ARGS}'"
umask "${CONTAINER_KOLLA_UMASK:-0022}"
exec ${CMD} ${ARGS}
