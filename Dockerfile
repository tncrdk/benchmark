# Dockerfile
FROM ubuntu:24.04

# Set environment variables for non-interactive installs
# ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies (from your build_scripts/ or notes)
RUN apt-get update
# RUN apt-get update --snapshot 20231102T030400Z
RUN apt-get install hello --snapshot 20231102T030400Z
RUN apt-get install -y --snapshot 20240410T203634Z \
        cmake \
        g++ \
        gfortran \
        git \
        curl \
        python3 \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Switch to new user
USER ubuntu
WORKDIR /home/ubuntu/Code

# Create volumes for IFEM and experiment
VOLUME /home/ubuntu/Code/benchmark
VOLUME /home/ubuntu/Code/disk
VOLUME /home/ubuntu/Code/memory
VOLUME /home/ubuntu/Code/arithmetic
VOLUME /home/ubuntu/Code/parallel

# Keep the container running
CMD ["bash"]
