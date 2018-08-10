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
var rJson,rJsonMac;
var v_wanList,v_wanMode,v_lanIp;
var v_wanIp,v_wanMask,v_wanGw,v_priDns,v_secDns;  
var v_pptpIp,v_pptpMask,v_pptpGw,v_pptpServer;
var v_l2tpIp,v_l2tpMask,v_l2tpGw,v_l2tpServer;   
var v_cloneMac,v_defaultMac,v_enCloneMac;
var v_russiaSupport;
var pppConnectStatus=0;  

function cloneMacClick(){
	supplyValue("macCloneEnabled",1);
	setDisabled("#factoryMacBtn",false);
	setDisabled("#cloneMacBtn",true);
	var postVar={topicurl:"setting/getStationMacByIp"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJsonMac=JSON.parse(Data);							
		}
    });	
	var mac=rJsonMac['stationMac'].split(":");
	$("#mac1").val(mac[0].toUpperCase());
	$("#mac2").val(mac[1].toUpperCase());
	$("#mac3").val(mac[2].toUpperCase());
	$("#mac4").val(mac[3].toUpperCase());
	$("#mac5").val(mac[4].toUpperCase());
	$("#mac6").val(mac[5].toUpperCase());
}

function factoryMacClick(){
	supplyValue("macCloneEnabled",0);
	supplyValue("macCloneMac",v_defaultMac);
	var macArr=$("#macCloneMac").val().split(":");
	$("#mac1").val(macArr[0].toUpperCase());
	$("#mac2").val(macArr[1].toUpperCase());
	$("#mac3").val(macArr[2].toUpperCase());
	$("#mac4").val(macArr[3].toUpperCase());
	$("#mac5").val(macArr[4].toUpperCase());
	$("#mac6").val(macArr[5].toUpperCase());
	setDisabled("#factoryMacBtn",true);
	setDisabled("#cloneMacBtn",false);
}

function showMac(){
	var currMac=(v_enCloneMac==1?v_cloneMac:v_defaultMac);
	supplyValue("macCloneEnabled",v_enCloneMac);
	supplyValue("macCloneMac",currMac);
	if(v_enCloneMac ==1){
		setDisabled("#factoryMacBtn",false);
		setDisabled("#cloneMacBtn",true);
	}else{
		setDisabled("#factoryMacBtn",true);
		setDisabled("#cloneMacBtn",false);
	}
	var macArr=currMac.split(":");
	$("#mac1").val(macArr[0]);
	$("#mac2").val(macArr[1]);
	$("#mac3").val(macArr[2]);
	$("#mac4").val(macArr[3]);
	$("#mac5").val(macArr[4]);
	$("#mac6").val(macArr[5]);
}

function setValAttr(objectID){
	$("#"+objectID).val("");
	$("#"+objectID).focus();	
}

