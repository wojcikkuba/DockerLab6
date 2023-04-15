# DockerLab6

**Komendy do budowania i uruchomienia kontenera:**

docker build --ssh default --build-arg DOCKER_PASSWORD=$DOCKER_PASSWORD --build-arg DOCKER_USERNAME=$DOCKER_USERNAME -t builder1 .

docker run -dt -v /var/run/docker.sock:/var/run/docker.sock --name testcont builder1
