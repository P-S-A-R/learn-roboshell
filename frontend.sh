source common.sh

print_head "Installing nginx"
yum install nginx -y &>>${log_file}
status_check $?

print_head "Removing old content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
status_check $?

print_head "Downloading frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
status_check $?

print_head "Extracting Downloaded frontend"
cd /usr/share/nginx/html

print_head "extracting nginx"
unzip /tmp/frontend.zip &>>${log_file}
status_check $?

print_head "Copying nginx for roboshop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
status_check $?

print_head "Enabling nginx"
systemctl enable nginx
status_check $?

print_head "Starting nginx"
systemctl restart nginx
status_check $?