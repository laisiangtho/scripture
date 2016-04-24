<?php
session_start();
$config['DefaultTemplate'] = 'template/classic/';
// LOCALHOST
// $config['www'] = 'http://laisiangtho.localhost/';
// $config['path'] = 'http://laisiangtho.localhost/';
// $config['QueryExtract'] = 1;
// $db_host = "localhost";
// $db_username = "root";
// $db_password = "search";
// $databse_name = "laisiangtho";
// $config['prefix'] = 'laisiangtho_';

// LIVE
$config['www'] = 'http://www.laisiangtho.com/';
$config['path'] = 'http://www.laisiangtho.com/';
$config['QueryExtract'] = 1;
$db_host = "localhost";
$db_username = "root";
$db_password = "road2SQL";
$databse_name = "laisiangtho";
$config['prefix'] = 'laisiangtho_';

$config['parallelBibles'] = 4;
$config['defaultbible'] = '3';
$config['site_version'] = '1.2';
$config['site_title'] = 'Lai Siangtho';
$config['site_keywords'] = '';
$config['site_description'] = '';
$config['site_heading'] = '';
$config['site_founded'] = '2008';
$config['site_author'] = 'Khen Solomon Lethil';
$config['site_maintain'] = 'ZOMI.developer';

$config['site_email_noreply'] = 'noreply@laisiangtho.com';
$config['db_error'] = '<pre>
The Problem is : DATABASE
  You can email me [khensolomon@gmail.com] directly to solved this problem.....
  http://www.laisiangtho.com
</pre>';
$MyOrdbokReturnArr = array();
?>