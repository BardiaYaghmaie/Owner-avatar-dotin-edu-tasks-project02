# Problem
## Step 1
Configure an Nginx server on port 8888 and serve all files located at /var/lib/dotin/www/ directory.

## Step 2
Enable HTTPS on port 8443 for your Nginx and redirect all requests (even 8888 HTTP requests) to the HTTPS port.

## Step 3
Using a Firewall system (like ufw or iptables) block requests to all ports except 8443 port.

## Step 4
Dockerize your deployment. Do your firewall rules work after dockerizing? Explain your answer.

-------

# Solution

## Step 1
1- install nginx via apt repository

2- create a file named pr02.conf at "/etc/nginx/conf.d/pr02.conf"

3- pr02.conf
```
server {
    listen 8888;
    server_name localhost;
   
    location /  {
       alias /var/lib/dotin/www/;
       autoindex on;
       #index index.html;
    }
}
```
4- access dir via localhost:8888

## Step 2
1- generate cert.pem and key.pem with openssl
```
sudo openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"
```

2- put these 2 pem files in /etc/nginx/certs/

3- change the pr02.conf file to apply SSL and to handle rediraction

pr02.conf
```
server {
    listen 8443 ssl;
    server_name localhost;

    ssl_certificate /etc/nginx/certs/cert.pem;
    ssl_certificate_key /etc/nginx/certs/key.pem;

    location /  {
       alias /var/lib/dotin/www/;
       autoindex on;
       #index index.html;
    }
}

server {
    listen 8888;
    server_name localhost;

    return 301 https://$host:8443$request_uri;

}
```

4- try to access localhost:8888 and see that is redirected to 8443

## Step 3
To use a firewall system to block requests to all ports except 8443, follow these steps:


1- install ufw:
```
sudo apt-get install ufw
```

2- allow incoming traffic on port 8443:
```
sudo ufw allow 8443
```

3- block all other ports:
```
sudo ufw default deny incoming
```

4- enable the firewall:
```
sudo ufw enable
```

## Step 4
1- create a dockerfile for nginx project

Dockerfile
```
FROM nginx:latest

COPY project02.conf /etc/nginx/conf.d/project02.conf
COPY ./certs/cert.pem /etc/nginx/certs/cert.pem
COPY ./certs/key.pem /etc/nginx/certs/key.pem

EXPOSE 8443

CMD ["nginx", "-g", "daemon off;"]
```

2- build the image
```
docker build -t nginx-project02 .
```

3- run a container from the image
```
docker run --name nginx-project02 -d -p 8446:8443 nginx-project02
```

4- access the web server via ```localhost:8446```