<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="/style/normal_ws.css" rel="stylesheet" type="text/css">
<script src="/js/jquery.min.js"></script>
<script src="/js/load.js"></script>
<script src="/js/jcommon.js"></script>
<script src="/js/json2.min.js"></script>
<SCRIPT>
var rJson, rJsonPpp;
$(function(){
    var postVar={topicurl:"setting/getIPv6Cfg"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);	
			$("#wan_enable").val(rJson['Enabled']);
			if(rJson['WanIPv6Type']==1){
				setJSONValue({
					'static_ipv6'	:   rJson['IPv6Address'],
					'static_gw'		: 	rJson['IPv6Gateway'],
					'static_dns1'	:	rJson['IPv6DNS1'],
					'static_dns2'	:	rJson['IPv6DNS2'],
					'static_mtu'	:	rJson['static_mtu']
				});				
				$("#OriginType").get(0).selectedIndex=rJson['WanIPv6Type'];
				ipv6_wan_enable_select();				
			}else if(rJson['WanIPv6Type']==2){
				supplyValue("dnsMode_D",rJson['ipv6DnsAuto']);
				$("#dhcp_mtu").val(rJson['static_mtu']);
				if(rJson['wan_addr6_global'] !=null){
					var globalIp=insert_flg(rJson['wan_addr6_global'], ':', 4);
					$("#dhcp_ip").val(globalIp);
				}else{
					$("#dhcp_ip").val("::");
				}
				if(rJson['ipv6DnsAuto']==0){	
					setJSONValue({				
						'dhcp_dns1'	: 	rJson['IPv6DNS1'],
						'dhcp_dns2'	:	rJson['IPv6DNS2'],
						'pri_dns'	: 	rJson['IPv6DNS1']									
					});
					if(rJson['IPv6DNS2'] !=""){
						$("#sec_dns").val(rJson['IPv6DNS2']);
					}else{
						$("#sec_dns").val("::");
					}
					manualDNS_D();	
				}else{
					if(rJson['wan_addr6_global'] !=null){
						if(rJson['RDDNS'] !=""){
							$("#pri_dns").val(rJson['RDDNS']);
						}else{
							$("#pri_dns").val("::");
						}
						if(rJson['RDDNS2'] !=""){
							$("#sec_dns").val(rJson['RDDNS2']);
						}else{
							$("#sec_dns").val("::");
						}
					}else{
						$("#pri_dns").val("::");
						$("#sec_dns").val("::");
					}
				}					
				$("#OriginType").get(0).selectedIndex=rJson['WanIPv6Type'];
				ipv6_wan_enable_select();			
			}else if(rJson['WanIPv6Type']==0){				
				supplyValue("dnsMode_P",rJson['ipv6DnsAuto']);
				if(rJson['ipv6DnsAuto']==0){
					setJSONValue({				
						'pppoe_dns1'	: 	rJson['IPv6DNS1'],
						'pppoe_dns2'	:	rJson['IPv6DNS2']			
					});
					manualDNS_P();	
				}
				setJSONValue({				
					'pppUserName'	: 	rJson['pppoe_user'],
					'pppPassword'	:	rJson['pppoe_pass'],
					'pppPassword1'	:	rJson['pppoe_pass'],
					'pppPassword2'	:	rJson['pppoe_pass'],
					'pppoeMtu'		: 	rJson['pppoe_mtu']	
				});												
				$("#OriginType").get(0).selectedIndex=rJson['WanIPv6Type'];
				ipv6_wan_enable_select();		
			}
			if(rJson['prefix_type']==1){						
				var prefix1=rJson['Prefix1'].split("/");
				$("#lanPrefix").val(prefix1[0]);
				supplyValue("PreType",1);
				Static();
			}else{
				supplyValue("PreType",0);
				Delegated();
			}
		}
    });		
    try{ 
	   parent.frames["title"].initValue();
    }catch(e){}
});

function onclick_enable_dhcpv6pd(checked){
	with(document.tcpip){
		if(checked){
			enable_dhcpv6pd.value=1;
		}else{
			enable_dhcpv6pd.value=0
		}
	}
}

function onclick_enable_dhcpv6commit(checked){
	with(document.tcpip){
		if(checked){
			enable_dhcpv6RapidCommit.value=1;
		}else{
			enable_dhcpv6RapidCommit.value=0
		}
	}
}

function do_count_down(){
	document.getElementById("show_sec").innerHTML=wtime;
	if(wtime==0){resetForm(); return false;}
	if(wtime>0){wtime--;setTimeout('do_count_down()',1000);}
}

