FROM nginx

WORKDIR /usr/share/nginx/html

RUN rm index.html

COPY . .

ARG portexp=8090
EXPOSE ${portexp}