FROM openjdk:8-jdk-alpine

ENV JETTY_VERSION 9.4.43.v20210629

RUN apk update && \
    apk add --no-cache curl && \
    mkdir -p /opt/jetty && \
    curl -sSL https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${JETTY_VERSION}/jetty-distribution-${JETTY_VERSION}.tar.gz \
    | tar -xzf - --strip-components=1 -C /opt/jetty

RUN mkdir -p /opt/dev-build/src
COPY src /opt/dev-build/src
WORKDIR /opt/dev-build

RUN mkdir -p /opt/jetty/webapps/mywebapp/WEB-INF/classes

RUN find /opt/dev-build/src -name "*.java" > sources.txt && \
    javac -cp /opt/jetty/lib/servlet-api-3.1.jar:/opt/jetty/lib/javax.servlet-api-4.0.1.jar -d /opt/jetty/webapps/mywebapp/WEB-INF/classes @sources.txt

COPY webapp /opt/jetty/webapps/mywebapp

WORKDIR /opt/jetty

CMD ["java","-jar","/opt/jetty/start.jar", "--add-module=ee10-demo-simple"]
