<?php 
extract($_REQUEST);
extract($_GET);
extract($_POST);
$ip_address = $_SERVER['REMOTE_ADDR']; 
//$redirect_page=$_SERVER['HTTP_REFERER'];


require "Laisiangtho.config.php";
require "Functions.php";
require "Laisiangtho.mysql.php";
require "Laisiangtho.page.php";
require "Class.Template.php";
require "Class.Laisiangtho.php";
require "laisiangtho/config.inc.php";
require "laisiangtho/name.judson.php";
require "laisiangtho/name.norsk.php";
require "laisiangtho/name.tedim.php";
//require $config['DefaultTemplate']."dynamic_wrapper.php";

$db = new sql_db($db_host, $db_username, $db_password, $databse_name, false);
if(!$db->db_connect_id) { print $config['db_error'];  die(); }
/*
$db = @mysql_connect($db_host, $db_username, $db_password) or die(mysql_error());
mysql_select_db($databse_name);
*/
$Laisiangtho = new Laisiangtho();



$LaisiangthoUser 		 	= $_COOKIE['LaisiangthoUser'];
$LangSite					= $_SESSION["LaisiangthoLangSite"];

$current_unique_page 		= $Laisiangtho->unique_page($config['QueryExtract']);
$current_sil 				= $Laisiangtho->sil($bible);
$current_sil_name			= $Laisiangtho->sil_name;
$current_sil_html			= $Laisiangtho->sil_html();

$currenttemplatedirectory	= $config['www'].$config['DefaultTemplate'];

//require('language/'.$current_sil.'/language.php');

$Laisiangtho->page();
$page_title 				= $Laisiangtho->page_title;
$page_keywords 				= $Laisiangtho->page_keywords;
$page_description 			= $Laisiangtho->page_description;
$page_heading 				= $Laisiangtho->page_heading;
$page_class 				= $Laisiangtho->page_class;
$page_id 					= $Laisiangtho->page_id;

$page_link 					= $Laisiangtho->page_link;
$page_logo 					= $Laisiangtho->page_logo;
$page_logo_alt 				= $Laisiangtho->page_logo_alt;

$page_bar					= $Laisiangtho->page_bar;
$page_header				= $Laisiangtho->page_header;
$page_search				= $Laisiangtho->page_search;
$page_content				= $Laisiangtho->page_content;
$page_footer				= $Laisiangtho->page_footer;
$page_including				= $Laisiangtho->page_including;
$page_is					= $Laisiangtho->page_is;
$page_redirect_url			= $Laisiangtho->redirect_url;

$templatedata = "
<h1>$page_bar - bar</h1>
<pre>
including $page_including

current_unique_page: $current_unique_page
current_sol_name: $current_sol_name
current_sil_name: $current_sil_name
sil: $current_sil($current_sil_name)
</pre>
<p> $userid, $username, $password, $uname, $level, $uemail</p>

<p>title: $page_title</p>
<p>keywords: $page_keywords</p>
<p>description: $page_description</p>
<p>heading: $page_heading</p>
<p>plag_class: $page_class</p>
<p>page_id: $page_id </p>
<p>page_content: $page_content</p>
";
if($format) 
{
	if ($format =='json') 
	{
		echo json_encode($Laisiangtho->results_format);
	}
	else 
	{
		echo '<pre>';
		print_r($Laisiangtho->results_format);
		echo '</pre>';
	}
	exit();
} 
else if ($page_is == 'ajax') 
{ 
	echo $page_content; 
} 
else if ($page_redirect_url) 
{
	header("Location: ".$page_redirect_url);
} 
else if ($page_including) 
{ 
	if (!file_exists($page_including)) { print "Laisiangtho->Error->file->page->{$page_including}->Notfound!"; exit(); }
	include($page_including);
} else 
{
	echo $page_content;
}
?>