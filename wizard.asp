<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="style/style.css" rel="stylesheet" type="text/css">
<link href="style/normal_ws.css" rel="stylesheet" type="text/css">
<link rel="shortcut icon" href="style/favicon.ico">
<script src="/js/jquery.min.js"></script>
<script src="/js/json2.min.js"></script>
<script src="/js/load.js"></script>
<script src="/js/jcommon.js"></script>
<script>
var rJson;
var v_wanList,v_wanIp,v_wanMask,v_wanGw,v_priDns,v_secDns,v_lanIp,v_staticIp,v_staticMask,v_staticGw;
var v_pptpIp,v_pptpMask,v_pptpGw,v_pptpServer;
var v_l2tpIp,v_l2tpMask,v_l2tpGw,v_l2tpServer; 
var v_russiaSupport;  
var v_lanIp;
var helpUrl="";
function updateWanMode(){
	$("#div_static_ip,#div_pppoe,#div_l2tp,#div_pptp").hide();
	if ($("#wanMode").val()=="0"){
		$("#div_static_ip").show();
		if ('0.0.0.0' != v_staticIp && v_staticIp !=""){
			decomIP($(":input[name=ip]"),v_staticIp,1);
		}else{
			$(":input[name=ip]").each(function(){this.value = ''; })
		}
		if ('0.0.0.0' != v_staticMask && v_staticMask !=""){
			decomIP($(":input[name=mask]"),v_staticMask,1);
		}else{
			$(":input[name=mask]").each(function(){this.value = ''; })
		}
		if ('0.0.0.0' != v_staticGw && v_staticGw !=""){
			decomIP($(":input[name=gw]"),v_staticGw,1);
		}else{
			$(":input[name=gw]").each(function(){this.value = ''; })
		}
		if ('0.0.0.0' != v_priDns && v_priDns !=""){
			decomIP($(":input[name=dns1]"),v_priDns,1);
		}else{
			$(":input[name=dns1]").each(function(){this.value = ''; })
		}
		if ('0.0.0.0' != v_secDns && v_secDns !=""){
			decomIP($(":input[name=dns2]"),v_secDns,1);
		}else{
			$(":input[name=dns2]").each(function(){this.value = ''; })
		}
	}else if ($("#wanMode").val()=="3"){
		$("#div_pppoe").show();
	}else if ($("#wanMode").val()=="4"){
		$("#div_pptp").show();
		if (v_pptpIp !="") decomIP($(":input[name=pptp_ip]"),v_pptpIp,1);
		if (v_pptpMask !="") decomIP($(":input[name=pptp_mask]"),v_pptpMask,1);
		if (v_pptpGw !="") decomIP($(":input[name=pptp_gw]"),v_pptpGw,1);
		if (v_pptpServer !="") decomIP($(":input[name=pptp_server]"),v_pptpServer,1);
		pptpModeSwitch();
		pptpDomainFlagSwitch();
	}else if ($("#wanMode").val()=="6"){
		$("#div_l2tp").show();
		if (v_l2tpIp !="") decomIP($(":input[name=l2tp_ip]"),v_l2tpIp,1);	
		if (v_l2tpMask !="") decomIP($(":input[name=l2tp_mask]"),v_l2tpMask,1);
		if (v_l2tpGw !="") decomIP($(":input[name=l2tp_gw]"),v_l2tpGw,1);
		if (v_l2tpServer !="") decomIP($(":input[name=l2tp_server]"),v_l2tpServer,1);
		l2tpModeSwitch();
		l2tpDomainFlagSwitch();
	}
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
	}else if(index == 4){
		var checkbox = $('input[id="wpakey_2g"]:checked').val();
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

function CreateWanOption(val){
	new_options=[MM_StaticIp,'DHCP','PPPoE','PPTP','L2TP'];
	new_values=['0','1','3','4','6'];	
	CreateOptions("wanMode",new_options,new_values);
	if (val.indexOf("static")==-1){$("#wanMode option[value='0']").remove();}
	if (val.indexOf("dhcp")==-1){$("#wanMode option[value='1']").remove();}
	if (val.indexOf("pppoe")==-1){$("#wanMode option[value='3']").remove();}
	if (val.indexOf("pptp")==-1){$("#wanMode option[value='4']").remove();}
	if (val.indexOf("l2tp")==-1){$("#wanMode option[value='6']").remove();}
}

$(function(){
	var postVar={topicurl:"setting/getEasyWizardCfg"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);	
			v_russiaSupport=rJson['russiaSupport'];		
			v_lanIp=rJson['lanIp'];
			v_wanList=rJson['wanList'];
			CreateWanOption(v_wanList);
			setJSONValue({
				'wanMode'	:   rJson['wanMode'],				
				'pptpUser'      :   rJson['pptpUser'],
				'pptpPass'	    :   rJson['pptpPass'],
				'pptpPass2'	    :   rJson['pptpPass'],
				'pptpPass3'	    :   rJson['pptpPass'],
				'pptpMppe' 		:   rJson['pptpMppe'],
				'pptpMppc' 		:   rJson['pptpMppc'],
				'pptpMode'		:   rJson['pptpMode'],
				'pptpDomainFlag'  :   rJson['pptpDomainFlag'],
				'pptpServerDomain'  :   rJson['pptpServerDomain'],
				'l2tpUser'      :   rJson['l2tpUser'],
				'l2tpPass'	    :   rJson['l2tpPass'],
				'l2tpPass2'	    :   rJson['l2tpPass'],
				'l2tpPass3'	    :   rJson['l2tpPass'],
				'l2tpMode'		:   rJson['l2tpMode'],
				'l2tpDomainFlag'  :   rJson['l2tpDomainFlag'],
				'l2tpServerDomain'  :   rJson['l2tpServerDomain'],		
				'pppoeServiceName'     :   rJson['pppoeServiceName'],
				'pppoeAcName'   :   rJson['pppoeAcName'],		
				'pppoeUser'		:   rJson['pppoeUser'],
				'pppoePass'		:   rJson['pppoePass'],
				'pppoePass2'	:   rJson['pppoePass'],
				'pppoePass3'	:   rJson['pppoePass']
			});
			v_wanIp=rJson['wanIp'];
			v_wanMask=rJson['wanMask'];
			v_wanGw=rJson['wanGw'];
			v_priDns=rJson['priDns'];
			v_secDns=rJson['secDns'];
			v_staticIp=rJson['staticIp'];
			v_staticMask=rJson['staticMask'];
			v_staticGw=rJson['staticGw'];					
			v_pptpIp=rJson['pptpIp'];
			v_pptpMask=rJson['pptpMask'];
			v_pptpGw=rJson['pptpGw'];
			v_pptpServer=rJson['pptpServerIp'];
			v_l2tpIp=rJson['l2tpIp'];
			v_l2tpMask=rJson['l2tpMask'];
			v_l2tpGw=rJson['l2tpGw'];
			v_l2tpServer=rJson['l2tpServerIp'];	
			if (v_wanIp !="") decomIP($(":input[name=ip]"),v_wanIp,1);
			if (v_wanIp=="0.0.0.0") $(":input[name=ip]").val("");
			if (v_wanMask !="") decomIP($(":input[name=mask]"),v_wanMask,1);
			if (v_wanMask=="0.0.0.0") $(":input[name=mask]").val("");
			if (v_wanGw !="") decomIP($(":input[name=gw]"),v_wanGw,1);
			if (v_wanGw=="0.0.0.0") $(":input[name=gw]").val("");
			if (v_priDns !="") decomIP($(":input[name=dns1]"),v_priDns,1);
			if (v_priDns=="0.0.0.0") $(":input[name=dns1]").val("");
			if (v_secDns !="") decomIP($(":input[name=dns2]"),v_secDns,1);
			if (v_secDns=="0.0.0.0") $(":input[name=dns2]").val("");
			if (v_pptpIp !="") decomIP($(":input[name=pptp_ip]"),v_pptpIp,1);
			if (v_pptpMask !="") decomIP($(":input[name=pptp_mask]"),v_pptpMask,1);
			if (v_pptpGw !="") decomIP($(":input[name=pptp_gw]"),v_pptpGw,1);
			if (v_pptpServer !="") decomIP($(":input[name=pptp_server]"),v_pptpServer,1);
			if (v_l2tpIp !="") decomIP($(":input[name=l2tp_ip]"),v_l2tpIp,1);	
			if (v_l2tpMask !="") decomIP($(":input[name=l2tp_mask]"),v_l2tpMask,1);
			if (v_l2tpGw !="") decomIP($(":input[name=l2tp_gw]"),v_l2tpGw,1);
			if (v_l2tpServer !="") decomIP($(":input[name=l2tp_server]"),v_l2tpServer,1);
			updateWanMode();
			$("#div_pppoe_pass2,#div_pptp_pass2,#div_l2tp_pass2").show();//p
			$("#div_pppoe_pass3,#div_pptp_pass3,#div_l2tp_pass3").hide();//t
			
			if (rJson['russiaSupport']==1){
				$("#div_pppoe_service_name,#div_pppoe_ac_name").show();
			}else{
				$("#div_pppoe_service_name,#div_pppoe_ac_name").hide();
			}
			
			if (rJson['wanMode']==0){
				$("#div_wanmode").html(MM_StaticIpMode);
			}else if (rJson['wanMode']==1){
				$("#div_wanmode").html(MM_DhcpMode);
			}else if (rJson['wanMode']==3){
				$("#div_wanmode").html(MM_PppoeMode);
			}else if (rJson['wanMode']==4){
				$("#div_wanmode").html(MM_PptpMode);
			}else if (rJson['wanMode']==6){
				$("#div_wanmode").html(MM_L2tpMode);
			}	
			if (rJson['wanConnStatus']=="connected"){
				$("#div_wanstatus").html(MM_Connected).attr('class','blue');
			}else{
				$("#div_wanstatus").html(MM_Disconnected).attr('class','red');
			}
			if (rJson['wanAutoDetectBt']==1){
				$("#div_wandetect").show();
			}else{
				$("#div_wandetect").hide();
			}
			setJSONValue({
				'ssid'			:	rJson['ssid'],
				'wpakey1'		:	rJson['wpakey']
			});
			document.title=rJson['webTitle'];
			$("#productModel").html(rJson['productName']+" ("+MM_Firmware+"  "+rJson['fmVersion']+")");
			var tmpCsid=rJson['CSID'];
			if(tmpCsid=="CS13KR"){
				CreateLangOption();
			}else{
				CreateLanguageOption(rJson['multiLangBt']);
			}
			if (rJson['multiLangBt'].split(",").length>1) $("#div_multi_language").show();
			if(tmpCsid=="CS13KR"||tmpCsid=="CS13JR"){
				$("#langType").val(localStorage.language);
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
				if (rJson['langFlag']==1){ 
					$("#langType").val(localStorage.language);
				}else{
					$("#langType").val("auto");
				}
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
			if (rJson['helpBt']==1 && helpUrl!="") $("#div_help").show();
			$("#helpUrl").attr("href",'http://'+helpUrl);
		}
    });
	$("#langType").change(function(){
		var val=$(this).val();
		if (val=="auto"){
			autoLanguage(1);
		}else{
			if (val!=""){
				setLanguage(1,val);
			}
		}		
	});
});

