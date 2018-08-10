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
var rJson,iptvEn,proxyEn,snoopEn,tag;
function setbackgroundValue(){
	setJSONValue({
		"mode"			: 	rJson['serviceType'],
		"InternetVid"		:	rJson['internetVid'],
		"InternetPri"		:	rJson['internetPri'],
		"IpPhoneVid"		:	rJson['ipPhoneVid'],
		"IpPhonePri"		:	rJson['ipPhonePri'],
		"IptvVid"		:	rJson['iptvVid'],
		"IptvPri"		:	rJson['iptvPri'],
		"lan1"			:	rJson['lan1'],
		"lan2"			:	rJson['lan2'],
		"lan3"			:	rJson['lan3'],
		"lan4"			:	rJson['lan4']
	});
	if(rJson['tagFlag']==1){
		tag = document.getElementById('tagflag');
		tag.checked=true;
	}else{
		tag = document.getElementById('tagflag');
		tag.checked=false;
	}
}
function initValue()
{
	setJSONValue({
		"IgmpVer"		:	rJson['IgmpVer'],
		"mode"			: 	rJson['serviceType'],
		"InternetVid"		:	rJson['internetVid'],
		"InternetPri"		:	rJson['internetPri'],
		"IpPhoneVid"		:	rJson['ipPhoneVid'],
		"IpPhonePri"		:	rJson['ipPhonePri'],
		"IptvVid"		:	rJson['iptvVid'],
		"IptvPri"		:	rJson['iptvPri'],
		"tagflag"		:	rJson['tagFlag'],
		"lan1"			:	rJson['lan1'],
		"lan2"			:	rJson['lan2'],
		"lan3"			:	rJson['lan3'],
		"lan4"			:	rJson['lan4']
	});
	
	if(0 == rJson['IgmpProxyEn']){
		proxyEn = document.getElementById('IgmpProxyEn');
		proxyEn.checked=true;
	}else{
		proxyEn = document.getElementById('IgmpProxyEn');
		proxyEn.checked=false;
	}
	if(1 == rJson['iptvEnabled']){
		iptvEn = document.getElementById('iptvEnable');
		iptvEn.checked=true;
		$("#vlan_div,#lan_div,#mode_div").show();
	}else{
		iptvEn = document.getElementById('iptvEnable');
		iptvEn.checked=false;
		$("#vlan_div,#lan_div,#mode_div").hide();
	}
	if(1 == rJson['IgmpSnoopEn']){
		snoopEn = document.getElementById('IgmpSnoopEn');
		snoopEn.checked=true;
	}else{
		snoopEn = document.getElementById('IgmpSnoopEn');
		snoopEn.checked=false;
	}
	if(1 == rJson['tagFlag']){
		tag = document.getElementById('tagflag');
		tag.checked=true;
	}else{
		tag = document.getElementById('tagflag');
		tag.checked=false;
	}
	if($("#mode").val()==0){
		$("#InternetVid,#InternetPri,#tagflag,#IpPhoneVid,#IpPhonePri,#IptvVid").attr("disabled",false);
		$("#InternetPri,#IpPhonePri,#IptvPri,#lan1,#lan2,#lan3,#lan4").attr("disabled",false).removeClass("select-dis").addClass("select");
	}else{
		$("#InternetVid,#tagflag,#IpPhoneVid,#IptvVid,#IptvPri").attr("disabled",true);
		$("#InternetPri,#IpPhonePri,#IptvPri,#lan1,#lan2,#lan3,#lan4").attr("disabled",true).removeClass("select").addClass("select-dis");
	}

	if(rJson['serviceType']==2 || rJson['serviceType']==1){
		$("#ipPhone_vid").hide();
	}
	else{
		$("#ipPhone_vid").show();
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

function iptvSwitch()
{
	if($("#iptvEnable").is(":checked")){
		$("#vlan_div,#lan_div,#mode_div").show();
		updateMode();
	}else{
		$("#vlan_div,#lan_div,#mode_div").hide();
	}
}
function updateMode()
{
	if($("#mode").val()==3){//Malaysia-Maxis
		$("#InternetVid").val("621");
		$("#InternetPri").val("0");
		$("#IptvVid").val("823");
		$("#IptvPri").val("0");
		$("#IpPhoneVid").val("822");
		$("#IpPhonePri").val("0");
		$("#lan1").val("1");
		$("#lan2,#lan3").val("3");
		$("#lan4").val("2");
	}else if($("#mode").val()==2){//Malaysia-Unifi
		$("#InternetVid").val("500");
		$("#InternetPri").val("0");
		$("#IptvVid").val("600");
		$("#IptvPri").val("0");
		$("#lan1").val("1");
		$("#lan2,#lan3,#lan4").val("3");
	}else if($("#mode").val()==1){//Singapore-Singtel
		$("#InternetVid").val("10");
		$("#InternetPri").val("0");
		$("#IptvVid").val("20");
		$("#IptvPri").val("4");
		$("#lan1").val("1");
		$("#lan2,#lan3,#lan4").val("3");
	}else if($("#mode").val()==4){//VTV
		$("#InternetVid").val("35");
		$("#InternetPri").val("0");
		$("#IptvVid").val("36");
		$("#IptvPri").val("4");
		$("#IpPhoneVid").val("37");
		$("#IpPhonePri").val("5");
		$("#lan1").val("1");
		$("#lan3").val("2");
		$("#lan2,#lan4").val("3");
	}else{//user define
		$("#InternetVid").val("1");
		$("#InternetPri").val("0");
		$("#IptvVid").val("2");
		$("#IptvPri").val("0");
		$("#IpPhoneVid").val("3");
		$("#IpPhonePri").val("0");
		$("#lan1").val("1");
		$("#lan2").val("2");
		$("#lan3,#lan4").val("3");
		if(rJson['serviceType']=="0")setbackgroundValue();
	}
	if($("#mode").val()==0){
		$("#InternetVid,#InternetPri,#tagflag,#IpPhoneVid,#IpPhonePri,#IptvVid").attr("disabled",false);
		$("#InternetPri,#IpPhonePri,#IptvPri,#lan1,#lan2,#lan3,#lan4").attr("disabled",false).removeClass("select-dis").addClass("select");
	}else{
		$("#InternetVid,#tagflag,#IpPhoneVid,#IptvVid,#IptvPri").attr("disabled",true);
		$("#InternetPri,#IpPhonePri,#IptvPri,#lan1,#lan2,#lan3,#lan4").attr("disabled",true).removeClass("select").addClass("select-dis");
		tag = document.getElementById('tagflag');
		tag.checked=true;
	}
	
	if($("#mode").val()==1 || $("#mode").val()==2){
		$("#ipPhone_vid").hide();
	}else{
		$("#ipPhone_vid").show();
	}
}

function saveChanges(){
	if($("#mode").val()==0){//User
		if(!checkVaildVal.IsVaildNumberRange($('#IptvVid').val(), "IPTV "+MM_VlanVID, 1, 4094)) return false;
		if(!checkVaildVal.IsVaildNumberRange($('#IpPhoneVid').val(), "IP-Phone "+MM_VlanVID, 1, 4094)) return false;
		if(!checkVaildVal.IsVaildNumberRange($('#InternetVid').val(), "Internet "+MM_VlanVID, 1, 4094)) return false;

		if($("#tagflag").is(":checked")){
			if($('#IptvVid').val()==$('#IpPhoneVid').val()||$('#IpPhoneVid').val()==$('#InternetVid').val()||$('#IptvVid').val()==$('#InternetVid').val()){
				alert(JS_msg143);
				return false;
			}
		}else{
			if(($("#lan1").val()==1 && ($("#lan2").val()==2 || $("#lan3").val()==2 || $("#lan4").val()==2))
			|| ($("#lan2").val()==1 && ($("#lan1").val()==2 || $("#lan3").val()==2 || $("#lan4").val()==2))
			|| ($("#lan3").val()==1 && ($("#lan1").val()==2 || $("#lan2").val()==2 || $("#lan4").val()==2))
			|| ($("#lan4").val()==1 && ($("#lan1").val()==2 || $("#lan3").val()==2 || $("#lan3").val()==2))){
				if($('#IptvVid').val()!=$('#IpPhoneVid').val() || $("#IptvPri").val()!=$("#IpPhonePri").val()){
					alert(JS_msg144);
					return false;
				}
			}
		}
	}
	return true;
}

function doSubmit()
{
	if(saveChanges()==false) return false;
	var postVar = {"topicurl" : "setting/setIptvConfig"};
	postVar['IgmpVer'] = $("#IgmpVer").val();
	postVar['ServiceType'] = $("#mode").val();
	postVar['IptvVid'] = $("#IptvVid").val();
	postVar['IptvPri'] = $("#IptvPri").val();
	postVar['IpPhoneVid'] = $("#IpPhoneVid").val();
	postVar['IpPhonePri'] = $("#IpPhonePri").val();
	postVar['InternetVid'] = $("#InternetVid").val();
	postVar['InternetPri'] = $("#InternetPri").val();
	postVar['lan1']=$("#lan1").val();
	postVar['lan2']=$("#lan2").val();
	postVar['lan3']=$("#lan3").val();
	postVar['lan4']=$("#lan4").val();
	
	if($("#IgmpProxyEn").is(":checked"))
		postVar['IgmpProxyEn'] = "0"
	else
		postVar['IgmpProxyEn'] = "1"

	if($("#IgmpSnoopEn").is(":checked"))
		postVar['IgmpSnoopEn'] ="1"
	else
		postVar['IgmpSnoopEn'] ="0"

	if($("#iptvEnable").is(":checked"))
		postVar['iptvEnable'] = "1"
	else 
		postVar['iptvEnable'] = "0"
		
	if ($("#tagflag").is(":checked"))
		postVar['tagFlag']="1";
	else
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

<table border=0 width="100%" style="padding-top: 10px">
<tr>
<td class="item_left"><script>dw(MM_IgmpProxy)</script></b></td>
<td><input type="Checkbox" id="IgmpProxyEn" checked="checked"><span>&nbsp;&nbsp;&nbsp;<script>dw(MM_Enable)</script></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_IgmpSnooping)</script></td>
<td><input type="Checkbox" id="IgmpSnoopEn" checked="checked"><span>&nbsp;&nbsp;&nbsp;<script>dw(MM_Enable)</script></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_IgmpVer)</script></td>
<td><select class="select3" id="IgmpVer" >
<option value="0">V2</option>
<option value="1">V3</option>
</select></td>
</tr>
</table>

</br>
<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_IPTV)</script></td>
<td><input type="Checkbox" id="iptvEnable" checked="checked" onClick="iptvSwitch()"><span>&nbsp;&nbsp;&nbsp;<script>dw(MM_Enable)</script></span></td>
</tr>
<tr id="mode_div">
<td class="item_left"><script>dw(MM_Mode)</script></td>
<td><select class="select" id="mode" onChange="updateMode()" style="">
<option value="1">Singapore-Singtel</option>
<option value="2">Malaysia-Unifi</option>
<option value="3">Malaysia-Maxis</option>
<option value="4">VTV</option>
<option value="0">User Define</option>
</select></td>
</tr>
</table>

