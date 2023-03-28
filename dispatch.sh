source common.sh

mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31mMissing mysql root password argument\e[0m"
  exit 1
fi
print_head "installing golang"
yum install golang -y
status_check $?

print_head "cleaning packages"

yum clean packages
status_check $?

component=dispatch
golang