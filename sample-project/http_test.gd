extends Node

# This script makes an HTTP request to a public API and prints the response
var http_request
var timer

func _ready():
    print("Starting HTTP request test...")
    
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
    
    # Make a request to a public API
    var error = http_request.request("https://httpbin.org/get")
    if error != OK:
        print("An error occurred while making the HTTP request: ", error)
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
        print("HTTP Request failed with result code: ", result)
        get_tree().quit(1)
    
    print("HTTP Request successful!")
    print("Response code: ", response_code)
    print("Headers: ", headers)
    print("Body: ", body.get_string_from_utf8())
    
    # Exit the application
    get_tree().quit(0)
