extends SceneTree

# This script uses OS.execute to run curl directly
# It is designed to run in headless mode

func _init():
    print("Starting Curl Wrapper...")
    
    # Run curl with -k flag to disable SSL verification
    var url = "https://192.168.1.70:8443/health"
    print("Making request to: " + url)
    
    var output = []
    var exit_code = OS.execute("curl", ["-k", "-v", url], output)
    
    print("Curl exit code: " + str(exit_code))
    print("Curl output: " + "\n".join(output))
    
    # Exit the application
    quit(exit_code)