function saveChanges(){	
	setJSONValue({
		'priDns'			:	combinIP($(":input[name=dns1]")),
		'secDns'			:	combinIP($(":input[name=dns2]")),			
		'staticIp'			:	combinIP($(":input[name=ip]")),
		'staticMask'		:	combinIP($(":input[name=mask]")),
		'staticGw'			:	combinIP($(":input[name=gw]")),					
		'pptpIp'			:	combinIP($(":input[name=pptp_ip]")),
		'pptpMask'			:	combinIP($(":input[name=pptp_mask]")),
		'pptpGw'			:	combinIP($(":input[name=pptp_gw]")),
		'pptpServerIp'		:	combinIP($(":input[name=pptp_server]")),
		'l2tpIp'			:	combinIP($(":input[name=l2tp_ip]")),
		'l2tpMask'			:	combinIP($(":input[name=l2tp_mask]")),
		'l2tpGw'			:	combinIP($(":input[name=l2tp_gw]")),
		'l2tpServerIp'		:	combinIP($(":input[name=l2tp_server]")),	
		'macCloneMac'		:	combinMAC2($("#mac1").val(),$("#mac2").val(),$("#mac3").val(),$("#mac4").val(),$("#mac5").val(),$("#mac6").val())
	});
	
	if ($("#wanMode").val()=="0"){
		if (!checkVaildVal.IsVaildIpAddr($("#staticIp").val(),MM_Ip)) return false;
		if (!checkVaildVal.IsSameIp($("#staticIp").val(),v_lanIp)){alert(JS_msg44);return false}
		if (!checkVaildVal.IsVaildMaskAddr($("#staticMask").val(),MM_Mask)) return false;
		if (!checkVaildVal.IsVaildIpAddr($("#staticGw").val(),MM_Gateway)) return false;   
		if (!checkVaildVal.IsIpSubnet($("#staticGw").val(),$("#staticMask").val(),$("#staticIp").val())){alert(JS_msg45);return false;}		
		if ($("#staticGw").val()==$("#staticIp").val()){alert(JS_msg46);return false;}
		if (!checkVaildVal.IsVaildIpAddr($("#priDns").val(),MM_PriDns)) return false;  
		if ($("#secDns").val()!=""){if(!checkVaildVal.IsVaildIpAddr($("#secDns").val(),MM_SecDns)) return false;}
		if (!checkVaildVal.IsVaildNumber($("#staticMtu").val(),"MTU")){setValAttr("staticMtu");return false;}
		if (!checkVaildVal.IsVaildNumberRange($("#staticMtu").val(),"MTU",576,1500)){setValAttr("staticMtu");return false;}
	}else if ($("#wanMode").val()=="1"){ 
		if ($("#hostName").val()!=""){if (!checkVaildVal.IsVaildString($("#hostName").val(),MM_HostName,1)) return false;}
		if (!checkVaildVal.IsVaildNumber($("#dhcpMtu").val(),"MTU")){setValAttr("dhcpMtu");return false;}
		if (!checkVaildVal.IsVaildNumberRange($("#dhcpMtu").val(),"MTU",576,1500)){setValAttr("dhcpMtu");return false;}
		if ($('#dnsMode').get(0).selectedIndex==1){
			if (!checkVaildVal.IsVaildIpAddr($("#priDns").val(),MM_PriDns)) return false;  
			if ($("#secDns").val()!=""){if (!checkVaildVal.IsVaildIpAddr($("#secDns").val(),MM_SecDns)) return false;}
		}
	}else if ($("#wanMode").val()=="3"){
		var checkbox = $('input[id="pppoe_pass"]:checked').val();
		if(checkbox == "on"){
			$("#pppoePass").val($("#pppoePass3").val());
		}else{
			$("#pppoePass").val($("#pppoePass2").val());
		} 
		if (!checkVaildVal.IsVaildString($("#pppoeUser").val(),MM_UserName,1)){return false;}
		if (!checkVaildVal.IsVaildString($("#pppoePass").val(),MM_Password,1)){return false;}	
		if (v_russiaSupport==1){
			if ($("#pppoeServiceName").val()!=""){if (!checkVaildVal.IsVaildString($("#pppoeServiceName").val(),MM_ServiceName,1)) return false;}
			if ($("#pppoeAcName").val()!=""){if (!checkVaildVal.IsVaildString($("#pppoeAcName").val(),MM_AcName,1)) return false;}
		}
		if (!checkVaildVal.IsVaildNumber($("#pppoeMtu").val(),"MTU")){setValAttr("pppoeMtu");return false;}	
		if (!checkVaildVal.IsVaildNumberRange($("#pppoeMtu").val(),"MTU",546,1492)){setValAttr("pppoeMtu");return false;}
		if ($('#dnsMode').get(0).selectedIndex==1){
			if (!checkVaildVal.IsVaildIpAddr($("#priDns").val(),MM_PriDns)) return false;  
			if ($("#secDns").val()!=""){if(!checkVaildVal.IsVaildIpAddr($("#secDns").val(),MM_SecDns)) return false;}   
		}
	}else if ($("#wanMode").val()=="4"){ 
		var checkbox = $('input[id="pptp_pass"]:checked').val();
		if(checkbox == "on"){
			$("#pptpPass").val($("#pptpPass3").val());
		}else{
			$("#pptpPass").val($("#pptpPass2").val());
		}
		if (!checkVaildVal.IsVaildString($("#pptpUser").val(),MM_UserName,1)){setValAttr("pptpUser");return false;}		
		if (!checkVaildVal.IsVaildString($("#pptpPass").val(),MM_Password,1)){setValAttr("pptpPass");return false;}
		if ($('#pptpMode').get(0).selectedIndex==0){
			if(!checkVaildVal.IsVaildIpAddr($("#pptpIp").val(),MM_Ip))return false;
			if (!checkVaildVal.IsVaildMaskAddr($("#pptpMask").val(),MM_Mask))return false;
			if(!checkVaildVal.IsVaildIpAddr($("#pptpGw").val(),MM_Gateway))return false;
		}		
		if ($('#pptpDomainFlag').get(0).selectedIndex==0){
			if (!checkVaildVal.IsVaildIpAddr($("#pptpServerIp").val(),MM_ServerIp))return false;
		}else{
			if (!checkVaildVal.IsVaildString($("#pptpServerDomain").val(),MM_DomainServiceName,1))return false;
		}
		if (!checkVaildVal.IsVaildNumber($("#pptpMtu").val(),"MTU")){setValAttr("pptpMtu");return false;}
		if (!checkVaildVal.IsVaildNumberRange($("#pptpMtu").val(),"MTU",546,1492)){setValAttr("pptpMtu");return false;}
		if ($('#dnsMode').get(0).selectedIndex==1){
			if (!checkVaildVal.IsVaildIpAddr($("#priDns").val(),MM_PriDns))return false;  
			if ($("#secDns").val()!=""){if(!checkVaildVal.IsVaildIpAddr($("#secDns").val(),MM_SecDns))return false;}   
		}
	}else if ($("#wanMode").val()=="6"){
		var checkbox = $('input[id="l2tp_pass"]:checked').val();
		if(checkbox == "on"){
			$("#l2tpPass").val($("#l2tpPass3").val());
		}else{
			$("#l2tpPass").val($("#l2tpPass2").val());
		} 
		if (!checkVaildVal.IsVaildString($("#l2tpUser").val(),MM_UserName,1)){setValAttr("l2tpUser");return false;}
		if (!checkVaildVal.IsVaildString($("#l2tpPass").val(),MM_Password,1)){setValAttr("l2tpPass");return false;}		
		if ($('#l2tpMode').get(0).selectedIndex==0){
			if (!checkVaildVal.IsVaildIpAddr($("#l2tpIp").val(),MM_Ip))return false;
			if (!checkVaildVal.IsVaildMaskAddr($("#l2tpMask").val(),MM_Mask))return false;
			if (!checkVaildVal.IsVaildIpAddr($("#l2tpGw").val(),MM_Gateway))return false;
		}		
		if ($('#l2tpDomainFlag').get(0).selectedIndex==0){
			if (!checkVaildVal.IsVaildIpAddr($("#l2tpServerIp").val(),MM_ServerIp))return false;
		}else{
			if (!checkVaildVal.IsVaildString($("#l2tpServerDomain").val(),MM_DomainServiceName,1))return false;
		}
		if (!checkVaildVal.IsVaildNumber($("#l2tpMtu").val(),"MTU")){setValAttr("l2tpMtu");return false;}
		if (!checkVaildVal.IsVaildNumberRange($("#l2tpMtu").val(),"MTU",546,1492)){setValAttr("l2tpMtu");return false;}
		if ($('#dnsMode').get(0).selectedIndex==1){
			if (!checkVaildVal.IsVaildIpAddr($("#priDns").val(),MM_PriDns))return false;  
			if ($("#secDns").val()!=""){if(!checkVaildVal.IsVaildIpAddr($("#secDns").val(),MM_SecDns))return false;}  
		}
	}
	if ($("#macCloneMac").val()!=""){if (!checkVaildVal.IsVaildMacAddr($("#macCloneMac").val(),MM_Mac))return false;} 
	return true;
}

