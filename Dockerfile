FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    tar \
    libgsl-dev \
    libfftw3-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt

# Copy GROMACS tarball into the container
RUN wget https://ftp.gromacs.org/gromacs/gromacs-2025.2.tar.gz

# Extract and build GROMACS
RUN tar xfz gromacs-2025.2.tar.gz && \
    mkdir gromacs-2025.2/build && \
    cd gromacs-2025.2/build && \
    cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON && \
    make -j$(nproc) && \
    make check && \
    make install

# Add GROMACS binaries to PATH permanently
ENV PATH="/usr/local/gromacs/bin:${PATH}"

# Set default command
CMD ["bash"]
