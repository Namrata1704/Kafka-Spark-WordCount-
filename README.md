# Kafka-Spark-WordCount in Docker
Spark Streaming app with Kafka in Docker

Docker
Docker is a tool that can package an application and its dependencies in a virtual container that can run on any Linux server. This helps enable flexibility and portability on where the application can run, whether on premises, public cloud, private cloud, bare metal,etc.

https://www.docker.com/

Online Documentation
You can find the latest Docker documentation at https://docs.docker.com/. This README file only contains basic setup instructions.
                                                                                      
1. Download Docker Quickstart Terminal (Docker Toolbox) to run docker on your system:
   - Docker Toolbox provides a way to use Docker on Windows systems that do not meet minimal system requirements for the Docker for          Windows app.

2. Create Dockerfile:
   - Docker can build images automatically by reading the instructions from a Dockerfile.
   - A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image. Using        docker build users can create an automated build that executes several command-line instructions in succession.
   - Refer the uploaded Dockerfile
 
3. Create Docker Image:
   - A Docker Image is the template (application plus required binaries and libraries) needed to build a running Docker Container (the        running instance of that image).
   - Command to build image (Go the path where Dockerfile is saved)
     docker build -t <imageName>:<tag> .
     Eg: docker build bigdata:1 .

4. List docker images:
   - Command to list all build docker images in the cache
     docker images
     
5. Run Docker container
   - docker run -it <imagename>:<tag>
     Eg: docker run -it bigdata:1

6. List running container:
   - docker ps -a
Now the docker is all setup and running.

7. Create Twitter API account and get keys for twitter_config.py
   Update Tweet_to_kafka_topic.py and add in the needed credentials for your twitter account.

8. Start Zookeeper:
   - bin/zookeeper-server-start.sh ../../config/zookeeper.properties  > zookeeper.log 2>&1 &

9. Start apache kafka
   - bin/kafka-server-start.sh ../../config/server.properties > kafka.log 2>&1 &
   
10. Create kafka topic:
    - kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic BigData
   
10. Write tweets to kafka Topic:
	- Use Tweet_to_kafka_topic.py
  - python Tweet_to_kafka_topic.py (that will begin to stream data events into a kafka producer)

11. Spark-streaming
    - Use spark_streaming_wordcount.py
    - bin/spark-submit --jars jars/spark-streaming-kafka-assembly-*.jars spark_streaming_wordcount.py localhost:9092 BigData