function saveChanges(){	
	$("#staticIp").val(combinIP($(":input[name=ip]")));
	$("#staticMask").val(combinIP($(":input[name=mask]")));
	$("#staticGw").val(combinIP($(":input[name=gw]")));
	$("#priDns").val(combinIP($(":input[name=dns1]")));
	$("#secDns").val(combinIP($(":input[name=dns2]")));
	$("#pptpIp").val(combinIP($(":input[name=pptp_ip]")));
	$("#pptpMask").val(combinIP($(":input[name=pptp_mask]")));
	$("#pptpGw").val(combinIP($(":input[name=pptp_gw]")));
	$("#pptpServerIp").val(combinIP($(":input[name=pptp_server]")));
	$("#l2tpIp").val(combinIP($(":input[name=l2tp_ip]")));
	$("#l2tpMask").val(combinIP($(":input[name=l2tp_mask]")));
	$("#l2tpGw").val(combinIP($(":input[name=l2tp_gw]")));
	$("#l2tpServerIp").val(combinIP($(":input[name=l2tp_server]")));	
	
	if ($("#wanMode").val()=="0"){
		if (!checkVaildVal.IsVaildIpAddr($("#staticIp").val(),MM_Ip)) return false;  
		if (!checkVaildVal.IsSameIp($("#staticIp").val(),v_lanIp)){alert(JS_msg44);return false;}
		if (!checkVaildVal.IsVaildMaskAddr($("#staticMask").val(),MM_Mask)) return false;
		if (!checkVaildVal.IsVaildIpAddr($("#staticGw").val(),MM_Gateway)) return false;   
		if (!checkVaildVal.IsIpSubnet($("#staticGw").val(),$("#staticMask").val(),$("#staticIp").val())){alert(JS_msg45);return false;}		
		if ($("#staticGw").val()==$("#staticIp").val()){alert(JS_msg46);return false;}
		if (!checkVaildVal.IsVaildIpAddr($("#priDns").val(),MM_PriDns)) return false;  
		if ($("#secDns").val()!=""){if(!checkVaildVal.IsVaildIpAddr($("#secDns").val(),MM_SecDns)) return false;}
	}else if ($("#wanMode").val()=="3"){
		var checkbox = $('input[id="pppoe_pass"]:checked').val();
		if(checkbox == "on"){
			$("#pppoePass").val($("#pppoePass3").val());
		}else{
			$("#pppoePass").val($("#pppoePass2").val());
		}
		if (!checkVaildVal.IsVaildString($("#pppoeUser").val(),MM_UserName,1)) return false;
		if (!checkVaildVal.IsVaildString($("#pppoePass").val(),MM_Password,1)) return false;
		if (v_russiaSupport==1){
			if ($("#pppoeServiceName").val()!=""){if (!checkVaildVal.IsVaildString($("#pppoeServiceName").val(),MM_ServiceName,1)) return false;}
			if ($("#pppoeAcName").val()!=""){if (!checkVaildVal.IsVaildString($("#pppoeAcName").val(),MM_AcName,1)) return false;}
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
			if (!checkVaildVal.IsVaildMaskAddr($("#pptpMask").val(),"PPTP "+MM_Mask))return false;
			if(!checkVaildVal.IsVaildIpAddr($("#pptpGw").val(),MM_Gateway))return false;
		}		
		if ($('#pptpDomainFlag').get(0).selectedIndex==0){
			if (!checkVaildVal.IsVaildIpAddr($("#pptpServerIp").val(),MM_ServerIp))return false;
		}else{
			if (!checkVaildVal.IsVaildString($("#pptpServerDomain").val(),MM_DomainServiceName,1))return false;
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
			if (!checkVaildVal.IsVaildMaskAddr($("#l2tpMask").val(),"L2TP "+MM_Mask))return false;
			if (!checkVaildVal.IsVaildIpAddr($("#l2tpGw").val(),MM_Gateway))return false;
		}		
		if ($('#l2tpDomainFlag').get(0).selectedIndex==0){
			if (!checkVaildVal.IsVaildIpAddr($("#l2tpServerIp").val(),MM_ServerIp))return false;
		}else{
			if (!checkVaildVal.IsVaildString($("#l2tpServerDomain").val(),MM_DomainServiceName,1))return false;
		}
	}
	
	if (!checkVaildVal.IsVaildSSID($("#ssid").val(),MM_Ssid)) return false;
	var checkbox = $('input[id="wpakey_2g"]:checked').val();
	if(checkbox == "on"){
		$("#wpakey").val($("#wpakey2").val());
	}else{
		$("#wpakey").val($("#wpakey1").val());
	}
	if ($('#wpakey').val().length<8||$('#wpakey').val().length>63){alert(JS_msg24);return false;}
	if (!checkVaildVal.IsVaildWiFiPass($('#wpakey').val(),MM_Password,"ascii")) return false;			
	return true;
}

