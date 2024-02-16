# Tests for N2L.cgi script
# Author: Peter Pakula

setup() {
   export SERVER_PROTOCOL="HTTP/1.1"
}

# bats test_tags=tag:303, tag:GET
@test "Expected(303) - GET existing SHA1 with non-sense parameter name=test" {
   export REQUEST_METHOD="GET"
   export QUERY_STRING="urn:sha1:8581c654cb1594a23ec563a5721e2e19d19df839&name=test"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 303 See Other" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [[ "${lines[4]}" == "Location: "* ]]
   [ "${lines[5]}" = "" ]
}

# bats test_tags=tag:404, tag:GET
@test "Expected(404) - GET existing SHA1 double urn parameters" {
   export REQUEST_METHOD="GET"
   export QUERY_STRING="urn:sha1:urn:sha1:8581c654cb1594a23ec563a5721e2e19d19df839"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 404 Not Found" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [ "${lines[4]}" = "" ]
}

# bats test_tags=tag:404, tag:GET
@test "Expected(404) - GET inkorrekt SHA256" {
   export REQUEST_METHOD="GET"
   export QUERY_STRING="urn:sha256:8581c654cb1594a23ec563a5721e2e19d19df839&name=11111"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 404 Not Found" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [ "${lines[4]}" = "" ]
}

# bats test_tags=tag:303, tag:GET
@test "Expected(303) - GET existing SHA1 Location without spaces" {
   export REQUEST_METHOD="GET"
   export QUERY_STRING="urn:sha1:b528a19bd5416efe4fe41a0461fa181cc65fc9ec"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 303 See Other" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [[ "${lines[4]}" == "Location: "* ]]
   [ "${lines[5]}" = "" ]
}

# bats test_tags=tag:303, tag:GET
@test "Expected(303) - GET existing SHA256 Location without spaces" {
   export REQUEST_METHOD="GET"
   export QUERY_STRING="urn:sha256:37f6da63887a0efb5c59342b59c4b3afd22494a9f13eaf862362e985ec16ab4b"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 303 See Other" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [[ "${lines[4]}" == "Location: "* ]]
   [ "${lines[5]}" = "" ]
}

# bats test_tags=tag:303, tag:GET
@test "Expected(303) - GET existing SHA1 Location with single quote" {
   export REQUEST_METHOD="GET"
   export QUERY_STRING="urn:sha1:550db109d73f638912d09d40d85c7f8d336d81da"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 303 See Other" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [[ "${lines[4]}" == "Location: "* ]]
   [ "${lines[5]}" = "" ]
}

# bats test_tags=tag:404, tag:GET
@test "Expected(404) - GET correct SHA1 but not found" {
   export REQUEST_METHOD="GET"
   export QUERY_STRING="urn:sha1:b528a19bd5416efe4fe41a0461fa181cc65fc9ee"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 404 Not Found" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [ "${lines[4]}" = "" ]
}

# all http methods RFC2616
# bats test_tags=tag:303, tag:GET
@test "Expected(303) - GET existing SHA1" {
   export REQUEST_METHOD="GET"
   export QUERY_STRING="urn:sha1:8581c654cb1594a23ec563a5721e2e19d19df839&name=11111"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 303 See Other" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [[ "${lines[4]}" == "Location: "* ]]
   [ "${lines[5]}" = "" ]
}

# bats test_tags=tag:404, tag:HEAD
@test "Expected(404) - HEAD existing SHA1" {
   export REQUEST_METHOD="HEAD"
   export QUERY_STRING="urn:sha1:550db109d73f638912d09d40d85c7f8d336d81da"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 404 Not Found" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [ "${lines[4]}" = "" ]
}

# bats test_tags=tag:404, tag:POST
@test "Expected(404) - POST existing SHA1" {
   export REQUEST_METHOD="POST"
   export QUERY_STRING="urn:sha1:8581c654cb1594a23ec563a5721e2e19d19df839&name=11111"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 404 Not Found" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [ "${lines[4]}" = "" ]
}

# bats test_tags=tag:404, tag:PUT
@test "Expected(404) - PUT existing SHA1" {
   export REQUEST_METHOD="PUT"
   export QUERY_STRING="urn:sha1:550db109d73f638912d09d40d85c7f8d336d81da"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 404 Not Found" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [ "${lines[4]}" = "" ]
}

# bats test_tags=tag:404, tag:DELETE
@test "Expected(404) - DELETE existing SHA1" {
   export REQUEST_METHOD="DELETE"
   export QUERY_STRING="urn:sha1:550db109d73f638912d09d40d85c7f8d336d81da"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 404 Not Found" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [ "${lines[4]}" = "" ]
}

# bats test_tags=tag:404, tag:TRACE
@test "Expected(404) - TRACE existing SHA1" {
   export REQUEST_METHOD="TRACE"
   export QUERY_STRING="urn:sha1:550db109d73f638912d09d40d85c7f8d336d81da"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 404 Not Found" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [ "${lines[4]}" = "" ]
}

# bats test_tags=tag:404, tag:OPTIONS
@test "Expected(404) - OPTIONS existing SHA1" {
   export REQUEST_METHOD="OPTIONS"
   export QUERY_STRING="urn:sha1:550db109d73f638912d09d40d85c7f8d336d81da"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 404 Not Found" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [ "${lines[4]}" = "" ]
}

# bats test_tags=tag:404, tag:CONNECT
@test "Expected(404) - CONNECT existing SHA1" {
   export REQUEST_METHOD="CONNECT"
   export QUERY_STRING="urn:sha1:550db109d73f638912d09d40d85c7f8d336d81da"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 404 Not Found" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "Connection: close" ]
   [ "${lines[4]}" = "" ]
}

# bats test_tags=tag:302, tag:GET
@test "Expected(302) - HTTP/1.0 GET existing SHA1" {
   export SERVER_PROTOCOL="HTTP/1.0"
   export REQUEST_METHOD="GET"
   export QUERY_STRING="urn:sha1:8581c654cb1594a23ec563a5721e2e19d19df839&name=11111"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 302 Found" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [[ "${lines[3]}" == "Location: "* ]]
   [ "${lines[4]}" = "" ]
}

# bats test_tags=tag:404, tag:GET
@test "Expected(404) - HTTP/1.0 GET inkorrekt SHA256" {
   export SERVER_PROTOCOL="HTTP/1.0"
   export REQUEST_METHOD="GET"
   export QUERY_STRING="urn:sha256:8581c654cb1594a23ec563a5721e2e19d19df839&name=11111"
   run ./N2L.cgi
   [ "${lines[0]}" = "Status: 404 Not Found" ]
   [ "${lines[1]}" = "Content-type: text/plain" ]
   [ "${lines[2]}" = "Content-Length: 0" ]
   [ "${lines[3]}" = "" ]
}