function insert_flg(str,flg,sn){
    var newstr="";
    for(var i=0;i<str.length-1;i+=sn){
        var tmp=str.substring(i, i+sn);
        newstr+=tmp+flg;
    }
    newstr=newstr.substring(0, newstr.length-1);
    return newstr;
}

function isIPv6(str){//IPV6地址判断 
 	return /:/.test(str) 
 	&&str.match(/:/g).length<8
 	&&/::/.test(str)
 	?(str.match(/::/g).length==1
 	&&/^::$|^(::)?([\da-f]{1,4}(:|::))*[\da-f]{1,4}(:|::)?$/i.test(str))
 	:/^([\da-f]{1,4}:){7}[\da-f]{1,4}$/i.test(str);
}

function originTypeSelection(){
	$("#div_static,#div_dhcp,#div_pppoe").hide();	
	if($("#OriginType").get(0).selectedIndex==0){
		$("#div_pppoe").show();
	}else if($("#OriginType").get(0).selectedIndex==1){
		$("#div_static").show();
		$("#static_mtu").hide();
	}else if($("#OriginType").get(0).selectedIndex==2){
		$("#div_dhcp").show();
		$("#dhcp_mtu,#hiddhcp").hide();
	}
}

function ipv6_wan_enable_select(){
	if($("#wan_enable").val()==0){
		setDisabled("#OriginType",true);
		$("#div_pppoe,#div_static,#div_dhcp,#ipv6Lan_div").hide();
		$("#OriginType").css('backgroundColor','#ebebe4');
	}else{
		setDisabled("#OriginType",false);
		$("#OriginType").css('backgroundColor','');
		$("#div_pppoe,#div_static,#div_dhcp,#ipv6Lan_div").show();
		originTypeSelection();
	}
}

function Delegated(){$("#div_lan_prefix").hide();}
function Static(){$("#div_lan_prefix").show();}
function autoDNS_P(){$("#div_dns1,#div_dns2").hide();}
function manualDNS_P(){$("#div_dns1,#div_dns2").show();}
function autoDNS_D(){$("#div_dns3,#div_dns4").hide();}
function manualDNS_D(){$("#div_dns3,#div_dns4").show();}

function checkIpField(type){
	if(type==1){
		if(!isIPv6($("#static_ipv6").val())){$("#ip_tip").show();}else{$("#ip_tip").hide();}
	}else if(type==2){
		if(!isIPv6($("#static_gw").val())){$("#gw_tip").show();}else{$("#gw_tip").hide();}	
	}else if(type==3){
		if(!isIPv6($("#lanPrefix").val())){$("#prefix_tip").show();}else{$("#prefix_tip").hide();}		
	}
}

function checkDnsField(type){
	if(type==1){
		if(!isIPv6($("#static_dns1").val())){$("#dns1_tip").show();}else{$("#dns1_tip").hide();}
	}else if(type==2){
		if(!isIPv6($("#static_dns2").val())){$("#dns2_tip").show();}else{$("#dns2_tip").hide();}	
	}else if(type==3){
		if(!isIPv6($("#pppoe_dns1").val())){$("#dns3_tip").show();}else{$("#dns3_tip").hide();}	
	}else if(type==4){
		if(!isIPv6($("#pppoe_dns2").val())){$("#dns4_tip").show();}else{$("#dns4_tip").hide();}
	}else if(type==5){
		if(!isIPv6($("#dhcp_dns1").val())){$("#dns5_tip").show();}else{$("#dns5_tip").hide();}	
	}else if(type==6){
		if(!isIPv6($("#dhcp_dns2").val())){$("#dns6_tip").show();}else{$("#dns6_tip").hide();}
	}
}