function doSubmit(){
	if (saveChanges()==false) return false;	
	var postVar={"topicurl":"setting/setEasyWizardCfg"};
	postVar['wanMode']=$('#wanMode').val();
	if ($("#wanMode").val()=="0"){
		postVar['staticIp']=$('#staticIp').val();
		postVar['staticMask']=$('#staticMask').val();
		postVar['staticGw']=$('#staticGw').val();
		postVar['priDns']=$('#priDns').val();
		if($('#secDns').val()==""){
			postVar['secDns']="0.0.0.0";
		}else{
			postVar['secDns']=$('#secDns').val();
		}
	}else if ($("#wanMode").val()=="3"){
		postVar['pppoeUser']=$('#pppoeUser').val();
		postVar['pppoePass']=$('#pppoePass').val();
		postVar['pppoeServiceName']=$("#pppoeServiceName").val();
		postVar['pppoeAcName']=$("#pppoeAcName").val();	
	}else if ($("#wanMode").val()=="4"){
		postVar['pptpUser']=$("#pptpUser").val();
		postVar['pptpPass']=$('#pptpPass').val();
		postVar['pptpMode']=$('#pptpMode').val();
		postVar['pptpDomainFlag']=$('#pptpDomainFlag').val();	
		if ($('#pptpDomainFlag').val()==1){
			postVar['pptpServerDomain']=$('#pptpServerDomain').val();	
		}else{
			postVar['pptpServerIp']=$('#pptpServerIp').val();
		}
		postVar['pptpIp']=$("#pptpIp").val();
		postVar['pptpMask']=$('#pptpMask').val();
		postVar['pptpGw']=$('#pptpGw').val();
		postVar['pptpMppe']=$("#pptpMppe").is(':checked')?"1":"0";
		postVar['pptpMppc']=$("#pptpMppc").is(':checked')?"1":"0";
	}else if ($("#wanMode").val()=="6"){
		postVar['l2tpUser']=$("#l2tpUser").val();
		postVar['l2tpPass']=$('#l2tpPass').val();
		postVar['l2tpMode']=$('#l2tpMode').val();
		postVar['l2tpDomainFlag']=$('#l2tpDomainFlag').val();	
		if ($('#l2tpDomainFlag').val()==1){
			postVar['l2tpServerDomain']=$('#l2tpServerDomain').val();	
		}else{
			postVar['l2tpServerIp']=$('#l2tpServerIp').val();
		}
		postVar['l2tpIp']=$("#l2tpIp").val();
		postVar['l2tpMask']=$('#l2tpMask').val();
		postVar['l2tpGw']=$('#l2tpGw').val();
	}
	if($('#wanMode').val()=="0"){
		postVar['dnsMode']="1";
	}else{
		postVar['dnsMode']="0";
	}
	postVar['ssid']=$('#ssid').val();
	postVar['wpakey']=$('#wpakey').val();	
	uiPost(postVar);
}

