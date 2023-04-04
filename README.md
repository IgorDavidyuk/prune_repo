# Prune Repo

Trim your repository to remove files with specific extensions within a container and assess the resulting size.

## Usage:
1. Clone and cd to the project folder
2. `DOCKER_BUILDKIT=1 docker build -f prune_repo.Dockerfile -t prune_repo --build-arg REPO_ADDRESS=your_repo_address .`
3. `docker run -it --rm --name prune_repo prune_repo "jpeg mp4 bin"`
