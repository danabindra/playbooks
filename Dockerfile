FROM artifactory.ssnc.dev/docker-repos/pipeline/gitlabci/ssc-cloud-cli:1.4

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY run-playbook.sh /run-playbook.sh

# Code file to execute when the docker container starts up
ENTRYPOINT ["bash", "/run-playbook.sh"]
