<?php
    class Template {
        protected $file;
        protected $values = array();
        public function __construct($file) {
            $this->file = $file;
        }
        public function set($key, $value) {
            $this->values[$key] = $value;
        }
        public function HTMLPage() {
            if (!file_exists($this->file)) {
            	return "Laisiangtho->Error->Template->$this->file->Notfound";
            }
            $output = file_get_contents($this->file);
            foreach ($this->values as $key => $value) {
            	$tagToReplace = "{@$key}";
            	$output = str_replace($tagToReplace, $value, $output);
            }
            return $output;
        }
        public function HTMLTag() {
            foreach ($this->values as $key => $value) {
            	$tagToReplace = "{@$key}";
            	$output = str_replace($tagToReplace, $value, $this->file);
            }
            return $output;
        }	
        public function BibleVersion($BibleVersion,$active,$lab) {
			$QueryBible = explode(',',','.$_REQUEST['bible']);
			//array_search($j, $this->config['sil']);
			//array_key_exists($DicSource, $this->config['sol']);			
			foreach($BibleVersion as $line)
			{

				if (array_search($line["shortname"], $QueryBible)) {
					$Checked = 'checked="checked"';
				} else {
					if ($_REQUEST['bible']) 
					{
						$Checked = ' ';
					} else {
						$Checked = ($line["shortname"]==$active)?'checked="checked"':' ';
					}					
				}
				$BibleList .= '
				<div class="share">
					<input type="checkbox" name="bibleVersion[]" value="'.$line["shortname"].'" id="'.$line["shortname"].$lab.'" '.$Checked.'>
					<label for="'.$line["shortname"].$lab.'">'.$line["name"].'</label>
				</div>';
			}
			return $BibleList;
		}
        public function BookListForm($position,$booklists,$active) {
			foreach($booklists as $key => $Book)
			{
				if ($key==$_GET[$position]) {
					$selected = 'selected="selected"';
				} else {
					$selected = ($key==$active)?'selected="selected"':'';
				}
				$showBooks .= '<option value="'.$key.'" '.$selected.'>'.$Book.'</option>';
			}	
			return $showBooks;
		}	
        public function BookCategoryForm($BookCategory,$active) {
			foreach($BookCategory as $key => $Category)
			{
				if ($_REQUEST['bookset']) {
					$selected = ($key==$_REQUEST['bookset'])?'selected="selected"':'';
				} else {
					$selected = ($key==$active)?'selected="selected"':'';
				}
				$showCategory .= '<option value="'.$key.'" '.$selected.'>'.$Category.'</option>';
			}	
			return $showCategory;
		}			
        public function ActiveLimitSearch($active) {
			$limit = $_GET['limit'];
			$limitChcked = 'checked="checked"';
			$ActiveLimitSearch = $limitChcked;
			return $ActiveLimitSearch.$limit;
		}				
        static public function merge($templates, $separator = "\n") {
            $output = "";
            
            foreach ($templates as $template) {
            	$content = (get_class($template) !== "Template")
            		? "Error, incorrect type - expected Template."
            		: $template->output();
            	$output .= $content . $separator;
            }
            
            return $output;
        }
    }

?>