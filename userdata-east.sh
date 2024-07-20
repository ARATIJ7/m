#!/bin/bash

# Update and install MongoDB
yum update -y
amazon-linux-extras enable corretto8
amazon-linux-extras install java-openjdk11
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo rpm --import -
tee -a /etc/yum.repos.d/mongodb-org-6.0.repo << EOL
[mongodb-org-6.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/6.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc
EOL
yum install -y mongodb-org

# Configure MongoDB
systemctl start mongod
systemctl enable mongod

# Allow remote access to MongoDB (optional, be cautious with security)
sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

# Enable replication in the MongoDB configuration file
cat >> /etc/mongod.conf << EOL

replication:
  replSetName: "rs0"
EOL

# Restart MongoDB to apply the changes
systemctl restart mongod

# Setup MongoDB Replica Set
PRIMARY_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
SECONDARY_IP1="${element(aws_instance.west_mongodb_instance_1.*.private_ip, 0)}"
SECONDARY_IP2="${element(aws_instance.west_mongodb_instance_2.*.private_ip, 0)}"

cat > /tmp/rs.js <<-EOF
  rs.initiate({
    _id: "rs0",
    members: [
      { _id: 0, host: "$PRIMARY_IP:27017" },
      { _id: 1, host: "$SECONDARY_IP1:27017" },
      { _id: 2, host: "$SECONDARY_IP2:27017" }
    ]
  })
EOF

# Execute the Replica Set configuration script
mongo --eval "rs.initiate()"  # Initial setup
sleep 10  # Wait for the primary to stabilize
mongo < /tmp/rs.js

# Check Replica Set status
mongo --eval "rs.status()"
