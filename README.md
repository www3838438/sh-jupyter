## Get Start - Deploy jupyter as simple as possible

* clone this project then `cd` to sh-jupyter
* __before__ execute manager.sh you should `vim devops/nginx-data/confs/jupyter.conf` and config your jupyter web site 
* sh manager.sh init [your name] - like sh manager.sh huazhou
* sh manager.sh build - you should build jupyter images at the first time. Dockerfile is in devops/jupyter 
* sh manager.sh run - run nginx and jupyter docker
* sh manager.sh clean - clean enviroment when you remove this jupyter web site
