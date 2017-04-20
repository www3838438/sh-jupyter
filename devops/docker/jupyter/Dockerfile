FROM debian:jessie

MAINTAINER sh jupyter <huazhou19@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN REPO=http://cdn-fastly.deb.debian.org && \
    echo "deb $REPO/debian jessie main\ndeb $REPO/debian-security jessie/updates main" > /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install wget locales git bzip2 &&\
    /usr/sbin/update-locale LANG=C.UTF-8 && \
    locale-gen C.UTF-8 && \
    apt-get remove -y locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    ENV LANG C.UTF-8

RUN wget -q https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh -O /tmp/miniconda.sh  && \
    echo 'd0c7c71cc5659e54ab51f2005a8d96f3 */tmp/miniconda.sh' | md5sum -c - && \
    bash /tmp/miniconda.sh -f -b -p /opt/conda && \
    /opt/conda/bin/conda install --yes python=3.5 pip ipykernel jupyter notebook && \
    /opt/conda/bin/pip install --upgrade pip && \
    rm /tmp/miniconda.sh && \
    /opt/conda/bin/conda clean --yes --all

ENV PATH=/opt/conda/bin:$PATH NOTEBOOKS_PATH=/notebooks
WORKDIR ${NOTEBOOKS_PATH}

RUN conda install --yes numpy pandas  matplotlib scikit-learn bokeh && \
    conda clean --yes --all

EXPOSE 8888

CMD jupyter-notebook --allow-root --no-browser --ip=0.0.0.0 --notebook-dir=${NOTEBOOKS_PATH}

