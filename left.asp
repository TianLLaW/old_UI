<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="style/menu.css" rel="stylesheet" type="text/css">
<script src="/js/jquery.min.js"></script>
<script src="/js/json2.min.js"></script>
<script src="/js/load.js"></script>
<script src="/js/forbidView.js"></script>
<script>
var rJson,opmode,counts=0;//ddns use it
var icon_System_Status = "icon_System_Status";
var icon_Opmode = "icon_Opmode";
var IPv6_icon = "IPv6_icon";
var icon_Network = "icon_Network";
var icon_Wireless = "icon_Wireless";
var icon_Management = "icon_Management";
var icon_QoS = "icon_QoS";
var icon_Firewall = "icon_Firewall";
var unfold = 1;
var fold = 0;

$(function(){
	var postVar={ topicurl : "setting/getGlobalFeatureBuilt"};
    postVar=JSON.stringify(postVar);
	$.ajax({
       	type : "post", url : "/cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);					
			opmode=rJson['operationMode'];
			a = new Menu('a');
			if(opmode!=1&&opmode!=2){
				a.add(1, 	0, MM_SystemStatus,  		"adm/status.asp",  unfold,icon_System_Status);	
				a.add(101,  1, MM_SystemStatus,     		"adm/status.asp");
				a.add(102,  1, MM_DeviceInfo,    		 	"adm/deviceinfo.asp");
			}else{
				a.add(1, 	0, MM_SystemStatus,  		"adm/status.asp",  unfold,icon_System_Status);	
			}
			
			a.add(2, 	0, MM_OperationMode,         "adm/opmode.asp",  fold,icon_Opmode);
			
			if(opmode!=1&&opmode!=2){
				a.add(3,     0, MM_Network,        	"internet/wan.asp",	 unfold,icon_Network);
				a.add(301,   3, MM_Wan,     			"internet/wan.asp");
				a.add(302,   3, MM_Lan,    		 		"internet/lan.asp");
				a.add(303,   3, MM_StaticDhcp,  		"internet/static_dhcp.asp");
				if (rJson['ethSpeedBt'] == 1)
					a.add(304,  	3, MM_EthSpeed,     "internet/ethspeed.asp");
				if(rJson['iptvBt']==1 && opmode==0){
					if(rJson['iptvSupportCustom'] == 1){
						if(rJson['iptvSupport'] == 1)
							a.add(305,   3, MM_IptvSetup,         "internet/iptv_custom.asp");
					}else{
						if(rJson['csid'] == "CS161R-CT")
							a.add(305,   3, MM_IptvSetup,         "internet/iptv_tw.asp");
						else
							a.add(305,   3, MM_IptvSetup,  		"internet/iptv.asp");
						}
					}
					if(rJson['ipv6Bt']==1){							
						a.add(11,   0,   MM_Ipv6, 		"internet/ipv6_status.asp",	 unfold, IPv6_icon);
						a.add(1101,  10, MM_Ipv6Ststus,     					"internet/ipv6_status.asp");
						a.add(1102,  10, MM_Ipv6,     					"internet/ipv6.asp");
					}
			}else{
				a.add(3,     0, MM_Network,        	"internet/lan.asp",	  unfold,icon_Network);
				a.add(301,   3, MM_Lan,     			"internet/lan.asp");
			}
		
			if(rJson['wifiOff'] == 1){	
				a.add(4,     0, MM_Wireless,  		"wireless/basic.asp",	unfold,icon_Wireless);
				a.add(401,   4, MM_Basic,        		"wireless/basic.asp");
			}else{	
				a.add(4,     0, MM_Wireless,  		"wireless/stainfo.asp",		unfold,icon_Wireless);
				a.add(401,   4, MM_WirelessStatus,      "wireless/stainfo.asp");
				a.add(402,   4, MM_Basic,        		"wireless/basic.asp");
				a.add(403,   4, MM_MultiAp,   			"wireless/multipleap.asp");
				a.add(404,   4, MM_Acl,        	    	"wireless/acl.asp");
				a.add(405,   4, "WDS",        			"wireless/wds.asp");
				a.add(406,   4, "WPS",         			"wireless/wps.asp");
				a.add(407,   4, MM_Advanced,        	"wireless/advanced.asp");
			}
		
			if(opmode!=1&&opmode!=2){
				a.add(5,    0, "QoS",        	  	"firewall/qos.asp",		fold,icon_QoS);
				a.add(6,    0, MM_Firewall,      	"firewall/firewall_type.asp",	unfold,icon_Firewall);
				a.add(601,  6, MM_FirewallType,    		"firewall/firewall_type.asp");
				a.add(602,  6, MM_PortFiltering,   		"firewall/ipport_filtering.asp");
				a.add(603,  6, MM_MacFiltering,    		"firewall/mac_filtering.asp");
				a.add(604,  6, MM_UrlFiltering,    		"firewall/url_filtering.asp");
				a.add(605,  6, MM_PortForwarding,  		"firewall/port_forward.asp");
				a.add(606,  6, MM_VpnPass,  			"firewall/vpnpass.asp");
				a.add(607,  6, "DMZ",      				"firewall/dmz.asp");	
				a.add(608,  6, MM_RuleSchedule,  		"firewall/fwSchedule.asp");				
			}
		
			if(1){
				a.add(9,    0, MM_Management,      		"adm/password.asp",	unfold,icon_Management);
				a.add(901,  9, MM_Administrator,   			"adm/password.asp");
				a.add(902,  9, MM_Ntp,     					"adm/ntp.asp");
				if(opmode!=1&&opmode!=2){				
					a.add(903,  9, "DDNS",        	     	"adm/ddns.asp");
					a.add(904,  9, MM_Remote, 				"adm/remote.asp");
					a.add(905,  9, "UPnP",    				"adm/upnp.asp");
				}
				a.add(906,  9, MM_UpgradeFirmware,    		"adm/upload_firmware.asp");
				a.add(907,  9, MM_SystemSettings,        	"adm/settings.asp");
				a.add(908,  9, MM_SystemLog,        	   	"adm/syslog.asp");
				if(rJson['rebootschBt']==1)
					a.add(909,  9, MM_RebootSchedule, 		"adm/schedule.asp");
				if(rJson['wifiScheduleBt']==1&&opmode==0)
					a.add(910,  9, MM_WiFiSchedule,  		"adm/schedulewifi.asp");
					if(rJson['noticeBt']==1&&opmode!=1&&opmode!=2)
						a.add(911, 9, MM_Notice,                    "adm/notice.asp");
				a.add(999,  9, MM_Logout,      				"#");
			}
			$("#div_Menu").html(a.toString());
		}
    }); 
});
</script>
</head>
<body style="overflow-x:hidden">
<div id="div_Menu"></div>
<form target="_top"></form>
</body>
</html>