function do_count_down(){
	$("#show_sec").html(wtime);
	if(wtime==0){parent.location.href='http://'+lanip+'/wizard_connect_state.asp';}
	if(wtime>0){wtime--;setTimeout('do_count_down()',1000);}
}

var lanip='',wtime=0;
function uiPost(postVar){
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		var rJsonP=JSON.parse(Data);
		lanip=rJsonP['lan_ip'];
		wtime=rJsonP['wtime'];
		$("#div_mainbody").hide();
		$("#div_wait").show();
		do_count_down();
	});
}

function clickAdvanced(){window.location.href="/home.asp?timestamp="+(new Date()).valueOf();}

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
<body style="overflow-x:hidden;">
<div id="div_mainbody">
<table height="96" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="top_left">&nbsp;</td>
<td class="top_center">&nbsp;</td>
<td class="top_right" align="right">&nbsp;</td>
</tr>
</table>

<table height="44" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="6"></td>
<td class="first_table"><table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="title_down_left" id="productModel"></td>
<td class="title_down_center">&nbsp;</td>
<td class="title_down_right" align="right"><span id="div_multi_language" style="display:none"><select class="select5" id="langType"></select></span>&nbsp;&nbsp;<span id="div_help" style="display:none"><a href="" id="helpUrl" target="_blank"><div class="help_button"><div class="help_title"><script>dw(BT_Help)</script></div></div></a></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</table></td>
<td width="6"></td>
</tr>
</table>

