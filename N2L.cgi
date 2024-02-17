#!/usr/bin/env bash

# URN to URL resolution service for urn:sha1 and urn:sha256 hashes as described in RFC 2169.
# Author: Peter Pakula

HTTP_CONTENT_TYPE_PLAIN="Content-type: text/plain"
HTTP_CONTENT_LENGTH="Content-Length: 0"
HTTP_CONNECTION="Connection: close"
COLLECTION_SHA1="/var/lib/urn-res/collections/N2L_sha1.txt"
COLLECTION_SHA256="/var/lib/urn-res/collections/N2L_sha256.txt"

# return URL for a given SHA Hash
fetch () {
   SHA_ALGORITHM=$1
   SHA_KEY=$2
   case "$SHA_ALGORITHM" in
      SHA-1)
         grep -m 1 "$SHA_KEY" "$COLLECTION_SHA1" | cut -d " " -f 2- ;;
      SHA-256)
         grep -m 1 "$SHA_KEY" "$COLLECTION_SHA256" | cut -d " " -f 2- ;;
   esac
}

# return HTTP Header
# N2L is the only request that need not return a body
return_with_status () {
   PARAM_STATUS=$1
   case "$PARAM_STATUS" in
      303)
         if [ "$SERVER_PROTOCOL" != "HTTP/1.0" ]; then
            echo "Status: 303 See Other"
         else
            echo "Status: 302 Found"
         fi
         echo "$HTTP_CONTENT_TYPE_PLAIN"
         echo "$HTTP_CONTENT_LENGTH"
         if [ "$SERVER_PROTOCOL" != "HTTP/1.0" ]; then
            echo "$HTTP_CONNECTION"
         fi
         echo "Location: ${*:2}"
         echo ""
         exit 0 ;;
      *)
         echo "Status: 404 Not Found"
         echo "$HTTP_CONTENT_TYPE_PLAIN"
         echo "$HTTP_CONTENT_LENGTH"
         if [ "$SERVER_PROTOCOL" != "HTTP/1.0" ]; then
            echo "$HTTP_CONNECTION"
         fi
         echo ""
         exit 0 ;;
   esac
}

if [[ ( -z "$REQUEST_METHOD" ) || ( -z "$QUERY_STRING" ) ]]; then
   return_with_status 404
fi

if [ "$REQUEST_METHOD" == "GET" ]; then
   URN_SHA_ALGORITHM=""
   if [[ "$QUERY_STRING" =~ urn:sha1:(.*) ]]; then
      URN_SHA_VALUE="${BASH_REMATCH[1]}"
      URN_SHA_VALUE="${URN_SHA_VALUE%&*}"
      URN_SHA_ALGORITHM="SHA-1"
   fi

   if [[ "$QUERY_STRING" =~ urn:sha256:(.*) ]]; then
      URN_SHA_VALUE="${BASH_REMATCH[1]}"
      URN_SHA_VALUE="${URN_SHA_VALUE%&*}"
      URN_SHA_ALGORITHM="SHA-256"
   fi

   if [ -z "$URN_SHA_VALUE" ]; then
      return_with_status 404
   fi

   URN_SHA_VALUE_LOWER="${URN_SHA_VALUE,,}"
   URN_SHA_VALUE_LENGTH=${#URN_SHA_VALUE_LOWER}
   if [[ ("$URN_SHA_ALGORITHM" = "SHA-1" && "$URN_SHA_VALUE_LENGTH" -eq 40) || ("$URN_SHA_ALGORITHM" = "SHA-256" && "$URN_SHA_VALUE_LENGTH" -eq 64) ]]; then
      PATH_TO_FILE=$(fetch "$URN_SHA_ALGORITHM" "$URN_SHA_VALUE_LOWER")
      if [ -z "$PATH_TO_FILE" ]; then
         return_with_status 404
      else
         return_with_status 303 "$PATH_TO_FILE"
      fi
   fi

   return_with_status 404
else
   return_with_status 404
fi
