// JavaScript Document
iSOL = {};
iSOL.Actions = {};
iSOL.Actions.layoutresize = function () {
	if ($(window).width() < 700 ) {
		$('.portal .resize').css({"width":$(window).width()});
		//$('div').css({"float":"left","height":"auto"});
	} else if ($(window).width() < 960 ) {
		$('.portal .resize').css({"width":$(window).width(),"margin-left":""});
		//$('div').removeAttr("style");
	} else {
		//$('.portal .resize').css({"width":"970"});
		$('.portal .resize').css({"width":"85%","margin-left":"5%"});
		//$('div').removeAttr("style");
	} 	
	//$BarHeight = $('#bar').height();
	//$('.menu ul').css({"height":$BarHeight});
	
}
/*
iSOL.Actions.getBiblesList = function () {
	$BiblesList = $(_isf('keysearch')+' .version').html();
	$(_isf('lookup')+' .version').html($BiblesList);
}
*/
iSOL.Actions.passageshow = function () {
	$passageForm = $(_isf('lookup'));
	if ($passageForm.is(':visible')) {
		$passageForm.slideUp(300);
		$passageForm.parents('.portal').fadeOut(200);
	} else {
		$passageForm.slideDown(300);
		$passageForm.parents('.portal').fadeIn(200);
	}
}
iSOL.Actions.searchoptions = function () {
	$ref = $(this).attr('id');
	$Name = $(this).parents('form').attr('name');
	$Class = $(_isf($Name)+' '+_isc($ref));
	if ($Class.is(':visible')) {
		$Class.slideUp(300);
		$(this).removeClass('active');
	} else {
		$(this).addClass('active');
		$Class.slideDown(300);
	}
}
iSOL.Actions.ifmessage = function () {
	$portal = $('#search');
	$wrapper = '#search .resize .wrapper .message';
	if ($($wrapper).is(':empty')) {
		//$portal.hide();
		$($wrapper).hide();
	} else {
		//$portal.show();
		$($wrapper).slideDown(300);			
	}
}
iSOL.Actions.SearchSubmit = function () {
	$getBibleslist = iSOL.getBibleslist('form[name="keysearch"] input[name="bibleVersion[]"]:checked');
	$case = $('form[name="keysearch"] input[name="case"]:checked').val();
	
	$type = $(('form[name="keysearch"] select[name="type"]')).val();
	
	$limit = $(('form[name="keysearch"] input[name="limit"]:checked')).val();
	$q = $(('form[name="keysearch"] input[name="search"]')).val();
	$bookset = $(('form[name="keysearch"] select[name="bookset"]')).val();
	$limitspanbegin = $(('form[name="keysearch"] select[name="spanbegin"]')).val();
	$limitspanend = $(('form[name="keysearch"] select[name="spanend"]')).val();
	var FormAction = $(this).attr('action');
	var FormMethod = $(this).attr('method');
	var FormName = $(this).attr("name");

	if ($getBibleslist && $q) {
		$case_ = ($case)?'&case='+$case:'';
		$type_ = (!$type || $type == 'all')?'':'&type='+$type;
		if ($limit == 'bookset') {
			$limitQuery = '&limit='+$limit+'&bookset='+$bookset;
		} else if ($limit == 'span') {
			$limitQuery = '&limit='+$limit+'&from='+$limitspanbegin+'&to='+$limitspanend;
		} else {
			$limitQuery = '';
		}
		$Query = '?q='+ $q +'&bible='+ $getBibleslist +$limitQuery+$case_+$type_;
		window.location = FormAction+$Query;
	} else {
		$('.version').slideDown(300);
	}
	return false;
}

iSOL.Actions.LookupSubmit = function () {
	$getBibleslist = iSOL.getBibleslist('form[name="lookup"] input[name="bibleVersion[]"]:checked');
	$lookup = $(('form[name="lookup"] input[name="lookup"]')).val();
	var FormAction = $(this).attr('action');
	var FormMethod = $(this).attr('method');
	var FormName = $(this).attr("name");

	if ($getBibleslist && $lookup) {
		$Query = '?lookup='+ $lookup +'&bible='+ $getBibleslist;
		window.location = FormAction+$Query;
	} else {
		$('.version').slideDown(300);
	}
	return false;
}
iSOL.getBibleslist = function (q) {
	var checkedList = '';
	$($(q).serializeArray()).each(function(i, field) {
		 checkedList += field.value+',';
	});
	return checkedList.slice(0, -1);
}


	
$(function() {
  iSOL.Actions.layoutresize();
})	
$(document).ready(function() {
  iSOL.Actions.ifmessage();
});
$(window).resize(function() {
  iSOL.Actions.layoutresize();
});
$(window).scroll(function () { 
  iSOL.Actions.layoutresize();
});



$('.options .ver').live("click",iSOL.Actions.searchoptions);
$('form[name="lookup"] input[type="button"]').live("click",iSOL.Actions.searchoptions);
$('.menu ul li.passage').live("click",iSOL.Actions.passageshow);
$('form[name="keysearch"]').live("submit",iSOL.Actions.SearchSubmit);
$('form[name="lookup"]').live("submit",iSOL.Actions.LookupSubmit);



function _isi (q) { return '#'+q; }
function _isc (q) { return '.'+q; }
function _isf (q) { return 'form[name="'+q+'"]'; }
function trip(q) { if (q.match(/[^a-zA-Z0-9 ]/g)) { q = q.replace(/[^a-zA-Z0-9 ]/g, '') } return q.replace(/ /g,'')}

