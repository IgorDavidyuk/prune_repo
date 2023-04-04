# Build:
# DOCKER_BUILDKIT=1 docker build -f prune_repo.Dockerfile -t prune_repo .
# Run:
# docker run -it --rm --name prune_repo prune_repo

FROM ubuntu:latest

RUN --mount=type=cache,id=apt-dev,target=/var/cache/apt \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates git git-filter-repo \
    && rm -rf /var/lib/apt/lists/*

ARG REPO_ADDRESS=https://github.com/openvinotoolkit/openvino_notebooks

RUN git clone $REPO_ADDRESS repo

ADD prune_repo.sh .

ENTRYPOINT [ "bash", "./prune_repo.sh" ]
CMD [ "pdiparams bin pt onnx jpg jpeg ttf mp4 pth pb pdmodel xml" ]