FROM andrewosh/binder-base

USER main

RUN conda config --add channels brian-team
RUN conda install --quiet --yes \
    pip \
    sphinx \
    coverage \
    'matplotlib=1.5*' \
    'cython=0.23*' \
    'nose=1.3*' \
    'brian2' \
    'brian2tools' \
    'joblib'

# Install and configure nbextensions
RUN conda install --quiet --yes -c conda-forge jupyter_contrib_nbextensions
RUN jupyter nbextension enable init_cell/main
RUN jupyter nbextension enable hide_input_all/main

# Fix matplotlib font cache
RUN rm -rf /home/main/.matplolib
RUN rm -rf /home/main/.cache/matplolib
RUN rm -rf /home/main/.cache/fontconfig
RUN python -c "import matplotlib.pyplot as plt"

