source common.sh

roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ]; then
  echo -e "\e[31mMissing roboshop app password argument\e[0m"
  exit 1
fi
print_head "setup erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "setup rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "install rabbitmq and eralng"
yum install rabbitmq-server erlang -y &>>${log_file}
status_check $?

print_head "Enabling rabbitmq"
systemctl enable rabbitmq-server &>>${log_file}
status_check $?

print_head "Starting rabbitmq"
systemctl start rabbitmq-server &>>${log_file}
status_check $?

print_head "add application user"
rabbitmqctl list_users | grep roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${roboshop_app_pssword} &>>${log_file}
fi
status_check $?

print_head "configure permissions for app user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?