function wanInfoCheck(){
	if($("#OriginType").val()=="1"){
		if (!checkVaildVal.IsEmpty($("#static_ipv6").val(),MM_Ipv6Addr)) return false;
		if (!checkVaildVal.IsEmpty($("#static_gw").val(),MM_Gateway)) return false;
		if (!checkVaildVal.IsEmpty($("#static_dns1").val(),MM_PriDns)) return false;
		if (!checkVaildVal.IsVaildNumber($("#static_mtu").val(),"MTU")) return false;
		if (!checkVaildVal.IsVaildNumberRange($("#static_mtu").val(),"MTU",1400,1500)) return false;
	}
	else if($("#OriginType").val()=="0"){
		var checkbox = $('input[id="checkbox"]:checked').val();
		if(checkbox == "on"){
			$("#pppPassword").val($("#pppPassword2").val());
		}else{
			$("#pppPassword").val($("#pppPassword1").val());
		}
		if (!checkVaildVal.IsEmpty($("#pppUserName").val(),MM_UserName)) return false;
		if (!checkVaildVal.IsEmpty($("#pppPassword").val(),MM_Password)) return false;
		if($(':radio[name=dnsMode_P]:checked').val()=="0"){
			if (!checkVaildVal.IsEmpty($("#pppoe_dns1").val(),MM_PriDns)) return false;
		}
		if (!checkVaildVal.IsVaildNumber($("#pppoeMtu").val(),"MTU")) return false;
		if (!checkVaildVal.IsVaildNumberRange($("#pppoeMtu").val(),"MTU",1360,1492)) return false;
	}else if($("#OriginType").val()=="2"){
		if($(':radio[name=dnsMode_D]:checked').val()=="0"){
			if (!checkVaildVal.IsEmpty($("#dhcp_dns1").val(),MM_PriDns)) return false;
		}
		if (!checkVaildVal.IsVaildNumber($("#dhcp_mtu").val(),"MTU")) return false;
		if (!checkVaildVal.IsVaildNumberRange($("#dhcp_mtu").val(),"MTU",1400,1500)) return false;
	}
	return true;
}

function doSubmit(){
	if(!wanInfoCheck()) return;
	var postVar={"topicurl":"setting/setIPv6WanCfg"};
	postVar['wan_enable']=$("#wan_enable").val();
	postVar['save']="Apply Changes";
	postVar['OriginType']=$("#OriginType").val();
	if($("#OriginType").val()==1){	
		postVar['linkType']="0";	
		postVar['dnsType']="0";
		postVar['static_ipv6']=$("#static_ipv6").val();
		postVar['static_gw']=$("#static_gw").val();
		postVar['static_dns1']=$("#static_dns1").val();
		postVar['static_dns2']=$("#static_dns2").val();
		postVar['static_mtu']=$("#static_mtu").val();
	}else if($("#OriginType").val()==2){
		postVar['linkType']="0";
		postVar['dhcpMode']="stateless";
		postVar['dnsType']=$(':radio[name=dnsMode_D]:checked').val();
		if(postVar['dnsType']==0){
			postVar['static_dns1']=$("#dhcp_dns1").val();
			postVar['static_dns2']=$("#dhcp_dns2").val();
		}
		postVar['static_mtu']=$("#dhcp_mtu").val();
	}else if($("#OriginType").val()==0){
		postVar['linkType']="1";
		postVar['dhcpMode']="stateless";
		postVar['dnsType']=$(':radio[name=dnsMode_P]:checked').val();
		if(postVar['dnsType']==0){
			postVar['static_dns1']=$("#pppoe_dns1").val();
			postVar['static_dns2']=$("#pppoe_dns2").val();
		}
		postVar['connectionType']="3";
		postVar['pppoeUser']=$("#pppUserName").val();
		var checkbox = $('input[id="checkbox"]:checked').val();
		if(checkbox == "on"){
			postVar['pppoePass']=$("#pppPassword2").val();
		}else{
			postVar['pppoePass']=$("#pppPassword1").val();
		}
		postVar['pppoeMtu']=$("#pppoeMtu").val();
		postVar['pppoeOPMode']="0";
		postVar['pppoeSpecType']="0";
		postVar['pppoeRedialPeriod']="60";
	}
	
	if($(':radio[name=PreType]:checked').val()==1){
		if (!checkVaildVal.IsEmpty($("#lanPrefix").val(),MM_Ipv6Prefix)) return false;
		var lan=$("#lanPrefix").val()+"/64";
		postVar['Prefix']=lan;
		postVar['enable_dhcpv6pd']="0";
		postVar['enable_radvd']="1";
	}else{
		postVar['enable_radvd']="0";
		postVar['enable_dhcpv6pd']="1";
	}
	postVar['wan_enable']=$("#wan_enable").val();
	postVar['prefix_type']=$(':radio[name=PreType]:checked').val();
	postVar['RadvdInterFaceName']="br0";
	postVar['MaxRtrAdvInterval']="600";
	postVar['MinRtrAdvInterval']="198";
	postVar['MinDelayBetweenRAs']="3";
	postVar['AdvManagedFlag']="0";
	postVar['AdvOtherConfigFlag']="1";
	postVar['AdvLinkMTU']="0";
	postVar['AdvReachableTime']="0"
	postVar['AdvRetransTimer']="0"
	postVar['AdvCurHopLimit']="64";
	postVar['AdvDefaultLifetime']="1800";	
	postVar['AdvDefaultPreference']="medium";
	postVar['AdvsourceLLAddress']="0";
	postVar['UnicastOnly']="0";	
	postVar['Enabled_0']="1";
	postVar['AdvOnLinkFlag_0']="1";
	postVar['AdvAutonomousFlag_0']="1";
	postVar['AdvValidLifetime_0']="2592000";
	postVar['AdvPreferredLifetime_0']="604800";
	postVar['AdvRouterAddr_0']="0";
	postVar['if6to4_0']="";
	uiPost2(postVar);
}

