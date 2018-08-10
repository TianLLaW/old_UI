<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="style/normal_ws.css" type="text/css">
<script src="/js/jquery.min.js"></script>
<script src="/js/json2.min.js"></script>
<script>
var i = 1;
$(function(){
	$('#addTextInput').click(function(){
        if(i < 100) {
  	        var tmp = '<tr><td align="right" width="20%"><span><b>'+ $("#parent_text").val() + ':</b></span></td>';
			tmp += '<td align="center" width="50%"><input type="text" name="'+ $("#parent_text").val() +'" value="' +$("#parent_value").val() +'" size="40"></td>';
			tmp += '<td align="left" width="30%"><input type="button" class="del-text" value="del" onClick="deleteElement(this)"></td></tr>';
		    $('#tableinput').append(tmp);
		    i++;
         } else {
            alert("最多加100个");
         }
    });
	var postVar = { topicurl : "setting/getSysStatusCfg"};
    postVar = JSON.stringify(postVar);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		$('#showdata').val(Data);
	});
});
function deleteElement(objid){
	$(objid).parent().parent().remove();
}
function uiSubmit(){
	var postVar ='{';
	$("#tableinput input:text").each(function(){
		postVar += '"' + this.name + '"' + ' : "' + this.value + '",';
	});
	postVar = postVar.substring(0,postVar.length - 1);
	postVar += '}';
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		$('#showdata').val(Data);
	});
}
function GET_Topic(){
	var postVar ={};
	postVar["topicurl"]= $('#GETtopicurl').val();
    postVar["ssid"]= $('#ssid').val();
	postVar = JSON.stringify(postVar);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		$('#showdata').val(Data);
	});
}
</script>
</head>
<body class="mainbody">
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title">TEST</td></tr>
<tr><td height="1" class="line"></td></tr>
</table>
<table border=0 width="100%">
<tr>
	<td align="center">
		<span>Name :</span><input type="txt" value="" id="parent_text">
		<span>Value:</span><input type="txt" value="" id="parent_value">
		<input type="button" value="add" id="addTextInput">
	</td>
</tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%" id="tableinput">
<tr>
	<td align="right" width="20%"><b>topicurl:</b></td>
	<td align="center" width="50%"><input type="text" name="topicurl" value="setting/setInicAdvancedConfig" size="40" /></td>
	<td align="left" width="30%"><input type="button"  value="del" onClick="deleteElement(this)" disabled="true" /></td>
</tr>
</table>

<table border=0 width="100%">
<tr>
	<td align="right">
		<input type="button" class="button" value="Submit" id="submit" onClick="uiSubmit()">
	</td>
</tr>
<tr><td height="1" class="line"></td></tr>
<tr>
	<td>
		<textarea name="showdata" id="showdata" style="font-size:9pt;width:100%" rows="10" wrap="off"></textarea>
	</td>
</tr>
<tr>
	<td align="right">
		<b>Topic:</b><input type="txt" value="setting/getSysStatusCfg" id="GETtopicurl" size="40" />
		<input type="button" class="button" value="GET" name="GET" id="GET" onClick="GET_Topic()">
	</td>
</tr>
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
</table>
</td></tr></table>
</body></html>