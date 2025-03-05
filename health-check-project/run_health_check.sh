#!/bin/bash

# Run the health check in headless mode
/workspaces/godot/run_godot_headless.sh --path /workspaces/godot/health-check-project --script headless_health_check.gd
