FROM ubuntu:latest

# Install required tools and dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    wget \
    unzip \
    git \
    curl \
    vim \
    neovim \
    openjdk-21-jdk \
    gnupg \
    lsb-release \
    && wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update && apt-get install -y postgresql-17 postgresql-contrib \
    && mkdir -p /var/run/postgresql \
    && chown -R postgres:postgres /var/run/postgresql \
    && rm -rf /var/lib/apt/lists/*

# Install Gradle 8
RUN wget https://services.gradle.org/distributions/gradle-8.11.1-bin.zip -P /tmp \
    && unzip /tmp/gradle-8.11.1-bin.zip -d /opt/gradle \
    && rm /tmp/gradle-8.11.1-bin.zip

# Set Gradle environment variables
ENV GRADLE_HOME=/opt/gradle/gradle-8.11.1
ENV PATH="$GRADLE_HOME/bin:$PATH"

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN mkdir -p /root/.gradle && chmod -R 777 /root/.gradle

# Configure PostgreSQL
USER postgres
RUN /usr/lib/postgresql/17/bin/initdb -D /var/lib/postgresql/data
# Expose PostgreSQL port
EXPOSE 5432

# Create working directory
WORKDIR /app

# Clone the Spring Boot project (replace <repository_url> with the actual Git repository URL)
RUN git clone https://github.com/thanoojgithub/SpringBootDataREST2.git && chmod -R -f 777 /app/SpringBootDataREST2/ && cd /app/SpringBootDataREST2 && ls -ltr && gradle clean build --refresh-dependencies --info --stacktrace && chmod -R -f 777 /app/SpringBootDataREST2/ && ls -ltr /app/SpringBootDataREST2/build/libs/SpringBootDataREST2-0.0.1-SNAPSHOT.jar

# Expose the Spring Boot application port
EXPOSE 8080

USER root
# Run PostgreSQL and the Spring Boot application
CMD ["bash", "-c", "service postgresql start && java -jar /app/SpringBootDataREST2/build/libs/SpringBootDataREST2-0.0.1-SNAPSHOT.jar & sleep 15 && curl -X GET http://localhost:8080/actuator/health && curl -X POST -H \"Content-Type: application/json\" -d '{\"id\":1, \"name\":\"John Doe\",\"branch\":\"101\",\"balance\":100}' http://localhost:8080/api/customers/ && curl -X GET http://localhost:8080/api/customers && curl -X GET http://localhost:8080/api/customers/search/findByBranch?branch=101 & tail -f /dev/null"]
