FROM debian:jessie
MAINTAINER Kevin Gustavson <kgustavson@straightnorth.com>

#RUN apt-get update
#RUN apt-get install -y software-properties-common
#RUN add-apt-repository ppa:ondrej/php5-5.6

RUN apt-get update
RUN apt-get upgrade -y --force-yes

RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y --force-yes\
    ant\
    beanstalkd\
    build-essential\
    g++\
    curl\
    git-core\
    libsqlite3-dev\
    mysql-server-5.5\
    nodejs-legacy\
    npm\
    php5-cli\
    php5-curl\
    php5-mcrypt\
    php5-mysql\
    php5-sqlite\
    php5-xsl\
    php5\
    phpunit\
    rubygems\
    ruby-dev\
    vim
#    python-software-properties\

RUN apt-get install php5-cli -y -o Dpkg::Options::="--force-confold" --force-yes
RUN apt-get install php5-mcrypt -y -o Dpkg::Options::="--force-confold" --force-yes
RUN apt-get install php5-xsl php5-gd php5-curl php5-mysql -y --force-yes

RUN echo "ServerName localhost" > /etc/apache2/httpd.conf

ENV vhost \
<VirtualHost *:80> \
    DocumentRoot "/home/vagrant/vhosts/gonorthwebsites/public" \
    ServerName localhost \
    <Directory "/home/vagrant/vhosts/gonorthwebsites/public"> \
        #Order allow,deny \
        #Allow from all \
        #The two lines above in apache2.4 are replaced by the one line below. \
        Require all granted \
        Options -Indexes +FollowSymLinks +MultiViews \
        AllowOverride All \
\
        # Helps with Vagrant / VBox / NFS shares \
        # http://www.mabishu.com/blog/2013/05/07/solving-caching-issues-with-vagrant-on-vboxsf/ \
        EnableSendfile off \
    </Directory> \
</VirtualHost>

RUN echo "${VHOST}" > /etc/apache2/sites-enabled/000-default.conf

# Enable mod_rewrite
RUN a2enmod rewrite

# Set up the database

# Set up the database
RUN sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

#Restart mySQL
RUN service mysql restart

#Enable PHP mod
RUN a2enmod php5
#Enable Mcrypt
RUN php5enmod mcrypt
# Restart apache
RUN service apache2 restart

#Install MailCatcher
RUN gem install mailcatcher

#start mailcatcher on boot
#RUN echo "@reboot $(which mailcatcher) --ip=10.1.1.1" >> /etc/crontab
#RUN update-rc.d cron defaults

#start mailcatcher now
#RUN /usr/bin/env $(which mailcatcher) --ip=10.1.1.1

# install adminer
#RUN cd /home/vagrant/vhosts/gonorthwebsites/public
#RUN wget -O adminer_lib.php http://www.adminer.org/latest.php
#RUN cp /home/vagrant/vhosts/gonorthwebsites/adminer.cfg /home/vagrant/vhosts/gonorthwebsites/public/adminer.php
#RUN cd /home/vagrant

# Start beanstalkd
#RUN service beanstalkd start

# Install jekyll
RUN gem install jekyll

# Install LESS compiler
RUN npm install -g less

# Install phantomjs
RUN npm install -g phantomjs
