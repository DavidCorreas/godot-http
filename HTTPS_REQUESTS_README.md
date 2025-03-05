# Godot HTTPS Requests Guide

This guide provides instructions for making HTTPS requests to servers with self-signed certificates in different versions of Godot, focusing on how to disable SSL verification.

## Table of Contents

1. [Installing Godot 4.4](#installing-godot-44)
2. [Making HTTPS Requests in Godot 4.4](#making-https-requests-in-godot-44)
3. [Issues with Godot 4.3](#issues-with-godot-43)
4. [Workaround with cURL in Godot](#workaround-with-curl-in-godot)

## Installing Godot 4.4

Follow these steps to install Godot 4.4 on a Linux system:

1. **Create a directory for Godot 4.4:**
   ```bash
   mkdir -p ~/godot4.4
   ```

2. **Download Godot 4.4:**
   ```bash
   wget https://github.com/godotengine/godot-builds/releases/download/4.4-stable/Godot_v4.4-stable_linux.x86_64.zip -P ~/godot4.4
   ```

3. **Extract the Godot executable:**
   ```bash
   unzip ~/godot4.4/Godot_v4.4-stable_linux.x86_64.zip -d ~/godot4.4
   ```

4. **Make the Godot executable file executable:**
   ```bash
   chmod +x ~/godot4.4/Godot_v4.4-stable_linux.x86_64
   ```

5. **Download export templates (optional):**
   ```bash
   wget https://github.com/godotengine/godot-builds/releases/download/4.4-stable/Godot_v4.4-stable_export_templates.tpz -P ~/godot4.4
   ```

6. **Extract export templates (optional):**
   ```bash
   mkdir -p ~/.local/share/godot/export_templates/4.4.stable
   mkdir -p ~/godot4.4/templates
   unzip ~/godot4.4/Godot_v4.4-stable_export_templates.tpz -d ~/godot4.4/templates
   cp -r ~/godot4.4/templates/templates/* ~/.local/share/godot/export_templates/4.4.stable/
   ```

7. **Run Godot 4.4:**
   ```bash
   ~/godot4.4/Godot_v4.4-stable_linux.x86_64
   ```

## Making HTTPS Requests in Godot 4.4

Godot 4.4 properly supports disabling SSL verification for HTTPS requests, which is useful when connecting to servers with self-signed certificates.

### Basic HTTPS Request with SSL Verification Disabled

```gdscript
extends Node

func _ready():
    print("Starting HTTPS Request...")
    
    # Create an HTTP request node
    var http_request = HTTPRequest.new()
    add_child(http_request)
    
    # Connect to the request completed signal
    http_request.request_completed.connect(_on_request_completed)
    
    # Disable SSL verification using TLSOptions
    var opts = TLSOptions.client_unsafe()
    print("TLSOptions is_unsafe_client(): ", opts.is_unsafe_client())
    http_request.set_tls_options(opts)
    
    # Make a request to the specified endpoint
    var url = "https://your-server:port/endpoint"
    print("Making request to: " + url)
    
    var error = http_request.request(url)
    if error != OK:
        print("An error occurred while making the HTTPS request: ", error)

func _on_request_completed(result, response_code, headers, body):
    print("HTTPS Request completed with result code: ", result)
    print("Response code: ", response_code)
    print("Headers: ", headers)
    
    if body.size() > 0:
        print("Body: ", body.get_string_from_utf8())
    else:
        print("No response body received")
```

### Project Settings

You can also disable SSL verification globally in your project settings:

1. Open your project.godot file or use the Project Settings in the editor
2. Add the following setting:
   ```
   [ssl]
   certificates_enabled=false
   ```

### Making POST Requests

For POST requests with JSON data:

```gdscript
func make_post_request():
    var http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.request_completed.connect(_on_post_completed)
    
    # Disable SSL verification
    var opts = TLSOptions.client_unsafe()
    http_request.set_tls_options(opts)
    
    # Prepare headers and body
    var headers = ["Content-Type: application/json"]
    var body = JSON.stringify({"key": "value", "another_key": 123})
    
    # Make the POST request
    var url = "https://your-server:port/endpoint"
    var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
    if error != OK:
        print("An error occurred while making the POST request: ", error)

func _on_post_completed(result, response_code, headers, body):
    print("POST request completed with result code: ", result)
    print("Response code: ", response_code)
    
    if body.size() > 0:
        var json = JSON.parse_string(body.get_string_from_utf8())
        print("Response body: ", json)
```

## Issues with Godot 4.3

Godot 4.3 has a known regression bug where `TLSOptions.client_unsafe()` doesn't properly disable SSL verification. This was a regression from Godot 4.2.2 where it did work correctly.

When attempting to make HTTPS requests to servers with self-signed certificates in Godot 4.3, you'll typically encounter errors like:

```
TLS handshake error: -9984
mbedtls error: returned -0x2700
```

This is due to the SSL verification failing, and despite using `TLSOptions.client_unsafe()`, the verification is still being performed.

Attempts to work around this issue by setting `ssl/certificates_enabled=false` in project settings also don't work in Godot 4.3.

The issue has been fixed in Godot 4.4, so upgrading is the best solution.

## Workaround with cURL in Godot

If you need to make HTTPS requests to servers with self-signed certificates in Godot 4.3 or earlier versions, you can use the `OS.execute()` function to run cURL commands with the `-k` flag (which disables SSL verification).

### Basic cURL Wrapper

```gdscript
extends Node

func _ready():
    print("Starting cURL Wrapper...")
    make_curl_request("https://your-server:port/endpoint")

func make_curl_request(url):
    print("Making cURL request to: " + url)
    
    # Execute curl with -k flag to disable SSL verification
    var output = []
    var exit_code = OS.execute("curl", ["-k", "-s", url], output)
    
    print("cURL exit code: ", exit_code)
    if output.size() > 0:
        print("Response: ", output[0])
        
        # Parse JSON response if applicable
        if output[0].begins_with("{") or output[0].begins_with("["):
            var json = JSON.parse_string(output[0])
            if json:
                print("Parsed JSON: ", json)
    else:
        print("No response received")
```

### POST Request with cURL

```gdscript
func make_curl_post_request(url, data_dict):
    print("Making cURL POST request to: " + url)
    
    # Convert dictionary to JSON string
    var json_data = JSON.stringify(data_dict)
    
    # Execute curl with -k flag and POST data
    var output = []
    var exit_code = OS.execute("curl", [
        "-k",                     # Disable SSL verification
        "-s",                     # Silent mode
        "-X", "POST",             # HTTP method
        "-H", "Content-Type: application/json",  # Header
        "-d", json_data,          # POST data
        url                       # URL
    ], output)
    
    print("cURL POST exit code: ", exit_code)
    if output.size() > 0:
        print("Response: ", output[0])
        
        # Parse JSON response
        var json = JSON.parse_string(output[0])
        if json:
            print("Parsed JSON: ", json)
    else:
        print("No response received")
```

### Complete cURL Wrapper Class

Here's a more complete cURL wrapper class that you can use in your Godot projects:

```gdscript
extends Node
class_name CurlWrapper

signal request_completed(result, response_code, headers, body)

func get(url, headers=null):
    return _make_request(url, "GET", headers)

func post(url, data, headers=null):
    return _make_request(url, "POST", headers, data)

func put(url, data, headers=null):
    return _make_request(url, "PUT", headers, data)

func delete(url, headers=null):
    return _make_request(url, "DELETE", headers)

func _make_request(url, method, headers=null, data=null):
    var args = ["-k", "-s", "-X", method]
    
    # Add headers
    if headers:
        for header in headers:
            args.append("-H")
            args.append(header)
    
    # Add data for POST/PUT
    if data and (method == "POST" or method == "PUT"):
        var json_data
        if typeof(data) == TYPE_STRING:
            json_data = data
        else:
            json_data = JSON.stringify(data)
        
        args.append("-d")
        args.append(json_data)
    
    # Add URL
    args.append(url)
    
    # Execute curl command
    var output = []
    var exit_code = OS.execute("curl", args, output)
    
    # Process response
    var response_body = ""
    var response_code = 0
    var result = 0
    var response_headers = []
    
    if exit_code == 0 and output.size() > 0:
        response_body = output[0]
        # Attempt to extract response code
        var code_output = []
        OS.execute("curl", ["-k", "-s", "-o", "/dev/null", "-w", "%{http_code}", url], code_output)
        if code_output.size() > 0:
            response_code = code_output[0].to_int()
    else:
        result = 1  # Error
    
    # Emit signal with response
    emit_signal("request_completed", result, response_code, response_headers, response_body.to_utf8_buffer())
    
    return {
        "result": result,
        "response_code": response_code,
        "headers": response_headers,
        "body": response_body
    }
```

### Usage of the cURL Wrapper Class

```gdscript
extends Node

func _ready():
    var curl = CurlWrapper.new()
    add_child(curl)
    curl.request_completed.connect(_on_request_completed)
    
    # Make a GET request
    curl.get("https://your-server:port/endpoint")
    
    # Make a POST request
    curl.post("https://your-server:port/endpoint", {"key": "value"})

func _on_request_completed(result, response_code, headers, body):
    print("Request completed with result: ", result)
    print("Response code: ", response_code)
    
    if body.size() > 0:
        var response_text = body.get_string_from_utf8()
        print("Response body: ", response_text)
        
        # Parse JSON if applicable
        if response_text.begins_with("{") or response_text.begins_with("["):
            var json = JSON.parse_string(response_text)
            if json:
                print("Parsed JSON: ", json)
```

## Conclusion

- **Godot 4.4+**: Use `TLSOptions.client_unsafe()` to disable SSL verification
- **Godot 4.3**: Use the cURL wrapper as a workaround
- **Godot 4.2.2**: Use `TLSOptions.client_unsafe()` (it works in this version)
- **Older versions**: Use the cURL wrapper

Remember that disabling SSL verification should only be done in development environments or when connecting to trusted servers with self-signed certificates. In production environments, it's recommended to use proper SSL certificates.
