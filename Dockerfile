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

# Make sure to trust the notebooks we have to explicitly do the copying ourselves
WORKDIR $HOME
#RUN git clone git://github.com/https://github.com/neural-reckoning/vcn_regularity.git
COPY *.ipynb ./
RUN mkdir notebooks
RUN mv *.ipynb notebooks
USER root
RUN chown -R main:main $HOME/notebooks
USER main
RUN find ./notebooks -name '*.ipynb' -exec jupyter trust {} \;

# Fix matplotlib font cache
RUN rm -rf /home/main/.matplolib
RUN rm -rf /home/main/.cache/matplolib
RUN rm -rf /home/main/.cache/fontconfig
RUN python -c "import matplotlib.pyplot as plt"

# Trust the notebooks
#RUN jupyter trust /home/main/notebooks/basic_model.ipynb
#RUN jupyter trust /home/main/notebooks/index.ipynb
#RUN jupyter trust /home/main/notebooks/deafferentation.ipynb
#RUN jupyter trust /home/main/notebooks/basic_model.ipynb
#RUN jupyter trust /home/main/notebooks/level_dependence_density.ipynb
#RUN jupyter trust /home/main/notebooks/maps.ipynb
RUN jupyter nbextension enable --py widgetsnbextension