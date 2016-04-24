<?php 
function addfullsthopncomma($str,$l=NULL) {
	$and = defined(_and)?_and:' & ';
	$fullstop = defined(_fullstop)?_fullstop:'.';
	$str_tmp = preg_replace('~,\s*(?=[^,]*,[^,]*$)~', $and, rtrim($str));	
	return substr_replace($str_tmp,($l)?$fullstop:'',-1);
}

function limit_char($string, $num, $tail='&nbsp;...') {
	$str_selected = rtrim(substr($string, 0, $num));
	$str_limited = (strlen($string)>$num)?$tail:'';
	return  $str_selected.$str_limited;
}
function limit_word($string,$length,$ellipsis = ".............") 
{ 
   $words = explode(' ', $string); 
   if (count($words) > $length) 
       return implode(' ', array_slice($words,0,$length)).$ellipsis; 
   else 
       return $string; 
} 
function daysAgo($days){  
return date( 'mdHis', mktime( date( 'H' ),                                 
									date( 'i' ),                                 
									date( 's' ),                                 
									date( 'm' ),                                 
									date( 'd' ) - $days) );
}
//echo daysAgo($days); */
function is_valid_email($email) {
  $result = TRUE;
  if(!eregi("^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$", $email)) {
    $result = FALSE;
  }
  return $result;
}
function linetoparagraphs($str,$spilt = "p") {
	$str_tmp = str_replace("\n", "</$spilt>\n<$spilt>", "<$spilt>".$str."</$spilt>");
	return preg_replace('/<[^\/>]*>([\s]?)*<\/[^>]*>/', '', $str_tmp);	
}
function new_pwd_generator() {
		$chars = "abchefghjkmnpqrstuvwxyz0123456789";
		srand((double)microtime()*1000000);
		$i = 0;
		while ($i <= 7) {
				  $num = rand() % 33;
				  $tmp = substr($chars, $num, 1);
				  $pwd = $pwd . $tmp;
				  $i++;
		}
		return $pwd;
}
function count_words($str) {
 return count(explode(" ",$str));
}
function isAjax() {
	return (isset($_SERVER['HTTP_X_REQUESTED_WITH']) && ($_SERVER['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest'));
}
function isID($q) {
	return preg_replace("/[^A-Za-z0-9]/", "", strtolower($q));
}
function highlight($q, $keys)
{
  foreach ($keys as $key )
  {
	  $q= str_ireplace($key, '<em>'.$key.'</em>', $q);
  }
  return $q;
}
function Numbers($j,$l) {
	global $config;	
	//$config["book"]["judson"]["number"]
	/*
	  for ($i = 0; $i < strlen($j); ++$i){
		  $display .= ($config['time_numb'][$j{$i}])?$config['time_numb'][$j{$i}]:$j{$i};
	  }		
	  */
	  for ($i = 0; $i < strlen($j); ++$i){
		  $display .= ($config["book"][$l]["number"][$j{$i}])?$config["book"][$l]["number"][$j{$i}]:$j{$i};
	  }		  
	return $display;
}
function BookNameURL($session,$book) {
	if ($session == "norsk" or $session == "judson")
	{
		$bookname_find = mb_convert_case(str_replace("'","",$book), MB_CASE_LOWER, 'UTF-8');
	}
	else 
	{
		$bookname_find = strtolower($book);
	}
	return str_replace(" ","-",$bookname_find);
}


function Days($j) {
	global $config;	
	$display = ($config['time_name'][$j])?$config['time_name'][$j]:$j;
	return $display;
}
function roman_to_int($r) { 
  $r = strtolower($r); 
  $rvals = array('i'=>1, 'v'=>5, 'x'=>10, 'l'=>50, 'c'=>100, 'd'=>500, 'm'=>1000); 
  $n = 0; 
  for ($i = 0; $i < strlen($r); $i++) { 
	  if (($i == strlen($r) - 1) or ($rvals[$r[$i]] >= $rvals[$r[$i+1]])) 
		  $n += $rvals[$r[$i]]; 
	  else 
		  $n -= $rvals[$r[$i]]; 
  } 
  return $n; 
} 
function hebrew_to_int($h) { 
    $n = 0; 
    for ($i = 0; $i < strlen($h); $i++) { 
        $pos = ord($h{$i}) - 0x8f; 
        switch($pos) { 
            case 11: case 12: $n+=20; break; 
            case 13: $n+=30; break; 
            case 14: case 15: $n+=40; break; 
            case 16: case 17: $n+=50; break; 
            case 18: $n+=60; break; 
            case 19: $n+=70; break; 
            case 20: case 21: $n+=80; break; 
            case 22: case 23: $n+=90; break; 
            default: 
              if ($pos <= 10) $n+=$pos; 
              elseif ($pos <= 27) $n += ($pos-23)*100; 
        } 
    } 
    return $n; 
} 
function num_conv($n) { 
    if (!$n) 
        return; 
    if ($n{0} >= '0' and $n{0} <= '9') 
        return intval($n); 
    if ($n{0} <= 'z') { // assume Roman 
        return roman_to_int(strtoupper($n)); 
    } 
    if ($n{0} == "\xD7") { // assume Hebrew unicode 
        return hebrew_to_int($n); 
    } 
    die('Unknown number form.'); 
}
?>