 code_dir=$(pwd)
 log_file=/tmp/roboshop.log
 rm -f ${log_file}

print_head() {
  echo -e "\e[36m$1\e[0m"
}

status_check() {
  if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
    echo "Read the logfile $(log_file) for more information about error"
    exit 1
  fi
}

nodejs() {

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

print_head "Making app Directory"

if [ ! -d /app ]; then
  mkdir /app &>>${log_file}
fi
status_check $?

print_head "Removing content in app"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "downloading user"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
status_check $?

cd /app

print_head "Extracting user"
unzip /tmp/${component}.zip &>>${log_file}
status_check $?

print_head "installing user dependencies"
npm install &>>${log_file}
status_check $?

print_head "copying systemd service file"
cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
status_check $?

print_head "Relaoding user"
systemctl daemon-reload  &>>${log_file}
status_check $?

print_head "enabling user"
systemctl enable ${component} &>>${log_file}
status_check $?

print_head "starting user"
systemctl start ${component} &>>${log_file}
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

}