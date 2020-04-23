FROM ubuntu:18.04

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
	apt-get remove -y python && \
	apt-get install -y --no-install-recommends \
		git \
		build-essential \
		r-base \
		r-base-dev \
		latexmk \
		texlive-latex-extra \
		libopenmpi-dev \
		liblzma-dev \
		libgit2-dev \
		libxml2-dev \
		libcurl4=7.58.0-2ubuntu3.8 \
		libcurl4-openssl-dev \
		libcurl4-gnutls-dev \
		libssl-dev \
		libopenblas-dev


# Make sure python means python3
RUN apt-get install -y --no-install-recommends \
	python3 \
	python3-dev \
	python3-tk \
	python3-pip && \
    pip3 install --no-cache-dir --upgrade pip setuptools && \
	echo "alias python='python3'" >> /root/.bash_aliases && \
	echo "alias pip='pip3'" >> /root/.bash_aliases && \
	cd /usr/local/bin && ln -s /usr/bin/python3 python && \
    pip install virtualenv abed

# Set the default shell to bash
RUN mv /bin/sh /bin/sh.old && cp /bin/bash /bin/sh

# Clone the dataset repo
RUN git clone https://github.com/alan-turing-institute/TCPD

# Build the dataset
RUN cd TCPD && make export

# Clone the repo
RUN git clone --recurse-submodules https://github.com/alan-turing-institute/TCPDBench

# Copy the datasets into the benchmark dir
RUN mkdir -p /TCPDBench/datasets && cp TCPD/export/*.json /TCPDBench/datasets/

# Install Python dependencies
RUN pip install -r /TCPDBench/analysis/requirements.txt

# Set the working directory
WORKDIR TCPDBench