function updateWanMode(){	
	$("#div_static,#div_dhcp,#div_pppoe,#div_l2tp,#div_pptp,#div_dns,#div_dns_mode").hide();
	$("#div_macclone").show();
	if ($("#wanMode").val()=="0"){			
		$("#div_static,#div_dns").show();
		supplyValue("dnsMode",1);
	}else if ($("#wanMode").val()=="1"){			
		$("#div_dhcp,#div_dns,#div_dns_mode").show();
		if(rJson['wanMode']=="1"&&rJson['dnsMode']==1){
			supplyValue("dnsMode",1);
		}else{
			supplyValue("dnsMode",0);
		}
	}else if ($("#wanMode").val()=="3"){ 
		pppoeOPModeSwitch();
		$("#div_pppoe,#div_dns,#div_dns_mode").show();
		if(rJson['wanMode']=="3"&&rJson['dnsMode']==1){
			supplyValue("dnsMode",1);
		}else{
			supplyValue("dnsMode",0);
		}
	}else if ($("#wanMode").val()=="4"){
		pptpModeSwitch();
		pptpDomainFlagSwitch();
		pptpOPModeSwitch();
		$("#div_pptp,#div_dns,#div_dns_mode").show();
		if(rJson['wanMode']=="4"&&rJson['dnsMode']==1){
			supplyValue("dnsMode",1);
		}else{
			supplyValue("dnsMode",0);
		}
	}else if ($("#wanMode").val()=="6"){
		l2tpModeSwitch();
		l2tpDomainFlagSwitch();
		l2tpOPModeSwitch();
		$("#div_l2tp,#div_dns,#div_dns_mode").show();
		if(rJson['wanMode']=="6"&&rJson['dnsMode']==1){
			supplyValue("dnsMode",1);
		}else{
			supplyValue("dnsMode",0);
		}
	}
	if(rJson['operationMode']==3){
		$("#div_macclone").hide();
	}
	dnsModeSwitch();
	showMac();
}

function l2tpModeSwitch(){
	if ($("#l2tpMode").get(0).selectedIndex==0){ 
		$("#div_l2tpIp,#div_l2tpMask,#div_l2tpGw").show();
	}else{
		$("#div_l2tpIp,#div_l2tpMask,#div_l2tpGw").hide();
	}
}

function l2tpDomainFlagSwitch(){
	if ($("#l2tpDomainFlag").get(0).selectedIndex==0){ 
		$("#div_l2tpServerIp").show();
		$("#div_l2tpServerDomain").hide();
	}else{
		$("#div_l2tpServerIp").hide();
		$("#div_l2tpServerDomain").show();
	}
}

function pptpModeSwitch(){
	if ($("#pptpMode").get(0).selectedIndex==0){ 
		$("#div_pptpIp,#div_pptpMask,#div_pptpGw").show();
	}else{ 
		$("#div_pptpIp,#div_pptpMask,#div_pptpGw").hide();
	}
}

function pptpDomainFlagSwitch(){
	if ($("#pptpDomainFlag").get(0).selectedIndex==0){ 
		$("#div_pptpServerIp").show();
		$("#div_pptpServerDomain").hide();
	}else{
		$("#div_pptpServerIp").hide();
		$("#div_pptpServerDomain").show();
	}
}

function setPPPConnected(){
   	pppConnectStatus=1;
}

function updatePassType(index){
	if(index == 1){
		var checkbox = $('input[id="pppoe_pass"]:checked').val();
		if(checkbox == "on"){
			$("#pppoePass3").val($("#pppoePass2").val()); 
			$("#pppoePass").val($("#pppoePass2").val());
			$("#div_pppoe_pass2").hide();
			$("#div_pppoe_pass3").show();
		}else{
			$("#pppoePass2").val($("#pppoePass3").val());
			$("#pppoePass").val($("#pppoePass3").val());
			$("#div_pppoe_pass2").show();//p
			$("#div_pppoe_pass3").hide();//t
		}
	}else if(index == 2){
		var checkbox = $('input[id="l2tp_pass"]:checked').val();
		if(checkbox == "on"){
			$("#l2tpPass3").val($("#l2tpPass2").val()); 
			$("#l2tpPass").val($("#l2tpPass2").val());
			$("#div_l2tp_pass2").hide();
			$("#div_l2tp_pass3").show();
		}else{
			$("#l2tpPass2").val($("#l2tpPass3").val());
			$("#l2tpPass").val($("#l2tpPass3").val());
			$("#div_l2tp_pass2").show();//p
			$("#div_l2tp_pass3").hide();//t
		}
	}else if(index == 3){
		var checkbox = $('input[id="pptp_pass"]:checked').val();
		if(checkbox == "on"){
			$("#pptpPass3").val($("#pptpPass2").val()); 
			$("#pptpPass").val($("#pptpPass2").val());
			$("#div_pptp_pass2").hide();
			$("#div_pptp_pass3").show();
		}else{
			$("#pptpPass2").val($("#pptpPass3").val());
			$("#pptpPass").val($("#pptpPass3").val());
			$("#div_pptp_pass2").show();//p
			$("#div_pptp_pass3").hide();//t
		}
	}
}
function pppoeOPModeSwitch(){
	if ($("#pppoeOpMode").get(0).selectedIndex==1){
		$("#div_pppoe_manual").show();
		if (pppConnectStatus==0){	
			setDisabled("#pppConnect",false);
			setDisabled("#pppDisconnect",true);
		}else{
			setDisabled("#pppConnect",true);
			setDisabled("#pppDisconnect",false);
		}
	}else{
		$("#div_pppoe_manual").hide();
	}
}

function l2tpOPModeSwitch(){
	if ($("#l2tpOpMode").get(0).selectedIndex==0){	
		setDisabled("#l2tpTime",false);
	}else{
		setDisabled("#l2tpTime",true);
	}
}

function pptpOPModeSwitch(){
	if ($("#pptpOpMode").get(0).selectedIndex==0){
		setDisabled("#pptpTime",false);
	}else{
		setDisabled("#pptpTime",true);
	}
}

