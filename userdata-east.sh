#!/bin/bash
# Install MongoDB
sudo apt-get update
sudo apt-get install -y mongodb

# Configure MongoDB replica set
cat <<EOF > /etc/mongod.conf
replication:
  replSetName: "rs0"
net:
  bindIp: 0.0.0.0
EOF

# Start MongoDB
sudo systemctl start mongodb

# Enable MongoDB service
sudo systemctl enable mongodb

# Wait for MongoDB to start
sleep 10

# Initialize replica set
mongo --eval 'rs.initiate({_id: "rs0", members: [{ _id: 0, host: "'$(curl http://169.254.169.254/latest/meta-data/public-ipv4)':27017" }]})'
