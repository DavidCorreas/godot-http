extends SceneTree

# This script makes an HTTP request to a health check endpoint using HTTPClient directly
# It is designed to run in headless mode

func _init():
    print("Starting Direct HTTP Client Health Check...")
    
    # Create an HTTP client
    var client = HTTPClient.new()
    
    # Parse the URL
    var host = "192.168.1.70"
    var port = 8443
    var use_ssl = false  # We'll use HTTP to avoid SSL verification issues
    var path = "/health"
    
    print("Connecting to: " + host + ":" + str(port) + path)
    
    # Connect to host
    var err = client.connect_to_host(host, port)
    if err != OK:
        print("Failed to connect to host: ", err)
        quit(1)
    
    # Wait for connection to complete
    while client.get_status() == HTTPClient.STATUS_CONNECTING or client.get_status() == HTTPClient.STATUS_RESOLVING:
        client.poll()
        print("Connecting...")
        OS.delay_msec(500)
    
    if client.get_status() != HTTPClient.STATUS_CONNECTED:
        print("Failed to connect to host. Status: ", client.get_status())
        quit(1)
    
    print("Connected to host. Status: ", client.get_status())
    
    # Make a GET request
    var headers = ["User-Agent: Godot", "Accept: */*"]
    err = client.request(HTTPClient.METHOD_GET, path, headers)
    if err != OK:
        print("Failed to make request: ", err)
        quit(1)
    
    print("Request sent. Waiting for response...")
    
    # Wait for response
    while client.get_status() == HTTPClient.STATUS_REQUESTING:
        client.poll()
        print("Waiting for response...")
        OS.delay_msec(500)
    
    if client.get_status() != HTTPClient.STATUS_BODY and client.get_status() != HTTPClient.STATUS_CONNECTED:
        print("Request failed. Status: ", client.get_status())
        quit(1)
    
    print("Got response! Status: ", client.get_status())
    print("Response code: ", client.get_response_code())
    print("Headers: ", client.get_response_headers_as_dictionary())
    
    # Read the response body
    var response_body = ""
    if client.get_status() == HTTPClient.STATUS_BODY:
        while client.get_status() == HTTPClient.STATUS_BODY:
            client.poll()
            var chunk = client.read_response_body_chunk()
            if chunk.size() == 0:
                OS.delay_msec(100)
            else:
                response_body += chunk.get_string_from_utf8()
    
    print("Response body: ", response_body)
    
    # Close the connection
    client.close()
    print("Connection closed.")
    
    # Exit the application
    quit(0)
