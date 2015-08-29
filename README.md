== README

Run this cmd, and import all data using SQL
```
rake db:drop; rake db:create; rake db:migrate VERSION=20150131150856
```

revise the database.yml and run:
```
rake db:create RAILS_ENV=production
```

run `rake secret`, the revise the belowed file
```
secrets.yml
```

if GemNotFound
remove the `.ruby-version` and `.ruby-gemset` and reboot the system
then bundle it again.

whenever issue
A solution is to disable the prompt by adding this line to your user rvm file in ~/.rvmrc
```
rvm_trust_rvmrcs_flag=1
```
### phpmyadmin config
```
sudo apt-get -y install php5-cli php5-common php5-fpm mysql-server mysql-common mysql-client libmysqlclient-dev php5-mysql
```
sudo vim /etc/php5/fpm/php.ini
change `cgi.fix_pathinfo = 0`
sudo vim /etc/php5/fpm/pool.d/www.conf 
uncomment `listen.mode = 0660`
```
echo "<?php phpinfo(); ?>" | sudo tee -a /opt/nginx/html/phpinfo.php
```
download phpmyadmin, extract the files and move to `/opt/nginx/html`
change the owner
```
cd /opt/nginx/html/
sudo chown -R tb:www-data phpmyadmin/
```
rename config.inc.php, 
and change auth_type from `cookie` to `config`, 
the AllowNoPassword from false to true
```
mv config.sample.inc.php /opt/nginx/html/phpmyadmin/config.inc.php
```
change nginx config
```
user  www-data;
        location ~ \.php$ {
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            # NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
            # With php5-cgi alone:
            #fastcgi_pass 127.0.0.1:9000;
            # With php5-fpm:
            fastcgi_pass unix:/var/run/php5-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include fastcgi_params;
        }

         location /phpmyadmin {
           index index.php;
        }
```
restart
```
sudo service php5-fpm restart
sudo service nginx restart
```