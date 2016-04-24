<?php 
//ini_set( "display_errors", 0);
class Laisiangtho {
	public function __construct()
	{
		global $config;
		$this->config = $config;
	}
	public function unique_page($j)
	{
		$URL=explode("/", str_replace("?","/",$_SERVER["REQUEST_URI"]));
		  $this->unique_page = (!$URL[$j])?'home':$URL[$j];
		  return $this->unique_page;
	}
	public function sil($l)
	{
		$j = explode(",",strtolower($l));
		
		if (!$_SESSION['sil']) 
		{
			$_SESSION['sil'] = $this->config["bible"][$this->config['defaultbible']]["shortname"];
			$_SESSION['sil_id'] = $this->config['defaultbible'];
		} 
		else if ($j[0] == $_SESSION['sil'] or count($j) > 1) 
		{
		} 
		else if($j) 
		{
			for($i=0;$i<count($this->config["bible"]);$i++)
			{
				if($this->config["bible"][$i]["shortname"]==$j[0])
				{
					$_SESSION['sil'] = $j[0];
					$_SESSION['sil_id'] = $i;
					break;
				}
			}
		}
		$this->sil = $_SESSION['sil'];
		$this->sil_id = $_SESSION['sil_id'];
		$this->sil_name = $this->config["bible"][$_SESSION['sil_id']]["name"];; 
		return $this->sil;
	}	
	public function sil_html() {
	   foreach ($this->config["bible"] as $lang => $des){
		$iscurrent = ($des['shortname'] == $this->sil)?'current':'lt';				
		  $sil_HTMl .= '<a href="?bible='.$des['shortname'].'" class="lang '.$des['shortname'].' '.$iscurrent.' bs5 ifie">'.$des['name'].'</a>';					
	   }
	   return $sil_HTMl;
	}	
	public function page()
	{
		/*
		PAGE OPTIONS
		$this->page_including = '';
		$this->ir = 'no hit counting';
		$this->page_is = 'ajax';
		$this->redirect_url = $this->config['www'];
		*/	
		$this->q = $_GET['q'];
		$this->bible = $_GET['bible'];
		$this->limit = $_GET['limit'];
		$this->start_span = (int)$_GET['from'];
		$this->end_span = (int)$_GET['to'];
		$this->bookset = $_GET['bookset'];
		$this->type = $_GET['type'];
		$this->case = $_GET['case'];
		
		$this->isBibleQuery = ($this->bible)?'?bible='.$this->bible:'';
				
		$s_f = array("{Laisiangtho}","{LSTMin}","{Version}","{QUERY}");
		$s_r = array(Laisiangtho,Tedim,$this->config['site_version'],$_GET['q']);
		$page = json_decode($this->config['page']);	

		$__title = defined($page->{$this->unique_page}->title)?$page->{$this->unique_page}->title:$page->home->title;
		$__keywords = defined($page->{$this->unique_page}->keywords)?$page->{$this->unique_page}->keywords:$page->home->keywords;
		$__description = defined($page->{$this->unique_page}->description)?$page->{$this->unique_page}->description:$page->home->description;
		$__heading = defined($page->{$this->unique_page}->heading)?$page->{$this->unique_page}->heading:$page->home->heading;

		$__bar = ($page->{$this->unique_page}->bar)?$page->{$this->unique_page}->bar:$page->home->bar;
		$__header = ($page->{$this->unique_page}->header)?$page->{$this->unique_page}->header:$page->home->header;
		$__search = ($page->{$this->unique_page}->search)?$page->{$this->unique_page}->search:$page->home->search;
		$__content = ($page->{$this->unique_page}->content)?$page->{$this->unique_page}->content:'';
		$__footer = ($page->{$this->unique_page}->footer)?$page->{$this->unique_page}->footer:$page->home->footer;
		$__link = ($page->{$this->unique_page}->link)?$page->{$this->unique_page}->link:$page->home->link;

		$this->s_f = $s_f;
		$this->s_r = $s_r;		

		$bookname = str_replace("-",' ',strtolower($this->unique_page));
		if ($this->config['abbr'][urldecode($bookname)])
		{
			//READ BIBLE
			$_book = $this->config['abbr'][urldecode($bookname)];
			$_nextbook = ($_book +1 <= 66)?$_book +1:1;
			$_previousbook = ($_book -1 >= 1)?$_book -1:66;
			$_chapter = $this->unique_page($this->config['QueryExtract']+1);
			$_verse = explode("-",$this->unique_page($this->config['QueryExtract']+2));

			$this->nextbookName = ($this->config["book"][$this->sil][$_nextbook])?$this->config["book"][$this->sil][$_nextbook]:$this->config["book"]["All"][$_nextbook];
			$this->previousbookName = ($this->config["book"][$this->sil][$_previousbook])?$this->config["book"][$this->sil][$_previousbook]:$this->config["book"]["All"][$_previousbook];
			$this->currentbookName = ($this->config["book"][$this->sil][$_book])?$this->config["book"][$this->sil][$_book]:$this->config["book"]["All"][$_book];
			
			$this->currentbook_url = BookNameURL($this->sil,$this->currentbookName);
			$this->nextbook_url = BookNameURL($this->sil,$this->nextbookName);
			$this->previousbook_url = BookNameURL($this->sil,$this->previousbookName);

			if ($_chapter == $this->config['bibledetail'][$_book]["ChapterCount"])
			{
				$_chapter = $_chapter;
				$_chapter_next = $this->nextbook_url.'/1';
				$_chapter_previous = $this->currentbook_url.'/'.($_chapter-1);
			} 						
			else if (!is_numeric($_chapter) or $_chapter < 1 )				
			{
				$_chapter = 1;
				$_chapter_next = $this->currentbook_url.'/2';
				$_chapter_previous = $this->previousbook_url.'/1';
			}
			else if ($_chapter ==1)
			{
				$_chapter = 1;
				$_chapter_next = $this->currentbook_url.'/2';
				$_chapter_previous = $this->previousbook_url.'/'.$this->config['bibledetail'][$_previousbook]["ChapterCount"];
			} 			
			else if ($_chapter > $this->config['bibledetail'][$_book]["ChapterCount"])
			{
				$_chapter = 1;
				$_chapter_next = $this->currentbook_url.'/2';
				$_chapter_previous = $this->previousbook_url.'/1';
			} 		
			else 
			{
				$_chapter = $_chapter;
				$_chapter_next_num = ($this->config['bibledetail'][$_book]["ChapterCount"] >= $_chapter+1)?$_chapter+1:1;
				$_chapter_previous_num = ($this->config['bibledetail'][$_book]["ChapterCount"] >= $_chapter-1)?$_chapter-1:1;
				$_chapter_next = $this->currentbook_url.'/'.$_chapter_next_num;
				$_chapter_previous = $this->currentbook_url.'/'.$_chapter_previous_num;
			}

			if (!is_numeric($_verse[0]))				
			{
				$_verse_start = 0;
			}
			else if ($_verse[0] > $this->config['bibledetail'][$_book]["Chapter"][$_chapter]["NumVerse"] or $_verse[0] < 1 )
			{
				$_verse_start = 0;
			} 
			else 
			{
				$_verse_start = $_verse[0];
			}
			if (!is_numeric($_verse[1]))				
			{
				$_verse_end = 0;
			}
			else if ($_verse[1] > $this->config['bibledetail'][$_book]["Chapter"][$_chapter]["NumVerse"] or $_verse_start > $_verse[1])
			{
				$_verse_end = 0;
			} 
			else 
			{
				$_verse_end = $_verse[1];
			}			

			$this->current_book = $_book;
			$this->current_chapter = $_chapter;
			$this->current_verse_start = ($_verse_start)?':'.$_verse_start:'';
			$this->current_verse_end = ($_verse_end)?'-'.$_verse_end:'';

			$this->chapter_next = $_chapter_next;
			$this->chapter_previous = $_chapter_previous;
							
			
			$readbiblequery = "$_book $_chapter:$_verse_start-$_verse_end";
			/*
			previouschpater | nextchapter
			PreviousBook << previouschpater | nextchapter >NextBook
			*/
			$this->q = $this->currentbookName.' '.$_chapter.$this->current_verse_start.$this->current_verse_end;
			$this->getBibleList();
			if($this->checkPassageQuery($readbiblequery))
			{
				$this->page_content = $this->db_readbible_results_html();
				$this->results_format = $this->db_passage_results;
				$this->page_class = 'readbible';
				$this->page_id = 'readbible';				
			}
			else 
			{
				$this->page_title = "error";	
				$this->results_format = array("result"=>$this->config["book"]["All"], "message"=>$readbiblequery);		
			}
		}
		else if($this->checkBibleQuery())
		{
			if($this->checkPassageQuery($this->q))
			{
				//PASSAGE
				$this->page_content = $this->db_passage_results_html();
				$this->results_format = $this->db_passage_results;
				$this->page_class = 'willSOLPassage';
				$this->page_id = 'willSOLPassage';
			}
			else if($this->checkSearchQuery())
			{
				//SEARCH
				$this->db_search_results();
				$this->page_class = 'willSOLSearch';
				$this->page_id = 'willSOLSearch';					
				$this->page_content = $this->db_search_results_html();
				$this->results_format = $this->db_search_results;				
			}
			else 
			{
				$this->page_title = "none";
			}
		}
		else 
		{
			$this->page_class = ($page->{$this->unique_page}->Class)?$page->{$this->unique_page}->Class:$page->home->Class;
			$this->page_id = ($page->{$this->unique_page}->id)?$page->{$this->unique_page}->id:$page->home->id;
			$this->page_content = $this->home_html();
			$this->results_format = array("bible"=>$this->config["book"]["All"], "message"=>$readbiblequery);				
		}
		$this->page_including = ($page->{$this->unique_page}->including)?$page->{$this->unique_page}->including:$page->home->including;
		
		if(file_exists("laisiangtho/config.inc.php")) 
		{
			$this->page_including = ($page->{$this->unique_page}->including)?$page->{$this->unique_page}->including:$page->home->including;	
		} 
		else 
		{
			$this->page_including = $page->installer->including;	
		}		
		if (method_exists($this, $__content) == true) { $this->page_content = $this->{$__content}(); }
	}
	private function checkPassageQuery($q)
	{
		$pattern = '/[;,]/'; 
		$verseArray= preg_split($pattern, stripslashes($q));
		$bibleVerseParseInfo =array();
		$this->db_passage_results['summary']['result'] = 'passage';
		foreach($verseArray as $content)
		{
			$parseInfo = $this->getPassage($content,$parseInfo);
			if($parseInfo["status"]=="ok")
			{
				$bibleVerseParseInfo[]=$parseInfo;
				$verseListArray[]= $this->getVerse($parseInfo);
			}
			else
			{
				$errorMessageArray[] = $parseInfo["statusMessage"];
			}
		}
		if(isset($errorMessageArray))
		{
			foreach($errorMessageArray as $errorMessage)
			{
				$this->db_passage_results['summary']['status'][] = $errorMessage;
			}
		}
		if(isset($verseListArray))
		{
			foreach($verseListArray as $verseListMessage)
			{
				$this->db_passage_results['summary']['passage'][] = $verseListMessage; //array("passage"=>$verseListMessage);
				$this->db_passage_results['summary']['detail'][] = str_replace($parseInfo['bookName'].' ','',$verseListMessage);
			}
			
			$this->db_passage_results['summary']['error'] = "no";
			$this->db_passage_results['summary']['versions'] = count($this->BibleTable);
		}
		else
		{
			$this->db_passage_results['summary']['error'] = "yes";
			return false;
		}		
		foreach($this->BibleTable as $bible)
		{
			$this->db_passage_results['summary'][$bible['shortname']] = array("name"=>$bible['name']);
			foreach($bibleVerseParseInfo as $parseInfo)
			{
				$laibu=(int)$this->config["index"][$parseInfo['bookName']];
				$verseTextArray=$this->getChaptersFromDB($bible['shortname'],$laibu,$parseInfo['startChap']);
				unset($fileContentsStruct);
				$fileContentsStruct[]=array($parseInfo['startChap'],array_slice($verseTextArray,$parseInfo['startVerse']-1));
				for($i=$parseInfo['startChap']+1;$i<=$parseInfo['endChap'];$i++)
				{
					$ChapterNo=$i;
					$verseTextArray=$this->getChaptersFromDB($bible['shortname'],$laibu,$ChapterNo);
					$fileContents=array($ChapterNo,$verseTextArray);
					$fileContentsStruct[] = $fileContents;
				}
				$fileContentsStruct[count($fileContentsStruct)-1][1]=array_slice($fileContentsStruct[count($fileContentsStruct)-1][1],0,(($parseInfo['endVerse']+1)-$parseInfo['startVerse']));
				foreach($fileContentsStruct as $chapterText)
				{
					$alian=$chapterText[0];
					foreach($chapterText[1] as $verseText)
					{
						$aneu=$verseText[0];
						$verseText=$verseText[1];
						$this->db_passage_results['result'][$bible['shortname']][$laibu][$alian][$aneu] = array("aneu"=>$aneu,"lai"=>$verseText);
					}
				}
			}
		}
		//return $this->db_passage_results;
		return true;
	}
	private function checkSearchQuery()
	{
		$regex ='/([a-zA-Z]+)/';
		$replace="$1,";
		$this->KeyWordList = substr(preg_replace( $regex, $replace, $this->q),0,-1);	

		$newSearchString=trim(stripslashes ($this->q));
		if($this->type == "phrase")
		{
			$newSearchString= "\"".$this->q."\"";
		}
		$newSearchString_dump = preg_split( "/[\s,]*\\\"([^\\\"]+)\\\"[\s,]*|[\s,]+/", $newSearchString, 0, PREG_SPLIT_DELIM_CAPTURE );
		$this->searchArray = array_filter(array_map('trim', $newSearchString_dump));
			
		$this->BibleTable=array();
		$this->BibleTableNotfound =array();
		$versionfound =false;
		if(!$this->bible)
		{
			$this->diagnosticMessage="Bible version not specified cannot continue";
			return false;
		}
		$bible = explode(",",$this->bible);
		foreach($bible as $version)
		{
			if($version =="")
			{
				continue;
			}
			for($i=0;$i<count($this->config["bible"]);$i++)
			{
				if($this->config["bible"][$i]["shortname"]==$version)
				{
					$versionfound=true;
					$this->BibleTable[] =$this->config["bible"][$i];
					break;
				} else {
					$versionfound=false;
					$this->BibleTableNotfound[]=$version;
				}
			}
		}
	
		if(!$versionfound)
		{
			$invalid_key = implode(', ', array_unique($this->BibleTableNotfound));	
			$invalid_list = addfullsthopncomma($invalid_key);
			$this->diagnosticMessage="Bible version $invalid_list doesn't exist.";
			return false;
		}
		$typeValueArray=array("","all","any","phrase","allInFile");
		$typeValueFound=false;
		foreach($typeValueArray as $typeValue)
		{
			if($this->type==$typeValue)
			{
				$typeValueFound=true;
				break;
			}
		}
		if(!$typeValueFound)
		{
			$this->diagnosticMessage="Invalid search type";
			return false;
		}
		$limitValueArray=array("","none","bookset","span");
		$limitValueFound=false;
		foreach($limitValueArray as $limitValue)
		{
			if($this->limit==$limitValue)
			{
				$limitValueFound=true;
				break;
			}
		}
		if(!$limitValueFound)
		{
			$this->diagnosticMessage="Invalid search range";
			return false;
		}
	
		if($this->limit=="span")
		{
			if(($this->start_span < 1)||($this->start_span > count($this->config["book"]['All'])))
			{
				$this->diagnosticMessage="Invalid search range";
				return false;
			}
			if(($this->end_span < 1)||($this->end_span > count($this->config["book"]['All'])))
			{
				$this->diagnosticMessage="Invalid search range";
				return false;
			}
			if(($this->start_span >$this->end_span))
			{
				$this->diagnosticMessage="Invalid search range";
				return false;
			}
		}
		if($this->limit=="bookset")
		{
			if($this->config["category"][$this->bookset])
			{
				return $this->config["category"][$this->bookset];
			}
			else
			{
				$this->diagnosticMessage="Invalid search category";
				return false;
			}
		}
		return true;
	}
	public function db_search_results()
	{
		$this->db_search_results['summary']['result'] = 'search';
		foreach($this->BibleTable as $bible)
		{
			$language = $bible['shortname'];
			$this->bibleName =$bible['name'];
			@mysql_query("SET NAMES 'utf8'");
			$result = @mysql_query($this->db_search_query($language));
			$Total = @mysql_num_rows($result);
			$this->db_search_results['summary'][$language] = array("total"=>$Total,"name"=>$this->bibleName);
			while ($R = @mysql_fetch_assoc($result))
			{
			  $this->db_search_results['result'][$language][$R[laibu]][$R[alian]][$R[aneu]] =array("aneu"=>$R[aneu],"lai"=>$R[lai]);
			}
			if (!$Total){
				$this->db_search_results['result'][$language] =array("heading"=>"no result found","description"=>"Please try again with relevant keyword");  
			}
		}		
		//return $this->db_search_results;	
	}
	private function db_search_query($table)
	{
		$bookset = (int)$_REQUEST['bookset'];
		$sql = " SELECT * FROM ".$this->config['prefix'].$table." WHERE ";
		if($_REQUEST['limit'] == "bookset")
		{
			$sql .="( ";
			foreach($this->config["book"][$this->config["category"][$bookset]] as $BookName)
			{
				$laibu=array_search($BookName, $this->config["book"]["All"]);
				$sql .="laibu = $laibu OR ";
			}
			$sql=substr($sql,0,(strlen($sql)-3));
			$sql .=") AND ";
		}
		if($_REQUEST['limit'] == "span")
		{
			for($i=$_REQUEST['from'];$i<=$_REQUEST['to'];$i++)
			{
				if($i==$_REQUEST['from'])
				{
					$sql .="( ";
				}

				$sql .="laibu = $i ";
				if($i != $_REQUEST['to'])
				{
					$sql .=" OR ";
				}
				else
				{
					$sql .=") AND ";
				}
			}
		}

		  foreach($this->searchArray as $search)
		  {
			  if($_REQUEST['case'] =="sensitive")
			  {
				$sql .="binary ";
			  }
			  
			  if(!$_REQUEST['type'] or $_REQUEST['type']=="all")
			  {
				  $sql .= "lai LIKE '%".addslashes($search)."%' AND ";
			  }
			  else
			  {
				  $sql .= "lai LIKE '%".addslashes($search)."%' OR ";
			  }
		  }
		$sql=substr($sql,0,(strlen($sql)-4))." ORDER BY ABS(laibu), ABS(alian), ABS(aneu) ASC;";// ORDER BY ABS(laibu), ABS(alian), ABS(aneu) ASC
		return $sql;
	}
	private function checkBibleQuery()
	{
		if(!isset($this->bible))
		{
			$this->diagnosticMessage="Bible version not specified cannot continue.";
			return false;
		}
		$bible = explode(",",$this->bible);
		$this->BibleTable = array();
		$this->BibleTableNotfound =array();
		foreach($bible as $version)
		{
			if($version =="")
			{
				continue;
			}
			for($i=0;$i<count($this->config["bible"]);$i++)
			{
				if($this->config["bible"][$i]["shortname"]==$version)
				{
					$this->BibleTable[] =$this->config["bible"][$i];
					break;
				} 
				else 
				{
					$this->BibleTableNotfound[]=$version;	
				}
			}
		}
		if(!$this->BibleTable)
		{
			$invalid_key = implode(', ', array_unique($this->BibleTableNotfound));
			$this->diagnosticMessage="Bible version $invalid_key doesn't exist.";
			return false;
		}
		if(!isset($this->q)||trim($this->q)=="")
		{
			$this->diagnosticMessage="Lookup Passage not given cannot continue.";
			return false;
		}
		return true;			
	}
	private function getBibleList()
	{
		$bible = explode(",",$this->bible);
		$this->BibleTable = array();
		$this->BibleTableNotfound =array();
		foreach($bible as $version)
		{
			if($version =="")
			{
				continue;
			}
			for($i=0;$i<count($this->config["bible"]);$i++)
			{
				if($this->config["bible"][$i]["shortname"]==$version)
				{
					$this->BibleTable[] =$this->config["bible"][$i];
					break;
				} 
				else 
				{
					$this->BibleTableNotfound[]=$version;	
				}
			}
		}
		if(!$this->BibleTable)
		{
			$this->BibleTable[] =$this->config["bible"][$this->sil_id];
		}
		return true;			
	}	
	public function getPassage($passageString,$previousPassageInfo)
	{
		$bibleVerseParseInfo["passage"]=$passageString;
		$pattern="/^[\d]*[\s]*[a-zA-Z ]+/";
		if(preg_match($pattern, trim($passageString), $matches))  
		{
			$bibleVerseParseInfo['givenBookName']=trim($matches[0]);
			if(isset($this->config["index"][trim($matches[0])]))
			{
				$indexOfBook=$this->config["index"][trim($matches[0])];
			}
			else if(isset($this->config['abbr'][strtolower(trim($matches[0]))]))
				{
					$indexOfBook=$this->config['abbr'][strtolower(trim($matches[0]))];
				}
				else
				{
					$bibleVerseParseInfo["status"]="error";
					$bibleVerseParseInfo["statusMessage"]="Book ". $bibleVerseParseInfo['givenBookName']." Not Found";
					return $bibleVerseParseInfo;
				}
				$bibleVerseParseInfo['bookIndex']=$indexOfBook;
				$bibleVerseParseInfo['bookName']=$this->config["book"]["All"][$indexOfBook];
				$rest=substr(trim($passageString),strlen(trim($matches[0])));
				$rest = preg_replace('/^\./', '', trim($rest));
		}
		else if(isset($previousPassageInfo['bookIndex']))
			{
				$indexOfBook=$previousPassageInfo['bookIndex'];
				$bibleVerseParseInfo['bookIndex']=$indexOfBook;
				$bibleVerseParseInfo['givenBookName'] =$previousPassageInfo['givenBookName'];
				$bibleVerseParseInfo['bookName']=$this->config["book"]["All"][$indexOfBook];
				$bibleVerseParseInfo['bookStatus']="calculated";
				$pattern="/^\d/";
				if(preg_match($pattern, trim($passageString), $matches))
				{
					$rest = $passageString;
				}
				else
				{
					$bibleVerseParseInfo["status"]="error";
					$bibleVerseParseInfo["statusMessage"]="incorrect format for ".$bibleVerseParseInfo['bookName']." $passageString";
					return $bibleVerseParseInfo;
				}
			}
			else
			{
				$bibleVerseParseInfo["status"]="error";
				$bibleVerseParseInfo["statusMessage"]="incorrect format for $passageString";
				return $bibleVerseParseInfo;
			}
			$verse = str_replace("\xe2\x80\x93", '-', strtolower($rest)); // endash -> - 
			$nreg = '([0-9]+|[ivxlcm]+|['."\x90-\xAA"."\xD7]+)"; 
			$reg = '/^'.$nreg.'\.?(\s*[:. ]\s*'.$nreg.')?(\s*-\s*'.$nreg.'\.?(\s*[:. ]\s*'.$nreg.')?)?/i'; 
			if(!preg_match($reg, trim($verse), $matches)&&(!trim($rest)==""))
			{
				$bibleVerseParseInfo["status"]="error";
				$bibleVerseParseInfo["statusMessage"]="incorrect format for ".$bibleVerseParseInfo['bookName']." $rest";
				return $bibleVerseParseInfo;
			}
			$s_chap = num_conv($matches[1]); 
			$s_vers = num_conv($matches[3]); 
			$e_chap = num_conv($matches[5]); 
			$e_vers = num_conv($matches[7]);
			if($bibleVerseParseInfo['bookStatus']=="calculated")
			{
				if(isset($previousPassageInfo['startVerse'])&&$previousPassageInfo['startVerseStatus']!="calculated"&&$previousPassageInfo['startVerseStatus']!="incorrect"
					&&!$s_vers&&(!isset($previousPassageInfo['endVerse'])||$previousPassageInfo['endVerseStatus']=="calculated"))
				{
					$s_vers=$s_chap;
					$s_chap = $previousPassageInfo['startChap'];
				}
				if(isset($previousPassageInfo['endVerse'])&&$previousPassageInfo['endVerseStatus']!="calculated"&&$previousPassageInfo['endVerseStatus']!="incorrect"
					&&!$e_chap)
				{
					$s_vers=$s_chap;
					$s_chap = $previousPassageInfo['endChap'];
				}
			}
			if (!$s_chap)
			{
				$s_chap = 1;
				$bibleVerseParseInfo['startChapStatus']="calculated";
			}
			if (!$e_chap&&$s_vers) { // eg 15 or 15:30 
				$e_chap = $s_chap; 
				$e_vers = $s_vers; 
				$bibleVerseParseInfo['endChapStatus']="calculated";
				$bibleVerseParseInfo['endChapStatusConvertedFrom']="startChapter";
				$bibleVerseParseInfo['endVerseStatus']="calculated";
				$bibleVerseParseInfo['endVerseStatusConvertedFrom']="startVerse";
			} 
			else if ($s_vers and $e_chap and !$e_vers) { // eg 15:30-35 
				$e_vers = $e_chap; 
				$e_chap = $s_chap; 
				$bibleVerseParseInfo['endChapStatus']="calculated";
				$bibleVerseParseInfo['endChapStatusConvertedFrom']="startChapter";
				$bibleVerseParseInfo['endVerseStatus']="calculated";
				$bibleVerseParseInfo['endVerseStatusConvertedFrom']="endChapter";
			}
			else if(!$e_chap&&!$s_vers)
				{
					$e_chap = $s_chap;
					$s_vers = 1;
					$bibleVerseParseInfo['endChapStatus']="calculated";
					$bibleVerseParseInfo['startVerseStatus']="calculated";
				}
			if (!$s_vers)
			{
				$s_vers = 1;
				$bibleVerseParseInfo['startVerseStatus']="calculated";
			}
		if($e_chap < $s_chap)
		{
			$bibleVerseParseInfo['endChapStatus']="incorrect";
			$bibleVerseParseInfo["status"]="error";
			$bibleVerseParseInfo["statusMessage"]="end Chapter Cannot be less than start chapter for ".$bibleVerseParseInfo['bookName']." $s_chap-$e_chap";
			return $bibleVerseParseInfo;
		}
		if(($s_chap==$e_chap)&&$e_vers&&($e_vers< $s_vers))
		{
			$bibleVerseParseInfo['endVerseStatus']="incorrect";
			$bibleVerseParseInfo["status"]="error";
			$bibleVerseParseInfo["statusMessage"]="end Verse Cannot be less than start Verse for ".$bibleVerseParseInfo['bookName']." $s_chap:$s_vers-$e_chap:$e_vers";
			return $bibleVerseParseInfo;
	
		}
		if(!isset($this->config['bibledetail'][$indexOfBook]["Chapter"][$s_chap]))
		{
			$bibleVerseParseInfo['startChapStatus']="incorrect";
			$bibleVerseParseInfo["status"]="error";
			$bibleVerseParseInfo["statusMessage"]="start Chapter not found for ".$bibleVerseParseInfo['bookName']." $s_chap";
			return $bibleVerseParseInfo;
		}
	
		if(!isset($this->config['bibledetail'][$indexOfBook]["Chapter"][$e_chap]))
		{
			$bibleVerseParseInfo['endChapStatus']="incorrect";
			$bibleVerseParseInfo["status"]="error";
			$bibleVerseParseInfo["statusMessage"]="end Chapter not found for ".$bibleVerseParseInfo['bookName']." $e_chap";
			return $bibleVerseParseInfo;
		}
	   
		if ($s_vers == 1 and !$e_vers)
		{
			$e_vers = $this->config['bibledetail'][$indexOfBook]["Chapter"][$e_chap]["NumVerse"];
			$bibleVerseParseInfo['endVerseStatus']="calculated";
			$bibleVerseParseInfo['startChap']=$s_chap;
			$bibleVerseParseInfo['startVerse']=1;
			$bibleVerseParseInfo['endChap']=$e_chap;
			$bibleVerseParseInfo['endVerse']=$e_vers;
			$bibleVerseParseInfo["status"]="ok";
			return $bibleVerseParseInfo;
		}
		else 
		{
			if($this->config['bibledetail'][$indexOfBook]["Chapter"][$s_chap]["NumVerse"]<$s_vers)
			{
				$bibleVerseParseInfo['startVerseStatus']="incorrect";
				$bibleVerseParseInfo["status"]="error";
				$bibleVerseParseInfo["statusMessage"]="start verse range exceeded for ".$bibleVerseParseInfo['bookName']." $s_chap:$s_vers";
				return $bibleVerseParseInfo;
			}
	
			if($this->config['bibledetail'][$indexOfBook]["Chapter"][$e_chap]["NumVerse"]<$e_vers)
			{
				$bibleVerseParseInfo['endVerseStatus']="incorrect";
				$bibleVerseParseInfo["status"]="error";
				$bibleVerseParseInfo["statusMessage"]="end verse range exceeded for ".$bibleVerseParseInfo['bookName']." $s_chap:$s_vers-$e_chap:$e_vers";
				return $bibleVerseParseInfo;
			}
			$bibleVerseParseInfo['startChap']=$s_chap;
			$bibleVerseParseInfo['startVerse']=$s_vers;
			$bibleVerseParseInfo['endChap']=$e_chap;
			$bibleVerseParseInfo['endVerse']=$e_vers;
			$bibleVerseParseInfo["status"]="ok";
			return $bibleVerseParseInfo;
		}
	}	
	private function getVerse($bibleParseInfo)
	{
		if($bibleParseInfo['startVerseStatus']=="calculated"&&$bibleParseInfo['endChapStatus']=="calculated")
		{
			return $bibleParseInfo['bookName']." ".$bibleParseInfo['startChap']; 
		}
		else if($bibleParseInfo['startVerseStatus']=="calculated"&&$bibleParseInfo['endVerseStatus']=="calculated")
		{
			return $bibleParseInfo['bookName']." ".$bibleParseInfo['startChap']."-".$bibleParseInfo['endChap'];
		}
		else if($bibleParseInfo['endChapStatus']=="calculated"&&$bibleParseInfo['endVerseStatus']=="calculated"&&$bibleParseInfo['endVerseStatusConvertedFrom']=="startVerse")
		{
			return $bibleParseInfo['bookName']." ".$bibleParseInfo['startChap'].":".$bibleParseInfo['startVerse'];
		}
		else if($bibleParseInfo['endChapStatus']=="calculated"&&$bibleParseInfo['endVerseStatus']=="calculated"&&$bibleParseInfo['endVerseStatusConvertedFrom']=="endChapter")
		{
			return $bibleParseInfo['bookName']." ".$bibleParseInfo['startChap'].":".$bibleParseInfo['startVerse']."-".$bibleParseInfo['endVerse'];
		}
		else
		{
			return $bibleParseInfo['bookName']." ".$bibleParseInfo['startChap'].":".$bibleParseInfo['startVerse']."-".$bibleParseInfo['endChap'].":".$bibleParseInfo['endVerse'];
		}
	}
	public function getChaptersFromDB($table,$laibu,$alian)
	{
		if(!isset($this->config["book"]["All"][$laibu]))
		{
			return false;
		}	
		if($alian!==false)
		{
			$sql = "SELECT aneu, lai FROM ".$this->config['prefix'].$table."  WHERE laibu = $laibu AND alian = $alian ORDER BY ABS(laibu), ABS(alian), ABS(aneu) ASC;";
			@mysql_query("SET NAMES 'utf8'");
			$result=mysql_query($sql);
			while($row=mysql_fetch_array($result))
			{
				$verseTextArray[]=$row;
			}
		}
		return $verseTextArray;
	}
	public function db_passage_results_html()
	{
		if ($this->db_passage_results['summary']['error'] == 'no')
		{		
			while (list($k, $v) = each($this->db_passage_results['result'])) 
			{
				foreach($v as $b => $Books) 
				{
					foreach($Books as $i => $verses) 
					{
						foreach($verses as $y) 
						{
							$this->db_passage_results_verse .='
							<div class="verse '.$y['aneu'].'">
							  <span><!--{@verse_num} -->'.Numbers($y['aneu'],$k).'</span>
							  <p><!--{@verse} -->'.$y['lai'].'</p>
							</div>';
						}		
						$this->page_description = $verses[key($verses)]['lai'];
						$chapter =($this->config["book"][$k]["chapter"])?$this->config["book"][$k]["chapter"]:'Chapter';
						$this->db_passage_results_chapter .='
						<div class="chapter '.$i.'">
						  <h4><!--{@chapter} --> '.Numbers($chapter.' '.$i,$k).'</h4>
						  <!--{@data} -->'.$this->db_passage_results_verse.'
						</div>';
						$this->db_passage_results_verse ='';
					}
					$bookClass = $this->config["book"]["All"][$b];
					$book =($this->config["book"][$k][$b])?$this->config["book"][$k][$b]:$bookClass;
					$this->db_passage_results_book .='
					<div class="book '.isID($bookClass).' bs rc2 ifie">
					  <h3><!--{@book} -->'.$book.'</h3>
					  <!--{@data} -->'.$this->db_passage_results_chapter.'
					</div>';
					$this->db_passage_results_chapter ='';
				}
				$version = $k;
				$version_name =($this->config["book"]["name"][$k])?$this->config["book"]["name"][$k]:$this->db_passage_results['summary'][$k]['name'];
				$totalverses = $this->db_passage_results['summary'][$k]['total'];
				$isMoreVerses = ($totalverses > 1)?'verses':'verse';
				$verse = ($this->config["book"][$k]["verse"])?$this->config["book"][$k]["verse"]:$isMoreVerses;
				$this->db_passage_results_version .='
				<div class="version '.$k.'">
				  <h2><strong>'.$version_name.'</strong> <span>'.$this->q.'</span></h2>
				  '.$this->db_passage_results_book.'
				</div>';		
				$this->db_passage_results_book ='';				
			}
		}
		else 
		{
			$this->db_passage_results_version .='
			<div class="version noresults">
			  <h2>in '.$this->db_passage_results['summary'][$k]['name'].' found no verse</h2>
			  <!--{@data} -->
			</div>';
			$this->diagnosticMessage ='Sorry, no result were found in '.$this->db_passage_results['summary'][$k]['name'].'!';			
		}
		$this->page_title = $book.' '.Numbers($this->db_passage_results['summary']['detail'][0],$version).' - '. $version_name;
		$this->page_keywords = $version_name.', '.$this->q.', '.$this->config['site_title'];
		$this->MainMenu = $this->BibleMainMenu_html();
		$parable = $this->db_passage_results['summary']['versions'];
		$this->db_passage_results_html_final = '
		<div class="bible wise'.$parable.'">
		'.$this->db_passage_results_version.'
		</div>';		
		return $this->db_passage_results_html_final;
	}
	public function db_search_results_html()
	{
		while (list($k, $v) = each($this->db_search_results['result'])) 
		{ 
			if ($this->db_search_results['summary'][$k]['total'] > 0)
			{
				foreach($v as $b => $Books) 
				{
					foreach($Books as $i => $verses) 
					{
						foreach($verses as $y) 
						{
							$this->db_search_results_verse .='
							<div class="verse '.$y[aneu].'">
							  <span><!--{@verse_num} -->'.Numbers($y[aneu],$k).'</span>
							  <p><!--{@verse} -->'.highlight($y[lai], $this->searchArray).'</p>
							</div>';
						}
						$chapter =($this->config["book"][$k]["chapter"])?$this->config["book"][$k]["chapter"]:'Chapter';
						$this->page_description = $verses[key($verses)]['lai'];
						$this->db_search_results_chapter .='
						<div class="chapter '.$i.'">
						  <h4><!--{@chapter} --> '.Numbers($chapter.' '.$i,$k).'</h4>
						  <!--{@data} -->'.$this->db_search_results_verse.'
						</div>';
						$this->db_search_results_verse ='';
					}
					$bookClass = $this->config["book"]["All"][$b];
					$book =($this->config["book"][$k][$b])?$this->config["book"][$k][$b]:$bookClass;
					$this->db_search_results_book .='
					<div class="book '.isID($bookClass).' bs rc2 ifie">
					  <h3><!--{@book} -->'.$book.'</h3>
					  <!--{@data} -->'.$this->db_search_results_chapter.'
					</div>';
					$this->db_search_results_chapter ='';
				}
				$version =($this->config["book"]["name"][$k])?$this->config["book"]["name"][$k]:$this->db_search_results['summary'][$k]['name'];
				$totalverses = $this->db_search_results['summary'][$k]['total'];
				$isMoreVerses = ($totalverses > 1)?'verses':'verse';
				$verse = ($this->config["book"][$k]["verse"])?$this->config["book"][$k]["verse"]:$isMoreVerses;
				$this->db_search_results_version .='
				<div class="version '.$k.'">
				  <h2><strong>'.$version.'</strong> <span>'.$this->q.' &raquo; '.Numbers($verse.' &raquo; '.$totalverses,$k).'</span></h2>
				  '.$this->db_search_results_book.'
				</div>';		
				$this->db_search_results_book ='';
			}
			else 
			{
				$this->db_search_results_version .='
				<div class="version noresults">
				  <h2>in '.$this->db_search_results['summary'][$k]['name'].' found no verse</h2>
				  <!--{@data} -->
				</div>';
				$this->diagnosticMessage ='Sorry, no result were found in '.$this->db_search_results['summary'][$k]['name'].'!';
			}	
		} 
		$this->MainMenu = $this->BibleMainMenu_html();
		$this->db_search_results_html_final = '
		<div class="bible">
		'.$this->db_search_results_version.'
		</div>';
		$this->page_title = $this->q.' - '.$version.' &raquo; '.$this->config['site_title'];
		$this->page_keywords = $version.', '.$this->q.', '.$this->config['site_title'];
		return $this->db_search_results_html_final;
	}
	public function db_readbible_results_html()
	{
		if ($this->db_passage_results['summary']['error'] == 'no')
		{		
			while (list($k, $v) = each($this->db_passage_results['result'])) 
			{
				foreach($v as $b => $Books) 
				{
					foreach($Books as $i => $verses) 
					{
						foreach($verses as $f => $y) 
						{
							$this->db_passage_results_verse .='
							<div class="verse '.$y['aneu'].'">
							  <span><!--{@verse_num} -->'.Numbers($y['aneu'],$k).'</span>
							  <p><!--{@verse} -->'.$y['lai'].'</p>
							</div>';
							
						}
						$this->page_description = $verses[key($verses)]['lai'];
						$chapter =($this->config["book"][$k]["chapter"])?$this->config["book"][$k]["chapter"]:'Chapter';
						$this->db_passage_results_chapter .='
						<div class="chapter '.$i.'">
						  <h4><!--{@chapter} --> '.Numbers($chapter.' '.$i,$k).'</h4>
						  <!--{@data} -->'.$this->db_passage_results_verse.'
						</div>';
						$this->db_passage_results_verse ='';
					}
					$bookClass = $this->config["book"]["All"][$b];
					$bookID = $b;
					$book =($this->config["book"][$k][$b])?$this->config["book"][$k][$b]:$bookClass;
					$this->db_passage_results_book .='
					<div class="book '.isID($bookClass).' bs rc2 ifie">
					  <h3><!--{@book} -->'.$book.'</h3>
					  <!--{@data} -->'.$this->db_passage_results_chapter.'
					</div>';
					$this->db_passage_results_chapter ='';
				}
				$version = $k;
				$version_name =($this->config["book"]["name"][$k])?$this->config["book"]["name"][$k]:$this->db_passage_results['summary'][$k]['name'];
				$totalverses = $this->db_passage_results['summary'][$k]['total'];
				$isMoreVerses = ($totalverses > 1)?'verses':'verse';
				$verse = ($this->config["book"][$k]["verse"])?$this->config["book"][$k]["verse"]:$isMoreVerses;
				$this->db_passage_results_version .='
				<div class="version '.$k.'">
				  <h2 class="none"><strong>'.$version_name.'</strong> <span>'.$this->q.'</span></h2>
				  '.$this->db_passage_results_book.'
				</div>';		
				$this->db_passage_results_book ='';				
			}
		}
		else
		{
			$this->db_passage_results_version .='
			<div class="version noresults">
			  <h2>in '.$this->db_passage_results['summary'][$k]['name'].' found no verse</h2>
			  <!--{@data} -->
			</div>';
			$this->diagnosticMessage ='Sorry, no result were found in '.$this->db_passage_results['summary'][$k]['name'].'!';			
		}

		$current_chapter = $this->db_passage_results['summary']['detail'][0];

		$current_book = ($this->config["book"][$this->sil][$bookID])?$this->config["book"][$this->sil][$bookID]:$bookClass;
		
		$chapter =($this->config["book"][$this->sil]["chapter"])?$this->config["book"][$this->sil]["chapter"]:'Chapter';
		$verse = ($this->config["book"][$this->sil]["verse"])?$this->config["book"][$this->sil]["verse"]:'verse';
				
		$OldTestament = ($this->config["book"]["testament"][$this->sil][1])?$this->config["book"]["testament"][$this->sil][1]:"Old Testament";
		$NewTestament = ($this->config["book"]["testament"][$this->sil][2])?$this->config["book"]["testament"][$this->sil][2]:"New Testament";
		$Testament = ($bookID <= 39)?$OldTestament:$NewTestament;
		$parable = $this->db_passage_results['summary']['versions'];
		
		$this->MainMenu = $this->BibleMainMenu_html();
		$this->db_passage_results_html_final = '
		<div class="bible wise'.$parable.'">
			<div class="currentChapter">
				<ul>
					<li class="books bs rc2 ifie">
						<a href="'.$this->config['www'].'">'.$version_name.'</a>
					</li>
					<li class="bs rc2 ifie"><a href="#">'.$Testament.'</a></li>
					<li class="parable bs rc2 ifie">
						<span>Parallel</span>
						<ul class="parables bs rc2 ifie">'.$this->parallel_html().'</ul>
					</li>
					<li class="chapters bs rc2 ifie">
						<a href="#">'.$current_book.'</a>
						<ul class=" bs rc2 ifie">
							<li class="cap">'.$chapter.'</li>
							<li class="chapter">'.$this->chpaterlist_html($bookID,$this->currentbook_url,$current_chapter).'</li>
						</ul>
					</li>
					
					<li class="nav bs rc2 ifie">
						<a href="'.$this->config['www'].$this->previousbook_url.$this->isBibleQuery.'" title="'.$this->previousbookName.'" class="book previous">&laquo;</a>
						<a href="'.$this->config['www'].$this->chapter_previous.$this->isBibleQuery.'" class="pre">Previous</a>
						<a href="'.$current_url.'" class="num">'.$current_chapter.'</a>
						<a href="'.$this->config['www'].$this->chapter_next.$this->isBibleQuery.'" class="nex">Next</a>
						<a href="'.$this->config['www'].$this->nextbook_url.$this->isBibleQuery.'" title="'.$this->nextbookName.'" class="book next">&raquo;</a>
					</li>
				</ul>                
			</div>					
		'.$this->db_passage_results_version.'
			<div class="version widgets">
				<ul class="parables bs rc2 ifie"><li class="title">Parallel</li>'.$this->parallel_html().'</ul>
			</div>			
		</div>';
		$this->page_title = $book.' '.Numbers($current_chapter,$version).' - '. $version_name;
		$this->page_keywords = $version_name.', '.$book.', '.$this->config['site_title'];
		
		return $this->db_passage_results_html_final;
	}
	public function parallel_html()
	{
		$checkbible = ($this->bible)?$this->bible:$this->sil;

		$QueryBible = explode(',',','.$checkbible);
		$BibleVersion = $this->config['bible'];
		foreach($BibleVersion as $line)
		{

			if (array_search($line["shortname"], $QueryBible)) {
				$url_find = array($line["shortname"],",,");
				$url_replace = array("",",");
				$url_dump = str_replace($url_find ,$url_replace,$checkbible);
				$url_dump_right = rtrim($url_dump, ",");
				$url_dump_left = ltrim($url_dump_right, ",");
				$url = ($url_dump_left)?$url_dump_left:$line["shortname"];
				$Class = 'active';
			} else {
				if ($this->bible) 
				{
					$url = $this->bible.','.$line["shortname"];
					$Class = '';
				} else {
					$url = $this->sil.','.$line["shortname"];
					$Class = '';
				}					
			}
			$BibleList .= '<li class="'.$Class.'"><a href="?bible='.$url.'">'.$line["shortname"].'</a></li>';
		}
		return $BibleList;
	}
	public function chpaterlist_html($bookID,$current_book_url,$current_chapter)
	{
		$TotalChapter = $this->config['bibledetail'][$bookID]["ChapterCount"]+1;
		for($i=1;$i<$TotalChapter;$i++)
		{
			$Class = ($current_chapter ==$i)?'active bs ifie':'bs ifie';
			$chpaterlist_html_final .= '<a href="'.$this->config['www'].$current_book_url.'/'.$i.$this->isBibleQuery.'" class="'.$Class.'">'.Numbers($i.'',$this->sil).'</a>';
		}
		return $chpaterlist_html_final;
	}		
	public function home_html()
	{
	  $HTMLBookslist = new Template($this->config['DefaultTemplate'].'books-list.html');
	  
	  $OldTestament = ($this->config["book"]["testament"][$this->sil][1])?$this->config["book"]["testament"][$this->sil][1]:"Old Testament";
	  $NewTestament = ($this->config["book"]["testament"][$this->sil][2])?$this->config["book"]["testament"][$this->sil][2]:"New Testament";
	  $HTMLBookslist->set("Old Testament", $OldTestament);
	  $HTMLBookslist->set("New Testament", $NewTestament);

		foreach ($this->config["book"]["All"] as $key => $id) {
			$bookname = ($this->config["book"][$this->sil][$key])?$this->config["book"][$this->sil][$key]:$id;
			$_title[] = $bookname;
			if ($this->sil == "norsk" or $this->sil == "judson")
			{
				$bookname_find = mb_convert_case(str_replace("'","",$bookname), MB_CASE_LOWER, 'UTF-8');
			} 
			else 
			{
				$bookname_find = strtolower($bookname);
			}
			$bookurl = ($this->config['abbr'][$bookname_find])?str_replace(" ","-",$bookname_find):strtolower(str_replace(" ","-",$id));
			$HTMLBookslist->set("www ".$id, $this->config['www'].$bookurl);
			$HTMLBookslist->set($id, $bookname);
		}
		$this->page_title = $this->sil_name.' - Laisiangtho';
		$this->page_keywords = implode(",",$_title);
		$this->page_description = 'The Find online free Bible application, '.$OldTestament.' and '.$NewTestament.' Laisiangtho';
	   return $HTMLBookslist->HTMLPage();		
	}
	public function BibleMainMenu_html()
	{
	  $HTMLBookslist = new Template($this->config['DefaultTemplate'].'books-list-menu.html');
	  
	  $OldTestament = ($this->config["book"]["testament"][$this->sil][1])?$this->config["book"]["testament"][$this->sil][1]:"Old Testament";
	  $NewTestament = ($this->config["book"]["testament"][$this->sil][2])?$this->config["book"]["testament"][$this->sil][2]:"New Testament";
	  $HTMLBookslist->set("Old Testament", $OldTestament);
	  $HTMLBookslist->set("New Testament", $NewTestament);

		foreach ($this->config["book"]["All"] as $key => $id) {
			$bookname = ($this->config["book"][$this->sil][$key])?$this->config["book"][$this->sil][$key]:$id;
			if ($this->sil == "norsk" or $this->sil == "judson")
			{
				$bookname_find = mb_convert_case(str_replace("'","",$bookname), MB_CASE_LOWER, 'UTF-8');
			} 
			else 
			{
				$bookname_find = strtolower($bookname);
			}
			$bookurl = ($this->config['abbr'][$bookname_find])?str_replace(" ","-",$bookname_find):strtolower(str_replace(" ","-",$id));
			$HTMLBookslist->set("www ".$id, $this->config['www'].$bookurl.$this->isBibleQuery);
			$HTMLBookslist->set($id, $bookname);
		}
	   return $HTMLBookslist->HTMLPage();		
	}	
}
?>