<?php 
$pages['home'] = array(
	"title"=>"site_title",
	"keywords"=>"site_keywords",
	"description"=>"site_description",
	"heading"=>"site_heading",
	"Class"=>"home",
	"id"=>"laisiangtho",
	"including"=>"Page.default.php",
	"bar"=>"bar",
	"header"=>"header",
	"search"=>"search",	
	"content"=>"",
	"footer"=>"footer",

	"navigator"=>"no",
	"menu"=>"Laisiangtho",
	"link"=>"",
	"type"=>"apps"	
	);
$pages['installer'] = array(
	"title"=>"installer_title",
	"keywords"=>"installer_keywords",
	"description"=>"installer_description",
	"heading"=>"installer_heading",
	"Class"=>"installer",
	"id"=>"installer",
	"including"=>"page.installer.php",
	
	"content"=>"installer",

	"navigator"=>"no",
	"menu"=>"Installer",
	"link"=>"installer",
	"type"=>"apps"	
	);	
$pages['search'] = array(
	//"including"=>"Page.search.php",
	"id"=>"search"
	);
$pages['passage'] = array(
	//"including"=>"Page.passage.php"
	"id"=>"passage"
	);	
$pages['readbible'] = array(
	//"including"=>"Page.readbible.php"
	"id"=>"readbible"
	);		
$pages['test'] = array(
	"content"=>"test_----page"
	);	
/*API*/
$pages['paungku'] = array(
	"including"=>"MyOrdbok.api.paungku.php",
	"navigator"=>"no",
	"menu"=>"paungku",
	"link"=>"paungku",
	"type"=>"api"	
	);	

			
$config['page'] = json_encode($pages);
?>