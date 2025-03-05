extends Node

# This script demonstrates various HTTP request capabilities in Godot
var current_test = 0
var tests = [
    {"name": "GET Request", "method": "get"},
    {"name": "POST Request", "method": "post"},
    {"name": "PUT Request", "method": "put"},
    {"name": "DELETE Request", "method": "delete"},
    {"name": "Headers Test", "method": "headers"},
    {"name": "JSON Test", "method": "json"}
]

var http_request
var timer

func _ready():
    print("Starting Advanced HTTP Request Tests...")
    
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
    
    # Start the first test
    run_next_test()

func run_next_test():
    if current_test >= tests.size():
        print("\nAll HTTP tests completed successfully!")
        get_tree().quit(0)
        return
    
    var test = tests[current_test]
    print("\n--- Running Test: " + test.name + " ---")
    
    # Reset and start the timer
    timer.stop()
    timer.start()
    
    # Run the appropriate test
    match test.method:
        "get":
            var error = http_request.request("https://httpbin.org/get")
            if error != OK:
                print_error("Failed to make GET request", error)
        
        "post":
            var headers = ["Content-Type: application/json"]
            var body = JSON.stringify({"test": "value", "number": 42})
            var error = http_request.request("https://httpbin.org/post", headers, HTTPClient.METHOD_POST, body)
            if error != OK:
                print_error("Failed to make POST request", error)
        
        "put":
            var headers = ["Content-Type: application/json"]
            var body = JSON.stringify({"updated": true})
            var error = http_request.request("https://httpbin.org/put", headers, HTTPClient.METHOD_PUT, body)
            if error != OK:
                print_error("Failed to make PUT request", error)
        
        "delete":
            var error = http_request.request("https://httpbin.org/delete", [], HTTPClient.METHOD_DELETE)
            if error != OK:
                print_error("Failed to make DELETE request", error)
        
        "headers":
            var custom_headers = [
                "X-Custom-Header: Test Value",
                "Authorization: Bearer test_token"
            ]
            var error = http_request.request("https://httpbin.org/headers", custom_headers)
            if error != OK:
                print_error("Failed to make headers test request", error)
        
        "json":
            var error = http_request.request("https://httpbin.org/json")
            if error != OK:
                print_error("Failed to make JSON test request", error)

func print_error(message, error_code):
    print("ERROR: " + message + " (Code: " + str(error_code) + ")")
    get_tree().quit(1)

func _on_timeout():
    print("Request timed out for test: " + tests[current_test].name)
    get_tree().quit(1)

func _on_request_completed(result, response_code, headers, body):
    # Stop the timer
    timer.stop()
    
    if result != HTTPRequest.RESULT_SUCCESS:
        print("HTTP Request failed with result code: ", result)
        get_tree().quit(1)
    
    print("Response code: ", response_code)
    print("Headers: ", headers)
    
    # Parse and print the body
    var json_string = body.get_string_from_utf8()
    var preview_length = min(200, json_string.length())
    var ellipsis = "..." if json_string.length() > 200 else ""
    print("Body preview: " + json_string.substr(0, preview_length) + ellipsis)
    
    # Move to the next test
    current_test += 1
    run_next_test()
