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
var rJson,v_csid;
var v_wifiOff,v_regDomain,v_authMode,v_encrypType,v_keyFormat,v_wepkey,v_wpakey,v_bw;
var v_wscDisabled,v_apcliEnable,v_ntpEnabled,v_wifiSchEnabled,v_countryBt;

function CreateWirelessMode(){	
	var new_options,new_values;
	new_options = ['2.4 GHz (B)','2.4 GHz (G)','2.4 GHz (N)','2.4 GHz (B+G+N)','2.4 GHz (B+G+N+AC)'];
	new_values  = ['1','4','6','9','75'];			
	CreateOptions("band",new_options,new_values);
}

function CreateCountry(val){
	var new_options,new_values;
	new_options=[MM_China,MM_Usa,MM_Europe,MM_Indonesia,MM_Japan,MM_Other];
	new_values=['CN','US','EU','IA','JP','OT'];	
	CreateOptions("countryStr",new_options,new_values);
	if (val.indexOf("CN")==-1){$("#countryStr option[value='CN']").remove();}
	if (val.indexOf("US")==-1){$("#countryStr option[value='US']").remove();}
	if (val.indexOf("EU")==-1){$("#countryStr option[value='EU']").remove();}
	if (val.indexOf("IA")==-1){$("#countryStr option[value='IA']").remove();}
	if (val.indexOf("JP")==-1){$("#countryStr option[value='JP']").remove();}
	if (val.indexOf("OT")==-1){$("#countryStr option[value='OT']").remove();}
}

function CreateAuthMode(){
	var new_values=["NONE","OPEN","SHARED","WPAPSK","WPA2PSK","WPAPSKWPA2PSK"];
	var new_options=[MM_Disable,"WEP-"+MM_OpenSystem,"WEP-"+MM_SharedKey,"WPA-PSK","WPA2-PSK","WPA/WPA2-PSK"];
	CreateOptions("authMode",new_options,new_values);
}

function CreateEncrypType(){
	var new_options,new_values;
	switch($("#authMode").val()){
		case "NONE":
			new_values =["NONE"];
			new_options=[MM_Disable];
			break;
		case "OPEN":
		case "SHARED":
			new_values =["WEP64","WEP128"];
			new_options=["WEP64","WEP128"];
			break;
		case "WPAPSK":
			new_values =["TKIP","AES"];
			new_options=["TKIP","AES"];
			break;
		default:
			new_values =["TKIP","AES","TKIPAES"];
			new_options=["TKIP","AES","TKIP/AES"];
			break;
	}
	CreateOptions("encrypType",new_options,new_values);
}

function SetAuthMode(){
	supplyValue("authMode",v_authMode);
	supplyValue("encrypType",v_encrypType);
	$("#div_encryp_type,#div_key_format,#div_wepkey,#div_wpakey").hide();
	$("#wepkey,#wpakey").attr("disabled",true);
	CreateEncrypType();
	SetEncrypType();
}

function SetEncrypType(){
	switch($("#authMode").val()){
		case "NONE":
			supplyValue("encrypType","NONE");
			break;
		case "OPEN":
		case "SHARED":
			$("#div_encryp_type,#div_key_format,#div_wepkey").show();
			$("#wepkey").attr("disabled",false);				
			if (v_wepkey.length==5||v_wepkey.length==10){
				supplyValue("encrypType","WEP64");
			}else{
				supplyValue("encrypType","WEP128");
			}
			supplyValue("keyFormat",v_keyFormat);
			supplyValue("wepkey",v_wepkey);
			updateEncrypType();
			$("#wepkey1").val($("#wepkey").val());
			break;
		default:
			$("#div_encryp_type,#div_key_format,#div_wpakey").show();
			$("#wpakey").attr("disabled", false);
			if (v_encrypType=="TKIP"){
				supplyValue("encrypType","TKIP");
			}else if (v_encrypType=="AES"){
				supplyValue("encrypType","AES");
			}else{
				supplyValue("encrypType","TKIPAES");
			}
			supplyValue("keyFormat",v_keyFormat);
			supplyValue("wpakey",v_wpakey);
			updateEncrypType();
			$("#wpakey1").val($("#wpakey").val());
			break;
	}
}

