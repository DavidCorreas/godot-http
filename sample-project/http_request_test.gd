extends SceneTree

# This script makes an HTTP request to a public API and prints the response

func _init():
    print("Starting HTTP request test...")
    
    # Create an HTTP request node
    var http_request = HTTPRequest.new()
    self.root.add_child(http_request)
    
    # Connect to the request completed signal
    http_request.request_completed.connect(_on_request_completed)
    
    # Make a request to a public API
    var error = http_request.request("https://httpbin.org/get")
    if error != OK:
        print("An error occurred while making the HTTP request: ", error)
        quit(1)
    
    # We'll use a timer for timeout
    var timer = Timer.new()
    timer.one_shot = true
    timer.wait_time = 5.0
    timer.timeout.connect(func():
        print("Request timed out or didn't complete properly")
        quit(1)
    )
    self.root.add_child(timer)
    timer.start()

# Called when the HTTP request is completed
func _on_request_completed(result, response_code, headers, body):
    if result != HTTPRequest.RESULT_SUCCESS:
        print("HTTP Request failed with result code: ", result)
        quit(1)
    
    print("HTTP Request successful!")
    print("Response code: ", response_code)
    print("Headers: ", headers)
    print("Body: ", body.get_string_from_utf8())
    
    # Exit the application
    quit(0)