function dnsModeSwitch(){
	if ($("#dnsMode").get(0).selectedIndex==1){
		setDisabled(":input[name=dns1]",false);
		setDisabled(":input[name=dns2]",false);
	}else{		
		setDisabled(":input[name=dns1]",true);
		setDisabled(":input[name=dns2]",true);
	}
}

function CreateWanOption(val){
	new_options=[MM_StaticIp,'DHCP','PPPoE','PPTP','L2TP'];
	new_values=['0','1','3','4','6'];	
	CreateOptions("wanMode",new_options,new_values);
	if (val.indexOf("static")==-1){$("#wanMode option[value='0']").remove();}
	if (val.indexOf("dhcp")==-1){$("#wanMode option[value='1']").remove();}
	if (val.indexOf("pppoe")==-1){$("#wanMode option[value='3']").remove();}
	if (rJson['operationMode']==3){
		$("#wanMode option[value='4']").remove();
		$("#wanMode option[value='6']").remove();
	}else{
		if (val.indexOf("pptp")==-1){$("#wanMode option[value='4']").remove();}
		if (val.indexOf("l2tp")==-1){$("#wanMode option[value='6']").remove();}
	}
}

$(function(){
	var postVar={topicurl:"setting/getWanConfig"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);			
			v_russiaSupport=rJson['russiaSupport'];			
			v_lanIp=rJson['lanIp'];
			v_wanList=rJson['wanList'];
			v_wanMode=rJson['wanMode'];		  
			v_wanIp=rJson['staticIp'];
			v_wanMask=rJson['staticMask'];
			v_wanGw=rJson['staticGw'];
			v_priDns=rJson['priDns'];
			v_secDns=rJson['secDns'];
			v_pptpIp=rJson['pptpIp'];
			v_pptpMask=rJson['pptpMask'];
			v_pptpGw=rJson['pptpGw'];
			v_pptpServer=rJson['pptpServerIp'];
			v_l2tpIp=rJson['l2tpIp'];
			v_l2tpMask=rJson['l2tpMask'];
			v_l2tpGw=rJson['l2tpGw'];
			v_l2tpServer=rJson['l2tpServerIp'];
			v_cloneMac=rJson['macCloneMac'];
			v_defaultMac=rJson['wanDefMac'];
			v_enCloneMac=rJson['macCloneEnabled'];
			if (v_secDns=="0.0.0.0") v_secDns="";
			
			CreateWanOption(v_wanList);
			
			setJSONValue({
				'wanMode'		:	rJson['wanMode'], 
				'dhcpMtu'		:	rJson['dhcpMtu'],
			    'staticMtu'     :   rJson['staticMtu'],
				'hostName'		:	rJson['hostName'],
				
				'pppoeServiceName'     :   rJson['pppoeServiceName'],
				'pppoeAcName'   :   rJson['pppoeAcName'],
				'pppoeUser'     :   rJson['pppoeUser'],
				'pppoePass2'	:   rJson['pppoePass'],
				'pppoePass3'	:   rJson['pppoePass'],
				'pppoeMtu'	    :   rJson['pppoeMtu'],
				'pppoeOpMode'	:	rJson['pppoeOpMode'],
				'pppoeTime'		:	rJson['pppoeTime'],
				'pppoeSpecType'	:	rJson['pppoeSpecType'],

				'pptpUser'      :   rJson['pptpUser'],
				'pptpPass2'	    :   rJson['pptpPass'],
				'pptpPass3'	    :   rJson['pptpPass'],
				'pptpMtu'	    :   rJson['pptpMtu'],
				'pptpOpMode'	:	rJson['pptpOpMode'],
				'pptpIp'	    :   rJson['pptpIp'],
				'pptpMask'   	:   rJson['pptpMask'],
				'pptpGw'		:   rJson['pptpGw'],
				'pptpDomainFlag'  :   rJson['pptpDomainFlag'],
				'pptpServerDomain'  :   rJson['pptpServerDomain'],
				'pptpServerIp'  :   rJson['pptpServerIp'],
				'pptpMppe' 		:   rJson['pptpMppe'],
				'pptpMppc' 		:   rJson['pptpMppc'],
				'pptpTime'		:	rJson['pptpTime'],
				'pptpMode'		:	rJson['pptpMode'],
				
				'l2tpUser'      :   rJson['l2tpUser'],
				'l2tpPass2'	    :   rJson['l2tpPass'],
				'l2tpPass3'	    :   rJson['l2tpPass'],
				'l2tpMtu'	    :   rJson['l2tpMtu'],
				'l2tpOpMode'	:	rJson['l2tpOpMode'],
				'l2tpIp'	    :   rJson['l2tpIp'],
				'l2tpMask'   	:   rJson['l2tpMask'],
				'l2tpGw'		:   rJson['l2tpGw'],
				'l2tpDomainFlag'  :   rJson['l2tpDomainFlag'],
				'l2tpServerDomain'  :   rJson['l2tpServerDomain'],					
				'l2tpServerIp'  :   rJson['l2tpServerIp'],
				'l2tpTime'		:	rJson['l2tpTime'],
				'l2tpMode'		:	rJson['l2tpMode'],
					  
				'staticIp'	    :   rJson['staticIp'],
				'staticMask'	:   rJson['staticMask'],
				'staticGw'		:   rJson['staticGw'],
				'priDns'        :   rJson['priDns'],
				'secDns'        :   rJson['secDns']		  
			});  
				
			if(v_wanMode==3){
				if (rJson['wanConnStatus']=="connected"){	
					setPPPConnected();
				}
			}
			
			if (rJson['operationMode']==3){
				$("#div_macclone,#div_wandetect").hide();
			}else{
				$("#div_macclone").show();
				if (rJson['wanAutoDetectBt']==1){
					$("#div_wandetect").show();
				}else{
					$("#div_wandetect").hide();
				}
			}
			
			if (rJson['pppoeSpecBt']==1){
				$("#div_pppoe_spec").show();
			}else{
				$("#div_pppoe_spec").hide();
			}
			
			if (rJson['russiaSupport']==1){
				$("#div_pppoe_service_name,#div_pppoe_ac_name").show();
			}else{
				$("#div_pppoe_service_name,#div_pppoe_ac_name").hide();
			}
			
			if (v_wanMode==0){
				supplyValue("div_wanmode",MM_StaticIpMode);
				$("#div_dns").show();
				$("#div_dns_mode").hide();
			}else if (v_wanMode==1){
				supplyValue("div_wanmode",MM_DhcpMode);
				$("#div_dns,#div_dns_mode").show();
			}else if (v_wanMode==3){
				supplyValue("div_wanmode",MM_PppoeMode);
				pppoeOPModeSwitch();		
				$("#div_dns,#div_dns_mode").show();
			}else if (v_wanMode==4){
				supplyValue("div_wanmode",MM_PptpMode);
				pptpModeSwitch();	
				pptpDomainFlagSwitch();
				pptpOPModeSwitch();
				$("#div_dns,#div_dns_mode").show();
			}else if (v_wanMode==6){		
				supplyValue("div_wanmode",MM_L2tpMode);
				l2tpModeSwitch();
				l2tpDomainFlagSwitch();
				l2tpOPModeSwitch();
				$("#div_dns,#div_dns_mode").show();
			}			
			updateWanMode();
			
			if (rJson['wanConnStatus']=="connected"){
				$("#div_wanstatus").html(MM_Connected).attr('class','blue');
			}else{
				$("#div_wanstatus").html(MM_Disconnected).attr('class','red');
			}
			
			supplyValue("dnsMode",rJson['dnsMode']);
			dnsModeSwitch();
			
			if (v_enCloneMac==1){
				setDisabled("#factoryMacBtn",false);
				setDisabled("#cloneMacBtn",true);
				supplyValue("macCloneMac",v_cloneMac);
			}else{		
				setDisabled("#factoryMacBtn",true);
				setDisabled("#cloneMacBtn",false);
				supplyValue("macCloneMac",v_defaultMac);
			}

			if ('0.0.0.0' != v_wanIp && v_wanIp !="") decomIP($(":input[name=ip]"),v_wanIp,1);
			if ('0.0.0.0' != v_wanMask && v_wanMask !="") decomIP($(":input[name=mask]"),v_wanMask,1);
			if ('0.0.0.0' != v_wanGw && v_wanGw !="") decomIP($(":input[name=gw]"),v_wanGw,1);
			if ('0.0.0.0' != v_priDns && v_wanGw !="") decomIP($(":input[name=dns1]"),v_priDns,1);
			if ('0.0.0.0' != v_secDns && v_wanGw !="") decomIP($(":input[name=dns2]"),v_secDns,1);
			if (v_pptpIp !="") decomIP($(":input[name=pptp_ip]"),v_pptpIp,1);
			if (v_pptpMask !="") decomIP($(":input[name=pptp_mask]"),v_pptpMask,1);
			if (v_pptpGw !="") decomIP($(":input[name=pptp_gw]"),v_pptpGw,1);
			if (v_pptpServer !="") decomIP($(":input[name=pptp_server]"),v_pptpServer,1);
			if (v_l2tpIp !="") decomIP($(":input[name=l2tp_ip]"),v_l2tpIp,1);	
			if (v_l2tpMask !="") decomIP($(":input[name=l2tp_mask]"),v_l2tpMask,1);
			if (v_l2tpGw !="") decomIP($(":input[name=l2tp_gw]"),v_l2tpGw,1);
			if (v_l2tpServer !="") decomIP($(":input[name=l2tp_server]"),v_l2tpServer,1);			
			if (v_cloneMac!=""){
				cloneMac_tmp=v_cloneMac.split(":");
				$("#mac1").val(cloneMac_tmp[0]);
				$("#mac2").val(cloneMac_tmp[1]);
				$("#mac3").val(cloneMac_tmp[2]);
				$("#mac4").val(cloneMac_tmp[3]);
				$("#mac5").val(cloneMac_tmp[4]);
				$("#mac6").val(cloneMac_tmp[5]);
			}
			$("#div_pppoe_pass2,#div_pptp_pass2,#div_l2tp_pass2").show();//p
			$("#div_pppoe_pass3,#div_pptp_pass3,#div_l2tp_pass3").hide();//t
			showMac();
		}
    });	
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function doSubmit(){
	if(saveChanges()==false) return false;
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setWanConfig"};
	postVar['wanMode']= $('#wanMode').val();
	if($('#wanMode').val()=="0"){
		postVar['staticIp']=$('#staticIp').val();
		postVar['staticMask']=$('#staticMask').val();
		postVar['staticGw']=$('#staticGw').val();
		postVar['staticMtu']=$('#staticMtu').val();
	}else if($('#wanMode').val()=="1"){
		postVar['hostName']=$('#hostName').val();
		postVar['dhcpMtu']=$("#dhcpMtu").val();
	}else if($('#wanMode').val()=="3"){
		postVar['pppoeServiceName']=$("#pppoeServiceName").val();
		postVar['pppoeAcName']=$("#pppoeAcName").val();	
		postVar['pppoeUser']=$('#pppoeUser').val();
		postVar['pppoePass']=$("#pppoePass").val();
		postVar['pppoeSpecType']=$("#pppoeSpecType").val();
		postVar['pppoeMtu']=$('#pppoeMtu').val();
		postVar['pppoeOpMode']=$('#pppoeOpMode').val();
		postVar['pppoeTime']=$('#pppoeTime').val();
	}else if($('#wanMode').val()=="4"){
		postVar['pptpDomainFlag']=$('#pptpDomainFlag').val();	
		if($('#pptpDomainFlag').val()==1){
			postVar['pptpServerDomain']=$('#pptpServerDomain').val();	
		}else{
			postVar['pptpServerIp']=$('#pptpServerIp').val();
		}
		postVar['pptpUser']=$("#pptpUser").val();
		postVar['pptpPass']=$("#pptpPass").val();
		postVar['pptpMode']=$('#pptpMode').val();
		postVar['pptpIp']=$("#pptpIp").val();
		postVar['pptpMask']=$('#pptpMask').val();
		postVar['pptpGw']=$('#pptpGw').val();
		postVar['pptpMtu']=$("#pptpMtu").val();
		postVar['pptpOpMode']=$('#pptpOpMode').val();
		postVar['pptpTime']=$("#pptpTime").val();
		postVar['pptpMppe']=$("#pptpMppe").is(':checked')?"1":"0";
		postVar['pptpMppc']=$("#pptpMppc").is(':checked')?"1":"0";
	}else if($('#wanMode').val()=="6"){
		postVar['l2tpDomainFlag']=$('#l2tpDomainFlag').val();	
		if($('#l2tpDomainFlag').val()==1){
			postVar['l2tpServerDomain']=$('#l2tpServerDomain').val();	
		}else{
			postVar['l2tpServerIp']=$('#l2tpServerIp').val();
		}
		postVar['l2tpUser']=$("#l2tpUser").val();
		postVar['l2tpPass']=$("#l2tpPass").val();
		postVar['l2tpMode']=$('#l2tpMode').val();
		postVar['l2tpIp']=$("#l2tpIp").val();
		postVar['l2tpMask']=$('#l2tpMask').val();
		postVar['l2tpGw']=$('#l2tpGw').val();
		postVar['l2tpMtu']=$("#l2tpMtu").val();
		postVar['l2tpOpMode']=$('#l2tpOpMode').val();
		postVar['l2tpTime']=$("#l2tpTime").val();
	}
	postVar['macCloneEnabled']=$('#macCloneEnabled').val();
	postVar['macCloneMac']=$('#macCloneMac').val();
	postVar['dnsMode']=$('#dnsMode').val();
	if($('#dnsMode').get(0).selectedIndex==1){
		postVar['priDns']=$('#priDns').val();
		if($('#secDns').val()==""){
			postVar['secDns']='0.0.0.0';
		}else{
			postVar['secDns']=$('#secDns').val();
		}
	}
	$("#show_msg").html(JS_msg75);
	uiPost2(postVar);
}

