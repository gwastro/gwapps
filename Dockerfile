FROM ubuntu:rolling
USER root

# Install some Debian package
RUN apt-get update && apt-get install -y --no-install-recommends \
    python-setuptools     \
    python-wheel          \
    python-pip            \
    python-dev            \
    less                  \
    nano                  \
    sudo                  \
    git                   \
    npm                   \
    fftw3                 \
    build-essential \
    autoconf \
    libtool \
    pkg-config \
  && rm -rf /var/lib/apt/lists/*

# install Jupyter via pip
RUN pip2 install notebook

# install my other stuff
RUN pip2 install lalsuite pycbc appmodes

# install ipywidgets
RUN pip2 install ipywidgets  && \
    jupyter nbextension enable --sys-prefix --py widgetsnbextension

# install Appmode
COPY . /opt/appmode
WORKDIR /opt/appmode/
RUN jupyter nbextension     enable --py --sys-prefix appmode && \
    jupyter serverextension enable --py --sys-prefix appmode

# Possible Customizations
# RUN mkdir -p ~/.jupyter/custom/                                          && \
#     echo "\$('#appmode-leave').hide();" >> ~/.jupyter/custom/custom.js   && \
#     echo "\$('#appmode-busy').hide();"  >> ~/.jupyter/custom/custom.js   && \
#     echo "\$('#appmode-loader').append('<h2>Loading...</h2>');" >> ~/.jupyter/custom/custom.js

# Launch Notebook server
EXPOSE 8888
CMD ["jupyter-notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser", "--NotebookApp.token=''"]

#EOF
