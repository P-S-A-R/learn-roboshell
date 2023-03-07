code_dir=(pwd)
echo -e "\e[36mInstalling nginx\e[0m"
yum install nginx -y
echo -e "\e[35mRemoving oldcontent\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[33mDownloading frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo -e "\e[32mCopying nginx\e[0m"
cp ${code_dir}configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[34mEnabling nginx\e[0m"
systemctl enable nginx
systemctl restart nginx