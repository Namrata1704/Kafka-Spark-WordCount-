#Container for Kafka - Spark streaming
#Check https://github.com/Yannael/brufence/blob/master/docker/streaming/README.md for details

# Version & flavour of OS
FROM centos:centos6

RUN yum -y update;
RUN yum -y clean all;

# Install basic tools
RUN yum install -y  wget dialog curl sudo lsof vim axel telnet nano openssh-server openssh-clients bzip2 passwd tar bc git unzip

#Install Java
RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel 

ENV HOME /home/kpmg
WORKDIR $HOME

#Install Spark (Spark 2.1.1 - 02/05/2017, prebuilt for Hadoop 2.7 or higher)
RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.7.tgz
RUN tar xvzf spark-2.1.1-bin-hadoop2.7.tgz
RUN mv spark-2.1.1-bin-hadoop2.7 spark

#Copy spark-streaming-kafka jars
COPY ./kafka-clients-0.10.0.1.jar $HOME/spark/jars
COPY ./spark-streaming-kafka-0-10_2.11-2.1.1.jar $HOME/spark/jars 
COPY ./spark-streaming-kafka-0-10_2.11-2.3.0.jar $HOME/spark/jars
COPY ./spark-streaming-kafka-assembly_2.11-1.6.3.jar $HOME/spark/jars

ENV SPARK_HOME $HOME/spark

#Install Kafka
RUN wget http://mirrors.dotsrc.org/apache/kafka/0.10.2.1/kafka_2.11-0.10.2.1.tgz
RUN tar xvzf kafka_2.11-0.10.2.1.tgz
RUN mv kafka_2.11-0.10.2.1 kafka

#Install Anaconda Python distribution
RUN wget https://repo.continuum.io/archive/Anaconda2-4.4.0-Linux-x86_64.sh
RUN bash Anaconda2-4.4.0-Linux-x86_64.sh -b
ENV PATH $HOME/anaconda2/bin:$PATH
RUN conda install python=2.7.10 -y

#Install Kafka Python module
RUN pip install kafka-python
RUN pip install tweepy
RUN pip install pykafka

#expose ports
EXPOSE 5002

#COPY scripts
RUN mkdir scripts
COPY ./ReadTweet_to_kafka.py $HOME/scripts

#Environment variables for Spark and Java
ENV PATH $SPARK_HOME/bin:$SPARK_HOME/sbin:$HOME/kafka/bin:$PATH
ENV PYTHONPATH $SPARK_HOME/python/:$PYTHONPATH
ENV PYTHONPATH $SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$PYTHONPATH
ENV PYSPARK_PYTHON $HOME/anaconda2/bin/python2
ENV JAVA_HOME /etc/alternatives/java_sdk
ENV PATH $JAVA_HOME/bin:$PATH
