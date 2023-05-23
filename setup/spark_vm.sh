echo "Downloading Java"
cd ~
mkdir spark
cd spark
wget https://download.java.net/java/GA/jdk20.0.1/b4887098932d415489976708ad6d1a4b/9/GPL/openjdk-20.0.1_linux-aarch64_bin.tar.gz

echo "Extracting Java"
tar xzfv openjdk-20.0.1_linux-aarch64_bin.tar.gz

echo "Exporting Java path..."
echo '' >> ~/.bashrc
echo 'export JAVA_HOME="${HOME}/spark/jdk20.0.1"' >> ~/.bashrc
echo 'export PATH="${JAVA_HOME}/bin:${PATH}"' >> ~/.bashrc

echo "Installed Java version is.."
java --version

rm openjdk-20.0.1_linux-aarch64_bin.tar.gz

echo "Download Spark"
cd 
