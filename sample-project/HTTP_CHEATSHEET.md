# Godot HTTP Request Cheat Sheet

## Quick Reference

### Basic GET Request

```gdscript
var http_request = HTTPRequest.new()
add_child(http_request)
http_request.request_completed.connect(_on_request_completed)
http_request.request("https://example.com/api")

func _on_request_completed(result, response_code, headers, body):
    if result == HTTPRequest.RESULT_SUCCESS and response_code == 200:
        var json = JSON.parse_string(body.get_string_from_utf8())
        print(json)
```

### POST with JSON

```gdscript
var http_request = HTTPRequest.new()
add_child(http_request)
http_request.request_completed.connect(_on_request_completed)

var headers = ["Content-Type: application/json"]
var data = {"name": "John", "age": 30}
var json_string = JSON.stringify(data)

http_request.request("https://example.com/api", headers, HTTPClient.METHOD_POST, json_string)
```

### Download a File

```gdscript
var http_request = HTTPRequest.new()
add_child(http_request)
http_request.request_completed.connect(_on_download_completed)
http_request.download_file = "res://downloaded_file.png"
http_request.request("https://example.com/image.png")

func _on_download_completed(result, response_code, headers, body):
    if result == HTTPRequest.RESULT_SUCCESS:
        print("File downloaded successfully")
```

### Request with Authentication

```gdscript
var http_request = HTTPRequest.new()
add_child(http_request)
http_request.request_completed.connect(_on_request_completed)

var headers = ["Authorization: Bearer YOUR_TOKEN_HERE"]
http_request.request("https://example.com/api/protected", headers)
```

### Setting Timeout

```gdscript
var http_request = HTTPRequest.new()
add_child(http_request)
http_request.timeout = 10  # 10 seconds timeout
http_request.request_completed.connect(_on_request_completed)
http_request.request("https://example.com/api/slow")
```

### Form Data (multipart/form-data)

```gdscript
var http_request = HTTPRequest.new()
add_child(http_request)
http_request.request_completed.connect(_on_request_completed)

var headers = ["Content-Type: multipart/form-data; boundary=GodotFormBoundary"]
var body = "--GodotFormBoundary\r\n"
body += "Content-Disposition: form-data; name=\"field1\"\r\n\r\n"
body += "value1\r\n"
body += "--GodotFormBoundary\r\n"
body += "Content-Disposition: form-data; name=\"field2\"\r\n\r\n"
body += "value2\r\n"
body += "--GodotFormBoundary--\r\n"

http_request.request("https://example.com/api/form", headers, HTTPClient.METHOD_POST, body)
```

### URL-encoded Form Data

```gdscript
var http_request = HTTPRequest.new()
add_child(http_request)
http_request.request_completed.connect(_on_request_completed)

var headers = ["Content-Type: application/x-www-form-urlencoded"]
var form_data = "username=johndoe&password=secret"

http_request.request("https://example.com/api/login", headers, HTTPClient.METHOD_POST, form_data)
```

### HTTP Status Code Constants

```gdscript
# Common HTTP status codes
const HTTP_OK = 200
const HTTP_CREATED = 201
const HTTP_NO_CONTENT = 204
const HTTP_BAD_REQUEST = 400
const HTTP_UNAUTHORIZED = 401
const HTTP_FORBIDDEN = 403
const HTTP_NOT_FOUND = 404
const HTTP_SERVER_ERROR = 500

func _on_request_completed(result, response_code, headers, body):
    match response_code:
        HTTP_OK:
            print("Request successful")
        HTTP_UNAUTHORIZED:
            print("Authentication required")
        HTTP_NOT_FOUND:
            print("Resource not found")
        _:
            print("Unexpected status code: ", response_code)
```

### Error Handling

```gdscript
func make_request():
    var http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.request_completed.connect(_on_request_completed)
    
    var error = http_request.request("https://example.com/api")
    match error:
        OK:
            print("Request sent successfully")
        ERR_CANT_CONNECT:
            print("Cannot connect to host")
        ERR_INVALID_PARAMETER:
            print("Invalid parameter for request")
        _:
            print("Error occurred: ", error)

func _on_request_completed(result, response_code, headers, body):
    match result:
        HTTPRequest.RESULT_SUCCESS:
            print("Request completed successfully")
        HTTPRequest.RESULT_CHUNKED_BODY_SIZE_MISMATCH:
            print("Chunked body size mismatch")
        HTTPRequest.RESULT_CANT_CONNECT:
            print("Can't connect to host")
        HTTPRequest.RESULT_CANT_RESOLVE:
            print("Can't resolve hostname")
        HTTPRequest.RESULT_CONNECTION_ERROR:
            print("Connection error")
        HTTPRequest.RESULT_TLS_HANDSHAKE_ERROR:
            print("TLS handshake error")
        HTTPRequest.RESULT_NO_RESPONSE:
            print("No response")
        HTTPRequest.RESULT_BODY_SIZE_LIMIT_EXCEEDED:
            print("Body size limit exceeded")
        HTTPRequest.RESULT_REQUEST_FAILED:
            print("Request failed")
        HTTPRequest.RESULT_DOWNLOAD_FILE_CANT_OPEN:
            print("Can't open download file")
        HTTPRequest.RESULT_DOWNLOAD_FILE_WRITE_ERROR:
            print("Error writing to download file")
        HTTPRequest.RESULT_REDIRECT_LIMIT_REACHED:
            print("Redirect limit reached")
        _:
            print("Unknown result code: ", result)
```

### Canceling a Request

```gdscript
var http_request = HTTPRequest.new()
add_child(http_request)
http_request.request_completed.connect(_on_request_completed)
http_request.request("https://example.com/api")

# Later, to cancel the request
func _cancel_request():
    if http_request and is_instance_valid(http_request):
        http_request.cancel_request()
        print("Request canceled")
```

### Headless Mode Script

```gdscript
extends SceneTree

func _init():
    var http_request = HTTPRequest.new()
    root.add_child(http_request)
    http_request.request_completed.connect(_on_request_completed)
    http_request.request("https://example.com/api")

func _on_request_completed(result, response_code, headers, body):
    if result == HTTPRequest.RESULT_SUCCESS:
        print("Request successful")
        print(body.get_string_from_utf8())
    else:
        print("Request failed")
    
    # Always quit when done in headless mode
    quit()
```
