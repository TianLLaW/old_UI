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
var rJson,v_staNum=0;
function showWiFiBand(mode,bssidnum){
	for (var i=1;i<=bssidnum;i++){
		var objId=$("#band"+i);
		if (mode==0){
			objId.html("2.4GHz (B+G)");
		}else if (mode==1){	 
			objId.html("2.4GHz (B)");
		}else if (mode==2){ 
			objId.html("802.11A");
		}else if (mode==4){
			objId.html("2.4GHz (G)");
		}else if (mode==9){
			objId.html("2.4GHz (B+G+N)");
		}else if (mode==6){ 
			objId.html("2.4GHz (N)");
		}else if (mode==8){ 
			objId.html("802.11A/ N");
		}else if (mode==14){ 
			objId.html("802.11A/ N/ AC");
		}else if (mode==75){ 
			objId.html("2.4GHz (B+G+N+AC)");
		}
	}
}

function showWiFiAuthMode(auth_mode,encryp_type,bssidnum){
	for (var i=1;i<=bssidnum;i++){
		var j=i-1;
		var objId=$("#authMode"+i);
		if (auth_mode.split(";")[j]=="NONE"){
			objId.html(MM_Disable);
		}else if (auth_mode.split(";")[j]=="OPEN"||auth_mode.split(";")[j]=="SHARED"){ 	
			if (auth_mode.split(";")[j]=="OPEN"){ 
				objId.html("WEP-"+MM_OpenSystem);
			}else{
				objId.html("WEP-"+MM_SharedKey);
			}
		}else{
			if (auth_mode.split(";")[j]=="WPAPSK"){ 
				objId.html("WPA-PSK");
			}else if (auth_mode.split(";")[j]=="WPA2PSK"){  
				objId.html("WPA2-PSK");
			}else if (auth_mode.split(";")[j]=="WPAPSKWPA2PSK"){	 
				objId.html("WPA/WPA2-PSK");
			}
		}
	}
}

function showApcliAuthMode(auth_mode,encryp_type){
	if (auth_mode=="NONE"){ 
		supplyValue("apcliAuthMode",MM_Disable);
	}else if (auth_mode=="OPEN"||auth_mode=="SHARED"){ 
		if (auth_mode=="OPEN"){ 
			supplyValue("apcliAuthMode","WEP"+MM_OpenSystem);
		}else{ 
			supplyValue("apcliAuthMode","WEP"+MM_SharedKey);
		}
	}else{
	 	if (auth_mode=="WPAPSK"){  
			supplyValue("apcliAuthMode","WPA-PSK");
		}else{ 
			supplyValue("apcliAuthMode","WPA2-PSK");
		}
	}
}

