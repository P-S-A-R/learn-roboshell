echo -e "\e[32mCopying mongodb\e[0m"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[35mInstlling mongodb\e[0m"
yum install mongodb-org -y
echo -e "\e[34mEnbling mongodb\e[0m"
systemctl enable mongod
echo -e "\e[33mStarting mongodb\e[0m"
systemctl start mongod

