#!/bin/bash
replace-config-value() {
    # $1 - config key
    # $2 - config new value
    # $3 - config file name 
    sudo sed -c -i "s/#$1/$1/1" $3 # uncomment config value first
    sudo sed -c -i "s/\($1 *= *\).*/\1$2/" $3 # set config value
}
sudo hostnamectl set-hostname ${nodename}

create new sonarqube user
sudo groupadd sonar
sudo useradd -c "Sonar System User" -d /opt/sonarqube -g sonar -s /bin/bash sonar
echo ${server_user_password} | passwd sonar --stdin
sudo usermod -a -G sonar ec2-user

# install OpenJDK
curl -O https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz
tar zxvf openjdk-11.0.1_linux-x64_bin.tar.gz
sudo mv jdk-11.0.1 /usr/local/
sudo chmod -R 755 /usr/local/jdk-11.0.1

export JAVA_HOME=/usr/local/jdk-11.0.1
echo "export JAVA_HOME=/usr/local/jdk-11.0.1" | sudo tee -a /etc/profile
echo "export PATH=$JAVA_HOME/bin:$PATH" | sudo tee -a /etc/profile

source /etc/profile

# install SonarQube server
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${sonarqube_version}.zip
unzip sonarqube-${sonarqube_version}.zip
sudo mv -v sonarqube-${sonarqube_version}/* /opt/sonarqube
sudo chown -R sonar:sonar /opt/sonarqube
sudo chmod -R 775 /opt/sonarqube

export SONAR_HOME=/opt/sonarqube
echo "export SONAR_HOME=/opt/sonarqube" >> ~/.bashrc
source ~/.bashrc

# configure SonarQube server

# FIXME sonarqube cannot start (authentication failed) when running as sonar user
#replace-config-value "RUN_AS_USER" "sonar" $SONAR_HOME/bin/linux-x86-64/sonar.sh
replace-config-value "sonar\.jdbc\.username" "${db_user}" $SONAR_HOME/conf/sonar.properties
replace-config-value "sonar\.jdbc\.password" "${db_pass}" $SONAR_HOME/conf/sonar.properties
sudo sed -c -i "s/#sonar\.jdbc\.url=jdbc:postgresql.*/sonar\.jdbc\.url=jdbc:postgresql:\/\/${db_endpoint}\/${db_name}/g" $SONAR_HOME/conf/sonar.properties
replace-config-value "sonar\.web\.port" "8080" $SONAR_HOME/conf/sonar.properties

# fix SonarQube runtime issues
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sudo sysctl vm.max_map_count
sudo sysctl fs.file-max

# start SonarQube server
$SONAR_HOME/bin/linux-x86-64/sonar.sh start