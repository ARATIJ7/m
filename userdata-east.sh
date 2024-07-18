#!/bin/bash
# Update the package repository
sudo yum update -y

# Add the MongoDB repository
cat <<EOL | sudo tee /etc/yum.repos.d/mongodb-org-4.4.repo
[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EOL

# Install MongoDB
sudo yum install -y mongodb-org

# Enable and start the MongoDB service
sudo systemctl enable mongod
sudo systemctl start mongod

# Configure MongoDB replication
cat <<EOL | sudo tee -a /etc/mongod.conf
replication:
  replSetName: "rs0"
net:
  bindIp: 0.0.0.0
EOL

# Restart MongoDB to apply changes
sudo systemctl restart mongod

# Initialize the replica set (run only on one instance)
mongo --eval 'rs.initiate()'
