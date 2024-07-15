 user_data = <<-EOF
              #!/bin/bash
              # Step 1: Import the public key used by the package management system
              wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
              
              # Step 2: Create a list file for MongoDB
              echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

              # Step 3: Reload local package database
              apt-get update -y

              # Step 4: Install the MongoDB packages
              apt-get install -y mongodb-org

              # Step 5: Create MongoDB data directory
              mkdir -p /data/db

              # Step 6: Configure MongoDB
              cat <<EOT > /etc/mongod.conf
              systemLog:
                destination: file
                logAppend: true
                path: /var/log/mongodb/mongod.log
              storage:
                dbPath: /var/lib/mongodb
                journal:
                  enabled: true
              net:
                bindIp: 0.0.0.0
                port: 27017
              replication:
                replSetName: "rs0"
              EOT

              # Step 7: Start MongoDB service
              systemctl start mongod

              # Step 8: Enable MongoDB service to start on boot
              systemctl enable mongod

              # Step 9: Wait for MongoDB to start
              sleep 30

              # Step 10: Initiate the replica set
              mongo --eval 'rs.initiate({_id: "rs0", members: [{_id: 0, host: "localhost:27017"}]})'
              EOF
