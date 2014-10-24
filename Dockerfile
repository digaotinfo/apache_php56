FROM debian:wheezy

ADD run.sh /run.sh
RUN apt-get update -q && \
apt-get install apache2 wget curl -yq && \
echo "deb http://packages.dotdeb.org wheezy all" >> /etc/apt/sources.list && \
echo "deb-src http://packages.dotdeb.org wheezy all" >> /etc/apt/sources.list && \
echo "deb http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list && \
echo "deb-src http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list && \
wget http://www.dotdeb.org/dotdeb.gpg && \
apt-key add dotdeb.gpg && \
apt-get update -q && \
apt-get install -yq php5 php5-mysql && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/www/* && \
sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini && \
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
chmod 755 /*.sh && \
mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html && \
a2enmod php5 rewrite 

# Add application code onbuild
ONBUILD RUN rm -fr /app
ONBUILD ADD . /app
ONBUILD RUN chown www-data:www-data /app -R

EXPOSE 80
WORKDIR /app
CMD ["/run.sh"]