function updateAuthMode(){
	$("#div_encryp_type,#div_key_format,#div_wepkey,#div_wpakey").hide();
	$("#wepkey,#wpakey").attr("disabled",true);
	CreateEncrypType();	
	var auth_mode_str=$("#authMode").val();
	switch(auth_mode_str){
		case "NONE":
			supplyValue("encrypType","NONE");
			break;
		case "OPEN":
		case "SHARED":
			$("#div_encryp_type,#div_key_format,#div_wepkey").show();
			$("#wepkey").attr("disabled",false);	
			supplyValue("encrypType","WEP64");
			supplyValue("keyFormat","1");
			supplyValue("wepkey","");
			updateEncrypType();
			break;
		default:
			$("#div_encryp_type,#div_key_format,#div_wpakey").show();
			$("#wpakey").attr("disabled",false);
			supplyValue("encrypType","AES");
			supplyValue("keyFormat","0");
			supplyValue("wpakey","");
			updateEncrypType();
			break;
	}
}

function updateKeyFormat(){
	var auth_mode_index=$("#authMode")[0].selectedIndex;
	var encryp_type_index=$("#encrypType")[0].selectedIndex;
	var key_format_index=$("#keyFormat")[0].selectedIndex;
	if (auth_mode_index==1||auth_mode_index==2){
		if (encryp_type_index==0){//WEP64
			if (key_format_index==0){//hex
				$("#wepkey").attr("maxlength",10);
				$("#wepkey1").attr("maxlength",10);
				$("#wepkey2").attr("maxlength",10);
			}else{
				$("#wepkey").attr("maxlength",5);
				$("#wepkey1").attr("maxlength",5);
				$("#wepkey2").attr("maxlength",5);
			}
		}else{
			if (key_format_index==0){//hex
				$("#wepkey").attr("maxlength",26);
				$("#wepkey1").attr("maxlength",26);
				$("#wepkey2").attr("maxlength",26);
			}else{
				$("#wepkey").attr("maxlength",13);
				$("#wepkey1").attr("maxlength",13);
				$("#wepkey2").attr("maxlength",13);
			}
		}			
	}else{
		if (key_format_index==0){//hex
			$("#wpakey").attr("maxlength",64);
			$("#wpakey1").attr("maxlength",64);
			$("#wpakey2").attr("maxlength",64);
		}else{
			$("#wpakey").attr("maxlength",63);
			$("#wpakey1").attr("maxlength",63);
			$("#wpakey2").attr("maxlength",63);
		}
	}
}

function updateEncrypType(){
	updateKeyFormat();
}

function updateBand(){
	CreateBandwidth();
	updateBw($("#bw").val());
}

function updateBw(){
	var bw_val=arguments[0];
	var band_index=$("#band")[0].selectedIndex;		
	if(bw_val!==undefined){
		var temp=false;
		$('#bw OPTION').each(function(){
			if(this.value==bw_val){
				temp=true;
			}
		});
		if(temp){
			$("#bw").val(bw_val);
		}else{
			$("#bw").val('1');
		}	
		if(band_index<2){
			$("#bw").val('0');
		}
	}
}

function updateCountry(){
	var country_str=$("#countryStr").val();
	var new_options,new_values;
	switch(country_str){
		case 'US'://USA
			new_options = [MM_Auto,'1','2','3','4','5','6','7','8','9','10','11'];
			new_values  = ['0','1','2','3','4','5','6','7','8','9','10','11'];
			break;
		default:
			new_options = [MM_Auto,'1','2','3','4','5','6','7','8','9','10','11','12','13'];
			new_values  = ['0','1','2','3','4','5','6','7','8','9','10','11','12','13'];
			break;
	}	
	CreateOptions("channel",new_options,new_values);
}

function CreateChannel(){
	var new_options,new_values;
	v_regDomain = Number(v_regDomain);
	switch(v_regDomain){
		case 1://FCC
			new_options = [MM_Auto,'1','2','3','4','5','6','7','8','9','10','11'];
			new_values  = ['0','1','2','3','4','5','6','7','8','9','10','11'];
			break;
		default:
			new_options = [MM_Auto,'1','2','3','4','5','6','7','8','9','10','11','12','13'];
			new_values  = ['0','1','2','3','4','5','6','7','8','9','10','11','12','13'];
			break;
	}	
	CreateOptions("channel",new_options,new_values);
}

