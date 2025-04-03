# Exercise 1

### The following tasks should be performed from within a Docker container. 

Since i use linux, docker desktop  asked me to set the "pass" credential; i followed the steps from the docs: https://docs.docker.com/desktop/setup/sign-in/#signing-in-with-docker-desktop-for-linux to generate the gpg key, initialize the pass with pass init, create a password store for it 

Download and install Docker Desktop, then from terminal run an Ubuntu container: 

  docker run -it ubuntu

ran it as is - creates a docker container with the specified image/OS, in interactive mode


### Lookup the Public IP of cloudflare.com

the pulled image is minimal, so we have to install a tool that can test the reachability of a host; we have at least 4 options (https://linuxhandbook.com/find-website-ip-address-linux/)
install ping using "apt-get install -y iputils-ping command" (insert image)  (https://tecadmin.net/resolved-bash-ping-command-not-found-error/)
running "ping cloudflare.com" returns an address, but then is idle;
install another tool to check the address: apt-get install dnsutils -y  , used -y to automatically say yes to install prompts (https://www.curiouslychase.com/posts/install-dig-and-nslookup-dependencies-on-docker-containers#install-dig-and-nslookup-on-ubuntu-debian)
now that we have dnsutils, we can use "dig cloudflare.com" https://www.tecmint.com/install-dig-and-nslookup-in-linux/ to check the address again (insert images here)
we see that we get 104.16.132.229 and  104.16.133.229


### Map IP address 8.8.8.8 to hostname google-dns

CHALLENGE: trying to understand the dns mapping 

(https://developers.google.com/speed/public-dns/docs/using)

(https://yuminlee2.medium.com/linux-networking-dns-7ff534113f7d)

local mapping between googgle's public dns ip (8.8.8.8) and the hostname google-dns
it needs a (static) entry in the /etc/hosts file
to edit /etc/hots, we run "nano /etc/hosts"
nano is not installed, so we install nano
run "apt-get install nano -y" 
then we can proceed by editing the entries: "nano /etc/hosts
", then adding the line "8.8.8.8 google-dns" to map the address to the hostname; ctr+o to write, Enter to save, ctr+x to exit, "cat /etc/hosts" to show the file contents and verify the update
test with ping, dig and nslookup and we get "PING google-dns (8.8.8.8) 56(84) bytes of data."; (ping fails as before yet the single line shown is the desired address); nslookup and dig don't recognize the local mapping;

### Check if the DNS Port is Open for google-dns

DNS port is port 53
for port checking we need other tools, like nmap
we intall nmap first: "sudo apt install nmap"
(https://phoenixnap.com/kb/nmap-scan-open-ports) we run the command "nmap -p 53 google-dns" (looks for port 53 on the specified target address/host, and use the hostname and not the ip address so we can check if it resolves to the mapped address)
(insert image) -  port is confirmed as open

### Modify the System to Use Google’s Public DNS

Change the nameserver to 8.8.8.8 instead of the default local configuration. (https://yuminlee2.medium.com/linux-networking-dns-7ff534113f7d)  there's a config file named resolv.conf that handles the DNS settings; we can inspect it by running "cat /etc/resolv.conf" ->root@2c51f79ce470:/# cat /etc/resolv.conf
 DNS requests are forwarded to the host. DHCP DNS options are ignored.
nameserver 192.168.65.5; edit with nano: "nano /etc/resolv.conf" -> "root@2c51f79ce470:/# cat /etc/resolv.conf DNS requests are forwarded to the host. DHCP DNS options are ignored.

#nameserver 192.168.65.5  nameserver 8.8.8.8"
resolv.conf changes are tmeporay, restatring the os reverts the file changes
Perform another public IP lookup for cloudflare.com and compare the results. -> insert img; now the second lookup has the 8.8.8.8 server/address;


### Install and verify that Nginx service is running

https://www.digitalocean.com/community/tutorials/how-to-run-nginx-in-a-docker-container-on-ubuntu-22-04
https://www.tecmint.com/change-nginx-port-in-linux/
since docker is modular, we could install nginx in the current container running ubuntu, or as a separate container
in the current os: "apt install -y nginx" - nginx installation
(https://stackoverflow.com/questions/35220654/how-to-verify-if-nginx-is-running-or-not) start and check running: root@2c51f79ce470:/# service nginx start

Starting nginx nginx [ OK ] root@2c51f79ce470:/# service nginx status
nginx is running

### Find the Listening Port for Nginx

we can search inside the conf files to see the default assigned port; first I tried  to search inside the config file"cat /etc/nginx/nginx.conf", but there s no useful info here; then, in the default html testing page "cat nano /etc/nginx/sites-enabled/default" the port is 80; (insert page); by using "nmap 127.0.0.1"  we can see what ports are opened for the localhost, an port 80 is also found here

### Bonus

we saw previously that the default listening port for nginx in 80 found inside the "etc/nginx/sites-enabled/default" file; we can change the values from there; i had a syntax error while changing the port values; edit the wring value with nano again; then restart; restart nginx with "service nginx restart"; check the port again:  "root@2c51f79ce470:/# nmap 127.0.0.1 Starting Nmap 7.94SVN ( https://nmap.org ) at 2025-04-03 14:58 EEST Nmap scan report for localhost (127.0.0.1) Host is up (0.0000070s latency). Not shown: 999 closed tcp ports (reset) PORT STATE SERVICE 8080/tcp open http-proxy

Nmap done: 1 IP address (1 host up) scanned in 0.09 seconds"
in the "etc/nginx/sites-enabled/default" file there are the default html files that come with the server: "root /var/www/html;" if we display the directory cntents there's a default debian file.html: "root@2c51f79ce470:/# ls /var/www/html/  -> index.nginx-debian.html"
