<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="style/normal_ws.css" type="text/css">
<script src="/js/jquery.min.js"></script>
<script src="/js/json2.min.js"></script>
<script src="/js/jcommon.js"></script>
<script>
$(function(){
	var postVar={topicurl:"setting/getTelnetCfg"};
	postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			var rJson=JSON.parse(Data);
			supplyValue("telnet_enabled",rJson['telnet_enabled']);
		}
    });
});

function doSubmit(){
	var postVar={"topicurl" : "setting/setTelnetCfg"};
	postVar['telnet_enabled']=$('#telnet_enabled').val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title">Telnet</td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left">On/Off</td>
<td><select class="select" id="telnet_enabled">
<option value="0">Off</option>
<option value="1">On</option>
</select></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><input type=button class=button value="Apply" onClick="doSubmit()"></td></tr>
</table>
</td></tr></table>
</body></html>