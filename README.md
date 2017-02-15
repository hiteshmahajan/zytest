# zytest

## Docker Assignment

> To build

```
docker build -t demo .
```
> To run docker

```
docker run -it --rm -p 7080:8080 demo
```
## SSH Assignemnt

> Command to run

```
python ssh.py username pathtokeyfile ip,ip,ip
```
> Output

```
hitesh.mahajan@lu-3nswh32:~ $ python ssh.py hitesh.mahajan /home/hitesh.mahajan/.ssh/id_rsa 10.42.101.58,10.42.101.53
> ls /tmp
10.42.101.58:

tmp8d9qqk
tmpItCLa8
tmpnWB9kB

10.42.101.53:

icinga.lock
salt
synapse.config
tmp8tomqA
tmpgOygJb
tmpLy5j3m
wn-5551

```

## Migration Assignment

#### Steps

* create infra on aws inside VPC with same no. instances and make sure to nearest AWS region to avoid high network latency
* Setup network connectivity between local DC and AWS
* Setup New apache web server and tomcat application server with multi AZ(same no. instance accross multiple zone) for HA.
* Create New Activemq Master-Slave setup with multipe AZ accros region.
* Setup Oracle Active-Active Databases with Data Guard between data center and AWS
* Create new mongo replica set on aws and start the server for now write only on local DC.
* Ensuring after no lag between server on aws and local DC and all the message are consumed on activemq we can proceed further.
* Deploy Application on new servers and start the application server and web server.
* After sanity check and performance tuning will update DNS entry to point to NEW ELB on AWS.
* If Using Akamai we can also distribute traffice between DC and AWS.
* Once we ensure Everthing is working fine we can cut over from local DC.
* After cut over setup ensure entire architecture is multi AZ for HA.

#### Services will be using on AWS.

* VPC , Direct connect if possible ( for private setup and low latency connectivity )
* EC2 : Instance, ELB, Autoscaling ( ELB with cross load balancing between multiple AZ )
* RDS ( For database )
* Cloudwatch ( For alarms ) 
* IAM ( For Access Management )
* DMS ( For Database management )
