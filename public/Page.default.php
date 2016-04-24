<?php 
$TAG = new Template('none');
$HTMLBar = new Template($config['DefaultTemplate'].'bar.html');
$HTMLBar->set("template.directory", $config['www'].$config['DefaultTemplate']);
$HTMLBar->set("BibleList", $TAG->BibleVersion($config["bible"],$current_sil,'_'));
$HTMLBar->set("query", $Laisiangtho->q);
$HTMLBar->set("LimitActiveentire", (!$limit or $limit=='entire')?'checked="checked"':'');
$HTMLBar->set("LimitActivebookset", ($limit=='bookset')?'checked="checked"':'');
$HTMLBar->set("LimitActivespan", ($limit=='span')?'checked="checked"':'');
$HTMLBar->set("BookListForm_from", $TAG->BookListForm('from',$config["book"]["All"],1));
$HTMLBar->set("BookListForm_to", $TAG->BookListForm('to',$config["book"]["All"],66));
$HTMLBar->set("BookCategoryForm", $TAG->BookCategoryForm($config["category"],11));
$HTMLBar->set("MainMenu", $Laisiangtho->MainMenu);

$HTMLBarOutput = $HTMLBar->HTMLPage();

$HTMLSearch = new Template($config['DefaultTemplate'].'search.html');
$HTMLSearch->set("message", $diagnosticMessage);
$HTMLSearchOutput = $HTMLSearch->HTMLPage();

$HTMLContents = new Template($config['DefaultTemplate'].'content.html');
$HTMLContents->set("Contents", $page_content);
$HTMLContentsOutput = $HTMLContents->HTMLPage();

$HTMLFooter = new Template($config['DefaultTemplate'].'footer.html');
$HTMLFooter->set("languages", $current_sil_html);
$HTMLFooterOutput = $HTMLFooter->HTMLPage();

$HTMLLayout = new Template($config['DefaultTemplate'].'layout.html');
$HTMLLayout->set("title", $page_title);
$HTMLLayout->set("keywords", $page_keywords );
$HTMLLayout->set("Description", $page_description);
$HTMLLayout->set("author", $config['site_author']);	
$HTMLLayout->set("template.directory", $config['www'].$config['DefaultTemplate']);

$HTMLLayout->set("PageID", $page_id);
$HTMLLayout->set("PageClass", $page_class);
$HTMLLayout->set("CurrentSil", $current_sil);

$HTMLLayout->set("bar", $HTMLBarOutput);
$HTMLLayout->set("header", '');
$HTMLLayout->set("search", $HTMLSearchOutput);
$HTMLLayout->set("windows", '');
$HTMLLayout->set("content", $HTMLContentsOutput);
$HTMLLayout->set("footer", $HTMLFooterOutput);
$HTMLLayout->set("speechplayer", '');

$HTMLPage = new Template($HTMLLayout->HTMLPage());
$HTMLPage->set("www", $config['www']);

echo $HTMLPage->HTMLTag();
?>