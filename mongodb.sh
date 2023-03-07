echo -e "\e[35mInstlling mongodb\e[0m"
yum install mongodb-org -y
echo -e "\e[35mEnbling mongodb\e[0m"
systemctl enable mongod
echo -e "\e[35mStarting mongodb\e[0m"
systemctl start mongod
systemctl restart mongod
