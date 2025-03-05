extends SceneTree

func _init():
    print("Starting Simple Curl Request...")
    
    # Run curl with -k flag to disable SSL verification
    var url = "https://192.168.1.70:8443/health"
    print("Making request to: " + url)
    
    var output = []
    var exit_code = OS.execute("curl", ["-k", url], output, true)
    
    print("Curl exit code: " + str(exit_code))
    if output.size() > 0:
        print("Response: " + output[0])
    else:
        print("No response received")
    
    # Exit the application
    quit(0)
