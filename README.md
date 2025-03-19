## Running the HTTP Verb Tampering Script

This Bash script tests a target URL for HTTP Verb Tampering vulnerabilities by sending various HTTP method requests.

### Prerequisites
- Bash-compatible system (Linux, macOS, or WSL on Windows)
- `curl` installed (`sudo apt install curl` on Debian/Ubuntu, `brew install curl` on macOS)

### Usage
1. **Save the Script**
   - Copy the script into a file named `http_verb_test.sh`.

2. **Make it Executable**
   ```bash
   chmod +x http_verb_test.sh
3. **Run the Script**
   - Execute with a target URL:
   ```bash
   ./http_verb_test.sh http://example.com/api/resource

 ### Output
- Tests HTTP methods (GET, POST, PUT, etc.)
  - Color-coded results:
  - Green: Success (200, 201, 204)
  - Red: Errors
  - Yellow: Unexpected responses
- Includes special info for OPTIONS and TRACE methods
