# URN to URL resolution service

URN to URL resolution service for urn:sha1 and urn:sha256 hashes as described in RFC 2169.

## Installation

To run this cgi script you need bash, grep and cut.  

### Create Collections

Create your collections with SHA Keys and URL's from your informationsystem.  
The first column in the collection contains a SHA Key.  
The second column contains a encoded URL to file.  
The two columns a separated by a single blank.  

Example: 37f6da63887a0efb5c59342b59c4b3afd22494a9f13eaf862362e985ec16ab4b http://localhost/webdav/file3.txt

Create the file N2L_sha1.txt for SHA-1 keys and N2L_sha256.txt for SHA-256 keys.

### Copy cgi script and collections

Create directories  

```
sudo mkdir -p /usr/lib/cgi-bin/urn-res
sudo mkdir -p /var/lib/urn-res/collections
```

Copy the N2L.cgi script to /usr/lib/cgi-bin/urn-res directory and change the permissions.

```
sudo cp N2L.cgi /usr/lib/cgi-bin/urn-res
sudo chmod 755 /usr/lib/cgi-bin/urn-res/N2L.cgi
```

Copy your collections to /var/lib/urn-res/collections  

```
sudo cp collections/N2L_sha1.txt /var/lib/urn-res/collections
sudo cp collections/N2L_sha256.txt /var/lib/urn-res/collections
```

### Enable cgi Modul and reload the config on your webserver.  

#### Setup cgi for apache  

Enable cgi:  

```
sudo a2enmod cgi
```

Reload the apache config.  

```
sudo systemctl reload apache2.service
```

#### Setup cgi for lighttpd  

Enable mod_cgi:  

```
sudo lighttpd-enable-mod cgi
```

Open the mod_cgi configuration file and modify as follows:  

```
sudo vi /etc/lighttpd/conf-enabled/10-cgi.conf

cgi.execute-x-only = "enable"
$HTTP["url"] =~ "^/cgi-bin/" {
    cgi.assign = ( ".cgi" => "/usr/bin/bash", )
}
```

Reload the lighttpd config.  

```
sudo service lighttpd force-reload
```

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

To run tests you need bats (Bash Automated Testing System).  

Install bats

```
sudo apt-get install bats
```

Run tests

```
bats -t -T N2L.bats
```