function renew_D(){
	var postVar={"topicurl":"setting/setIPv6WanCfg"};
	postVar['wan_enable']=$("#wan_enable").val();
	postVar['save']="Apply Changes";
	postVar['OriginType']=$("#OriginType").val();
	postVar['linkType']="0";
	postVar['dhcpMode']="stateless";
	postVar['dnsType']=$(':radio[name=dnsMode_D]:checked').val();
	if(postVar['dnsType']==0){
		postVar['static_dns1']=$("#dhcp_dns1").val();
		postVar['static_dns2']=$("#dhcp_dns2").val();
	}
	postVar['static_mtu']=$("#dhcp_mtu").val();
	uiPost6(postVar);
}

function release_D1(){
	var postVar={"topicurl":"setting/setIPv6WanCfgRelease"};
	uiPost6(postVar);
}

function delay(){$("#pri_dns,#sec_dns,#dhcp_ip").val("::");}
function release_D(){setTimeout("delay()",3000);release_D1();}

function updatePassType(){
	var checkbox = $('input[id="checkbox"]:checked').val();
	if(checkbox == "on"){
		$("#pppPassword2").val($("#pppPassword1").val()); 
		$("#pppPassword").val($("#pppPassword1").val());
		$("#div_pppPassword1").hide();
		$("#div_pppPassword2").show();
	}else{
		$("#pppPassword1").val($("#pppPassword2").val());
		$("#pppPassword").val($("#pppPassword2").val());
		$("#div_pppPassword1").show();//p
		$("#div_pppPassword2").hide();//t
	}
}
</script>
</head>

<body class="mainbody"> 
<div id="div_body_setting">
<script>showLanguageLabel()</script>
<table width="900"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_Ipv6)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_Ipv6)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr><td colspan="2" height="10"></td></tr>
<tr><td colspan="2"><b>IPv6 WAN</b></td></tr>
<tr>
<td class="item_left"><script>dw(MM_OnOff)</script></td>
<td><select class="select" id="wan_enable" onChange="ipv6_wan_enable_select()">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Ipv6WanConnType)</script></td>
<td><select class="select" id="OriginType" onChange="originTypeSelection()">
<option value="0">PPPoE</option>
<option value="1"><script>dw(MM_StaticIp)</script></option>
<option value="2"><script>dw(MM_DynamicIp)</script></option>
</select></td>
</tr>
</table>

<span id="div_pppoe" class="off">  
<table border="0" width="100%">
<tr>
<td class="item_left"><script>dw(MM_UserName)</script></td>
<td><input type="text" class="text" id="pppUserName" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Password)</script></td>
<td><input type="hidden" id="pppPassword"><span id="div_pppPassword1"><input type=password class="text" id="pppPassword1" maxlength="32"></span><span id="div_pppPassword2" style="display:none"><input type="text" class="text" id="pppPassword2" maxlength="32"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="checkbox" onChange="updatePassType()"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Ipv6AddrType)</script></td>
<td>SLAAC</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_DnsServer)</script></td>
<td><input type="radio" value="1" name="dnsMode_P" onClick="autoDNS_P()" checked><script>dw(MM_Ipv6DnsType1)</script>
<input type="radio" value="0" name="dnsMode_P" onClick="manualDNS_P()"><script>dw(MM_Ipv6DnsType2)</script></td>
</tr>
<tr id="div_dns1" class="off">
<td class="item_left"><script>dw(MM_PriDns)</script></td>
<td><input type="text" class="text6" id="pppoe_dns1" maxlength="48"> <span id="dns3_tip" class="off"><script>dw(MM_Ipv6AddrCheck)</script></span></td>
</tr>
<tr id="div_dns2" class="off">
<td class="item_left"><script>dw(MM_SecDns)</script></td>
<td><input type="text" class="text6" id="pppoe_dns2" maxlength="48"> <span id="dns4_tip" class="off"><script>dw(MM_Ipv6AddrCheck)</script></span></td>
</tr>
<tr>
<td class="item_left">MTU</td>
<td><input type="text" class="text" id="pppoeMtu" maxlength="4" value="1492"> (1360~1492)</td>
</tr>
</table>
</span>

