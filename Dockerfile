# Use the jupyter minimal notebook to create the image base
FROM quay.io/jupyter/minimal-notebook:afe30f0c9ad8

# Copy the conda lock file from the github repo and create a directory to create the conda-lock file
COPY conda-linux-64.lock conda-linux-64.lock

# setup conda-lock in Docker
RUN conda install -n base -c conda-forge conda-lock -y

# install packages from lockfile into dockerlock environment
RUN conda-lock install -n dockerlock conda-lock.yml

# # make dockerlock the default environment
RUN echo "source /opt/conda/etc/profile.d/conda.sh && conda activate dockerlock" >> ~/.bashrc

# set the default shell to use bash with login to pick up bashrc
# this ensures that we are starting from an activated dockerlock environment
SHELL ["/bin/bash", "-l", "-c"]

# expose JupyterLab port
EXPOSE 8888

# sets the default working directory
# this is also specified in the compose file
WORKDIR /workplace

# run JupyterLab on container start
# uses the jupyterlab from the install environment
CMD ["conda", "run", "--no-capture-output", "-n", "dockerlock", "jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--IdentityProvider.token=''", "--ServerApp.password=''"]