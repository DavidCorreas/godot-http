extends Node

func _ready():
    print("Starting Simple HTTPS Request...")
    
    # Create an HTTP request node
    var http_request = HTTPRequest.new()
    add_child(http_request)
    
    # Connect to the request completed signal
    http_request.request_completed.connect(_on_request_completed)
    
    # Make a request to the specified endpoint
    var url = "https://192.168.1.70:8443/health"
    print("Making request to: " + url)
    
    var error = http_request.request(url)
    if error != OK:
        print("An error occurred while making the HTTPS request: ", error)
        get_tree().quit(1)

func _on_request_completed(result, response_code, headers, body):
    print("HTTPS Request completed with result: ", result)
    print("Response code: ", response_code)
    print("Headers: ", headers)
    print("Body: ", body.get_string_from_utf8())
    
    # Exit the application
    get_tree().quit(0)
