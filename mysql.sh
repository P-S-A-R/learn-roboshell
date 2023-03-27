source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31mMissing mysql root password argument\e[0m"
  exit 1
fi

print_head "Disabling mysql 8 version"
dnf module disable mysql -y &>>${log_file}
sttus_check $?

print_head "Installing mysql server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

Print_head "Enabling Mysql"
systemctl enable mysqld &>>${log_file}
status_check $?

print_hed "Starting mysql"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "set password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
status_check $?