function waitpage(){
	$("#div_setting").hide();
	$("#div_wait").show();
	do_count_down();
}

var lanip='',wtime=30;
function uiPost2(postVar){
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		var rJson=JSON.parse(Data);
		lanip=rJson['lan_ip'];
	});
	waitpage();
}

function do_count_down(){
	$("#show_sec").html(wtime);
	if(wtime==0){resetForm(); return false;}
	if(wtime > 0){wtime--;setTimeout('do_count_down()',1000);}
}

function pppConnectClick(connect){
	if(saveChanges()==false) return false;
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setWanConfig"};		
	postVar['wanMode']="3";
	postVar['pppoeServiceName']=$("#pppoeServiceName").val();
	postVar['pppoeAcName']=$("#pppoeAcName").val();	
	postVar['pppoeUser']=$('#pppoeUser').val();
	postVar['pppoePass']=$("#pppoePass").val();
	postVar['pppoeSpecType']=$("#pppoeSpecType").val();
	postVar['pppoeMtu']=$('#pppoeMtu').val();
	postVar['pppoeOpMode']=$('#pppoeOpMode').val();
	postVar['pppoeTime']=$('#pppoeTime').val();
	postVar['macCloneEnabled']=$('#macCloneEnabled').val();
	postVar['macCloneMac']=$('#macCloneMac').val();
	if(Number(connect)==0){
		postVar['pppConnect']="1";
	}else if(Number(connect)==1){	
		postVar['pppDisconnect']="1";
	}
	postVar['dnsMode']=$('#dnsMode').val();
	if($('#dnsMode').get(0).selectedIndex==1){
		postVar['priDns']=$('#priDns').val();
		postVar['secDns']=$('#secDns').val();
	}
	uiPost(postVar);
}