function CreateBandwidth(){
	var new_options,new_values;
	var band=$("#band").val();
	if (band<6){
		new_options = ['20MHz'];
		new_values  = ['0'];
	}else if ((band>=6&&band<12)||(band==75)){
		new_options = [MM_Auto,'20MHz','40MHz'];
		new_values  = ['1','0','3'];
	}
	CreateOptions("bw",new_options,new_values);	
}

var wifiIdx="0";
$(function(){
	var postVar={topicurl:"setting/getWiFiBasicConfig"};
	postVar['wifiIdx']=wifiIdx;
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : true, success : function(Data){
			rJson=JSON.parse(Data);
			v_wifiOff=rJson['wifiOff'];
			v_regDomain=rJson['regDomain'];
			v_authMode=rJson['authMode'];
			v_encrypType=rJson['encrypType'];
			v_keyFormat=rJson['keyFormat'];
			v_wepkey=rJson['wepkey'];//wep
			v_wpakey=rJson['wpakey'];//wpa
			v_bw=rJson['bw'];
			v_apcliEnable=rJson['apcliEnable'];
			v_ntpEnabled=rJson['ntpEnabled'];
			v_wifiSchEnabled=rJson['wifiSchEnabled'];
			v_countryBt=rJson['countryBt'];		
			v_csid=rJson['csid'];
			CreateWirelessMode();
			CreateCountry(rJson['countryList']);
			CreateAuthMode();
			CreateChannel();
			setJSONValue({
				"wifiOff"	  :	v_wifiOff,
				"ssid"		  :	rJson['ssid'],
				"channel"     : rJson['channel'],
				"hssid"       : rJson['hssid'],
				"countryStr"  : rJson['countryStr'],
				"band"        :	rJson['band']
			});	
			CreateBandwidth();
			$("#bw").val(v_bw);
			SetAuthMode();
			if (v_wifiOff==0){
				$("#div_wireless_setting").show();
			}else{
				$("#div_wireless_setting").hide();
			}	
			if (v_apcliEnable==1){
				$("#div_wifi_onoff").hide();
				$("#countryStr,#channel,#band,#bw").attr("disabled",true).css('backgroundColor','#ebebe4');
			}else{
				$("#div_wifi_onoff").show();
				$("#countryStr,#channel,#band,#bw").attr("disabled",false);
			}	
			if(v_ntpEnabled==1&&v_wifiSchEnabled==1){	
				$("#wifiOff").attr("disabled",true).css('backgroundColor','#ebebe4');
			}else{
				$("#wifiOff").attr("disabled",false);
			}
			if (v_countryBt==1){
				updateCountry();
				$("#channel").val(rJson['channel']);
				$("#div_countrystr").show();
			}else{
				$("#div_countrystr").hide();
			}	
		}
    });
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function addTimestamp(url){
	var _url = url;
	if(_url.indexOf("?") == -1){
		_url += "?timestamp=" + (new Date()).getTime();
	}else{
		if(_url.indexOf("timestamp") == -1)
			_url += "&timestamp=" + (new Date()).getTime();
		else
			_url=_url.replace(/timestamp=.*/ig,"timestamp=" + (new Date()).getTime());
	}
	return _url;
}

function updateState(){
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setWiFiBasicConfig"};
	postVar['wifiOff']=$("#wifiOff").val();
	postVar['wifiIdx']=wifiIdx;
	postVar['addEffect']="1";
	postVar=JSON.stringify(postVar);
	$(":input").attr("disabled",true);
	setTimeout('waitpage()',4000);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		if ($("#wifiOff").val()==1){
			top.frames[4].$("#401,#403,#404,#405,#406,#407").hide();
			top.frames[4].$("#4").parent().attr("href",addTimestamp("/wireless/basic.asp"));
		}else{
			top.frames[4].$("#401,#403,#404,#405,#406,#407").show();
			top.frames[4].$("#4").parent().attr("href",addTimestamp("/wireless/stainfo.asp"));
		}
		do_count_down();
	});
}

