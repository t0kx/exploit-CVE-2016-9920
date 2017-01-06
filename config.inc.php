<?php

$config = array();
$config['db_dsnw'] = 'sqlite:////var/www/html/roundcube/sqlite.db';
$config['default_host'] = 'localhost';
$config['smtp_server'] = '';
$config['smtp_port'] = 25;
$config['smtp_user'] = '';
$config['smtp_pass'] = '';
$config['product_name'] = 'Roundcube Webmail';
$config['plugins'] = array(
    'archive',
    'zipdownload',
);
$config['skin'] = 'larry';

