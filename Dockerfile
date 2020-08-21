FROM ubuntu:20.04

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
		libcurl4-openssl-dev \
		libssl-dev \
		libopenblas-dev \
		libfreetype6-dev \
		libv8-dev

RUN apt-get install -y --no-install-recommends \
	    r-cran-askpass \
	    r-cran-base64enc \
	    r-cran-colorspace \
	    r-cran-commonmark \
	    r-cran-curl \
	    r-cran-htmltools \
	    r-cran-htmlwidgets \
	    r-cran-jsonlite \
	    r-cran-markdown \
	    r-cran-prettyunits \
	    r-cran-psychometric \
	    r-cran-rcolorbrewer \
	    r-cran-stringi \
	    r-cran-viridislite \
	    r-cran-xml2 \
	    r-cran-yaml

# Make sure python means python3
RUN apt-get install -y --no-install-recommends \
	python3 \
	python3-dev \
	python3-tk \
	python3-pip && \
    pip3 install --no-cache-dir --upgrade setuptools && \
	echo "alias python='python3'" >> /root/.bash_aliases && \
	echo "alias pip='pip3'" >> /root/.bash_aliases && \
	cd /usr/local/bin && ln -s /usr/bin/python3 python && \
	cd /usr/local/bin && ln -s /usr/bin/pip3 pip && \
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
