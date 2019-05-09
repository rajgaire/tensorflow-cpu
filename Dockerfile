FROM continuumio/anaconda3
MAINTAINER Raj Gaire <raj.gaire@data61.csiro.au>

RUN conda create -n tensorflow_env tensorflow

ENV PATH /opt/conda/envs/tensorflow_env/bin:$PATH

RUN conda install -n tensorflow_env --yes scikit-learn scipy pandas matplotlib keras Pillow && \
    conda clean --yes --all && \
    rm -rf /var/cache/apk/*

RUN conda init bash
RUN source ~/.bashrc
RUN echo "conda activate tensorflow_env" >> ~/.bashrc