<table id="div_main" height="751" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="6"></td>
<td valign="top" class="first_table">
<table border=0 width="700" align="center">
<tr><td colspan="2" height="45"></td></tr>
<tr><td colspan="2" class="content_title"><script>dw(MM_EasyWizard)</script></td></tr>
<tr>
<td class="content_help"><script>dw(MSG_EasyWizard)</script></td>
<td align="right"><script>dw('<input type=button class=button_big value="'+BT_Advanced+'" onClick="clickAdvanced()">')</script></td>
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
</table>

<div align="center">
<fieldset>
<legend><script>dw(MM_ConnectionStatus)</script></legend>
<table border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_ConnectionStatus)</script></td>
<td>&nbsp;&nbsp;<span id="div_wanmode"></span>&nbsp;&nbsp;<b><span id="div_wanstatus"></span></b><span id="div_wanresult" style="display:none;" class="red"><script>dw(MM_WanDisconnected)</script></span></td>
</tr>
</table>
</fieldset>

<br><br>
<fieldset>
<legend><script>dw(MM_Internet)</script></legend>
<table border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_ConnectionType)</script></td>
<td>&nbsp;&nbsp;<select class="select" id="wanMode" onChange="updateWanMode()"></select><span id="div_wandetect" style="display:none"><script>dw('&nbsp;&nbsp;&nbsp;<input type=button class=button_big id=wanAutoConBTN value="'+BT_StartDetection+'" onClick="wanAutoConnect();">')</script></span>&nbsp;&nbsp;&nbsp;<span id="div_wandetect_wait" style="display:none"><img src="/style/load.gif" align="absmiddle" /></span></td>
</tr>
</table>

