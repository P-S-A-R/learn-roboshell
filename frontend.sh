source common.sh
print_head "Installing nginx"
yum install nginx -y &>>${log_file}
print_head "Removing oldcontent"
rm -rf /usr/share/nginx/html/* &>>${log_file}
print_head "Downloading frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
print_head "Copying nginx"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
print_head "Enabling nginx"
systemctl enable nginx
print_head "Starting nginx"
systemctl restart nginx