<span id="div_static" class="off">  
<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_Ipv6Addr)</script></td>
<td><input type="text" class="text6" id="static_ipv6" maxlength="48"> <span id="ip_tip" class="off"><script>dw(MM_Ipv6AddrCheck)</script></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Gateway)</script></td>
<td><input type="text" class="text6" id="static_gw" maxlength="48"> <span id="gw_tip" class="off"><script>dw(MM_Ipv6AddrCheck)</script></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_PriDns)</script></td>
<td><input type="text" class="text6" id="static_dns1" maxlength="48"> <span id="dns1_tip" class="off"><script>dw(MM_Ipv6AddrCheck)</script></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_SecDns)</script></td>
<td><input type="text" class="text6" id="static_dns2" maxlength="48"> <span id="dns2_tip" class="off"><script>dw(MM_Ipv6AddrCheck)</script></span></td>
</tr>
<tr id="static_mtu">
<td class="item_left">MTU</td>
<td><input type="text" class="text" maxlength="4" value="1500"> (1400-1500)</td>
</tr>
</table>  
</span>
            
<span id="div_dhcp" class="off" > 
<table border=0 width="100%">
<tbody id="hiddhcp">
<tr>
<td class="item_left"><script>dw(MM_Ipv6Addr)</script></td>
<td><input type="text" class="text6" id="dhcp_ip" maxlength="48" value="::" readonly></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_PriDns)</script></td>
<td><input type="text" class="text6" id="pri_dns" maxlength="48" value="::" readonly></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_SecDns)</script></td>
<td><input type="text" class="text6" id="sec_dns" maxlength="48" value="::" readonly></td>
</tr>
<tr>
<td class="item_left"></td>
<td><script>dw('<input type=button class=button value="'+BT_Update+'" onClick="renew_D()">&nbsp;&nbsp;<input type=button class=button value="'+BT_Release+'" onClick="release_D()">')</script></td></tr>
<tr>
<td class="item_left"><script>dw(MM_Ipv6AddrType)</script></td>
<td>SLAAC</td>
</tr>
</tbody>
<tr>
<td class="item_left"><script>dw(MM_DnsServer)</script></td>
<td><input type="radio" value="1" name="dnsMode_D" onClick="autoDNS_D()" checked><script>dw(MM_Ipv6DnsType1)</script>&nbsp;&nbsp;<input type="radio" value="0" name="dnsMode_D" onClick="manualDNS_D()"><script>dw(MM_Ipv6DnsType2)</script></td>
</tr>
<tr id="div_dns3" class="off">
<td class="item_left"><script>dw(MM_PriDns)</script></td>
<td><input type="text" class="text6" id="dhcp_dns1" maxlength="48"> <span id="dns5_tip" class="off"><script>dw(MM_Ipv6AddrCheck)</script></span></td>
</tr>
<tr id="div_dns4" class="off">
<td class="item_left"><script>dw(MM_SecDns)</script></td>
<td><input type="text" class="text6" id="dhcp_dns2" maxlength="48"> <span id="dns6_tip" class="off"><script>dw(MM_Ipv6AddrCheck)</script></span></td>
</tr>
<tr id="dhcp_mtu">
<td class="item_left">MTU</td>
<td><input type="text" class="text" maxlength="4" value="1500"> (1400-1500)</td>
</tr>
</table>
</span>

<span id="ipv6Lan_div" class="off"> 
<input type="hidden" value="/ipv6_wan.htm" name="submit-url">
<input type="hidden" value="no" name="ChangeNotSave">
<table border=0 width="100%">
<tr><td colspan="2" height="10"></td></tr>
<tr><td colspan="2"><b>IPv6 LAN</b></td></tr>
<tr>
<td class="item_left"><script>dw(MM_Ipv6AddrType)</script></td>
<td>RADVD+SLAAC</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Ipv6PrefixType)</script></td> 
<td><input type="radio" value=0 name="PreType" onClick="Delegated()" checked><script>dw(MM_Ipv6PrefixType1)</script>&nbsp;&nbsp;<input type="radio" value=1 name="PreType" onClick="Static()"><script>dw(MM_Ipv6PrefixType2)</script></td>
</tr>
<tr id="div_lan_prefix">
<td class="item_left"><script>dw(MM_Ipv6Prefix)</script></td>
<td><input type="text" class="text6" id="lanPrefix" maxlength="48">/64 <span id="prefix_tip" class="off"><script>dw(MM_Ipv6AddrCheck)</script></span><td>
</tr>
</table>
</span>

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