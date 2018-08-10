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
		"wanPingFilter"  	: rJson['wanPingFilter'],
		"l2tpPassThru" 		: rJson['l2tpPassThru'],
		"pptpPassThru" 		: rJson['pptpPassThru'],
		"ipsecPassThru" 	: rJson['ipsecPassThru']
	});
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
}
$(function(){	
	var postVar={topicurl:"setting/getVpnPassCfg"};
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
	var postVar={topicurl:"setting/setVpnPassCfg"};
	$(".select").css('backgroundColor','#ebebe4');
	postVar['wanPingFilter']=$("#wanPingFilter").val();
	postVar['l2tpPassThru']=$("#l2tpPassThru").val();
	postVar['pptpPassThru']=$("#pptpPassThru").val();
	postVar['ipsecPassThru']=$("#ipsecPassThru").val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_VpnPass)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_VpnPass)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_WanPing)</script></td>
<td><select class="select" id="wanPingFilter">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_L2tpPass)</script></td>
<td><select class="select" id="l2tpPassThru">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_PptpPass)</script></td>
<td><select class="select" id="pptpPassThru">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_IpsecPass)</script></td>
<td><select class="select" id="ipsecPassThru">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</td></tr></table>
</body></html>