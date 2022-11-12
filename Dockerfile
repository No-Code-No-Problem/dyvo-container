FROM continuumio/miniconda3

# SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND noninteractive\
    SHELL=/bin/bash

RUN apt-get update --yes && \
    apt-get upgrade --yes && \
    apt install --yes --no-install-recommends \
    git \
    fonts-dejavu-core \
    pip \
    curl \
    nano \
    jq \
    gnupg2 \
    ffmpeg \
    libsm6 \
    libxext6 \
    openssh-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub

ADD env-automatic.yaml /
ADD env-ldm.yaml /
RUN conda update -n base -c defaults conda && \
    conda env create -f env-ldm.yaml && \
    conda env create -f env-automatic.yaml && \
    conda clean --all --yes

ADD start.sh /
RUN chmod +x /start.sh
CMD [ "/start.sh" ]