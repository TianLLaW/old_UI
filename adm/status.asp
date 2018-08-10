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
var rJson,v_opMode,v_portLinkStatus,v_wanMode,v_wanConnStatus,v_wifiOff,v_apcliEnable,v_hardModel;
var helpUrl="";
function setPortStatusInfo(){
	if (rJson["portlinkBt"]==1){
		$("#div_port_status").show();
		v_portLinkStatus=rJson['portLinkStatus'];
		var port=v_portLinkStatus.split(",");
		if (v_hardModel=="04361"||v_hardModel=="04362"){
			if (v_opMode==0){
				if(port[4]==1){	
					$("#wan_port").attr("src", "../style/port_WAN_ON.gif");
					$("#wan_port_n").addClass("port_link");
				}
			}else {
				if(port[4]==1){	
					$("#wan_port").attr("src", "../style/port_LAN_ON.gif");
					$("#wan_port_n").html("LAN3").addClass("port_link");
				}else {
					$("#wan_port_n").html("LAN3");
				}
			}
			if (port[0]==1){
				 $("#lan_port1").attr("src", "../style/port_LAN_ON.gif");
				 $("#lan_port1_n").addClass("port_link");
			}
			if (port[3]==1){
				 $("#lan_port2").attr("src", "../style/port_LAN_ON.gif");
				 $("#lan_port2_n").addClass("port_link");
			}
			$("#div_lan_port4,#div_lan_port3,#div_lan_port4_n,#div_lan_port3_n").hide();
		}else{
			if (v_opMode==0){
				if(port[0]==1){	
					$("#wan_port").attr("src", "../style/port_WAN_ON.gif");
					$("#wan_port_n").addClass("port_link");
				}
			}else {
				if(port[0]==1){	
					$("#wan_port").attr("src", "../style/port_LAN_ON.gif");
					$("#wan_port_n").html("LAN5").addClass("port_link");
				}else {
					$("#wan_port_n").html("LAN5");
				}
			}
			if (port[4]==1){
				 $("#lan_port1").attr("src", "../style/port_LAN_ON.gif");
				 $("#lan_port1_n").addClass("port_link");
			}
			if (port[3]==1){
				 $("#lan_port2").attr("src", "../style/port_LAN_ON.gif");
				 $("#lan_port2_n").addClass("port_link");
			}
			if (port[2]==1){
				 $("#lan_port3").attr("src", "../style/port_LAN_ON.gif");
				 $("#lan_port3_n").addClass("port_link");
			}
			if (port[1]==1){
				$("#lan_port4").attr("src", "../style/port_LAN_ON.gif");
				$("#lan_port4_n").addClass("port_link");
			}
		}
	}else{
		$("#div_port_status").hide();
	}
}

function setSysInfo(){
	setJSONValue({
		"opmode"	   : showOpMode(rJson['operationMode']),
		"upTime"       : showTimeFormat(rJson['upTime'].split(';')),
		"fmVersion"    : rJson['fmVersion'],
		"buildTime"    : rJson['buildTime']
	});
	var tmpCsid=rJson['CSID'];
	if(tmpCsid=="CS13KR"||tmpCsid=="CS13JR"){
		if (localStorage.language=="vn"&&loadMultiLangBt.indexOf("vn")>-1){
			helpUrl="www.totolink.vn";
		}else if (localStorage.language=="ru"&&loadMultiLangBt.indexOf("ru")>-1){
			helpUrl="www.totolink.ru";
		}else if (localStorage.language=="jp"&&loadMultiLangBt.indexOf("jp")>-1){
			helpUrl="www.totolink.jp";
		}else if (localStorage.language=="cn"&&loadMultiLangBt.indexOf("cn")>-1){
			helpUrl="www.totolink.cn";
		}else if (localStorage.language=="ct"&&loadMultiLangBt.indexOf("ct")>-1){
			helpUrl="www.totolink.tw";
		}else{
			helpUrl="www.totolink.net";
		}
	}else{
		if (localStorage.language=="vn"&&loadMultiLangBt.indexOf("vn")>-1){
			helpUrl=rJson['helpUrl_vn'];
		}else if (localStorage.language=="ru"&&loadMultiLangBt.indexOf("ru")>-1){
			helpUrl=rJson['helpUrl_ru'];
		}else if (localStorage.language=="jp"&&loadMultiLangBt.indexOf("jp")>-1){
			helpUrl=rJson['helpUrl_jp'];
		}else if (localStorage.language=="cn"&&loadMultiLangBt.indexOf("cn")>-1){
			helpUrl=rJson['helpUrl_cn'];
		}else if (localStorage.language=="ct"&&loadMultiLangBt.indexOf("ct")>-1){
			helpUrl=rJson['helpUrl_ct'];
		}else{
			helpUrl=rJson['helpUrl_en'];
		}
	}
	if (helpUrl!=""){
		$("#div_customer_url").show();
		$("#customerUrl").html(helpUrl).attr("href",'http://'+helpUrl);
	}	
}