var rJsonConn;
function wanAutoConnect(){
	$(".select").css('backgroundColor','#ebebe4');
	$(":input").attr('disabled',true);
	$("#div_wandetect_wait").show();
	var postVar={topicurl:"setting/discoverWan"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, success : function(Data){
			rJsonConn=JSON.parse(Data);	
			$("#div_wandetect_wait,#div_wanresult").hide();
			$("#div_wanmode,#div_wanstatus").show();
			var wanType=rJsonConn['discoverProto'];
			if(wanType == -1){//link down
				$("#div_wanmode,#div_wanstatus").hide();
				$("#div_wanresult").show();
			}else if(wanType == 0){//static
				supplyValue("wanMode","0");
				$("#div_wanmode").html(MM_StaticIpMode);
			}else if(wanType == 1){//dhcp
				supplyValue("wanMode","1");
				$("#div_wanmode").html(MM_DhcpMode);
			}else if(wanType == 2){//ppp
				supplyValue("wanMode","3");
				$("#div_wanmode").html(MM_PppoeMode);
				$("#div_wanstatus").html(MM_Disconnected).attr('class','red');
			}else{
				supplyValue("wanMode","0");
				$("#div_wanmode").html(MM_StaticIpMode);
			}
			updateWanMode();
			$(".select").css('backgroundColor','#ffffff');
			$(":input").attr('disabled',false);
		}
    });
}
</script>
</head>
<body class="mainbody">
<div id="div_setting">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_Wan)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_Wan)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_ConnectionStatus)</script></td>
<td><span id="div_wanmode"></span>&nbsp;&nbsp;&nbsp;<span id="div_wanstatus"></span><span id="div_wanresult" class="red" style="display:none;"><script>dw(MM_WanDisconnected)</script></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ConnectionType)</script></td>
<td><select class="select" id="wanMode" onChange="updateWanMode()"></select><span id="div_wandetect" style="display:none"><script>dw('&nbsp;&nbsp;&nbsp;<input type=button class=button_big id=wanAutoConBTN value="'+BT_StartDetection+'" onClick="wanAutoConnect();">')</script></span>&nbsp;&nbsp;&nbsp;<span id="div_wandetect_wait" style="display:none"><img src="/style/load.gif" align="absmiddle" /></span></td>
</tr>
</table>

