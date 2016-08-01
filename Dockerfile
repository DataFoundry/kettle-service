# kettle-service
FROM library/ubuntu:14.04

RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/mirrors.aliyun.com/g" /etc/apt/sources.list 
RUN apt-get update -y && apt-get -y install software-properties-common unzip 
RUN add-apt-repository ppa:webupd8team/java  && apt-get update

RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get -y install oracle-java7-installer ant && apt-get clean
RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/environment

RUN wget -P / https://s3.cn-north-1.amazonaws.com.cn/datafoundry/base_software/pdi-ce-5.0.1-stable.zip && \
    wget -P / https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz 
ADD . /
RUN unzip pdi-ce-5.0.1-stable.zip \
 && rm pdi-ce-5.0.1-stable.zip \
 && mkdir /.kettle \
 && chmod +x /start.sh
RUN tar -xzf mysql-connector-java-5.1.38.tar.gz \
 && mv /mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar /data-integration/lib/

WORKDIR /data-integration

EXPOSE 8080

CMD ["/start.sh"]
