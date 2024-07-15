 user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y mongodb
              mkdir -p /data/db
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
              systemctl start mongod
              sleep 30
              mongo --eval 'rs.initiate({_id: "rs0", members: [{_id: 0, host: "localhost:27017"}]})'
              EOF
