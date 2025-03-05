FROM ubuntu:22.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables for headless mode
ENV DISPLAY=:99
ENV XDG_RUNTIME_DIR=/tmp/runtime-dir

# Install dependencies and SSH server
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    python3 \
    python3-pip \
    git \
    openssh-server \
    sudo \
    libx11-dev \
    libxcursor-dev \
    libxinerama-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libasound2-dev \
    libpulse-dev \
    libudev-dev \
    libxi-dev \
    libxrandr-dev \
    libwayland-dev \
    libwayland-client0 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user with sudo privileges and no password
RUN useradd -m vscode -s /bin/bash \
    && passwd -d vscode \
    && adduser vscode sudo \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configure SSH server for empty password authentication
RUN mkdir -p /var/run/sshd
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitEmptyPasswords yes' >> /etc/ssh/sshd_config
RUN sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Configure vscode user for SSH access with empty password
RUN passwd -d vscode && \
    mkdir -p /etc/sudoers.d && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode && \
    chmod 0440 /etc/sudoers.d/vscode

# Create XDG_RUNTIME_DIR and set permissions
RUN mkdir -p /tmp/runtime-dir && chmod 700 /tmp/runtime-dir

# Install Godot
RUN wget https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_linux.x86_64.zip \
    && unzip Godot_v4.3-stable_linux.x86_64.zip \
    && mv Godot_v4.3-stable_linux.x86_64 /usr/local/bin/godot \
    && chmod +x /usr/local/bin/godot \
    && rm Godot_v4.3-stable_linux.x86_64.zip

# Install Godot export templates
RUN mkdir -p /root/.local/share/godot/export_templates/4.3.stable/ \
    && wget https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_export_templates.tpz \
    && unzip Godot_v4.3-stable_export_templates.tpz -d /tmp \
    && mv /tmp/templates/* /root/.local/share/godot/export_templates/4.3.stable/ \
    && rm Godot_v4.3-stable_export_templates.tpz

# Install gdtoolkit for linting
RUN pip3 install gdtoolkit

# Create Godot directories for the vscode user
RUN mkdir -p /home/vscode/.local/share/godot/export_templates/4.3.stable/ \
    && cp -r /root/.local/share/godot/export_templates/4.3.stable/* /home/vscode/.local/share/godot/export_templates/4.3.stable/ \
    && chown -R vscode:vscode /home/vscode/.local

# Generate SSH host keys
RUN ssh-keygen -A

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]

# Set working directory
WORKDIR /workspace

# Add environment variables to vscode user's profile
RUN echo 'export DISPLAY=:99' >> /home/vscode/.bashrc \
    && echo 'export XDG_RUNTIME_DIR=/tmp/runtime-dir' >> /home/vscode/.bashrc \
    && mkdir -p /tmp/runtime-dir \
    && chmod 700 /tmp/runtime-dir \
    && chown -R vscode:vscode /tmp/runtime-dir

# Switch to the vscode user
USER vscode
