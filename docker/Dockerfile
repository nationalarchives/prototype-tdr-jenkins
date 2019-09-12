FROM jenkins/jenkins:lts
USER root
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"
RUN apt-get update && \
        apt-key update && \
        apt-get install -y libltdl7 && \
        mkdir -p /opt/jcasc && \
        groupadd docker && \
        usermod -G docker jenkins
        # keytool -genkey -noprompt \
        # -alias keystorealias \
        # -dname "CN=Dev Team, OU=Digital Archiving, O=The National Archives, L=London, ST=Unknown, C=UK" \
        # -keystore /var/jenkins_home/jenkins_keystore.jks \
        # -storepass password \
        # -keypass password
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/jenkins.yaml
# ENV JENKINS_OPTS "--httpPort=-1 --httpsPort=8443 --httpsKeyStore=/var/jenkins_home/jenkins_keystore.jks --httpsKeyStorePassword=password"
ENV JENKINS_OPTS "--httpPort=-1 --httpsPort=8443"
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY jenkins.yml /usr/share/jenkins/ref/jenkins.yaml
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
