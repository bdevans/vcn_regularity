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
RUN conda install -c conda-forge ipywidgets
RUN jupyter nbextension enable --py widgetsnbextension

# Make sure to trust the notebooks we have to explicitly do the copying ourselves
WORKDIR $HOME
COPY *.ipynb ./
RUN mkdir notebooks
RUN mv *.ipynb notebooks
USER root
RUN chown -R main:main $HOME/notebooks
USER main
# And now we actually do the trusting step
RUN find ./notebooks -name '*.ipynb' -exec jupyter trust {} \;

# Fix matplotlib font cache
RUN rm -rf /home/main/.matplolib
RUN rm -rf /home/main/.cache/matplolib
RUN rm -rf /home/main/.cache/fontconfig
RUN python -c "import matplotlib.pyplot as plt"
