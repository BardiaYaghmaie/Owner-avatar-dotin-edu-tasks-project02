FROM nginx:latest

COPY project02.conf /etc/nginx/conf.d/project02.conf
COPY ./certs/cert.pem /etc/nginx/certs/cert.pem
COPY ./certs/key.pem /etc/nginx/certs/key.pem

EXPOSE 8443

CMD ["nginx", "-g", "daemon off;"]