function saveChanges(){
	if (!checkVaildVal.IsVaildSSID($("#ssid").val(),MM_Ssid)) return false;	
	var auth_mode_index=$("#authMode")[0].selectedIndex;
	var encryp_type_index=$("#encrypType")[0].selectedIndex;
	var key_format_index=$("#keyFormat")[0].selectedIndex;
	if (auth_mode_index==1||auth_mode_index==2){
		var checkbox = $('input[id="checkboxPass1"]:checked').val();
		if(checkbox == "on"){
			$("#wepkey").val($("#wepkey2").val());
		}else{
			$("#wepkey").val($("#wepkey1").val());
		}
		var wepkey=$("#wepkey").val();
		if (key_format_index==0){//hex
			if (encryp_type_index==0){//10hex
				if (wepkey.length!=10){alert(JS_msg21);return false;}				
			}else{//26hex
				if (wepkey.length!=26){alert(JS_msg22);return false;}				
			}
			if (!checkVaildVal.IsVaildWiFiPass(wepkey,MM_Password,"hex"))return false;
		}else{
			if (encryp_type_index==0){//10hex
				if (wepkey.length!=5){alert(JS_msg19);return false;}
			}else{
				if (wepkey.length!=13){alert(JS_msg20);return false;}
			}						
			if (!checkVaildVal.IsVaildWiFiPass(wepkey,MM_Password,"ascii"))return false;
		}	
		if (!confirm(JS_msg26))return false;
	}else if (auth_mode_index==3||auth_mode_index==4||auth_mode_index==5){
		var checkbox = $('input[id="checkboxPass2"]:checked').val();
		if(checkbox == "on"){
			$("#wpakey").val($("#wpakey2").val());
		}else{
			$("#wpakey").val($("#wpakey1").val());
		}
		var wpakey=$("#wpakey").val();
		if (key_format_index==0){//64 hex
			if (wpakey.length!=64){alert(JS_msg25);return false;}
			if (!checkVaildVal.IsVaildWiFiPass(wpakey,MM_Password,"hex"))return false;
		}else{
			if (wpakey.length<8||wpakey.length>63){alert(JS_msg24);return false;}
			if (!checkVaildVal.IsVaildWiFiPass(wpakey,MM_Password,"ascii"))return false;
		}
		if (auth_mode_index==3){//wpapsk
			if (!confirm(JS_msg118))return false;
		}else if (encryp_type_index==0){//tkip
			if (!confirm(JS_msg27))return false;
		}
	}
	if (auth_mode_index==1||auth_mode_index==2){//wep
		v_wscDisabled=1;
	}else if (auth_mode_index>=3){//wpa/wpa2/wpa-wps2
		if (auth_mode_index==3){//wpa
			v_wscDisabled=1;
		}else{
			if (encryp_type_index==0){//tkip
				v_wscDisabled=1;
			}else{
				if ($("#hssid").val()==1){
					if (!confirm(JS_msg86))return false;
					v_wscDisabled=1;
				}else{
					v_wscDisabled=rJson['wscDisabled'];
				}
			}
		}
	}else{
		if ($("#hssid").val()==1){			
			if (!confirm(JS_msg86))return false;
			v_wscDisabled=1;
		}else{
			v_wscDisabled=rJson['wscDisabled'];
		}
	}
	return true;
}

function updatePassType(index){
	
	if(index == 1){
		var checkbox = $('input[id="checkboxPass1"]:checked').val();
		if(checkbox == "on"){
			$("#wepkey").val($("#wepkey1").val()); 
			$("#wepkey2").val($("#wepkey1").val());
			$("#div_wepkey1").hide();
			$("#div_wepkey2").show();
		}else{
			$("#wepkey1").val($("#wepkey2").val());
			$("#wepkey").val($("#wepkey2").val());
			$("#div_wepkey1").show();//p
			$("#div_wepkey2").hide();//t
		}
	}else if(index == 2){
		var checkbox = $('input[id="checkboxPass2"]:checked').val();
		if(checkbox == "on"){
			$("#wpakey2").val($("#wpakey1").val()); 
			$("#wpakey").val($("#wpakey1").val());
			$("#div_wpakey1").hide();
			$("#div_wpakey2").show();
		}else{
			$("#wpakey1").val($("#wpakey2").val());
			$("#wpakey").val($("#wpakey2").val());
			$("#div_wpakey1").show();//p
			$("#div_wpakey2").hide();//t
		}
	}
}