<table id="div_static" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_Ip)</script></td>
<td><input type="hidden" id="staticIp"><input type="text" class="text3" maxlength="3" name="ip" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="ip" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="ip" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="ip" onKeyDown="return ipVali(event,this.name,3);" > </td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Mask)</script></td>
<td><input type="hidden" id="staticMask"><input type="text" class="text3" maxlength="3" name="mask" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="mask" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="mask" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="mask" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Gateway)</script></td>
<td><input type="hidden" id="staticGw"><input type="text" class="text3" maxlength="3" name="gw" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="gw" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="gw" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="gw" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr>
<td class="item_left">MTU</td>
<td><input type="text" class="text" id="staticMtu" maxlength=4>&nbsp;(576~1500)</td>
</tr>
</table>

<table id="div_dhcp" style="display:none" border=0 width="100%">
<tr style="display:none">
<td class="item_left"><script>dw(MM_HostName)</script></td>
<td><input type="text" class="text" id="hostName" maxlength=32> (<script>dw(MM_Optional)</script>)</td>
</tr>
<tr>
<td class="item_left">MTU</td>
<td><input type="text" class="text" id="dhcpMtu" maxlength=4>&nbsp;(576~1500)</td>
</tr>
</table>

<table id="div_pppoe" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_UserName)</script></td>
<td><input type="text" class="text" id="pppoeUser" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Password)</script></td>
<td><input type="hidden" id="pppoePass"><span id="div_pppoe_pass2"><input type="password" class="text" id="pppoePass2" maxlength="32"></span><span id="div_pppoe_pass3" style="display:none"><input type="text" class="text" id="pppoePass3" maxlength="32"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="pppoe_pass" onChange="updatePassType(1)"></td>
</tr>
<tr id="div_pppoe_service_name" style="display:none">
<td class="item_left"><script>dw(MM_ServiceName)</script></td>
<td><input type="text" class="text" id="pppoeServiceName" maxlength="32"></td>
</tr>
<tr id="div_pppoe_ac_name" style="display:none">
<td class="item_left"><script>dw(MM_AcName)</script></td>
<td><input type="text" class="text" id="pppoeAcName" maxlength="32"></td>
</tr>
<tr id="div_pppoe_spec" style="display:none">
<td class="item_left"><script>dw(MM_SpecType)</script></td>
<td><select class="select" id="pppoeSpecType">
<option value="0"><script>dw(MM_None)</script></option>
<option value="1"><script>dw(MM_SpecType)</script> 1</option>
<option value="2"><script>dw(MM_SpecType)</script> 2</option>
<option value="3"><script>dw(MM_SpecType)</script> 3</option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ConnectionMode)</script></td>
<td><select class="select" id="pppoeOpMode" onChange="pppoeOPModeSwitch()">
<option value="0"><script>dw(MM_Auto)</script></option>
<option value="2"><script>dw(MM_Manual)</script></option>
</select>&nbsp;&nbsp;<span id="div_pppoe_manual" style="display:none">
<script>dw('<input type=button class=button id="pppConnect" value="'+BT_Connect+'" onClick="pppConnectClick(0)">')</script>&nbsp;&nbsp;<script>dw('<input type=button class=button id="pppDisconnect" value="'+BT_Disconnect+'" onClick="pppConnectClick(1)">')</script></span></td>
</tr>
<input type="hidden" id="pppoeTime" value="60">
<tr>
<td class="item_left">MTU</td>
<td><input type="text" class="text" id="pppoeMtu" maxlength=4>&nbsp;(546-1492)</td>
</tr>
</table>

<table id="div_l2tp" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_AddressMode)</script></td>
<td><select class="select" id="l2tpMode" onChange="l2tpModeSwitch()">
<option value="1"><script>dw(MM_Static)</script></option>
<option value="0"><script>dw(MM_Dynamic)</script></option>
</select></td>
</tr>
<tr id="div_l2tpIp" style="display:none">
<td class="item_left"><script>dw(MM_Ip)</script></td>
<td><input type="hidden" id="l2tpIp"><input type="text" class="text3" maxlength="3" name="l2tp_ip" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_ip" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_ip" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_ip" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_l2tpMask" style="display:none">
<td class="item_left"><script>dw(MM_Mask)</script></td>
<td><input type="hidden" id="l2tpMask"><input type="text" class="text3" maxlength="3" name="l2tp_mask" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_mask" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_mask" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_mask" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_l2tpGw" style="display:none">
<td class="item_left"><script>dw(MM_Gateway)</script></td>
<td><input type="hidden" id="l2tpGw"><input type="text" class="text3" maxlength="3" name="l2tp_gw" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_gw" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_gw" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_gw" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_l2tpDomainFlag">
<td class="item_left"><script>dw(MM_ServerAddressType)</script></td>
<td><select class="select" id="l2tpDomainFlag" onChange="l2tpDomainFlagSwitch()">
<option value="0">IP</option>
<option value="1"><script>dw(MM_DomainName)</script></option>
</select></td>
</tr>
<tr id="div_l2tpServerIp">
<td class="item_left"><script>dw(MM_ServerIp)</script></td>
<td><input type="hidden" id="l2tpServerIp"><input type="text" class="text3" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_l2tpServerDomain" style="display:none">
<td class="item_left"><script>dw(MM_DomainServiceName)</script></td>
<td><input type="text" class="text" id="l2tpServerDomain" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_UserName)</script></td>
<td><input type="text" class="text" id="l2tpUser" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Password)</script></td>
<td><input type="hidden" id="l2tpPass"><span id="div_l2tp_pass2"><input type="password" class="text" id="l2tpPass2" maxlength="32"></span><span id="div_l2tp_pass3" style="display:none"><input type=text class="text" id="l2tpPass3" maxlength="32"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="l2tp_pass" onChange="updatePassType(2)"></td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_ConnectionMode)</script></td>
<td><select class="select" id="l2tpOpMode" onChange="l2tpOPModeSwitch()">
<option value="0"><script>dw(MM_Auto)</script></option>
<!--<option value="2"><script>dw(MM_Manual)</script></option>-->
</select></td>
</tr>
<input type="hidden" id="l2tpTime" value="60">
<tr>
<td class="item_left">MTU</td>
<td><input type="text" class="text" id="l2tpMtu" maxlength=4>&nbsp;(546-1492)</td>
</tr>
</table>

