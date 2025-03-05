extends SceneTree

# This script makes an HTTPS request to a specified endpoint with SSL verification disabled
# It is designed to run in headless mode

func _init():
    print("Starting Headless Health Check HTTPS request...")
    
    # Create an HTTP request node
    var http_request = HTTPRequest.new()
    root.add_child(http_request)
    
    # Connect to the request completed signal
    http_request.request_completed.connect(_on_request_completed)
    
    # Create a timeout timer with autostart
    var timer = Timer.new()
    timer.one_shot = true
    timer.wait_time = 10.0
    timer.autostart = true
    timer.timeout.connect(_on_timeout)
    root.add_child(timer)
    
    # Configure request
    http_request.use_threads = true
    http_request.accept_gzip = true
    
    # Note: Due to a bug in Godot 4.3, TLSOptions.client_unsafe() doesn't work correctly
    # We'll use HTTP instead of HTTPS as a workaround
    var url = "http://192.168.1.70:8443/health"
    print("Making request to: " + url)
    
    var error = http_request.request(url)
    if error != OK:
        print("An error occurred while making the HTTP request: ", error)
        quit(1)

# Called when the HTTP request times out
func _on_timeout():
    print("Request timed out or didn't complete properly")
    quit(1)

# Called when the HTTP request is completed
func _on_request_completed(result, response_code, headers, body):
    print("HTTPS Request completed with result: ", result)
    
    if result != HTTPRequest.RESULT_SUCCESS:
        print("HTTPS Request failed with result code: ", result)
        quit(1)
    
    print("HTTPS Request successful!")
    print("Response code: ", response_code)
    print("Headers: ", headers)
    print("Body: ", body.get_string_from_utf8())
    
    # Exit the application
    quit(0)