function setLanInfo(){
	setJSONValue({	
		"lanIp"      : rJson['lanIp'],
		"lanMask"    : rJson['lanMask'],
		"lanMac"     : rJson['lanMac']
	});

	if (v_opMode!=1&&v_opMode!=2){
		$("#div_dhcp_server").show();
		if (rJson['dhcpServer']==1){
			supplyValue("dhcpServer",MM_Enabled); 
		}else{
			supplyValue("dhcpServer",MM_Disabled); 
		}
	}else{
		$("#div_dhcp_server").hide();
	}
}

function setWanInfo(){
	if (v_opMode!=1&&v_opMode!=2){
		$("#div_wan,#div_wan_br,#div_wan_statistics").show();
		supplyValue("wanConnTime",showTimeFormat(rJson['wanConnTime'].split(';')));
		$("#div_wan_conntime").show();
	}	
	
	v_wanMode=rJson['wanMode'];
	v_wanConnStatus=rJson['wanConnStatus'];
	if (v_wanMode==0){
		supplyValue("wanMode",MM_StaticIpMode);
	}else if (v_wanMode==1){ 
		supplyValue("wanMode",MM_DhcpMode);
	}else if (v_wanMode==3){
		supplyValue("wanMode",MM_PppoeMode);
	}else if (v_wanMode==4){
		supplyValue("wanMode",MM_PptpMode);
	}else if (v_wanMode==6){
		supplyValue("wanMode",MM_L2tpMode);
	}
	setJSONValue({
		"wanMac"          : rJson['wanMac']
	});
	
	if (v_wanMode==0){
		setJSONValue({
			"wanIp"         : rJson['wanIp'],
			"wanMask"    	: rJson['wanMask'],
			"wanGw"    		: rJson['wanGw'],
			"priDns"        : rJson['priDns'],
			"secDns"        : rJson['secDns']
		});
	}else{
		if (v_wanConnStatus!="connected"){
			setJSONValue({
				"wanIp"         : "0.0.0.0",
				"wanMask"    	: "0.0.0.0",
				"wanGw"    		: "0.0.0.0",
				"priDns"        : "0.0.0.0",
				"secDns"        : "0.0.0.0"
			});
		}else{
			setJSONValue({
				"wanIp"         : rJson['wanIp'],
				"wanMask"    	: rJson['wanMask'],
				"wanGw"    		: rJson['wanGw'],
				"priDns"        : rJson['priDns'],
				"secDns"        : rJson['secDns']
			});
		}
	}
	
	if (v_opMode!=1&&v_opMode!=2&&rJson['secDns']!=""){
		$("#div_wan_dns2").show();
	}else{
		$("#div_wan_dns2").hide();
	}
	
	if (v_wanConnStatus=="connected"){
		$("#wanConnStatus").html(MM_Connected);
	}else{
		$("#wanConnStatus").html(MM_Disconnected);
	}
}

