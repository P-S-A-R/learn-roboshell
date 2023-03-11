source common.sh 
print_head "Looking for Catalogue"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>{log_file}
print_head "Installing Catalogue"
yum install nodejs -y &>>{log_file}
print_head "Adding user"
useradd roboshop
print_head "Creating app directory"
mkdir /app
print_head "Removing content in app"
rm -rf /app/* &>>{log_file}
print_head "Downloading Catalogue"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>{log_file}
cd /app
print_head "Extracting Catalogue"
unzip /tmp/catalogue.zip &>>{log_file}
cd /app
print_head "Reinstalling  Catalogue"
npm install &>>{log_file}
cp configs/catalogue.service /etc/systemd/system/catalogue.service &>>{log_file}
print_head "Reloading Catalogue"
systemctl daemon-reload
print_head "Enabling Catalogue"
systemctl enable catalogue
print_head "Starting Catalogue"
systemctl start catalogue
cp configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>{log_file}
print_head "Installing mongodb"
yum install mongodb-org-shell -y &>>{log_file}
print_head "Downloading schema"
mongo --host mongodb.devopsb71.shop </app/schema/catalogue.js &>>{log_file}