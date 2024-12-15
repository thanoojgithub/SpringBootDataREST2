# Getting Started

In this Application,

Using,
- **JDK 21**
- **Gradle 8.11**
- **Git 2.47.0.windows.2**
- for DB, **Neon Postgres**

Implementation,
- **spring-boot-starter-data-rest** 

### Properties:
```
spring.application.name=SpringBootDataREST2

# Postgres Database configuration
spring.datasource.url=jdbc:postgresql://ep-royal-snow-a55hwgsz.us-east-2.aws.neon.tech/mydb?user=mydb_owner&password=DPQfWFCX49Lh&sslmode=require
spring.datasource.driverClassName=org.postgresql.Driver
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect

# Enable Spring Data REST
spring.data.rest.base-path=/api
```

### Dependencies:
```
implementation("org.springframework.boot:spring-boot-starter-actuator")
implementation("org.springframework.boot:spring-boot-starter-data-jpa")
implementation("org.springframework.boot:spring-boot-starter-data-rest")
implementation("org.springframework.data:spring-data-rest-hal-explorer")
testImplementation("org.springframework.boot:spring-boot-starter-test")
testRuntimeOnly("org.junit.platform:junit-platform-launcher")
runtimeOnly("org.postgresql:postgresql:42.7.2")
```

### Build :
```
.\gradlew clean build 
```

### Run:
```
.\gradlew bootRun
```


### GET APIs:
```
http://localhost:8080/actuator/health

http://localhost:8080/api/customers
http://localhost:8080/api/customers/2
http://localhost:8080/api/customers/search/findByName?name=aaa
http://localhost:8080/api/customers/search/findByBranch?branch=101
```