function setWlanInfo(){
	if(v_wifiOff==1) return;
	$("#div_wifi").show();
	if (v_wifiOff==0){
		$("#div_wifi_statistics").show();
		if (rJson['wifiOff2']==0) $("#div_wifi2").show();
		if (rJson['wifiOff3']==0) $("#div_wifi3").show();
	}else{
		$("#div_wifi2,#div_wifi3").hide();
	}
	//SSID1
	if(v_wifiOff==0){
		supplyValue("wifiOff",MM_Enabled);
	}else{
		supplyValue("wifiOff",MM_Disabled);
	}
	setWirelessMode("band",rJson['band']);
	supplyValue("ssid1",showSsidFormat(rJson['ssid1']));
	if(rJson['channel']==0){
		supplyValue("channel",MM_Auto+" ("+rJson['autoChannel']+")");
	}else{
		supplyValue("channel",rJson['autoChannel']);
	}
	var auth_mode=rJson['authMode'].split(";");
	var encryp_type=rJson['encrypType'].split(";");
	setAuthMode("authMode1",auth_mode[0],encryp_type[0]);
	supplyValue("bssid1",rJson['bssid1']);
	supplyValue("staNum1",rJson['staNum1']);
	//SSID2
	supplyValue("ssid2",showSsidFormat(rJson['ssid2']));
	setAuthMode("authMode2",auth_mode[1],encryp_type[1]);
	supplyValue("bssid2",rJson['bssid2']);
	supplyValue("staNum2",rJson['staNum2']);
	//SSID3
	supplyValue("ssid3",showSsidFormat(rJson['ssid3']));
	setAuthMode("authMode3",auth_mode[2],encryp_type[2]);
	supplyValue("bssid3",rJson['bssid3']);
	supplyValue("staNum3",rJson['staNum3']);
}

function setReapeaterInfo(){	
	if (v_wifiOff==1||v_opMode==0) return;
	if (rJson['apcliEnable']==0) return;
	supplyValue("apcliSsid",showSsidFormat(rJson['apcliSsid']));
	supplyValue("apcliBssid",rJson['apcliBssid']);
	setAuthMode("apcliAuthMode",rJson['apcliAuthMode'],rJson['apcliEncrypType']);
	if(rJson['apcliStatus']=="success"){
		supplyValue("apcliStatus",MM_ConnectionSuccess);
	}else{
		supplyValue("apcliStatus",MM_ConnectionFail);
	}
	$("#div_apcli").show();
}

function setStatisticsInfo(){
	setJSONValue({
		"wanrx"     : rJson['wanRx'],
		"wantx"     : rJson['wanTx'],
		"lanrx"     : rJson['lanRx'],
		"lantx"     : rJson['lanTx'],
		"wlanrx"    : rJson['wlanRx'],
		"wlantx"    : rJson['wlanTx']
	});
}

$(function(){
	var postVar={topicurl:"setting/getSysStatusCfg"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : true, success : function(Data){
			rJson=JSON.parse(Data);
			v_opMode=rJson['operationMode'];
			v_wifiOff=rJson['wifiOff'];		
			v_hardModel=rJson['hardModel'];
			v_apcliEnable=rJson['apcliEnable'];
			setPortStatusInfo();
			setSysInfo();
			setLanInfo();
			setWanInfo();
			setWlanInfo();
			if(v_apcliEnable==1) setReapeaterInfo();
			setStatisticsInfo();
		}
    });
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_SystemStatus)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_SystemStatus)</script></td></tr>
</table>

<div id="div_port_status" style="display:none">
<table border=0 cellpadding=0 cellspacing=0>
<tr>
<td><img id="wan_port" src='../style/port_Default.gif'></td>
<td width=10></td>
<td id="div_lan_port4"><img id="lan_port4" src='../style/port_Default.gif'></td>
<td id="div_lan_port3"><img id="lan_port3" src='../style/port_Default.gif'></td>
<td id="div_lan_port2"><img id="lan_port2" src='../style/port_Default.gif'></td>
<td id="div_lan_port1"><img id="lan_port1" src='../style/port_Default.gif'></td>
</tr>
<tr align=center>
<td class="port_default"><span id="wan_port_n">WAN</span></td>
<td width=10></td>
<td id="div_lan_port4_n" class="port_default"><span id="lan_port4_n">LAN4</span></td>
<td id="div_lan_port3_n" class="port_default"><span id="lan_port3_n">LAN3</span></td>
<td id="div_lan_port2_n" class="port_default"><span id="lan_port2_n">LAN2</span></td>
<td id="div_lan_port1_n" class="port_default"><span id="lan_port1_n">LAN1</span></td>
</tr>
</table>
<br>
</div>

