#!/bin/bash
sudo apt update
sudo apt install mongodb

mongo <<EOF
use authentiq
db.createUser(
    {
    user: 'admin@authentiq.com',
    pwd: 'admin1234',
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]
    }
)
EOF

sudo mongod --bind_ip 192.168.65.43
sudo service mongodb restart
