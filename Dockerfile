FROM nginx

WORKDIR /usr/share/nginx/html

COPY . .

ARG portexp=8090
EXPOSE ${portexp}