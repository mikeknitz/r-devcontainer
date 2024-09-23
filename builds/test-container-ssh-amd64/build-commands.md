## Commands to create and push image

Point working directory to folder where `Dockerfile` and `build-scripts/` exist for this particular build:

``` bash
cd builds/test-container-ssh-amd64
```

Populate `build-scripts/` directory with subdirectories containing installation code for devcontainer features

``` bash
bash build-scripts/pull-build-scripts.sh
```

Build Docker image

``` bash
# replace `knitz` with your Docker Hub username
docker build -t knitz/test-container-ssh-amd64:latest .
```

Push to Docker Hub

``` bash
# replace `knitz` with your Docker Hub username
docker login
docker push knitz/test-container-ssh-amd64:latest
```

## Testing ssh functionality

Run as disposable container

``` bash
docker run -it --rm \
  -p 8200:22 \
  knitz/test-container-ssh-amd64:latest
```

sshd config in non-standard location

``` bash
mkdir ~/etc
chmod 700 ~/etc
cat > ~/etc/sshd_config <<EOF
Port 22
HostKey /home/ubuntu/etc/ssh_host_key
PidFile /home/ubuntu/etc/sshd.pid
PasswordAuthentication no
ChallengeResponseAuthentication no
GSSAPICleanupCredentials no
EOF
chmod 600 ~/etc/*
```

need a host key in the container for ssh host server

``` bash
# Using name ssh_host_key
# Move to ~/etc afterard
ssh-keygen -t rsa -b 4096
```

Add any authorized keys if necessary

``` bash
cd
mkdir ~/.ssh
chmod 700 .ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

cat > ~/.ssh/authorized_keys <<EOF
PUBLIC KEY HERE TO ALLOW ACCESS
EOF
```

Running the ssh server as the user in the container

``` bash
# -f = config file
# -D = "detach" i.e., use in foreground not as daemon
# -p = override the port specified in the config
# The default config location is /etc/ssh/sshd_config, but we specify
  # in this command to use a custom config instead
# We are allow starting it here as the user instead of root, etc.
/usr/sbin/sshd \
  -f ~/etc/sshd_config \
  -D \
  -p 22
```

Connect from outside the container as the user running the server inside the container

``` bash
# Connect with ssh using the specified port
# Here using localhost since this example connecting to docker
  # container running on the local machine
ssh -i <key> -p <port> user@localhost
```
