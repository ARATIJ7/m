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

# Connect to the East instance and add this instance to the replica set
# Replace <East-Instance-Public-IP> with the actual public IP of the East instance

east_ip="<East-Instance-Public-IP>"
mongo --host ${east_ip}:27017 --eval 'rs.add("'$(curl http://169.254.169.254/latest/meta-data/public-ipv4)':27017")'
