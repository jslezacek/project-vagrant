Vagrant file to setup a 3 host environment: system, framework and ci. 
ci is the continuous integration server running jenkins.

setup.sh - optional, if you want have private git server on ci jenkins box.

Dependencies: VirtualBox, vagrant
vagrant up --provider virtualbox

./kafka-topics.sh --create --zookeeper framework:2181 --replication-factor 1 --partitions 1 --topic measurements
./kafka-topics.sh --zookeeper framework:2181 --alter --topic measurements --config retention.ms=1000
