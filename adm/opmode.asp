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
var rJson,rJsonR,wifiIdx="0";
function createApList(){
	$(":input").attr('disabled',true);	
	var postVar={ topicurl : "setting/getWiFiApcliScan"};
	postVar["wifiIdx"]=wifiIdx;
	postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : true, success : function(Data){
			rJson=JSON.parse(Data);
			var _html='';
			for (var i=0;i<rJson.length;i++) {
				var ssid=cs_hex_string(rJson[i].ssid);
				if (ssid.indexOf("<")!=-1) continue;
				if (ssid.indexOf(">")!=-1) continue;
				if (ssid.indexOf("'")!=-1) continue;
				if (ssid.indexOf('"')!=-1) continue;
				if (ssid.indexOf('"')!=-1) continue;
				if (ssid.indexOf('$')!=-1) continue;
				var data_wifi=rJson[i].channel+','+ssid+','+rJson[i].bssid+','+rJson[i].encrypt+','+rJson[i].cipher+','+rJson[i].band;
				_html+='<tr align=center class=item_list data-wifi="'+data_wifi+'" onclick=selectAP(this)>\n';
				_html+='<td>'+rJson[i].channel+'</td>\n';
				_html+='<td>'+showSsidFormat(ssid)+'</td>\n';
				_html+='<td>'+rJson[i].bssid+'</td>\n';
				_html+='<td>'+rJson[i].encrypt+'</td>\n';
				_html+='<td>'+rJson[i].signal+'%</td>\n';
				_html+='<td>'+rJson[i].band+'</td>\n';
				_html+='</tr>\n';
			}
			$("#aplist").empty().append(_html);
			$(":input").attr('disabled',false);	
		}
	});
}

function selectAP(data){
	var channel=$(data).data('wifi').split(",")[0];
	var ssid=$(data).data('wifi').split(",")[1];
	var bssid=$(data).data('wifi').split(",")[2];
	var encrypt=$(data).data('wifi').split(",")[3];
	var cipher=$(data).data('wifi').split(",")[4];
	$("#div_apclienc,#div_apcliformat,#div_apclikey").hide();
	$("#apcliChannel").val(channel);
	$("#apcliSsid").val(ssid).attr("disabled",true);
	$("#apcliBssid").val(bssid);
	$("#bssid1").val(bssid.split(":")[0]).attr("disabled",true);
	$("#bssid2").val(bssid.split(":")[1]).attr("disabled",true);
	$("#bssid3").val(bssid.split(":")[2]).attr("disabled",true);
	$("#bssid4").val(bssid.split(":")[3]).attr("disabled",true);
	$("#bssid5").val(bssid.split(":")[4]).attr("disabled",true);
	$("#bssid6").val(bssid.split(":")[5]).attr("disabled",true);
	$(".select").css('backgroundColor','#ebebe4');
	var f=document.wirelessRepeater;
	if (encrypt=="NONE"){
		f.apcliEncrypType.options[0]=new Option(MM_Disable,"NONE");
		supplyValue("apcliAuthMode","NONE");
		supplyValue("apcliEncrypType","NONE");
	}else if (encrypt=="WEP"){
		$("#div_apclienc,#div_apcliformat,#div_apclikey").show();
		$("#apcliKey").val("").attr("disabled",false);
		f.apcliEncrypType.options[0]=new Option(MM_OpenSystem,"OPEN");
		f.apcliEncrypType.options[1]=new Option(MM_SharedKey,"SHARED");	
		f.apcliEncrypType.options[2]=null;	
		supplyValue("apcliAuthMode","WEP");
		supplyValue("apcliEncrypType","OPEN");
		supplyValue("apcliKeyFormat","0");
		$("#apcliAuthMode").attr("disabled",true);
		$("#apcliEncrypType").attr("disabled",false);
	}else if (encrypt.search("WPA")!=-1){
		$("#div_apclienc,#div_apclikey").show();
		$("#apcliKey").val("").attr("disabled",false);
		f.apcliEncrypType.options[0]=new Option("TKIP","TKIP");
		f.apcliEncrypType.options[1]=new Option("AES","AES");
		f.apcliEncrypType.options[2]=null;
		supplyValue("apcliAuthMode",(encrypt=="WPAPSK")?"WPAPSK":"WPA2PSK");
		supplyValue("apcliEncrypType",(cipher=="TKIP")?"TKIP":"AES");
		supplyValue("apcliKeyFormat","0");
		$("#apcliAuthMode,#apcliEncrypType").attr("disabled",true);
	}
	$("#connect").attr("disabled",false);
	$("#div_aplist").hide();
	$("#div_repeater_setting").show();
	$("#div_aplist_info").html(JS_msg54);
}

