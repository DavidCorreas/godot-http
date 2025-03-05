# Godot HTTPS Health Check

This project demonstrates how to make an HTTPS request to a health check endpoint with SSL verification disabled (similar to `curl -k`).

## Features

- Makes an HTTPS request to `https://192.168.1.70:8443/health`
- Disables SSL certificate verification (equivalent to `curl -k`)
- Handles response data and errors
- Can be run in both GUI and headless modes

## Running the Project

### In the Godot Editor

1. Open the project in Godot
2. Press F5 or click the "Play" button to run the main scene

### In Headless Mode

To run the health check in headless mode (without a GUI):

```bash
# From the project root directory
/workspaces/godot/run_godot_headless.sh --path health-check-project

# Or to run the specific headless script
/workspaces/godot/run_godot_headless.sh --path health-check-project --script headless_health_check.gd
```

## How It Works

The project uses Godot's `HTTPRequest` node to make an HTTPS request to the specified endpoint. SSL verification is disabled using `TLSOptions.client_unsafe()`, which is equivalent to the `-k` flag in curl.

### Key Components

- `health_check.gd`: The main script for making the HTTPS request in GUI mode
- `headless_health_check.gd`: Script for making the HTTPS request in headless mode
- `main.tscn`: The main scene that runs the health check script

## Notes on SSL Verification

Disabling SSL verification (using `TLSOptions.client_unsafe()`) means that the client will not verify the server's certificate. This is equivalent to using the `-k` or `--insecure` flag with curl. This should only be used in development or testing environments, or when connecting to servers with self-signed certificates.
