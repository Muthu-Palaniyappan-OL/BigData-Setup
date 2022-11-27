# BigData-Setup

## Getting Started

Download latest version of [Ubuntu](https://releases.ubuntu.com/22.04.1/ubuntu-22.04.1-desktop-amd64.iso?_ga=2.262114509.1380062103.1669571995-365159036.1669571995)

Things to install before running main shell script
```sh
sudo apt install curl wget python3 python3-pip 
pip install requests
```

```sh
curl https://raw.githubusercontent.com/Muthu-Palaniyappan-OL/BigData-Setup/main/hadoop-setup.sh | bash
source ~/.bashrc
hdfs namenode -format
cd ~
wget https://raw.githubusercontent.com/Muthu-Palaniyappan-OL/BigData-Setup/main/script.py
wget https://raw.githubusercontent.com/Muthu-Palaniyappan-OL/BigData-Setup/main/agent1.properties
source ~/.bashrc
echo "export BEARER_TOKEN=<YourBearerToken>" >> ~/.bashrc
```

## Post Installation

```sh
start-all.sh
flume-ng agent --conf $FLUME_CONF -f agent1.conf -n agent1 -Dflume.root.logger=INFO,console
```
## Viewing Data

```sh
hdfs dfs -ls /
hdfs dfs -cat /FlumeData.1669570072323
```

## Stopping Hadoop

```sh
stop-all.sh
```