<table id="div_pptp" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_AddressMode)</script></td>
<td><select class="select" id="pptpMode" onChange="pptpModeSwitch()">
<option value="1"><script>dw(MM_Static)</script></option>
<option value="0"><script>dw(MM_Dynamic)</script></option>
</select></td>
</tr>
<tr id="div_pptpIp" style="display:none">
<td class="item_left"><script>dw(MM_Ip)</script></td>
<td><input type="hidden" id="pptpIp"><input type="text" class="text3" maxlength="3" name="pptp_ip" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_ip" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_ip" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_ip" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_pptpMask" style="display:none">
<td class="item_left"><script>dw(MM_Mask)</script></td>
<td><input type="hidden" id="pptpMask"><input type="text" class="text3" maxlength="3" name="pptp_mask" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_mask" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_mask" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_mask" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_pptpGw" style="display:none">
<td class="item_left"><script>dw(MM_Gateway)</script></td>
<td><input type="hidden" id="pptpGw"><input type="text" class="text3" maxlength="3" name="pptp_gw" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_gw" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_gw" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_gw" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_pptpDomainFlag">
<td class="item_left"><script>dw(MM_ServerAddressType)</script></td>
<td><select class="select" id="pptpDomainFlag" onChange="pptpDomainFlagSwitch()">
<option value="0">IP</option>
<option value="1"><script>dw(MM_DomainName)</script></option>
</select></td>
</tr>
<tr id="div_pptpServerIp">
<td class="item_left"><script>dw(MM_ServerIp)</script></td>
<td><input type="hidden" id="pptpServerIp"><input type="text" class="text3" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_pptpServerDomain" style="display:none">
<td class="item_left"><script>dw(MM_DomainServiceName)</script></td>
<td><input type="text" class="text" id="pptpServerDomain" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_UserName)</script></td>
<td><input type="text" class="text" id="pptpUser" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Password)</script></td>
<td><input type="hidden" id="pptpPass"><span id="div_pptp_pass2"><input type="password" class="text" id="pptpPass2" maxlength="32"></span><span id="div_pptp_pass3" style="display:none"><input type="text" class="text" id="pptpPass3" maxlength="32"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="pptp_pass" onChange="updatePassType(3)"></td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_ConnectionMode)</script></td>
<td><select class="select" id="pptpOpMode" onChange="pptpOPModeSwitch()">
<option value="0"><script>dw(MM_Auto)</script></option>
<!--<option value="2"><script>dw(MM_Manual)</script></option>-->
</select></td>
</tr>
<input type="hidden" id="pptpTime" value="60">
<tr>
<td class="item_left">MTU</td>
<td><input type="text" class="text" id="pptpMtu" maxlength=4>&nbsp;(546-1492)</td>
</tr>
<tr>
<td class="item_left"></td>
<td><input type="checkbox" id="pptpMppe">&nbsp;MPPE
<input type="checkbox" id="pptpMppc">&nbsp;MPPC</td>
</tr>
</table>

<table id="div_dns_mode" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_DnsMode)</script></td>
<td><select class="select" id="dnsMode" onChange="dnsModeSwitch()">
<option value="0"><script>dw(MM_DnsAuto)</script></option>
<option value="1"><script>dw(MM_DnsManual)</script></option>
</select></td>
</tr>
</table>

<table id="div_dns" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_PriDns)</script></td>
<td><input type="hidden" id="priDns"><input type="text" class="text3" maxlength="3" id="pridns1" name="dns1" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="pridns2" name="dns1" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="pridns3" name="dns1" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="pridns4" name="dns1" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_SecDns)</script></td>
<td><input type="hidden" id="secDns"><input type="text" class="text3" maxlength="3" id="secdns1" name="dns2" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="secdns2" name="dns2" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="secdns3" name="dns2" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="secdns4" name="dns2" onKeyDown="return ipVali(event,this.name,3);" >(<script>dw(MM_Optional)</script>)</td>	
</tr>
</table>

<table id="div_macclone" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_MacAddrClone)</script></td>
<td><input type="hidden" id="macCloneEnabled"><input type="hidden" id="macCloneMac"><input type="text" class="text3" maxlength="2" name="mac1" id="mac1" onFocus="this.select();" onKeyUp="HWKeyUp('mac',1,event);" onKeyDown="return HWKeyDown('mac', 1,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac2" id="mac2" onFocus="this.select();" onKeyUp="HWKeyUp('mac',2,event);" onKeyDown="return HWKeyDown('mac', 2,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac3" id="mac3" onFocus="this.select();" onKeyUp="HWKeyUp('mac',3,event);" onKeyDown="return HWKeyDown('mac', 3,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac4" id="mac4" onFocus="this.select();" onKeyUp="HWKeyUp('mac',4,event);" onKeyDown="return HWKeyDown('mac', 4,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac5" id="mac5" onFocus="this.select();" onKeyUp="HWKeyUp('mac',5,event);" onKeyDown="return HWKeyDown('mac', 5,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac6" id="mac6" onFocus="this.select();" onKeyUp="HWKeyUp('mac',6,event);" onKeyDown="return HWKeyDown('mac', 6,event)"></td>
</tr>
<tr>
<td class="item_left"></td>
<td><script>dw('<input type=button class=button_big id=cloneMacBtn value="'+BT_CloneMac+'" onClick="cloneMacClick()">&nbsp;&nbsp;<input type=button class=button_big id=factoryMacBtn value="'+BT_FactoryMac+'" onClick="factoryMacClick()">')</script></td>
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
<td class=msg_title><span id=show_msg></span></script></td></tr>
<tr><td><script>dw(MM_PleaseWait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table></td></tr></table>
</div>
</body></html>