<table id="div_static_ip" style="display:none" border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Ip)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="staticIp"><input type="text" class="text3" maxlength="3" id="ip1" name="ip" onKeyDown="return ipVali(event,this.name,0);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="ip2" name="ip" onKeyDown="return ipVali(event,this.name,1);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="ip3" name="ip" onKeyDown="return ipVali(event,this.name,2);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="ip4" name="ip" onKeyDown="return ipVali(event,this.name,3);"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Mask)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="staticMask"><input type="text" class="text3" maxlength="3" id="mask1" name="mask" onKeyDown="return ipVali(event,this.name,0);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="mask2" name="mask" onKeyDown="return ipVali(event,this.name,1);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="mask3" name="mask" onKeyDown="return ipVali(event,this.name,2);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="mask4" name="mask" onKeyDown="return ipVali(event,this.name,3);"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Gateway)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="staticGw"><input type="text" class="text3" maxlength="3" id="gw1" name="gw" onKeyDown="return ipVali(event,this.name,0);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="gw2" name="gw" onKeyDown="return ipVali(event,this.name,1);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="gw3" name="gw" onKeyDown="return ipVali(event,this.name,2);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="gw4" name="gw" onKeyDown="return ipVali(event,this.name,3);"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_PriDns)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="priDns"><input type="text" class="text3" maxlength="3" id="pridns1" name="dns1" onKeyDown="return ipVali(event,this.name,0);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="pridns2" name="dns1" onKeyDown="return ipVali(event,this.name,1);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="pridns3" name="dns1" onKeyDown="return ipVali(event,this.name,2);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="pridns4" name="dns1" onKeyDown="return ipVali(event,this.name,3);"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_SecDns)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="secDns"><input type="text" class="text3" maxlength="3" id="secdns1" name="dns2" onKeyDown="return ipVali(event,this.name,0);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="secdns2" name="dns2" onKeyDown="return ipVali(event,this.name,1);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="secdns3" name="dns2" onKeyDown="return ipVali(event,this.name,2);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="secdns4" name="dns2" onKeyDown="return ipVali(event,this.name,3);">(<script>dw(MM_Optional)</script>)</td>
</tr>
</table>

