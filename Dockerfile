FROM busybox:1.27

#VOLUME /etc/nginx/conf.d/
#VOLUME /var/www/

RUN mkdir /tmp/nginxconf && mkdir /tmp/html

COPY ./nginx/conf/ /tmp/nginxconf/
COPY ./html/ /tmp/html/