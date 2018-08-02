Graphistry Docker Compose Bootstrap
===================================

Environment Setup
-----------------
The contents of the `.env` file should guide you through your complete setup

```
GRAPHISTRY_LOG_LEVEL=DEBUG

S3_ENABLED=false

# S3_ACCESS=<YOUR AWS ACCESS KEY ID>
# S3_SECRET=<YOUR AWS ACCESS KEY SECRET>

# PIVOT_INTERNAL_IP_ACCEPTLIST=[]

# If you do not specify a password, one will be generated for you
# You can get that password with `docker-compose logs pivot | grep PIVOT_PASSWORD`
# You will also get the hash for your password, if you would like to specify only the password hash that you get from
# the output of the logs as `PIVOT_PASSWORD_HASH`, and you can skip the printing of generated temp passwords.

# PIVOT_PASSWORD=changeme
PIVOT_USERNAME=graphistry

# `docker-compose logs pivot | grep PIVOT_PASSWORD`
# pivot_1    | PIVOT_PASSWORD_HASH: $2b$10$LQRLZ3rBLAHBHLAHAHABLAHBLAHfc3q
# PIVOT_PASSWORD_HASH=$2b$10$LQRLZ3rBLAHBHLAHAHABLAHBLAHfc3q

# ES_HOST=es.example.com
# ES_PORT=9200
# ES_PROTOCOL=http # HTTP or HTTPS
# ES_VERSION=6.1
# ES_AUTH="username:password"

# SPLUNK_USER=splunk
# SPLUNK_KEY=<plunk password>
# SPLUNK HOST=splunk.example.com
# SPLUNK_PORT=8089
# SPLUNK_WEB_PORT=443
# SPLUNK_PROTOCOL=http
# SPLUNK_SUFFIX="/en-US"

# MONGO_USERNAME=graphistry
# MONGO_PASSWORD=<set your mongo password>

# GRAPHISTRY_HOST="http://graphistry"
```

As the comments say, a password wil be generated or hashed for you. If you specify a password it will hash it for you. 
If you do not, one will be provided for you. Afterwards you can retreive the password hash with 
`docker-compose logs pivot | grep PIVOT_PASSWORD` and specify it directly, thus avoiding plain text passwords.

Nginx Config and SSL
--------------------

There are two helper ssl configs provided for you in the `./etc/nginx` folder.

**ssl.self-provided.conf**
```
listen 443 ssl;
# certs sent to the client in SERVER HELLO are concatenated in ssl_certificate
# Includes the website cert, and the CA intermediate cert, in that order
ssl_certificate            /etc/ssl/ssl.crt;

# Unencrypted key file
ssl_certificate_key        /etc/ssl/ssl.key;
```

Notice the location of the SSL keys and certs. Also the SSL include in the supplied `graphistry.conf`.

**graphistry.conf**
```
...
    
    server_name                 _;

    proxy_http_version          1.1;
    client_max_body_size        256M;

    import /etc/nginx/graphistry/ssl.conf

    proxy_set_header            Host              $http_host;
    proxy_set_header            X-Real-IP         $remote_addr;
    proxy_set_header            X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header            X-Forwarded-Proto $scheme;

    # Support proxying WebSocket connections
    proxy_set_header            Upgrade           $http_upgrade;
    proxy_set_header            Connection        $connection_upgrade;

    # Block Slack's link preview generator bot, so that posting a viz link into Slack doesn't
    # overwhelm the server. We should have a more robust system for stopping all bots, though
    if ($http_user_agent ~* Slack) {
        return 403;
    }

...

```

If you uncomment the nginx volume mounts in the `docker-compose.yml` and supply SSL key and certs, SSL will start 
right up for you.

**docker-compose.yml**
```

  nginx:
    image: spengler.grph.xyz/release/nginx-proxy:2000
    ports:
      - 80:80
      - 443:443
    links:
      - pivot
      - central
    # volumes:  
    #   - ./etc/nginx/nginx.conf:/etc/nginx/nginx.conf
    #   - ./etc/nginx/graphistry.conf:/etc/nginx/conf.d/graphistry.conf
    #   - ./etc/nginx/ssl.self-provided.conf:/etc/nginx/graphistry/ssl.conf
    #   - ./etc/ssl:/etc/ssl

```

There is an alternate SSL conf you can use if yo uare not using a self signed cert. `./etc/nginx/ssl.conf`.

Bootstrap System
================

Bootstrap either rhel with

`$ ./bootstrap.sh [rhel|ubuntu]`

Take a look at the individual bootstrap scripts in `./bootstrap`