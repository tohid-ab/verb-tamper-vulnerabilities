#!/bin/bash

# Tohid AB
# HTTP Verb Tampering Testing Script
# Tests common HTTP methods against a target URL

# Check if URL parameter is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <target_url>"
    echo "Example: $0 http://example.com/api/resource"
    exit 1
fi

# Target URL from command line argument
TARGET_URL="$1"

# Array of HTTP methods to test
HTTP_METHODS=("GET" "POST" "PUT" "DELETE" "PATCH" "HEAD" "OPTIONS" "TRACE" "CONNECT")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Starting HTTP Verb Tampering Test on: $TARGET_URL"
echo "----------------------------------------"

# Function to test HTTP method
test_method() {
    local method=$1
    echo -e "\nTesting ${YELLOW}$method${NC} request..."
    
    # Use curl to test the method
    response=$(curl -s -o /dev/null -w "%{http_code}" -X "$method" "$TARGET_URL" --max-time 5)
    
    case $response in
        "200")
            echo -e "${GREEN}SUCCESS${NC}: $method request returned 200 OK"
            ;;
        "201")
            echo -e "${GREEN}SUCCESS${NC}: $method request returned 201 Created"
            ;;
        "204")
            echo -e "${GREEN}SUCCESS${NC}: $method request returned 204 No Content"
            ;;
        "403")
            echo -e "Blocked: $method request returned 403 Forbidden"
            ;;
        "405")
            echo -e "Blocked: $method request returned 405 Method Not Allowed"
            ;;
        "000")
            echo -e "${RED}ERROR${NC}: No response or connection timeout"
            ;;
        *)
            echo -e "${YELLOW}UNEXPECTED${NC}: $method request returned $response"
            ;;
    esac
    
    # If OPTIONS or TRACE, show additional info
    if [ "$method" = "OPTIONS" ]; then
        allowed=$(curl -s -X OPTIONS "$TARGET_URL" -I | grep -i "Allow:")
        [ -n "$allowed" ] && echo "Allowed methods: $allowed"
    fi
    
    if [ "$method" = "TRACE" ]; then
        trace_response=$(curl -s -X TRACE "$TARGET_URL")
        [ -n "$trace_response" ] && echo "TRACE response: $trace_response"
    fi
}

# Loop through each HTTP method and test
for method in "${HTTP_METHODS[@]}"; do
    test_method "$method"
    sleep 1  # Add delay to prevent overwhelming the server
done

echo -e "\n----------------------------------------"
echo "Test completed at $(date)"
echo "Note: Unexpected responses may indicate potential vulnerabilities"
echo "Review 200/201/204 responses to ensure they're intentional"
