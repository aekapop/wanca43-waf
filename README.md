# wanca43-waf
WAF with Ubuntu 22.04LTS Nginx + Modsecucrity + CRS for WUNCA43 Training

## Use lab
- install docker for desktop in your laptop 
- clone this repository
- docker-compose up
- can use for test working WAF at http://localhost:8080
- can use for test non-working at http://localhost
## Install on VM
- Install Ubuntu 22.04 LTS 
- clone this repository
- cd vminstall
- edit nginx.conf at proxy_pass http://ip-or-domain-your-web-site/; 
- sudo ./instalwaf.sh
- test
- and change domain to this vm
## Install with docker
 - install dockerce on ubuntu 22.04 LTS with this ref https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04
 - install docker compose with this ref https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04
 - use docker-compose.yml and remove dvwa all service and edit BACKEND to your ip or domain 
 - docker-compse up -d
 - test
- and change domain to this vm