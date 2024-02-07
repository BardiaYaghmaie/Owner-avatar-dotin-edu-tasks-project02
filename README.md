## Step 1
Configure an Nginx server on port 8888 and serve all files located at /var/lib/dotin/www/ directory.

## Step 2
Enable HTTPS on port 8443 for your Nginx and redirect all requests (even 8080 HTTP requests) to the HTTPS port.

## Step 3
Using a Firewall system (like ufw or iptables) block requests to all ports except 8443 port.

## Step 4
Dockerize your deployment. Do your firewall rules work after dockerizing? Explain your answer.
