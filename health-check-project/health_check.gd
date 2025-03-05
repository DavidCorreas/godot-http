extends Node

# This script makes an HTTPS request to a specified endpoint with SSL verification disabled
var http_request
var timer

func _ready():
    print("Starting Health Check HTTPS request...")
    
    # Create an HTTP request node
    http_request = HTTPRequest.new()
    add_child(http_request)
    
    # Connect to the request completed signal
    http_request.request_completed.connect(_on_request_completed)
    
    # Create a timeout timer
    timer = Timer.new()
    timer.one_shot = true
    timer.wait_time = 10.0
    timer.timeout.connect(_on_timeout)
    add_child(timer)
    timer.start()
    
    # Configure SSL verification (disable it to mimic curl -k)
    http_request.use_threads = true
    http_request.accept_gzip = true
    
    # Important: Disable SSL verification to mimic curl -k
    # In Godot 4.3, we need to use the ssl_verify_host property
    http_request.ssl_verify_host = false
    
    # Make a request to the specified endpoint
    var url = "https://192.168.1.70:8443/health"
    print("Making request to: " + url)
    
    var error = http_request.request(url)
    if error != OK:
        print("An error occurred while making the HTTPS request: ", error)
        get_tree().quit(1)

# Called when the HTTP request times out
func _on_timeout():
    print("Request timed out or didn't complete properly")
    get_tree().quit(1)

# Called when the HTTP request is completed
func _on_request_completed(result, response_code, headers, body):
    # Stop the timer
    timer.stop()
    
    if result != HTTPRequest.RESULT_SUCCESS:
        print("HTTPS Request failed with result code: ", result)
        get_tree().quit(1)
    
    print("HTTPS Request successful!")
    print("Response code: ", response_code)
    print("Headers: ", headers)
    print("Body: ", body.get_string_from_utf8())
    
    # Exit the application
    get_tree().quit(0)
