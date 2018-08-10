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
var rJson;
function initValue(){
	setJSONValue({
		"firewallType"  : rJson['firewallType']
	});
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
}

$(function(){
	var postVar={topicurl:"setting/getFirewallType"};
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

function doSubmit(){
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setFirewallType"};
	postVar['firewallType']=$("#firewallType").val();
	uiPost(postVar);
}
</script>
</head>
<body class=mainbody>
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_FirewallType)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_FirewallType)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_OnOff)</script></td>
<td><select class="select" id="firewallType" onChange="doSubmit()">
<option value="0"><script>dw(MM_AllowList)</script></option>
<option value="1"><script>dw(MM_DenyList)</script></option>
</select></td>
</tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table>
</td></tr></table>
</body></html>