FROM alpine:latest
MAINTAINER Raj Gaire <raj.gaire@data61.csiro.au>

# Install glibc and useful packages
RUN echo "@testing http://nl.alpinelinux.org/alpine/latest-stable/main" >> /etc/apk/repositories \
    && apk --update add \
    bash \
    curl \
    ca-certificates \
    libstdc++ \
    glib \
    libxext \
    libxrender \
    && curl "https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub" -o /etc/apk/keys/sgerrand.rsa.pub \
    && apk --no-cache add ca-certificates wget \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk \
    && apk add glibc-2.29-r0.apk \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-bin-2.29-r0.apk \
    && apk add glibc-bin-2.29-r0.apk \
    && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc/usr/lib \
    && rm -rf glibc*apk /var/cache/apk/*

# Create nbuser user with UID=1000 and in the 'users' group
RUN mkdir -p /opt/conda && \
    curl -L https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  -o miniconda.sh && \
    /bin/bash miniconda.sh -f -b -p /opt/conda && \
    rm miniconda.sh && \
    /opt/conda/bin/conda install --yes conda && \
    ln -s /opt/conda/bin/conda /usr/bin/conda 


RUN conda create -n tensorflow_env tensorflow

ENV PATH /opt/conda/envs/tensorflow_env/bin:$PATH



RUN conda install -n tensorflow_env --yes scikit-learn scipy pandas matplotlib keras Pillow && \
    conda clean --yes --all && \
    rm -rf /var/cache/apk/*

RUN conda init bash
RUN cat ~/.bashrc
RUN source ~/.bashrc

RUN echo "conda activate tensorflow_env" >> ~/.bashrc

