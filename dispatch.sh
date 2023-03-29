source common.sh

print_head "clean packages"
yum clean packages
status_check $?

component=dispatch
golang