#!/bin/bash

# Check if project name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <project_name>"
  exit 1
fi

PROJECT_NAME=$1

# Create project structure
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Create project.godot file
cat > project.godot << EOL
; Engine configuration file.
; It's best edited using the editor UI and not directly,
; since the parameters that go here are not all obvious.
;
; Format:
;   [section] ; section goes between []
;   param=value ; assign values to parameters

config_version=5

[application]

config/name="$PROJECT_NAME"
run/main_scene="res://main.tscn"
config/features=PackedStringArray("4.3", "Forward Plus")
config/icon="res://icon.svg"

[rendering]

renderer/rendering_method="gl_compatibility"
EOL

# Create a basic scene
mkdir -p scenes

echo "Project '$PROJECT_NAME' created successfully!"
echo "You can now open it with Godot by running: godot --path $PROJECT_NAME"
