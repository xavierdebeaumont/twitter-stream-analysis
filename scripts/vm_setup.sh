echo "Installed conda version..."
conda --version

echo "Running sudo apt-get update..."
sudo apt-get update

echo "Installing Docker..."
sudo apt-get -y install docker.io

echo "Docker without sudo setup..."
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo service docker restart

echo "Installing docker-compose..."
cd 
mkdir -p bin
cd bin
wget https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -O docker-compose
sudo chmod +x docker-compose

echo "Setup .bashrc..."
echo '' >> ~/.bashrc
echo 'export PATH=${HOME}/bin:${PATH}' >> ~/.bashrc
eval "$(cat ~/.bashrc | tail -n +10)" # A hack because source .bashrc doesn't work inside the script

echo "docker-compose version..."
docker-compose --version
