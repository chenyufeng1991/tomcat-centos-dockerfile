# 基于centos6基础镜像
FROM centos:6
MAINTAINER chenyufeng "yufengcode@gmail.com"

# 设置当前工具目录
# 该命令不会新增镜像层
WORKDIR /home

# 安装必要的工具
RUN yum install -y wget && \
    rpm --rebuilddb && \
    yum install -y tar && \
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz && \
    tar -xvzf jdk-8u131-linux-x64.tar.gz && \
    wget http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.0.48/bin/apache-tomcat-8.0.48.tar.gz && \
    tar -xvzf apache-tomcat-8.0.48.tar.gz && \ 
    mv apache-tomcat-8.0.48/ tomcat && \
    rm -f jdk-8u131-linux-x64.tar.gz && \
    rm -f apache-tomcat-8.0.48.tar.gz && \    
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    yum clean all

# 设置环境变量
ENV JAVA_HOME /home/jdk1.8.0_131
ENV CATALINA_HOME /home/tomcat
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin
ENV TZ Asia/Shanghai

# 暴露tomcat 8080端口
EXPOSE 8080

# 启动容器执行下面的命令
ENTRYPOINT /home/tomcat/bin/startup.sh && tail -f /home/tomcat/logs/catalina.out

# 创建容器启动tomcat，由于ENTRYPOINT优先级比CMD高，所以这里的CMD不会执行
CMD ["/home/tomcat/bin/startup.sh"]

