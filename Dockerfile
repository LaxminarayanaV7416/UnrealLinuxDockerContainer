# Use the NVIDIA base image with CUDA support
FROM nvidia/cuda:12.2.0-base-ubuntu22.04

# Install essential packages
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    wget \
    git \
    cmake \
    clang \
    libvulkan-dev \
    libx11-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxi-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libsdl2-dev \
    unzip \
    curl \
    python3 \
    python3-pip \
    && apt-get clean

RUN apt-get install -y wget tar
RUN wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | tee /etc/apt/trusted.gpg.d/lunarg.asc
RUN wget -qO /etc/apt/sources.list.d/lunarg-vulkan-1.3.290-jammy.list https://packages.lunarg.com/vulkan/1.3.290/lunarg-vulkan-1.3.290-jammy.list

RUN apt-get update

ENV NVARCH x86_64

# Install NVIDIA drivers and Vulkan SDK
RUN apt-get update && \
    apt-get install -y \
    vulkan-tools \
    vulkan-utils \
    && apt-get clean

ENV NVIDIA_VISIBLE_DEVICES all

ENV LD_LIBRARY "/usr/local/nvidia/lib:/usr/local/nvidia/lib64"

ENV NVIDIA_DRIVER_CAPABILITIES "graphics,compat32,utility,compute,display,video"

# ENV SDL_VIDEODRIVER=offscreen
# ENV SDL_HEADLESS=1

# COPY /usr/share/vulkan/icd.d/nvidia_icd.json /etc/vulkan/icd.d/

# COPY ./nvidia_icd.json /etc/vulkan/icd.d/

# RUN Xvfb :99 -screen 0 1024x768x24 &

# ENV DISPLAY=:99

WORKDIR /myGame

# Create a new user
RUN useradd -m -s /bin/bash myuser

COPY --chown=myuser:myuser . .

RUN chmod +rwx ./SADE_drone_rep.sh

# Switch to the new user
USER myuser

CMD ["./SADE_drone_rep.sh", "-AudioMixer", "-PixelStreamingIP=0.0.0.0", "-PixelStreamingPort=8888", "-RenderOffScreen"]