echo -e "\e[33mLooking for Catalogue\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[32mInstalling Catalogue\e[0m"
yum install nodejs -y
echo -e "\e[33mAdding user\e[0m"
useradd roboshop
echo -e "\e[34mCreating appdirectory\e[0m"
mkdir /app
echo -e "\e[35mRemoving content in app\e[0m"
rm -rf /app/*
echo -e "\e[31mDownloading Catalogue\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
echo -e "\e[36mExtracting Catalogue\e[0m"
unzip /tmp/catalogue.zip
cd /app
echo -e "\e[33mReinstalling  Catalogue\e[0m"
npm install
cp configs/catalogue.service /etc/systemd/system/catalogue.service
echo -e "\e[34mReloading Catalogue\e[0m"
systemctl daemon-reload
echo -e "\e[35mEnabling Catalogue\e[0m"
systemctl enable catalogue
echo -e "\e[36mStarting Catalogue\e[0m"
systemctl start catalogue
cp configs/mongodb.repo /etc/yum.repos.d/mongodb.repo
echo -e "\e[33mInstalling mongodbrepo\e[0m"
yum install mongodb-org-shell -y
echo -e "\e[31mDownloading schema\e[0m"
mongo --host mongodb.devopsb71.shop </app/schema/catalogue.js