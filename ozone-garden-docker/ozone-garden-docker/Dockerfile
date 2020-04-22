# start by using centos 7
FROM centos:centos7

# switch to root user for installing packages
USER root

# update with yum
RUN yum -y update

# installing perl CPANM for installing modules
RUN yum -y install cpanm gcc perl-App-cpanminus perl-Config-Tiny perl-CGI-Session perl-DBI && yum clean all

# installing perl modules
RUN cpanm Template
RUN cpanm Time::Piece
RUN cpanm Text::CSV
RUN cpanm Math::Random::Secure

#install dbd mysql module
RUN yum -y install "perl(DBD::mysql)"

# installing apache web server
RUN yum -y install httpd

# copy custom apache conf
COPY httpd.conf /etc/httpd/conf/

# copy HTML files over to container apache directory
COPY html/ /var/www/html/

# update permissions on copied files
RUN chmod -R 755 /var/www/html/*

# expose port 80 in the docker image to the host machine
EXPOSE 80

# start the apache service manually
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
