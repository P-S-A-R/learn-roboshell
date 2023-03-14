source common.sh

print_head "Installing user.repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Install Node.js"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Adding User"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log_file}
fi
status_check $?

Print_head "Making app Directory"

if [ ! -d /app ]; then
  mkdir /app &>>${log_file}
fi
status_check $?

Print_head "Removing content in app"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "downloading user"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
status_check $?

cd /app

print_head "Extracting user"
unzip /tmp/user.zip &>>${log_file}
status_check $?

print_head "installing user dependencies"
npm install &>>${log_file}
status_check $?

print_head "copying systemd service file"
cp ${code_dir}/configs/user.service /etc/systemd/system/user.service &>>${log_file}
status_check $?

print_head "Relaoding user"
systemctl daemon-reload  &>>${log_file}
status_check $?

print_head "enabling user"
systemctl enable user &>>${log_file}
status_check $?

print_head "starting user"
systemctl start user &>>${log_file}
status_check $?

print_head "copying mongodb.repo"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check $?

print_head "installing mongodb"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "downloading schema"
mongo --host mongodb.devopsb71.shop </app/schema/user.js &>>${log_file}
status_check $?
