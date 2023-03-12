source common.sh
print_head "copying mongodb"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
print_head "Instlling mongodb"
yum install mongodb-org -y &>>${log_file}
print_head "updating mongo db ip address"
sed -i -e `s/127.0.0.1/0.0.0.0` /etc/mongod.conf 
print_head "Enabling mongodb"
systemctl enable mongod
print_head "starting mongodb"
systemctl start mongod

