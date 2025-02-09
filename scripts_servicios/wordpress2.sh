
echo "
if(isset(\$_SERVER['HTTP_X_FORWARDED_FOR'])) {
    \$list = explode(',', \$_SERVER['HTTP_X_FORWARDED_FOR']);
    \$_SERVER['REMOTE_ADDR'] = \$list[0];
}
\$_SERVER['HTTP_HOST'] = 'nginxequipo45.duckdns.org';
\$_SERVER['REMOTE_ADDR'] = 'nginxequipo45.duckdns.org';
\$_SERVER['SERVER_ADDR'] = 'nginxequipo45.duckdns.org';
" | sudo tee -a /var/www/html/wp-config.php