FROM sbs20/scanservjs:latest

# Install rclone
RUN apt-get update && \
    apt-get install -y curl unzip && \
    curl https://rclone.org/install.sh | bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create rclone config directory
RUN mkdir -p /var/lib/scanservjs/.config/rclone
