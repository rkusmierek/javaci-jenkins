BASEDIR=$(readlink -f $(dirname "$0") )
ENV_FILE=${BASEDIR}/env

[ -f ${ENV_FILE} ] || {
    echo "Configuration file missing: $ENV_FILE"
    exit 1
}

. $ENV_FILE

docker run \
  --name jenkins \
  -d \
  --restart=unless-stopped \
  -p 8080:8080 \
  -p 50000:50000 \
  -u $(id -u jenkins):$(id -g jenkins) \
  -v /opt/jenkins:/var/jenkins_home \
  -v /opt/jdk1.8.0_201:/opt/jdk1.8.0_201 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ${BASEDIR}/config:/var/jenkins_home/casc_configs \
  -e CASC_JENKINS_CONFIG=/var/jenkins_home/casc_configs \
  -e JENKINS_URL=http://${HOSTNAME}:8080/ \
  -e ARTIFACTORY_URL \
  -e ARTIFACTORY_USER \
  -e ARTIFACTORY_PASSWORD \
  -e SONAR_URL \
  -e SONAR_TOKEN \
  labasc/javaci-jenkins