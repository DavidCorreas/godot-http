extends Node

func _ready():
    print("Starting Minimal HTTPS Request...")
    
    # Create an HTTP request node
    var http_request = HTTPRequest.new()
    add_child(http_request)
    
    # Connect to the request completed signal
    http_request.request_completed.connect(_on_request_completed)
    
    # Try to disable SSL verification using TLSOptions
    # Note: This is known to be broken in Godot 4.3
    var opts = TLSOptions.client_unsafe()
    print("TLSOptions is_unsafe_client(): ", opts.is_unsafe_client())
    http_request.set_tls_options(opts)
    
    # Make a request to the specified endpoint
    var url = "https://192.168.1.70:8443/health"
    print("Making request to: " + url)
    
    var error = http_request.request(url)
    if error != OK:
        print("An error occurred while making the HTTPS request: ", error)
        get_tree().quit(1)

func _on_request_completed(result, response_code, headers, body):
    print("HTTPS Request completed with result code: ", result)
    
    # Check for TLS handshake error
    if result == HTTPRequest.RESULT_TLS_HANDSHAKE_ERROR:
        print("TLS handshake error occurred. This is a known issue in Godot 4.3.")
        print("The fix will be available in Godot 4.4.")
    
    print("Response code: ", response_code)
    print("Headers: ", headers)
    
    if body.size() > 0:
        print("Body: ", body.get_string_from_utf8())
    else:
        print("No response body received")
    
    # Exit the application
    get_tree().quit(0)