var wtime=10;
function waitpage(){
	$("#div_setting").hide();
	$("#div_wait").show();
}
function do_count_down(){
	$("#show_sec").html(wtime);
	if(wtime==0){resetForm(); return false;}
	if(wtime>0){wtime--;setTimeout('do_count_down()',1000);}
}
function doSubmit(){
	if (saveChanges()==false) return false;
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setWiFiBasicConfig"};
	postVar['ssid']=$("#ssid").val();
	postVar['band']=$("#band").val();
	postVar['channel']=$("#channel").val();
	postVar['hssid']=$("#hssid").val();
	postVar['authMode']=$("#authMode").val();
	postVar['encrypType']=$("#encrypType").val();
	postVar['keyFormat']=$("#keyFormat").val();
	postVar['wepkey']=$("#wepkey").val();
	postVar['wpakey']=$("#wpakey").val();
	postVar['bw']=$("#bw").val();
	postVar['countryStr']=$("#countryStr").val();
	postVar['wscDisabled']=(v_wscDisabled==1)?"1":"0";
	postVar['addEffect']="0";
	postVar['wifiIdx']=wifiIdx;	
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		waitpage();
		do_count_down();
	});
}
</script>
</head>
<body class="mainbody">
<div id="div_setting">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_Basic)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_Basic)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<div id="div_wifi_onoff">
<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_WiFiOnOff)</script></td>
<td><select class="select" id="wifiOff" onChange="updateState()">
<option value="1"><script>dw(MM_Disable)</script></option>
<option value="0"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table>
</div>

<div id="div_wireless_setting" style="display:none">
<table border=0 width="100%">
<tr> 
<td class="item_left"><script>dw(MM_Ssid)</script></td>
<td><input type="text" class="text" id="ssid" maxlength=32></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_Band)</script></td>
<td><select class="select" id="band" onChange="updateBand()"></select></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_BSsid)</script></td>
<td><select class="select" id="hssid">
<option value="1"><script>dw(MM_Disable)</script></option>
<option value="0"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr id="div_countrystr" style="display:none"> 
<td class="item_left"><script>dw(MM_Country)</script></td>
<td><select class="select" id="countryStr" onChange="updateCountry()"></select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Channel)</script></td>
<td><select class="select" id="channel"></select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_BandWidth)</script></td>
<td><select class="select" id="bw" onChange="updateBw()"></select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_SecurityMode)</script></td>
<td><select class="select" id="authMode" onChange="updateAuthMode()"></select></td>
</tr>
<tr id="div_encryp_type" style="display:none"> 
<td class="item_left"><script>dw(MM_EncrypType)</script></td>
<td><select class="select" id="encrypType" onChange="updateEncrypType()"></select></td>
</tr>
<tr id="div_key_format" style="display:none"> 
<td class="item_left"><script>dw(MM_KeyFormat)</script></td>
<td><select class="select" id="keyFormat" onChange="updateKeyFormat()">
<option value="1">Hex</option>
<option value="0">ASCII</option>
</select></td>
</tr>
<tr id="div_wepkey" style="display:none"> 
<td class="item_left"><script>dw(MM_Password)</script></td>
<td><input type="hidden" id="wepkey" maxlength="26"><span id="div_wepkey1"><input type="password" class="text" id="wepkey1" maxlength="26"></span><span id="div_wepkey2" style="display:none"><input type="text" class="text" id="wepkey2" maxlength="26"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="checkboxPass1" onChange="updatePassType(1)"></td>
</tr> 
<tr id="div_wpakey" style="display:none">
<td class="item_left"><script>dw(MM_Password)</script></td>
<td><input type="hidden" id="wpakey"><span id="div_wpakey1"><input type="password" class="text" id="wpakey1" maxlength="64"></span><span id="div_wpakey2" style="display:none"><input type="text" class="text" id="wpakey2" maxlength="64"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="checkboxPass2" onChange="updatePassType(2)"></td>
</tr>
</table>

<table border=0 width="100%">
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
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
