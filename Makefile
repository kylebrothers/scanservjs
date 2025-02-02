.PHONY: build up down restart logs clean all

# Default target when just running 'make'
all: build up

# Build the Docker image
build:
	docker compose build --no-cache

# Start the containers in detached mode
up:
	docker compose up -d

# Stop the containers
down:
	docker compose down

# Restart the containers
restart: down up

# View container logs
logs:
	docker compose logs -f

# Clean up everything, including images
clean:
	docker compose down --rmi all --volumes --remove-orphans

# Update the base image and rebuild
update:
	docker pull sbs20/scanservjs:latest
	make build
	make restart
