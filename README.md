# URN to URL resolution service

URN to URL resolution service for urn:sha1 and urn:sha256 hashes as described in RFC 2169.

## Installation

Create your collections with SHA Keys and URL's from your informationsystems.  
For Example: calculate sha1sum from existing files and put it into your N2L_sha1.txt collection.  
Move the N2L.cgi script and collections directory to cgi-bin directory on your webserver.  
Enable cgi Modul and reload the config on your webserver.  

## Usage

Give me the Webdav URL for my URN with SHA-1 representing my file "file1.txt"

```
curl -v "http://localhost/cgi-bin/urn-res/N2L.cgi?urn:sha1:b528a19bd5416efe4fe41a0461fa181cc65fc9ec
```

Response

```
Status: 303 See Other
Content-type: text/plain
Content-Length: 0
Connection: close
Location: http://localhost/webdav/file1.txt

```

## Testing

Run Bash Automated Testing System

```
bats -t -T N2L.bats
```
