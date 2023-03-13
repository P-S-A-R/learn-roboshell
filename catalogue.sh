source common.sh
print_head "Downloading node js.repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?
print_head "Installing node js.repo"
yum install nodejs -y &>>${log_file}
status_check $?
print_head "Adding user"
useradd roboshop &>>${log_file}
status_check $?
print_head "Creating app directory"
mkdir /app &>>${log_file}
status_check $?
print_head "Removing content in app"
rm -rf /app/* &>>${log_file}
status_check $?
print_head "Downloading Catalogue"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
status_check $?
cd /app
print_head "Extracting Catalogue"
unzip /tmp/catalogue.zip &>>${log_file}
status_check $?
cd /app
print_head "installing  nodejs dependencies"
npm install &>>${log_file}
status_check $?
print_head "copying systemd Service file"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?
print_head "Reloading Catalogue"
systemctl daemon-reload
status_check $?
print_head "Enabling Catalogue"
systemctl enable catalogue
status_check $?
print_head "Starting Catalogue"
systemctl start catalogue
status_check $?
print_head "copying mongodb"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check $?
print_head "Installing mongodb"
yum install mongodb-org-shell -y &>>{log_file}
status_check $?
print_head "Downloading schema"
mongo --host mongodb.devopsb71.shop </app/schema/catalogue.js &>>${log_file}
status_check $?