<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_SystemInfo)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_OperationMode)</script></td>
<td><span id="opmode"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Uptime)</script></td>
<td><span id="upTime"></span></td>
</tr>
<tr id="div_customer_url" style="display:none">
<td class="item_left"><script>dw(MM_CustomerUrl)</script></td>
<td><a id="customerUrl" href="" target="_blank"></a></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_FirmwareVer)</script></td>
<td><span id="fmVersion"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_BuildTime)</script></td>
<td><span id="buildTime"></span></td>
</tr>
</table></td></tr>
</table>

<br id="div_wan_br" style="display:none">
<div id="div_wan" style="display:none">
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_WanInfo)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_ConnectionStatus)</script></td>
<td><span id="wanMode"></span>&nbsp;&nbsp;&nbsp;<span id="wanConnStatus"></span></td>
</tr>
<tr id="div_wan_conntime" style="display:none">
<td class="item_left"><script>dw(MM_ConnectionTime)</script></td>
<td><span id="wanConnTime"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Ip)</script></td>
<td><span id="wanIp"></span> </td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Mask)</script></td>
<td><span id="wanMask"></span> </td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Gateway)</script></td>
<td><span id="wanGw"></span> </td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_DnsServer)</script></td>
<td><span id="priDns"></span> <span id="div_wan_dns2" style="display:none">/ <span id="secDns"></span></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Mac)</script></td>
<td><span id="wanMac"></span></td>
</tr>
</table></td></tr>
</table>
</div>

<div id="div_wifi" style="display:none">
<br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_WirelessInfo)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_WirelessStatus)</script></td>
<td><span id="wifiOff"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Ssid)</script></td>
<td><span id="ssid1"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Band)</script></td>
<td><span id="band"></span></td>
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

<div id="div_wifi2" style="display:none">
<br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_MultiApInfo)</script>&nbsp;1</td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_Ssid)</script></td>
<td><span id="ssid2"></span></td>
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
</div>

<div id="div_wifi3" style="display:none">
<br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_MultiApInfo)</script>&nbsp;2</td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_Ssid)</script></td>
<td><span id="ssid3"></span></td>
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
</div>
</div>

<div id="div_apcli" style="display:none">
<br>
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
<td class="item_left">BSSID</td>
<td><span id="apcliBssid"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Status)</script></td>
<td><span id="apcliStatus"></span></td>
</tr>
</table></td></tr>
</table>
</div>

<br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_LanInfo)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_Ip)</script></td>
<td><span id="lanIp"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Mask)</script></td>
<td><span id="lanMask"></span></td>
</tr>
<tr id="div_dhcp_server">
<td class="item_left"><script>dw(MM_DhcpServer)</script></td>
<td><span id="dhcpServer"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Mac)</script></td>
<td><span id="lanMac"></span></td>
</tr>
</table></td></tr>
</table>

<br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_Statistics)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left">&nbsp;</td>
<td><b><script>dw(MM_RxPackets)</script></b></td>
<td><b><script>dw(MM_TxPackets)</script></b></td>
</tr>
<tr id="div_wan_statistics" style="display:none">
<td class="item_left"><b>WAN</b></td>
<td><span id="wanrx"></span></td>
<td><span id="wantx"></span></td>
</tr>
<tr>
<td class="item_left"><b>LAN</b></td>
<td><span id="lanrx"></span></td>
<td><span id="lantx"></span></td>
</tr>
<tr id="div_wifi_statistics" style="display:none">
<td class="item_left"><b><script>dw(MM_WiFi)</script></b></td>
<td><span id="wlanrx"></span></td>
<td><span id="wlantx"></span></td>
</tr>
</table></td></tr>
</table>
<br>
</td></tr></table>
</body></html>