function saveChanges(){
	var apcli_auth_mode_index=$('#apcliAuthMode')[0].selectedIndex;
	var apcli_keytype_index=$('#apcliKeyFormat')[0].selectedIndex;
	var checkbox = $('input[id="checkbox"]:checked').val();
	if (apcli_auth_mode_index==1){
		if(checkbox == "on"){
			$("#apcliKey").val($("#apcliKey2").val());
		}else{
			$("#apcliKey").val($("#apcliKey1").val());
		}
		var wepkey=$("#apcliKey").val();
		if (apcli_keytype_index==0){//hex
			if (wepkey.length==10||wepkey.length==26){
				if (!checkVaildVal.IsVaildWiFiPass(wepkey,MM_Password,"hex"))return false;
			}else{
				alert(JS_msg34);return false;
			}
		}else{//ascii
			if (wepkey.length==5||wepkey.length==13){
				if (!checkVaildVal.IsVaildWiFiPass(wepkey,MM_Password,"ascii"))return false;
			}else{
				alert(JS_msg35);return false;
			}
		}
	}else if (apcli_auth_mode_index>=2){
		if(checkbox == "on"){
			$("#apcliKey").val($("#apcliKey2").val());
		}else{
			$("#apcliKey").val($("#apcliKey1").val());
		}
		var wpakey=$("#apcliKey").val();
		if (apcli_keytype_index==0){//hex
			if (wpakey.length!=64){alert(JS_msg25);return false;}
			if (!checkVaildVal.IsVaildWiFiPass(wpakey,MM_Password,"hex"))return false;
		}else{
			if (wpakey.length<8||wpakey.length>63){alert(JS_msg24);return false;}		
			if (!checkVaildVal.IsVaildWiFiPass(wpakey,MM_Password,"ascii"))return false;
		}
	}	
	return true;
}

function updatePassType(){
	var checkbox = $('input[id="checkbox"]:checked').val();
	if(checkbox == "on"){
		$("#apcliKey").val($("#apcliKey1").val()); 
		$("#apcliKey2").val($("#apcliKey1").val());
		$("#div_apcliKey1").hide();
		$("#div_apcliKey2").show();
	}else{
		$("#apcliKey1").val($("#apcliKey2").val());
		$("#apcliKey").val($("#apcliKey2").val());
		$("#div_apcliKey1").show();//p
		$("#div_apcliKey2").hide();//t
	}
}

function updateKeyFormat(){
	var apcli_auth_mode_index=$('#apcliAuthMode')[0].selectedIndex;
	var apcli_keytype_index=$('#apcliKeyFormat')[0].selectedIndex;
	if (apcli_auth_mode_index==1){
		if (apcli_keytype_index==0){//hex
			$("#apcliKey").attr("maxlength",26);
		}else{
			$("#apcliKey").attr("maxlength",13);
		}
	}else if (apcli_auth_mode_index>=2){
		if (apcli_keytype_index==0){//hex
			$("#apcliKey").attr("maxlength",64);
		}else{
			$("#apcliKey").attr("maxlength",63);
		}
	}
}

$(function(){
	var postVar={topicurl:"setting/getOpMode"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJsonR=JSON.parse(Data);
			supplyValue("opmode",rJsonR['operationMode']);	
			if (rJsonR['operationMode']>1){
				$("#apply").hide();
				$("#next").show();
			}else{
				$("#apply").show();
				$("#next").hide();
			}
		}
    });
	$(":radio[name=opmode]").click(function(){
		if(this.value>1){
			$("#apply").hide();
			$("#next").show();
		}else{
			$("#apply").show();
			$("#next").hide();
		}
	});
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function doSubmit(){
	var postVar={"topicurl":"setting/setOpMode"};
	postVar['operationMode']=$(':radio[name=opmode]:checked').val();
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){});
	lanip=location.host;
	wtime=30;
	waitpage();
	do_count_down();
}

function doNext(){
	$("#div_opmode").hide();
	$("#div_repeater,#div_aplist_info").show();
	$("#div_aplist_info").html(JS_msg53);
}

function doBack(type){
	if (type==1){
		$("#div_opmode").show();
		$("#div_repeater,#div_aplist_info").hide();
	}else{
		$("#div_aplist").show();
		$("#div_repeater_setting").hide();
		$("#div_aplist_info").html(JS_msg53);
	}
}

function doConnect(){
	if (saveChanges()==false) return false;
	var postVar={"topicurl":"setting/setWiFiRepeaterConfig"};
	postVar['apcliSsid']=$('#apcliSsid').val();
	postVar['apcliBssid']=$('#apcliBssid').val();
	postVar['apcliChannel']=$('#apcliChannel').val();
	postVar['apcliAuthMode']=$('#apcliAuthMode').val();
	postVar['apcliEncrypType']=$('#apcliEncrypType').val();
	postVar['apcliKeyFormat']=$('#apcliKeyFormat').val();
	postVar['apcliKey']=$('#apcliKey').val();
	postVar['operationMode']=$(':radio[name=opmode]:checked').val();
	postVar['wifiIdx']=wifiIdx;
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){});
	lanip=location.host;
	wtime=40;
	waitpage();
	do_count_down();
}
</script>
</head>