var wifiIdx="0";
function showStaInfo(){
	var postVar={ topicurl : "setting/getWiFiStaInfo"};
	postVar["wifiIdx"]=wifiIdx;
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post",  url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			if (v_staNum>0&&Data!="{}"){
				var stadataRE=Data.split("$");
				var strTmp="",i;
				for(i=0;i<stadataRE.length-1;i++){
					var stadata=stadataRE[i].split(";");
					strTmp="<tr>\n";
					strTmp+="<td class=item_center2 align=center>"+stadata[1]+"</td>\n";
					strTmp+="<td class=item_center2 align=center>"+stadata[2]+"</td>\n";
					strTmp+="<td class=item_center2 align=center>"+stadata[3]+"</td>\n";
					strTmp+="<td class=item_center2><table><tr>";
					if (stadata[5]>=100){
						strTmp+="<td><div style=width:50px;></div></td><td align=left><div class=rssi1></div></td><td><div class=rssi2></div></td><td><div class=rssi3></div></td><td><div class=rssi4></div></td><td><div class=rssi5></div></td><td>"+stadata[5]+"%</td>";
					}else if(stadata[5]>=80){
						strTmp+="<td><div style=width:50px;></div></td><td align=left><div class=rssi1></div></td><td><div class=rssi2></div></td><td><div class=rssi3></div></td><td><div class=rssi4></div></td><td><div style='width:"+stadata[4]+"px;height:20px;background-color:#0047af;'></div></td><td>"+stadata[5]+"%</td>";
					}else if(stadata[5]>=60){
						strTmp+="<td><div style=width:50px;></div></td><td align=left><div class=rssi1></div></td><td><div class=rssi2></div></td><td><div class=rssi3></div></td><td><div style='width:"+stadata[4]+"px;height:20px;background-color:#005fbc;'></div></td><td>"+stadata[5]+"%</td>";
					}else if(stadata[5]>=40){
						strTmp+="<td><div style=width:50px;></div></td><td align=left><div class=rssi1></div></td><td><div class=rssi2></div></td><td><div style='width:"+stadata[4]+"px;height:20px;background-color:#0083d2;'></div></td><td>"+stadata[5]+"%</td>";
					}else if(stadata[5]>=20){
						strTmp+="<td><div style=width:50px;></div></td><td align=left><div class=rssi1></div></td><td><div style='width:"+stadata[4]+"px;height:20px;background-color:#00a5e6;'></div></td><td>"+stadata[5]+"%</td>";
					}else{
						strTmp+="<td><div style=width:50px;></div></td><td align=left><div style='width:"+stadata[4]+"px;height:20px;background-color:#00c8fb;'></div></td><td>"+stadata[5]+"%</td>";
					}
					strTmp+="</tr></table></td>\n";	
					strTmp+="</tr>";
					$("#div_stalist").after(strTmp);
				}
			}			
		}
    });
}

function wifiStainfo(){
	var postVar={topicurl:"setting/getWiFiApInfo"};
	postVar["wifiIdx"]=wifiIdx;
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);		
			setJSONValue({
				'ssid1'		:	showSsidFormat(rJson['ssid1']),
				'ssid2'		:	showSsidFormat(rJson['ssid2']),
				'ssid3'		:	showSsidFormat(rJson['ssid3']),
				'bssid1'	:	rJson['bssid1'],
				'bssid2'	:	rJson['bssid2'],
				'bssid3'	:	rJson['bssid3'],
				'staNum1'	:	rJson['staNum1'],
				'staNum2'	:	rJson['staNum2'],
				'staNum3'	:	rJson['staNum3'],
				'apcliSsid'	:	showSsidFormat(rJson['apcliSsid'])
			});
			
			v_staNum=rJson['staNum1']+rJson['staNum2']+rJson['staNum3'];
			if(v_staNum>0){
				supplyValue("staNum",v_staNum);
			}else{
				supplyValue("staNum",0);
			}		
			if(rJson['apcliBssid']==""){
				supplyValue("apcliBssid","00:00:00:00:00:00");
			}else{
				supplyValue("apcliBssid",rJson['apcliBssid']);
			}		
			if (rJson['channel']==0){
				supplyValue("channel",MM_Auto+" ("+rJson['autoChannel']+")");
			}else{
				supplyValue("channel",rJson['autoChannel']);
			}
						
			showWiFiBand(rJson['band'],parseInt(rJson['bssidNum']));
			showWiFiAuthMode(rJson['authMode'],rJson['encrypType'],parseInt(rJson['bssidNum']));
			showApcliAuthMode(rJson['apcliAuthMode'],rJson['apcliEncrypType']);
		
			if (rJson['operationMode']!=0&&rJson['wifiOff1']==0&&rJson['apcliEnable']==1){		
				if (rJson['apcliStatus']=="success"){
					supplyValue("apcliStatus",MM_ConnectionSuccess);
				}else{
					supplyValue("apcliStatus",MM_ConnectionFail);
				}
				$("#div_apcli").show();
			}
			
			if(rJson['wifiOff1']==0){
				supplyValue("wifiOff1",MM_Enabled);
				supplyValue("wifiOff2",MM_Enabled);
				supplyValue("wifiOff3",MM_Enabled);
				if (rJson['wifiOff2']==0) $("#div_wifi2").show();
				if (rJson['wifiOff3']==0) $("#div_wifi3").show();			
			}else{
				supplyValue("wifiOff1",MM_Disabled);
				supplyValue("wifiOff2",MM_Disabled);
				supplyValue("wifiOff3",MM_Disabled);
				$("#div_wifi2,#div_wifi3").hide();	
			}
			
			showStaInfo();
			$("#div_staList").show();
		}
    });
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
}
</script>
</head>
<body class="mainbody" onLoad="wifiStainfo();">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_WirelessStatus)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_WiFiStatus)</script></td></tr>
</table>

