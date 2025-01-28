#!/bin/sh

# Change the file to create a new container

HOSTNAME=`hostname`
VERSION=${VERSION:-v1}
IMAGE_TAG=${IMAGE_TAG:-nginx:alpine}

cat > /usr/share/nginx/html/index.html <<EOF
<HTML>
<HEAD>
   <body>
       <h1>Welcome to the Kubernetes Deployment Test Page</h1>
       <p>This page is on $HOSTNAME and is version $VERSION</p>
       <p>Hostname: $HOSTNAME</p>
       <p>And we're running version: $VERSION</p>
       <p>Current Date and Time: $(date)</p>
       <p>Image Tag: $IMAGE_TAG</p>
   </body>


</HTML>
EOF

mkdir /usr/share/nginx/html/healthz /usr/share/nginx/html/hostname /usr/share/nginx/html/version
cat > /usr/share/nginx/html/hostname/index.html <<EOF
$HOSTNAME -- $VERSION
EOF
cat > /usr/share/nginx/html/version/index.html <<EOF
$VERSION
EOF
chmod 777 /usr/share/nginx/html/healthz
cat > /usr/share/nginx/html/healthz/index.html <<EOF
healthy
EOF

nginx -g "daemon off;"