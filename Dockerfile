FROM ubuntu:latest

# Install required tools and dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    curl \
    vim \
    neovim \
    openjdk-21-jdk \
    gradle \
    gnupg \
    lsb-release \
    && wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update && apt-get install -y postgresql-17 \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Configure PostgreSQL
RUN mkdir -p /var/lib/postgresql/data && chown -R postgres:postgres /var/lib/postgresql
USER postgres
RUN /usr/lib/postgresql/17/bin/initdb -D /var/lib/postgresql/data
USER root

# Expose PostgreSQL port
EXPOSE 5432

# Create working directory
WORKDIR /app

# Clone the Spring Boot project (replace <repository_url> with the actual Git repository URL)
RUN git clone https://github.com/thanoojgithub/SpringBootDataREST2.git .

# Build the Spring Boot project
RUN gradle build

# Expose the Spring Boot application port
EXPOSE 8080

# Run PostgreSQL and the Spring Boot application
CMD ["bash", "-c", "service postgresql start && java -jar build/libs/*.jar & sleep 100 && curl -X GET http://localhost:8080/actuator/health && curl -X GET http://localhost:8080/api/customers && curl -X GET http://localhost:8080/api/customers/2 && curl -X GET http://localhost:8080/api/customers/search/findByName?name=aaa && curl -X GET http://localhost:8080/api/customers/search/findByBranch?branch=101 & tail -f /dev/null"]