#!/bin/bash

# Ensure runtime directory exists
mkdir -p /tmp/runtime-dir
chmod 700 /tmp/runtime-dir

# Set environment variables if not already set
export DISPLAY=${DISPLAY:-:99}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/tmp/runtime-dir}

# Run Godot in headless mode with the provided arguments
godot --headless "$@"
