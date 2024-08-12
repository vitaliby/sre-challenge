# SRE Coding Challenge

## Solution

Following folders are added to the repository:

- `infra/` - Helm charts for deploying Postgresql and Kafka
- `helm/` - Helm chart for deploying the application
- `deploy/` - bash scripts to build and deploy the solution

### Infra

Bitnami Helm charts are used to deploy Postgresql and Kafka. There are two folders `postgresql` nad `kafka` to deploy each component. Each folder has `values.yaml` to overwrite default chart values and `install.sh` - simple script to run helm installation. 

Kafka is installed in KRaft mode with provisioning enabled to add required topic. For simplicity, authentication is disabled.

Postgresql creates application database during installation. Admin and app user passwords are stored in Kubernetes secret, and pointed during the installation.

### Helm

Since all 3 components (front, back and reader) are very similar SpringBoot application, it is decided to create a `common` Helm chart to keep the solution DRY. `common` Helm chart contains all templates needed to deploy the application and default value file. For simplicity, some values were left hardcoded in the templates.

Each component is deployed by dedicated Helm chart in the corresponding folder. These charts contain only `values.yaml` to overwrite default values and dependency to the `common` chart.

### Deploy

Following scripts are created to simplify deployment process (located in `deploy/` folder):

- `_build_app.sh` - helper script to build an image for each component.   
Usage: `_build_app.sh APP TAG` (e.g. `_build_app.sh front 0.1.0`). 
- `_deploy_app.sh` - helper script to deploy just one component. Used by `deploy_apps.sh`.   
Usage: `_deploy_app.sh HELM_RELEASE NAMESPACE HELM_CHART_PATH` (e.g. `_deploy_app.sh front demo-front ../helm/front`)
- `deploy_apps.sh` - script to deploy the application. Runs Helm chart for each component: back, reader, front.
- `deploy_infra.sh` - script to deploy the infra. Runs installation script for Postgresql and Kafka. 

### How to deploy

> Requirements:
> - k8s cluster
> - docker
> - helm
> - kubectl
>
> Note: for simplicity, the Docker Hub public registry is used as image registry

#### Steps:

1. Deploy Infra (Postgresql and Kafka)
   ```sh
   ./deploy/deploy_infra.sh
   ```

2. Deploy Application
   ```sh
   ./deploy/deploy_apps.sh
   ```



## Description

You are tasked with deploying a solution to Kubernetes cluster. You may use Minikube, Microk8s, k3s or any other Kubernetes distribution  
Solution consists of 3 SpringBoot applications, Kafka deployment to support messaging and PostgreSQL database to provide persistence layer.
Application deployment should use helm (https://helm.sh/), Kafka and Postgres may be deployed with any technology you like.

We do not expect too much automation (few bash scripts should work just fine). In case you prefer to automate everything, 
you may use any flavour of automation tools, Ansible, Terraform - everything will work, You may even setup CI/CD flow using Jenkins/Tekton/Drone/etc. ;)

## Overall architecture

![Overall architecture](doc/img/application-architecture.png)

## Deployment layout

![Deployment layout](doc/img/deployment-layout.png)

## Kafka Topic specs

- name: testCommand
- partitions: 32
- replication-factor: 1

## Database

Application developed with PostgreSQL 11.5

Database schema created with Back application first run

## Applications

### Build applications

You need Java 11+ installed, then run

`./gradlew clean build`

to build applications. Jar files will land in `app/back/build/libs/back-0.1.0.jar` (Back app for instance)

### Hints

Few hints to simplify application deployment.

Docker:
`ENTRYPOINT ["java", "-jar", "/app.jar"]`

SpringBoot additional config arg if needed. Additional config values will override default.
`--spring.config.additional-location=path-to-additional-config`

Health check exposed as 
`http://localhost:{management.server.port}/health`

Applications expose API management interface as
`http://localhost:{server.port}/swagger-ui.html`

### Front

Sample application configuration `application.yaml` file

```yaml
server.port: 8080
################### Kafka ##############################
spring:
  kafka:
    bootstrap-servers:  {{ kafka-bootstrap-goes here }}

################### Logging settings ###################
logging:
  level:
    root: WARN
    db.demo: INFO

management.server.port: 8081
```

### Back

Sample application configuration `application.yaml` file

```yaml
spring:
  kafka:
    bootstrap-servers: {{ kafka-bootstrap-goes here }}
  datasource.url: jdbc:postgresql://localhost:5432/postgres
  datasource.username: {{ username }}
  datasource.password: {{ password }}

management.server.port: 8081
```

Hint: 
You may use Spring Boot relaxed binding to pass parameters through environment variables
https://docs.spring.io/spring-boot/docs/2.1.8.RELEASE/reference/html/boot-features-external-config.html#boot-features-external-config-relaxed-binding

`SPRING_DATASOURCE_USERNAME=postgres`

### Reader

Sample application configuration `application.yaml` file

```yaml
spring:
  datasource.url: jdbc:postgresql://localhost:5432/postgres
  datasource.username: {{ username }}
  datasource.password: {{ password }}

management.server.port: 8081
```