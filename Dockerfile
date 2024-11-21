FROM ubuntu:23.10

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nodejs \
    npm \
    python3 \
    python3-pip \
    wget \
    apparmor \
    apparmor-utils \
    fuse \
    libfuse2 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set up AppArmor profile for Cursor
RUN mkdir -p /etc/apparmor.d
COPY cursor-apparmor /etc/apparmor.d/cursor-appimage

# Parse and load AppArmor profile
RUN apparmor_parser -r /etc/apparmor.d/cursor-appimage

# Create necessary directories
RUN mkdir -p /home/user/Applications

# Install Cursor AppImage
WORKDIR /home/user/Applications
RUN curl -L "https://download.cursor.sh/linux/appimage" -o cursor.AppImage \
    && chmod +x cursor.AppImage

# Install Daytona dependencies
RUN curl -fsSL https://get.daytona.io | bash

# Configure Daytona workspace provider
WORKDIR /app
COPY workspace-config.json /etc/daytona/workspace-config.json

# Set up IDE integration
RUN mkdir -p /etc/daytona/extensions
COPY cursor-extension.json /etc/daytona/extensions/

# Authentication setup
ENV DAYTONA_AUTH_METHOD=oauth
ENV DAYTONA_AUTH_PROVIDER=github

# Git provider configuration
ENV DAYTONA_GIT_PROVIDER=github

# Expose necessary ports
EXPOSE 8080
EXPOSE 3000

# Start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]