source common.sh
print_head "copying mongodb"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
print_head "Instlling mongodb"
yum install mongodb-org -y &>>${log_file}
print_head "updating mongo db ip address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf  &>>${log_file}
print_head "Enabling mongodb"
systemctl enable mongod &>>${log_file}
print_head "starting mongodb"
systemctl restart mongod &>>${log_file}

