source common.sh

mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31mMissing mysql root password argument\e[0m"
  exit 1
fi
print_head "installing golang"
yum install golang -y
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

  print_head "downloading dispatch"
   curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>${log_file}
  status_check $?

  cd /app

  print_head "Extracting user"
  unzip /tmp/dispatch.zip &>>${log_file}
  status_check $?

 Print_head "go mod init dispatch get build"
go mod init dispatch
status_check $?
go get
status_check $?
go build

status_check $?

print_head "copying systemd service file"
cp ${code_dir}/configs/dispatch.service /etc/systemd/system/dispatch.service &>>${log_file}
status_check $?

print_head "reload"
systemctl daemon-reload
status_check $?
print_head "enable"
systemctl enable dispatch
status_check $?
print_head "start"
systemctl start dispatch
status_check $?