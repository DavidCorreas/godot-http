extends Node

# This script demonstrates downloading a file using HTTP request in Godot
var http_request
var timer
var download_path = "res://downloaded_image.png"

func _ready():
    print("Starting File Download Test...")
    
    # Create an HTTP request node
    http_request = HTTPRequest.new()
    add_child(http_request)
    
    # Set download file option
    http_request.download_file = download_path
    
    # Connect to the request completed signal
    http_request.request_completed.connect(_on_request_completed)
    
    # Create a timeout timer
    timer = Timer.new()
    timer.one_shot = true
    timer.wait_time = 15.0  # Longer timeout for download
    timer.timeout.connect(_on_timeout)
    add_child(timer)
    timer.start()
    
    # Make a request to download a small image file
    print("Downloading image from httpbin.org/image/png...")
    var error = http_request.request("https://httpbin.org/image/png")
    if error != OK:
        print_error("Failed to start download", error)

func print_error(message, error_code):
    print("ERROR: " + message + " (Code: " + str(error_code) + ")")
    get_tree().quit(1)

func _on_timeout():
    print("Download timed out")
    get_tree().quit(1)

func _on_request_completed(result, response_code, headers, body):
    # Stop the timer
    timer.stop()
    
    if result != HTTPRequest.RESULT_SUCCESS:
        print("HTTP Request failed with result code: ", result)
        get_tree().quit(1)
    
    print("Download completed successfully!")
    print("Response code: ", response_code)
    
    # Get file information
    var file = FileAccess.open(download_path, FileAccess.READ)
    if file:
        var file_size = file.get_length()
        print("Downloaded file size: " + str(file_size) + " bytes")
        file = null  # Close the file
    else:
        print("Could not open downloaded file")
    
    # Exit the application
    get_tree().quit(0)