<br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_WirelessInfo)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_WirelessStatus)</script></td>
<td><span id="wifiOff1"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Ssid)</script></td>
<td><span id="ssid1"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Band)</script></td>
<td><span id="band1"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Channel)</script></td>
<td><span id="channel"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_SecurityMode)</script></td>
<td><span id="authMode1"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Mac)</script></td>
<td><span id="bssid1"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_AssociatedClients)</script></td>
<td><span id="staNum1"></span></td>
</tr>
</table></td></tr>
</table>

<span id="div_wifi2" style="display:none"><br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_MultiApInfo)</script> 1</td></tr>
<tr><td><table class="list1">
<tr style="display:none">
<td class="item_left"><script>dw(MM_WirelessStatus)</script></td>
<td><span id="wifiOff2"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Ssid)</script></td>
<td><span id="ssid2"></span></td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_Band)</script></td>
<td><span id="band2"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_SecurityMode)</script></td>
<td><span id="authMode2"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Mac)</script></td>
<td><span id="bssid2"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_AssociatedClients)</script></td>
<td><span id="staNum2"></span></td>
</tr>
</table></td></tr>
</table>
</span>

<span id="div_wifi3" style="display:none"><br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_MultiApInfo)</script> 2</td></tr>
<tr><td><table class="list1">
<tr style="display:none">
<td class="item_left"><script>dw(MM_WirelessStatus)</script></td>
<td><span id="wifiOff3"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Ssid)</script></td>
<td><span id="ssid3"></span></td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_Band)</script></td>
<td><span id="band3"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_SecurityMode)</script></td>
<td><span id="authMode3"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Mac)</script></td>
<td><span id="bssid3"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_AssociatedClients)</script></td>
<td><span id="staNum3"></span></td>
</tr>
</table></td></tr>
</table>
</span>

<span id="div_apcli" style="display:none"><br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_RepeaterInfo)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_Ssid)</script></td>
<td><span id="apcliSsid"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_SecurityMode)</script></td>
<td><span id="apcliAuthMode"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Mac)</script></td>
<td><span id="apcliBssid"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Status)</script></td>
<td><span id="apcliStatus"></span></td>
</tr>
</table></td></tr>
</table>
</span>

<br>
<table id="div_staList" border=0 width="100%" style="display:none">
<tr><td colspan="5"><b><script>dw(MM_StationList)</script> (<script>dw(MM_AssociatedClients)</script>: <span id="staNum"></span>)</b></td></tr>
<tr><td colspan="4" height="1" class="line"></td></tr>
<tr><td colspan="4" height="2"></td></tr>
<tr align="center" id="div_stalist">
<td class="item_center"><b><script>dw(MM_Mac)</script></b></td>
<td class="item_center"><b><script>dw(MM_Mode)</script></b></td>
<td class="item_center"><b><script>dw(MM_BandWidth)</script></b></td>
<td class="item_center"><b><script>dw(MM_Signal)</script></b></td>
</tr>
<tr><td colspan="4" height="1" class="line"></td></tr>
</table>
<br>
</td></tr></table>
</body></html>