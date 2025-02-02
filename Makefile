# Define variables
IMAGE_NAME = sbs20/scanservjs:latest
CUSTOM_IMAGE_NAME = my-scanservjs:latest

.PHONY: all build clean run

# Build the custom image with rclone
build:
	@echo "Building custom image with rclone..."
	@docker build -t $(CUSTOM_IMAGE_NAME) -f- . <<EOF
	FROM $(IMAGE_NAME)
	
	# Install rclone
	RUN apt-get update && \
	    apt-get install -y curl unzip && \
	    curl https://rclone.org/install.sh | bash && \
	    apt-get clean && \
	    rm -rf /var/lib/apt/lists/*
	
	# Create rclone config directory
	RUN mkdir -p /root/.config/rclone
	EOF

# Run the container with scanner access
run:
	docker-compose up -d

# Stop and remove containers
clean:
	docker-compose down
	docker rmi $(CUSTOM_IMAGE_NAME)

# Default target
all: build run
