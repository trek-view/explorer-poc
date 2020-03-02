#!/bin/sh

#############################
# Deploy with docker-compose mode
#############################

# # Stop previous dockers
# docker-compose stop
# docker-compose down

# # Run dockers as daemon
# docker-compose up -d --build

# # Remove caches
# yes | docker container prune
# yes | docker network prune
# yes | docker image prune
# yes | docker volume prune

#############################
# Deploy with docker mode
#############################

# Stop current running docker
docker stop explorer-staging

# Remove caches
yes | docker container prune

# Run docker
docker run -d -p 3000:3000 --name explorer-staging ivvanov1009/explorer:staging

echo "Deployed!"