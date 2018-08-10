<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="/style/normal_ws.css" rel="stylesheet" type="text/css">
<script src="/js/jquery.min.js"></script>
<script src="/js/json2.min.js"></script>
<script src="/js/load.js"></script>
<script src="/js/jcommon.js"></script>
<script>
var rJson,rules_num=0;
function disableAddFiled(){
	setDisabled("#add,#url",true);
}
function disableDelButton(){
	setDisabled("#delsel,#delreset",true);
}

function initValue(){
	rules_num=rJson.length-1;
	supplyValue("enable",rJson[0].enable);
	if (rJson[0].enable==0){
		disableAddFiled();
		disableDelButton();
	}
	if (rules_num==0) disableDelButton();
	var trNode;
	var urlFilterListTab=$("#div_urlFilterList").get(0);
	for(var i=1;i<rJson.length;i++){
		trNode=urlFilterListTab.insertRow(-1);
		trNode.align="center";
		trNode.className="item_center2";
		trNode.insertCell(0).innerHTML=rJson[i].idx;		
		trNode.insertCell(1).innerHTML=rJson[i].url;
		trNode.insertCell(2).innerHTML='<input type=\"checkbox\" id=\"'+rJson[i].delRuleName+'\" value=\"'+rJson[i].delRuleName+'\">';	
	}
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
}

$(function(){
	var postVar={topicurl:"setting/getUrlFilterRules"};
    postVar=JSON.stringify(postVar);	
	$.when( $.post( " /cgi-bin/cstecgi.cgi", postVar))
    .done(function( Data) {
		rJson = JSON.parse(Data);
		initValue();
	})
	.fail(function(){
		setTimeout("resetForm();","3000");
	});
});

function saveChanges(){
	if (rules_num >= 10){
		alert(JS_msg28);
		return false;
	}
	if (!checkVaildVal.IsVaildString($("#url").val(),MM_UrlKeyword,1)) return false;
	for (var i=1; i<rJson.length; i++){
		if ($("#url").val().toLowerCase()==rJson[i].url.toLowerCase()){
			alert(JS_msg29);
			return false;
		}
	}	
	return true;
}

function doSubmit(){	
	if (saveChanges()==false) return false;
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setUrlFilterRules"};
	postVar['url']=$("#url").val();
	postVar['addEffect']="0";
	uiPost(postVar);
}

function updateState(){
	if ($("#enable").get(0).selectedIndex==0){
		disableAddFiled();
		disableDelButton();
	}
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setUrlFilterRules"};
	postVar['enable']=$("#enable").val();
	postVar['addEffect']="1";
	uiPost(postVar);
}	

function deleteClick(){	
	var flg=0;
	var postVar={"topicurl":"setting/delUrlFilterRules"};
    for (i=0; i<rules_num; i++){
		var tmp=$("#delRule"+i).get(0);
		if (tmp.checked==true){
			postVar['delRule'+i]=i;
			flg=1;
		}
	}
	if(flg==0){
		alert(JS_msg36);
	 	return false;
	}
	if( !confirm(JS_msg130) )	return false;
	if(flg==1){
		$(".select").css('backgroundColor','#ebebe4');
		uiPost(postVar);
	}
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_UrlFiltering)</script></td></tr> 
<tr><td class="content_help"><script>dw(MSG_UrlFiltering)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_OnOff)</script></td>
<td><select class="select" id="enable" onChange="updateState()">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table>

<table border=0 width="100%"> 
<tr><td colspan="2"><b><script>dw(MM_AddRule)</script></b></td></tr>
<tr>
<td class="item_left"><script>dw(MM_UrlKeyword)</script></td>
<td><input type="text" class="text" id="url" maxlength="32"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Add+'" id="add" onClick="doSubmit()">')</script></td></tr>
</table>

<table border=0 width="100%"> 
<tr><td colspan="3"><b><script>dw(MM_UrlFilteringTbl)</script>&nbsp;<script>dw(JS_msg59)</script></b></td></tr>
<tr><td colspan="3" height="1" class="line"></td></tr>
<tr><td colspan="3" height="2"></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_UrlKeyword)</script></b></td>
<td class="item_center"><b><script>dw(MM_Select)</script></b></td>
</tr>
<tbody id="div_urlFilterList"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Delete+'" id="delsel" onClick="deleteClick()">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="button" value="'+BT_Reset+'" id="delreset" onClick="resetForm()">')</script></td></tr>
</table>
</td></tr></table>
</body></html>