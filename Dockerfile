FROM centos:centos6

#adding EPEL repo to centos6
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Install yum dependencies
RUN yum -y update && \
    yum groupinstall -y development && \
    yum install -y \
    bzip2-devel \
    git \
    hostname \
    openssl \
    openssl-devel \
    sqlite-devel \
    sudo \
    tar \
    wget \
    zlib-dev

# Install python2.7
RUN cd /tmp && \
    wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz && \
    tar xvfz Python-2.7.8.tgz && \
    cd Python-2.7.8 && \
    ./configure --prefix=/usr/local && \
    make && \
    make altinstall

#Adding mongodb repo & installation
RUN echo -e "[mongodb-org-3.4]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/6/mongodb-org/3.4/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc" > /etc/yum.repos.d/mongodb-org-3.4.repo
RUN yum install -y mongodb-org

#Installing java

USER root

RUN yum install -y \
    java-1.8.0-openjdk \
    java-1.8.0-openjdk-devel

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

ENV TOMCAT_MAJOR 7
ENV TOMCAT_VERSION 7.0.75
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-7/v7.0.75/bin/apache-tomcat-7.0.75.tar.gz

RUN set -x \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
    && tar -xvf tomcat.tar.gz --strip-components=1 \
    && rm bin/*.bat \
    && rm tomcat.tar.gz*

COPY ./CONF/tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.xml
ADD ./CODE/knowlo.war $CATALINA_HOME/webapps/

EXPOSE 8080
CMD ["catalina.sh", "run"]