</br>
<table border=0 width="100%" id="vlan_div">
<tr id="internet_vid">
<td class="item_left"><script>dw(MM_InternetVID)</script></td>
<td><input type="text" class="text4" id="InternetVid" maxlength="4" value=""></td>
<td class="item_center2"><script>dw(MM_InternetPri)</script></td>
<td><select id="InternetPri" class="select3">
<option value="0">0</option>
<option value="1">1</option>
<option value="2">2</option>
<option value="3">3</option>
<option value="4">4</option>
<option value="5">5</option>
<option value="6">6</option>
<option value="7">7</option>
</select></td>
<td><input type="Checkbox" id="tagflag" checked="checked">&nbsp;802.1Q Tag</td>
</tr>
<tr id="ipPhone_vid" style="display: none">
<td class="item_left"><script>dw(MM_PhoneVID)</script></td>
<td><input type="text" class="text4" id="IpPhoneVid" maxlength="4" value="">
<td class="item_center2"><script>dw(MM_PhonePri)</script></td>
<td><select id="IpPhonePri" class="select3">
<option value="0">0</option>
<option value="1">1</option>
<option value="2">2</option>
<option value="3">3</option>
<option value="4">4</option>
<option value="5">5</option>
<option value="6">6</option>
<option value="7">7</option>
</select></td>
</tr>
<tr id="iptv_vid">
<td class="item_left"><script>dw(MM_IptvVID)</script></td>
<td><input type="text" class="text4" id="IptvVid" maxlength="4" value="">
<td id="item_center2"><script>dw(MM_IptvPri)</script></td>
<td><select id="IptvPri" class="select3">
<option value="0">0</option>
<option value="1">1</option>
<option value="2">2</option>
<option value="3">3</option>
<option value="4">4</option>
<option value="5">5</option>
<option value="6">6</option>
<option value="7">7</option>
</select></td>
</tr>
</table>
</br>

<table border=0 width="100%" id="lan_div">
<tr>
<td class="item_left">LAN1</td>
<td><select class="select" id="lan1">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
<tr>
<td class="item_left">LAN2</td>
<td><select class="select" id="lan2">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
<tr>
<td class="item_left">LAN3</td>
<td><select class="select" id="lan3">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
<tr>
<td class="item_left">LAN4</td>
<td><select class="select" id="lan4">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
</table>

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
