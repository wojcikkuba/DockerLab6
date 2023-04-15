FROM moby/buildkit:v0.11.5 as buildkit

FROM alpine:3.17.3 as buildkit-frontend

ARG DOCKER_USERNAME
ARG DOCKER_PASSWORD

ENV DOCKER_USERNAME=$DOCKER_USERNAME
ENV DOCKER_PASSWORD=$DOCKER_PASSWORD
ENV BUILDKIT_HOST=docker-container://buildkit

RUN apk update && apk add --no-cache \
    openssh-client \
    docker-cli \
    curl \
    git

RUN curl -o buildkit.tar.gz -LJO https://github.com/moby/buildkit/releases/download/v0.11.5/buildkit-v0.11.5.linux-amd64.tar.gz && \
    tar -xf buildkit.tar.gz -C /usr/local && \
    rm -f buildkit.tar.gz

RUN mkdir -p -m 0600 ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh git clone git@github.com:wojcikkuba/MultiStageDockerfile.git node-app

RUN echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin

WORKDIR /node-app

CMD buildctl build --frontend=dockerfile.v0 \
    --local context=. \
    --local dockerfile=. \
    --output type=image,name=docker.io/wojcikkuba/node-app:lab6,push=true