<table id="div_pppoe" style="display:none" border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_UserName)</script></td>
<td>&nbsp;&nbsp;<input type="text" class="text" id="pppoeUser" maxlength="32"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Password)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="pppoePass"><span id="div_pppoe_pass2"><input type="password" class="text" id="pppoePass2" maxlength="32"></span><span id="div_pppoe_pass3" style="display:none"><input type="text" class="text" id="pppoePass3" maxlength="32"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="pppoe_pass" onChange="updatePassType(1)"></td>
</tr>
<tr id="div_pppoe_service_name" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_ServiceName)</script></td>
<td>&nbsp;&nbsp;<input type="text" class="text" id="pppoeServiceName" maxlength="32"></td>
</tr>
<tr id="div_pppoe_ac_name" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_AcName)</script></td>
<td>&nbsp;&nbsp;<input type="text" class="text" id="pppoeAcName" maxlength="32"></td>
</tr>
</table>

<table id="div_l2tp" style="display:none" border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_AddressMode)</script></td>
<td>&nbsp;&nbsp;<select class="select" id="l2tpMode" onChange="l2tpModeSwitch()">
<option value="1"><script>dw(MM_Static)</script></option>
<option value="0"><script>dw(MM_Dynamic)</script></option>
</select></td>
</tr>
<tr id="div_l2tpIp" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Ip)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="l2tpIp"><input type="text" class="text3" maxlength="3" name="l2tp_ip" onKeyDown="return ipVali(event,this.name,0);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_ip" onKeyDown="return ipVali(event,this.name,1);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_ip" onKeyDown="return ipVali(event,this.name,2);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_ip" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_l2tpMask" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Mask)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="l2tpMask"><input type="text" class="text3" maxlength="3" name="l2tp_mask" onKeyDown="return ipVali(event,this.name,0);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_mask" onKeyDown="return ipVali(event,this.name,1);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_mask" onKeyDown="return ipVali(event,this.name,2);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_mask" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_l2tpGw" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Gateway)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="l2tpGw"><input type="text" class="text3" maxlength="3" name="l2tp_gw" onKeyDown="return ipVali(event,this.name,0);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_gw" onKeyDown="return ipVali(event,this.name,1);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_gw" onKeyDown="return ipVali(event,this.name,2);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_gw" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_l2tpDomainFlag">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_ServerAddressType)</script></td>
<td>&nbsp;&nbsp;<select class="select" id="l2tpDomainFlag" onChange="l2tpDomainFlagSwitch()">
<option value="0">IP</option>
<option value="1"><script>dw(MM_DomainName)</script></option>
</select></td>
</tr>
<tr id="div_l2tpServerIp">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_ServerIp)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="l2tpServerIp"><input type="text" class="text3" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,0);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,1);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,2);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,3);"></td>
</tr>
<tr id="div_l2tpServerDomain" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_DomainServiceName)</script></td>
<td>&nbsp;&nbsp;<input type="text" class="text" id="l2tpServerDomain" maxlength="32"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_UserName)</script></td>
<td>&nbsp;&nbsp;<input type="text" class="text" id="l2tpUser" maxlength="32"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Password)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="l2tpPass"><span id="div_l2tp_pass2"><input type="password" class="text" id="l2tpPass2" maxlength="32"></span><span id="div_l2tp_pass3" style="display:none"><input type="text" class="text" id="l2tpPass3" maxlength="32"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="l2tp_pass" onChange="updatePassType(2)"></td>
</tr>
</table>