<body class="mainbody">
<div id="div_body_setting">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_OperationMode)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_OperationMode)</script><div id="div_aplist_info" style="display:none"><script>dw(JS_msg53)</script></div></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<div id="div_opmode">
<table border=0 width="100%">
<tr>
<td class="item_left"><input type="radio" value="0" name="opmode"> <b><script>dw(MM_GatewayMode)</script></b></td>
<td><script>dw(MSG_GatewayMode)</script><br></td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<tr>
<td class="item_left"><input type="radio" value="1" name="opmode"> <b><script>dw(MM_BridgeMode)</script></b></td>
<td><script>dw(MSG_BridgeMode)</script><br></td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<tr>
<td class="item_left"><input type="radio" value="2" name="opmode"> <b><script>dw(MM_RepeaterMode)</script></b></td>
<td><script>dw(MSG_RepeaterMode)</script><br></td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<tr>
<td class="item_left"><input type="radio" value="3" name="opmode"> <b><script>dw(MM_WispMode)</script></b></td>
<td><script>dw(MSG_WispMode)</script><br></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" id=apply onClick="doSubmit()"><input type=button class=button value="'+BT_Next+'" id=next onClick="doNext()">')</script></td></tr>
</table>
</div>

<div id="div_repeater" style="display:none">
<div id="div_aplist">
<br />
<table border=0 width="100%">
<tr><td colspan="6" align="right"><script>dw('<input type=button class=button value="'+BT_Back+'" onClick="doBack(1)">&nbsp;&nbsp;<input type=button class=button value='+BT_Scan+' onClick="createApList()">')</script></td></tr>
<tr><td colspan="6" height="10"></td></tr>
<tr><td colspan="6" height="1" class="line"></td></tr>
<tr align="center">
<td class="item_center"><b><script>dw(MM_Channel)</script></b></td>
<td class="item_center"><b><script>dw(MM_Ssid)</script></b></td>
<td class="item_center"><b><script>dw(MM_Mac)</script></b></td>
<td class="item_center"><b><script>dw(MM_SecurityMode)</script></b></td>
<td class="item_center"><b><script>dw(MM_Signal)</script></b></td>
<td class="item_center"><b><script>dw(MM_Mode)</script></b></td>
</tr>
<tbody id="aplist"></tbody>
<tr><td colspan="6" height="1" class="line"></td></tr>
</table>
</div>

<div id="div_repeater_setting" style="display:none">
<form name="wirelessRepeater">
<input type="hidden" id="apcliChannel">
<table border=0 width="100%"> 
<tr> 
<td class="item_left"><script>dw(MM_Ssid)</script></td>
<td><input type="text" class="text" id="apcliSsid" disabled></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_Mac)</script></td>
<td><input type="hidden" id="apcliBssid"><input type="text" class="text3" maxlength="2" id="bssid1" disabled><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" id="bssid2" disabled><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" id="bssid3" disabled><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" id="bssid4" disabled><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" id="bssid5" disabled><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" id="bssid6" disabled></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_SecurityMode)</script></td>
<td><select class="select" id="apcliAuthMode" disabled> 
<option value="NONE"><script>dw(MM_Disable)</script></option>
<option value="WEP">WEP</option>
<option value="WPAPSK">WPA-PSK</option>
<option value="WPA2PSK">WPA2-PSK</option>
</select></td>
</tr>
<tr id="div_apclienc" style="display:none"> 
<td class="item_left"><script>dw(MM_EncrypType)</script></td>
<td><select class="select" name="apcliEncrypType" id="apcliEncrypType" disabled></select></td>
</tr>
<tr id="div_apcliformat" style="display:none"> 
<td class="item_left"><script>dw(MM_KeyFormat)</script></td>
<td><select class="select" id="apcliKeyFormat" onChange="updateKeyFormat()" disabled>
<option value="1">Hex</option>
<option value="0">ASCII</option>
</select>&nbsp;&nbsp;<script>dw("("+JS_msg121+")");</script></td>
</tr>
<tr id="div_apclikey" style="display:none">
<td class="item_left"><script>dw(MM_Password)</script></td>
<td><input type="hidden" id="apcliKey"><span id="div_apcliKey1"><input type="password" class="text" id="apcliKey1" maxlength="64"></span><span id="div_apcliKey2" style="display:none"><input type="text" class="text" id="apcliKey2" maxlength="64"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="checkbox" onChange="updatePassType()"></td>
</tr>
</table>
</form>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Back+'" onClick="doBack(2)">&nbsp;&nbsp;&nbsp;&nbsp;<input type=button class=button value="'+BT_Connect+'" id=connect disabled onClick="doConnect()">')</script></td></tr>
</table>
</div>
</div>
</td></tr></table>
</div>

<div id="div_wait" style="display:none">
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_ChangeSetting)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><script>dw(JS_msg75)</script></td></tr>
<tr><td><script>dw(MM_PleaseWait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table></td></tr></table>
</div>
</body></html>