FROM openjdk:21-jdk-slim

WORKDIR /app

COPY target/*.jar /app/*.jar

# Copy the keystore.p12 and cacerts files into the container
COPY keystore.p12 /app/keystore.p12
#COPY cacerts /app/cacerts

# Copy the certificate file
COPY server.crt.pem /app/server.crt.pem
COPY server.key.pem /app/server.key.pem

# Import the certificate into the truststore (cacerts)
# This command adds the certificate to the default truststore (cacerts)
RUN keytool -importkeystore -noprompt -srckeystore /app/keystore.p12 -srcstoretype PKCS12 -destkeystore /usr/local/openjdk-21/lib/security/cacerts -deststorepass changeit -srcstorepass 123456
RUN keytool -import -noprompt -trustcacerts -alias keycloak-cert -file /app/server.crt.pem -keystore /usr/local/openjdk-21/lib/security/cacerts -storepass changeit -srcstorepass 123456

EXPOSE 443

ENTRYPOINT ["java", "-jar", "*.jar"]