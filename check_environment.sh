#!/bin/bash

echo "=== Godot DevContainer Environment Check ==="
echo

# Check Godot installation
echo "Checking Godot installation..."
if command -v godot &> /dev/null; then
    GODOT_VERSION=$(godot --version)
    echo "✅ Godot is installed: $GODOT_VERSION"
else
    echo "❌ Godot is not installed or not in PATH"
fi

echo

# Check SSH service
echo "Checking SSH service..."
if service ssh status &> /dev/null; then
    echo "✅ SSH service is running"
    echo "   Connect using: ssh vscode@localhost -p 2222"
    echo "   No password required - passwordless authentication is configured"
else
    echo "❌ SSH service is not running"
    echo "   Start it with: sudo service ssh start"
fi

echo

# Check export templates
echo "Checking Godot export templates..."
if [ -d "/home/vscode/.local/share/godot/export_templates/4.3.stable/" ]; then
    echo "✅ Export templates are installed"
else
    echo "❌ Export templates are not installed"
fi

echo

# Check Python and gdtoolkit
echo "Checking Python and gdtoolkit..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✅ Python is installed: $PYTHON_VERSION"
    
    if pip3 list | grep -q gdtoolkit; then
        GDTOOLKIT_VERSION=$(pip3 show gdtoolkit | grep Version | awk '{print $2}')
        echo "✅ gdtoolkit is installed: v$GDTOOLKIT_VERSION"
    else
        echo "❌ gdtoolkit is not installed"
    fi
else
    echo "❌ Python is not installed or not in PATH"
fi

echo
echo "=== Environment Check Complete ==="
