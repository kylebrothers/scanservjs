.PHONY: build up down restart logs clean all up-all down-all list-instances

# Find all .env files
ENV_FILES := $(wildcard .env*)

# Default target when just running 'make'
all: build up-all

# Build the Docker image (only needs to be done once)
build:
	sudo docker compose build --no-cache

# Start single instance (default .env)
up:
	sudo docker compose up -d

# Stop single instance (default .env)
down:
	sudo docker compose down

# Start all instances (auto-detect .env files)
up-all:
	@echo "Found env files: $(ENV_FILES)"
	@for env_file in $(ENV_FILES); do \
		echo "Starting instance with $$env_file"; \
		sudo docker compose --env-file $$env_file up -d; \
	done

# Stop all instances
down-all:
	@for env_file in $(ENV_FILES); do \
		echo "Stopping instance with $$env_file"; \
		sudo docker compose --env-file $$env_file down; \
	done

# Restart all instances
restart-all: down-all up-all

# Restart single instance
restart: down up

# View logs for all instances
logs:
	sudo docker compose logs -f

# List detected instances
list-instances:
	@echo "Detected .env files:"
	@for env_file in $(ENV_FILES); do \
		echo "  $$env_file"; \
	done

# Clean up everything, including images
clean:
	@for env_file in $(ENV_FILES); do \
		sudo docker compose --env-file $$env_file down --rmi all --volumes --remove-orphans; \
	done

# Update the base image and rebuild
update:
	sudo docker pull sbs20/scanservjs:latest
	make build
	make restart-all
