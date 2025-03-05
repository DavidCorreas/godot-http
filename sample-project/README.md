# Godot HTTP Request Examples

This sample project demonstrates how to make HTTP requests in Godot 4.3, including examples for different request types and scenarios.

## Examples Included

### 1. Basic HTTP Request (`http_test.gd`)

A simple example showing how to make a GET request and process the response.

### 2. Advanced HTTP Requests (`advanced_http_test.gd`)

Demonstrates multiple HTTP request types:
- GET requests
- POST requests with JSON data
- PUT requests
- DELETE requests
- Custom headers
- JSON handling

### 3. File Download (`download_test.gd`)

Shows how to download files using HTTP requests and save them to the filesystem.

### 4. Headless Mode Script (`test_script.gd`)

A minimal example for running HTTP requests in headless mode, suitable for server-side operations or CI/CD pipelines.

## Running the Examples

### In the Godot Editor

1. Open the project in Godot
2. Select the scene you want to run (e.g., `http_test.tscn`, `advanced_http_test.tscn`, or `download_test.tscn`)
3. Press F5 or click the "Play" button

### In Headless Mode

To run the examples in headless mode (without a GUI):

```bash
# From the project root directory
./run_godot_headless.sh --path sample-project

# Or to run a specific script
./run_godot_headless.sh --path sample-project --script test_script.gd
```

## Key Concepts

### HTTP Request Node

The `HTTPRequest` node is the core component for making network requests in Godot. Key properties and methods:

- `request()`: Initiates an HTTP request
- `request_completed` signal: Emitted when a request is completed
- `download_file`: Path where to download a file (optional)
- `timeout`: Maximum time in seconds to wait for the request to complete

### Request Methods

Godot supports all standard HTTP methods:

- `HTTPClient.METHOD_GET` (default)
- `HTTPClient.METHOD_POST`
- `HTTPClient.METHOD_PUT`
- `HTTPClient.METHOD_DELETE`
- And others (HEAD, OPTIONS, etc.)

### Working with JSON

For JSON data:

1. Sending JSON: Use `JSON.stringify()` to convert a dictionary to a JSON string
2. Receiving JSON: Use `JSON.parse_string()` to parse a JSON string into a dictionary

### Error Handling

Always check the return value of `request()` and the `result` parameter in the `request_completed` signal to handle errors properly.

## Environment Setup

This project is configured to work in both regular and headless modes. For headless mode, the following environment variables are set:

- `DISPLAY=:99`
- `XDG_RUNTIME_DIR=/tmp/runtime-dir`

These settings allow HTTP requests to work properly in a headless environment.

## Further Resources

- [Godot HTTP Request Documentation](https://docs.godotengine.org/en/stable/classes/class_httprequest.html)
- [Godot HTTPClient Documentation](https://docs.godotengine.org/en/stable/classes/class_httpclient.html)
- [JSON in Godot Documentation](https://docs.godotengine.org/en/stable/classes/class_json.html)
