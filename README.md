# Godot DevContainer Environment

A complete development environment for Godot 4.3 using VS Code DevContainers with SSH access.

## Features

- Godot 4.3 (stable) pre-installed
- SSH server accessible on port 2222
- VS Code integration with Godot tools
- Export templates pre-installed
- Python and gdtoolkit for linting
- Helper script for project creation

## Prerequisites

- Docker
- Visual Studio Code
- Remote - Containers extension for VS Code

## Getting Started

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd godot
   ```

2. Build the DevContainer:
   ```bash
   devcontainer build --workspace-folder /home/david/tmp_projects/godot --no-cache
   ```

3. Start the DevContainer:
   ```bash
   devcontainer up --workspace-folder /home/david/tmp_projects/godot
   ```

4. Open the folder in VS Code:
   ```bash
   ssh vscode@localhost -p 2222 -F /dev/null
   ```

5. When prompted, click "Reopen in Container" or use the command palette (F1) and select "Remote-Containers: Reopen in Container".

6. VS Code will connect to the running container. This may take a few moments.

## SSH Access

The container exposes SSH on port 2222. You can connect using:

```bash
ssh vscode@localhost -p 2222 -F /dev/null
```

No password is required - the container is configured for passwordless SSH access.

## Creating a New Godot Project

Use the included script to create a new Godot project:

```bash
./create_project.sh MyNewGame
```

This will create a basic project structure with a minimal configuration.

## Opening an Existing Project

To open an existing Godot project:

```bash
godot --path /path/to/your/project
```

## Building and Exporting

Export templates are pre-installed. You can export your project using:

```bash
godot --headless --export "Linux/X11" /path/to/output/game.x86_64
```

## Making HTTP Requests in Godot

Godot provides a robust HTTP client for making network requests. Below is a comprehensive guide on how to use HTTP requests in your Godot projects, including examples for different request types.

### Basic HTTP GET Request

```gdscript
extends Node

func _ready():
    # Create an HTTP request node
    var http_request = HTTPRequest.new()
    add_child(http_request)
    
    # Connect to the request completed signal
    http_request.request_completed.connect(_on_request_completed)
    
    # Make a request to a URL
    var error = http_request.request("https://httpbin.org/get")
    if error != OK:
        print("An error occurred while making the HTTP request")

# Called when the HTTP request is completed
func _on_request_completed(result, response_code, headers, body):
    if result != HTTPRequest.RESULT_SUCCESS:
        print("HTTP Request failed with result code: ", result)
        return
    
    print("HTTP Request successful!")
    print("Response code: ", response_code)
    print("Headers: ", headers)
    print("Body: ", body.get_string_from_utf8())
```

### POST Request with JSON Data

```gdscript
func make_post_request():
    var http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.request_completed.connect(_on_post_completed)
    
    # Prepare headers and body
    var headers = ["Content-Type: application/json"]
    var body = JSON.stringify({"name": "John", "age": 30})
    
    # Make POST request
    var error = http_request.request("https://httpbin.org/post", headers, HTTPClient.METHOD_POST, body)
    if error != OK:
        print("Failed to make POST request")

func _on_post_completed(result, response_code, headers, body):
    # Handle response
    if result == HTTPRequest.RESULT_SUCCESS:
        var json = JSON.parse_string(body.get_string_from_utf8())
        print("POST response: ", json)
```

### Downloading Files

```gdscript
func download_file():
    var http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.request_completed.connect(_on_download_completed)
    
    # Set the download file destination
    http_request.download_file = "res://downloaded_image.png"
    
    # Start the download
    var error = http_request.request("https://httpbin.org/image/png")
    if error != OK:
        print("Failed to start download")

func _on_download_completed(result, response_code, headers, body):
    if result == HTTPRequest.RESULT_SUCCESS:
        print("File downloaded successfully!")
    else:
        print("Download failed with code: ", result)
```

### Making Requests with Custom Headers

```gdscript
func request_with_headers():
    var http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.request_completed.connect(_on_request_completed)
    
    # Define custom headers
    var headers = [
        "Authorization: Bearer your_token_here",
        "X-Custom-Header: Custom Value"
    ]
    
    # Make request with custom headers
    var error = http_request.request("https://httpbin.org/headers", headers)
    if error != OK:
        print("Failed to make request with custom headers")
```

### Handling Timeouts

To handle request timeouts, you can use a Timer node:

```gdscript
func make_request_with_timeout():
    var http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.request_completed.connect(_on_request_completed)
    
    # Create a timeout timer
    var timer = Timer.new()
    timer.one_shot = true
    timer.wait_time = 10.0
    timer.timeout.connect(func(): print("Request timed out"))
    add_child(timer)
    timer.start()
    
    # Make the request
    var error = http_request.request("https://httpbin.org/delay/5")
    if error != OK:
        print("Failed to make request")
        timer.stop()
```

### Running HTTP Requests in Headless Mode

To run HTTP requests in headless mode (for server-side or CI/CD operations), use:

```bash
./run_godot_headless.sh --path your-project --script http_script.gd
```

Make sure your script properly handles completion and exits the application when done:

```gdscript
extends SceneTree

func _init():
    # Make HTTP request
    var http_request = HTTPRequest.new()
    root.add_child(http_request)
    http_request.request_completed.connect(_on_request_completed)
    http_request.request("https://httpbin.org/get")

func _on_request_completed(result, response_code, headers, body):
    print("Request completed")
    # Process the response
    print(body.get_string_from_utf8())
    # Exit the application
    quit()
```

## VS Code Extensions

The following VS Code extensions are pre-installed:

- Godot Tools
- C/C++ Tools
- Godot C# Tools

## Customization

You can customize the container by modifying:

- `.devcontainer/devcontainer.json` - Container settings and extensions
- `.devcontainer/Dockerfile` - Container build instructions
- `.vscode/settings.json` - VS Code and Godot settings

## Troubleshooting

- If the SSH service isn't running, you can start it with:
  ```bash
  sudo service ssh start
  ```

- If you encounter permission issues, the `vscode` user has sudo access without password.

## License

This project is open source and available under the MIT License.
