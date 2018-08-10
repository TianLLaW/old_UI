<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="/style/normal_ws.css" rel="stylesheet" type="text/css">
<script src="/js/jquery.min.js"></script>
<script src="/js/load.js"></script>
<script src="/js/jcommon.js"></script>
<script src="/js/json2.min.js"></script>
<script>
var rJson,iptvEn;
function initValue()
{
	if(1 == rJson['iptvEnabled']){
		iptvEn = document.getElementById('iptvEnable');
		iptvEn.checked=true;
	}else{
		iptvEn = document.getElementById('iptvEnable');
		iptvEn.checked=false;
	}
}

$(function()
{
	var postVar={topicurl:"setting/getIptvConfig"};
	 postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", 
       	url : " /cgi-bin/cstecgi.cgi", 
       	data : postVar, 
       	async : false, 
       	success : function(Data){
			rJson=JSON.parse(Data);
		}
	});
	initValue();
});

function doSubmit()
{
	var postVar = {"topicurl" : "setting/setIptvConfig"};
	postVar['IgmpVer'] = "1";
	postVar['ServiceType'] = "0";
	postVar['IptvVid'] = "20";
	postVar['IptvPri'] = "0";
	postVar['IpPhoneVid'] = "30";
	postVar['IpPhonePri'] = "0";
	postVar['InternetVid'] = "10";
	postVar['InternetPri'] = "0";
	postVar['lan1']="1";
	postVar['lan2']="3";
	postVar['lan3']="3";
	postVar['lan4']="3";
	
	postVar['IgmpProxyEn'] = "0";

	postVar['IgmpSnoopEn'] ="0";

	if($("#iptvEnable").is(":checked"))
		postVar['iptvEnable'] = "1"
	else 
		postVar['iptvEnable'] = "0"
		
	postVar['tagFlag']="0";
		
	postVar['addEffect'] = "0";
	uiPost2(postVar); 
}
</script>
</head>
<body class="mainbody">
<div id="div_body_setting">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_IptvSetup)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_IptvSetup)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>
</br>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_IPTV)</script></td>
<td><input type="Checkbox" id="iptvEnable" checked="checked"><span>&nbsp;&nbsp;&nbsp;<script>dw(MM_Enable)</script></span></td>
</tr>
</table>
</br>

<table border=0 width="100%">
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</td></tr></table>
</div>

<div id="div_wait" style="display:none">
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_ChangeSetting)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><span id=show_msg></span></td></tr>
<tr><td><script>dw(MM_PleaseWait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table></td></tr></table>
</div>
</body></html>
