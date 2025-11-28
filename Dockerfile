# Use the lastest miniforge image to create the image base
FROM condaforge/miniforge3:latest

# Copy the conda lock file from the github repo and create a directory to create the conda-lock file
COPY conda-linux-64.lock conda-linux-64.lock

# setup conda-lock in Docker
RUN conda install -n base -c conda-forge conda-lock -y

# install packages from lockfile into DSCI_522_Assignment_2 environment
RUN conda-lock install -n DSCI_522_Assignment_2 conda-lock.yml --no-mamba

# # make DSCI_522_Assignment_2 the default environment
RUN echo "source /opt/conda/etc/profile.d/conda.sh && conda activate DSCI_522_Assignment_2" >> ~/.bashrc

# set the default shell to use bash with login to pick up bashrc
# this ensures that we are starting from an activated DSCI_522_Assignment_2 environment
SHELL ["/bin/bash", "-l", "-c"]

# expose JupyterLab port
EXPOSE 8888

# sets the default working directory
# this is also specified in the compose file
WORKDIR /workplace

# run JupyterLab on container start
# uses the jupyterlab from the install environment
CMD ["conda", "run", "--no-capture-output", "-n", "DSCI_522_Assignment_2", "jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--IdentityProvider.token=''", "--ServerApp.password=''"]