<table id="div_pptp" style="display:none" border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_AddressMode)</script></td>
<td>&nbsp;&nbsp;<select class="select" id="pptpMode" onChange="pptpModeSwitch()">
<option value="1"><script>dw(MM_Static)</script></option>
<option value="0"><script>dw(MM_Dynamic)</script></option>
</select></td>
</tr>
<tr id="div_pptpIp" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Ip)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="pptpIp"><input type="text" class="text3" maxlength="3" name="pptp_ip" onKeyDown="return ipVali(event,this.name,0);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_ip" onKeyDown="return ipVali(event,this.name,1);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_ip" onKeyDown="return ipVali(event,this.name,2);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_ip" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_pptpMask" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Mask)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="pptpMask"><input type="text" class="text3" maxlength="3" name="pptp_mask" onKeyDown="return ipVali(event,this.name,0);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_mask" onKeyDown="return ipVali(event,this.name,1);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_mask" onKeyDown="return ipVali(event,this.name,2);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_mask" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_pptpGw" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Gateway)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="pptpGw"><input type="text" class="text3" maxlength="3" name="pptp_gw" onKeyDown="return ipVali(event,this.name,0);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_gw" onKeyDown="return ipVali(event,this.name,1);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_gw" onKeyDown="return ipVali(event,this.name,2);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_gw" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_pptpDomainFlag">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_ServerAddressType)</script></td>
<td>&nbsp;&nbsp;<select class="select" id="pptpDomainFlag" onChange="pptpDomainFlagSwitch()">
<option value="0">IP</option>
<option value="1"><script>dw(MM_DomainName)</script></option>
</select></td>
</tr>
<tr id="div_pptpServerIp">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_ServerIp)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="pptpServerIp"><input type="text" class="text3" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,0);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,1);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,2);"><img src="style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_pptpServerDomain" style="display:none">
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_DomainServiceName)</script></td>
<td>&nbsp;&nbsp;<input type="text" class="text" id="pptpServerDomain" maxlength="32"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_UserName)</script></td>
<td>&nbsp;&nbsp;<input type="text" class="text" id="pptpUser" maxlength="32"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Password)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="pptpPass"><span id="div_pptp_pass2"><input type="password" class="text" id="pptpPass2" maxlength="32"></span><span id="div_pptp_pass3" style="display:none"><input type="text" class="text" id="pptpPass3" maxlength="32"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="pptp_pass" onChange="updatePassType(3)"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"></td>
<td>&nbsp;&nbsp;<input type="checkbox" id="pptpMppe">&nbsp;MPPE
<input type="checkbox" id="pptpMppc">&nbsp;MPPC</td>
</tr>
</table>
</fieldset>

<br><br>
<fieldset>
<legend>2.4G <script>dw(MM_Wireless)</script></legend>
<table border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Ssid)</script></td>
<td>&nbsp;&nbsp;<input type="text" class="text" id="ssid" maxlength="32"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_Password)</script></td>
<td>&nbsp;&nbsp;<input type="hidden" id="wpakey" maxlength="63"><span id="div_wpakey1"><input type="password" class="text" id="wpakey1" maxlength="63"></span><span id="div_wpakey2" style="display:none"><input type="text" class="text" id="wpakey2" maxlength="63"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="wpakey_2g" onChange="updatePassType(4)"></td>
</tr>
<tr><td colspan="3" align="center"><script>dw(JS_msg73)</script></td></tr>
</table>
</fieldset>
</div>

<table border=0 width="700" align="center">
<tr><td height="10"></td></tr>
<tr>
<td class="content_help">&nbsp;</td>
<td align="right"><script>dw('<input type=button class=button_big value="'+BT_Apply+'" onClick="doSubmit()">')</script></td>
</tr>
<tr><td height="50"></td></tr>
</table></td>
<td width="6"></td>
</tr>
</table>

<table height="41" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="bottom_left">&nbsp;</td>
<td class="bottom_center1">&nbsp;</td>
<td class="bottom_center">&nbsp;</td>
<td class="bottom_center1">&nbsp;</td>
<td class="bottom_right">&nbsp;</td>
</tr>
</table>
</div>
<div id="div_wait" style="display:none">
<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
<center>
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_ChangeSetting)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><script>dw(JS_msg75)</script></td></tr>
<tr><td><script>dw(MM_PleaseWait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table></td></tr></table>
</center>
</div>

<div id="div_wait_lang" style="display:none">
<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
<center>
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><span id="show_lang_title"></span></td></tr>
<tr><td height="1" class="line"></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title></td></tr>
<tr><td><span id="show_lang_msg"></span></td></tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table></td></tr></table>
</center>
</div>
<script>
	$(function(){
		$('#div_main').height($(window).height()-181);
	});
	$(window).resize(function(event) {
		$('#div_main').height($(window).height()-181);
	});
</script>
</body>
</html>