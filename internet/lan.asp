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
var rJson,v_lanIp,v_lanMask,v_br0Ip,v_br0Mask,v_dhcpStart,v_dhcpEnd;
var v_lanGw,v_priDns,v_secDns;
var dhcpStart,dhcpEnd;

function checkMask1(sIPAddress){   
	var exp=/^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;   
	var reg=sIPAddress.match(exp);   
	if(reg==null){   
		return false;
	}else{   
		return true;
	}
} 

function checkMask2(ulMask){
	var ulMask1=Math.floor(ulMask/0x40000000);
	var remainder1=Number(ulMask%0x40000000)
	if (ulMask1<=1) return false;
	if ((ulMask1==2)&&(remainder1!=0)) return false;
	
	ulMask=Number(remainder1*2);
	while(ulMask & 0x40000000){
		remainder1=Number(ulMask%0x40000000)
		ulMask=Number(remainder1*2);	
	}

	if (ulMask==0){
		return true;
	}else{
		return false;
	}
}

function zip(a, b, c, d){
   	var  re=0;
   	re=(Number(a)*16777216)+(Number(b)<<16)+(Number(c)<<8)+(Number(d));
    return re;
}

function unzip(zipc, flag){
	var var1=Math.floor(Number(zipc/16777216));
	var remainder1=Number(zipc%16777216);
	var var2=Math.floor(remainder1/65536);
	var remainder2=Math.floor(remainder1%65536);
	var var3=Math.floor(remainder2/256);
	var var4=Math.floor(remainder2%256);
	
	if(flag==1){
		dhcpStart=var1+'.'+ var2 +'.'+ var3 +'.'+ var4;
	}else if(flag==2){
		dhcpEnd=var1+'.'+ var2 +'.'+ var3 +'.'+ var4;	
	}
}

function IpMaskConfilict(ulIp, ulHostMask){
	var ip1=Math.floor(ulIp/4);
	var ip2=Number(ulIp%4);

	var mask1=Math.floor(~ulHostMask/4);
	var mask2=Number(~ulHostMask%4);

	var network=Number(ip1&mask1)*4+Number(ip2&mask2);//3221225472
	if (network==0 || network== ~ulHostMask){
		alert(JS_msg5);
		return 1;
	}  
	return 0;
}

function firstIP(IP,mask){
	$("#lanIp").val(combinIP($(":input[name=ip]")));
	$("#lanNetmask").val(combinIP($(":input[name=mask]")));
	var iparry=$("#lanIp").val().split('.');
	var ipadd4=iparry[3];
	
	var ip1=Math.floor(IP/4);
	var ip2=Number(IP%4);

	var mask1=Math.floor(mask/4);
	var mask2=Number(mask%4);

	var network=Number(ip1&mask1)*4+Number(ip2&mask2);//3221225472
	var firstIPAdd=0;
	var netIP=(IP&(~mask))+1;
	if (netIP<256&&netIP>128){
		netIP=1;
		firstIPAdd=network+netIP;//1+1;
	}else{
		if(Number(ipadd4)>128) netIP=1;
		firstIPAdd=network+netIP;
	}
	unzip(firstIPAdd,1);
}   

function lastIP(IP,mask){
    var ip1=Math.floor(IP/4);
	var ip2=Number(IP%4);
	var mask1=Math.floor(mask/4);
	var mask2=Number(mask%4);
	var network=Number(ip1&mask1)*4+Number(ip2&mask2);
	var network1=Math.floor(network/2);
	var network2=Number(network%2);
	var lastIPAdd=Number(network2|((~mask)%2))+Number(network1|((~mask)/2))*2-1;	
	var netIP=(IP&(~mask))+1;
	if (netIP==129) lastIPAdd=network+netIP-2;
	if (netIP>129&&mask==4294967040) lastIPAdd=network+netIP-2;//4294967040==[255.255.255.0]
	if (lastIPAdd==IP) lastIPAdd--;
	unzip(lastIPAdd,2);       
}

function autoChangePool(){
	var f=document.lanCfg;
	$("#lanIp").val(combinIP($(":input[name=ip]")));
	$("#lanNetmask").val(combinIP($(":input[name=mask]")));
	var ip=$("#lanIp").val().split('.');
	var mask=$("#lanNetmask").val().split('.');

	var ipadd1=ip[0];
	var ipadd2=ip[1];
	var ipadd3=ip[2];
	var ipadd4=ip[3];
	
	if(Number(ipadd4)>254){
		return false;
	}
	var maskadd1=mask[0];
	var maskadd2=mask[1];
	var maskadd3=mask[2];
	var maskadd4=mask[3];
	
	if (!checkVaildVal.isMask($("#lanNetmask").val()))return false;
	firstIP(zip(ipadd1, ipadd2, ipadd3, ipadd4),zip(maskadd1,maskadd2,maskadd3,maskadd4));
	lastIP(zip(ipadd1, ipadd2, ipadd3, ipadd4),zip(maskadd1,maskadd2,maskadd3,maskadd4));

	for(var i=0;i<4;i++){
		document.lanCfg.sip[i].value=dhcpStart.split(".")[i];
		document.lanCfg.eip[i].value=dhcpEnd.split(".")[i];
	}
	return true;
}

function checkPool(poolstart,poolend){
	var ip1=$("#ip1").val();
	var ip2=$("#ip2").val();
	var ip3=$("#ip3").val();
	var ip4=$("#ip4").val();
	var mask1=$("#mask1").val();
	var mask2=$("#mask2").val();
	var mask3=$("#mask3").val();
	var mask4=$("#mask4").val();
	
	//autoChangePool();
	firstIP(zip(ip1,ip2,ip3,ip4),zip(mask1,mask2,mask3,mask4));
	lastIP(zip(ip1,ip2,ip3,ip4),zip(mask1,mask2,mask3,mask4));

	var rightPools=zip(dhcpStart.split(".")[0], dhcpStart.split(".")[1], dhcpStart.split(".")[2], dhcpStart.split(".")[3]);
	var rightPoole=zip(dhcpEnd.split(".")[0], dhcpEnd.split(".")[1], dhcpEnd.split(".")[2], dhcpEnd.split(".")[3]);
	var currPoolStart=zip(poolstart.split(".")[0], poolstart.split(".")[1], poolstart.split(".")[2], poolstart.split(".")[3]);
	var currPoolEnd=zip(poolend.split(".")[0], poolend.split(".")[1], poolend.split(".")[2], poolend.split(".")[3]);
	
	if(currPoolStart<rightPools || currPoolEnd>rightPoole){
		alert(JS_msg106+dhcpStart+"-"+dhcpEnd);
		return false;
	}
	return true;
}

function checkpPrivateNetwork(ip){
	var aNetSegs=zip("0","0","0","0");
	var aNetSege=zip("127","255","255","255");
	var bNetSegs=zip("128","0","0","0");
	var bNetSege=zip("191","255","255","255");
	var cNetSegs=zip("192","0","0","0");
	var cNetSege=zip("233","255","255","255");
	
	var aPrivateNets=zip("10","0","0","0");
	var aPrivateNete=zip("10","255","255","255");
	var bPrivateNets=zip("172","16","0","0");
	var bPrivateNete=zip("172","31","255","255");
	var cPrivateNets=zip("192","168","0","0");
	var cPrivateNete=zip("192","168","255","255");
	var currIP=zip(ip.split(".")[0],ip.split(".")[1],ip.split(".")[2],ip.split(".")[3]);
	if(aNetSegs<currIP && currIP<aNetSege){ 
		if(aPrivateNete<currIP || currIP<aPrivateNets){
			alert(JS_msg43+"10.0.0.0-10.255.255.255");
			return false;
		}else{
			return true;
		}
	}else if(bNetSegs<currIP && currIP<bNetSege){
		if(bPrivateNete<currIP || currIP<bPrivateNets){
			alert(JS_msg43+"172.16.0.0-172.31.255.255");
			return false;
		}else{
			return true;
		}
	}else if(cNetSegs<currIP && currIP<cNetSege){
		if(cPrivateNete<currIP || currIP<cPrivateNets){
			alert(JS_msg43+"192.168.0.0-192.168.255.255");
			return false;
		}else{
			return true;
		}
	}else{
		return false;
	}
} 

function saveChanges(){	
	setJSONValue({
		'lanIp'			:	combinIP($(":input[name=ip]")),
		'lanNetmask'	:	combinIP($(":input[name=mask]")),			
		'dhcpStart'		:	combinIP($(":input[name=sip]")),
		'dhcpEnd'		:	combinIP($(":input[name=eip]"))
	});
	
	var v_wanConnStatus=rJson['wanConnStatus'];
	if (!checkVaildVal.IsVaildIpAddr($("#lanIp").val(),MM_Ip)) return false;
	if(v_wanConnStatus=="connected"){
		if (rJson['operationMode']!=1&&rJson['operationMode']!=2){if (!checkVaildVal.IsSameIp($("#lanIp").val(),rJson['wanIp'])){alert(JS_msg40);return false}}
	}
	if (!checkpPrivateNetwork($("#lanIp").val())) return false;	
	if (!checkVaildVal.IsVaildMaskAddr($("#lanNetmask").val(),MM_Mask)) return false;
	if ($("#dhcpServer").get(0).selectedIndex==1){
		if (!checkVaildVal.IsVaildIpAddr($("#dhcpStart").val(),"DHCP "+MM_StartIp))return false;				
		if (!checkVaildVal.IsVaildIpAddr($("#dhcpEnd").val(),"DHCP "+MM_EndIp))return false;			
		if (!checkVaildVal.IsIpRange($("#dhcpStart").val(),$("#dhcpEnd").val())) return false;
		if (($("#dhcpStart").val()==$("#lanIp").val())||($("#dhcpEnd").val()==$("#lanIp").val())){alert(JS_msg39);return false;}		
		if (!checkPool($("#dhcpStart").val(),$("#dhcpEnd").val())) return false;
		if (!checkVaildVal.IsIpSubnet($("#lanIp").val(),$("#lanNetmask").val(),$("#dhcpStart").val())){alert(JS_msg55);return false;}
		if (!checkVaildVal.IsIpSubnet($("#lanIp").val(),$("#lanNetmask").val(),$("#dhcpEnd").val())){alert(JS_msg56);return false;}
		if(v_wanConnStatus=="connected"){if (checkVaildVal.IsIpSubnet($("#lanIp").val(),$("#lanNetmask").val(),rJson['wanIp'])){alert(JS_msg76);return false;}}
	}
	if(rJson['operationMode']==1 || rJson['operationMode']==2){
		setJSONValue({
			'lanGateway'	:	combinIP($(":input[name=gateway]")),
			'lanPriDns'		:	combinIP($(":input[name=pridns]")),
			'lanSecDns'		:	combinIP($(":input[name=secdns]"))
		});
		if ($("#lanMode").get(0).selectedIndex == 0) {
			if (!checkVaildVal.IsIpSubnet($("#lanGateway").val(), $("#lanNetmask").val(), $("#lanIp").val())) {alert(JS_msg45);return false;}
			if (!checkVaildVal.IsVaildIpAddr($("#lanGateway").val(),MM_Gateway)) return false;
			if (!checkVaildVal.IsVaildIpAddr($("#lanPriDns").val(),MM_PriDns)) return false;
			if ($("#lanSecDns").val()!=""&&!checkVaildVal.IsVaildIpAddr($("#lanSecDns").val(),MM_SecDns)) return false;
		}
	}
	return true;
}

function dhcpTypeSwitch(){
	if ($("#dhcpServer").get(0).selectedIndex==1){
		$("#div_dhcp_setting").show();
  	}else{
   	  	$("#div_dhcp_setting").hide();
	}
}

function dhcpClientClick(){
	if ($("#dhcpServer").get(0).selectedIndex==1){
		openWindow("dhcp_list.asp", 'DHCPTbl', 700, 400);
	}
}

$(function(){
	var postVar={topicurl:"setting/getLanConfig"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);							
			v_lanIp=rJson['lanIp'];
			v_lanMask=rJson['lanNetmask'];
			v_dhcpStart=rJson['dhcpStart'];
			v_dhcpEnd=rJson['dhcpEnd'];
			v_br0Ip=rJson['br0Ip'];
			v_br0Mask=rJson['br0Netmask'];
			setJSONValue({
				'lanIp'			:	rJson['lanIp'],
				'lanNetmask'	:	rJson['lanNetmask'],
				'dhcpServer'	: 	rJson['dhcpServer'],	
				'dhcpStart'		:	rJson['dhcpStart'],
				'dhcpEnd'		:	rJson['dhcpEnd'],
				'dhcpLease'		:	rJson['dhcpLease']		
			});
			if(v_br0Ip != "0.0.0.0" && v_br0Ip != v_lanIp){
				decomIP($(":input[name=ip]"),v_br0Ip,1);
			}else if(v_lanIp !=""){
				decomIP($(":input[name=ip]"),v_lanIp,1);
			}
			if(v_br0Mask != "0.0.0.0" && v_br0Mask != v_lanMask){
				decomIP($(":input[name=mask]"),v_br0Mask,1);
			}else if(v_lanMask !=""){
				decomIP($(":input[name=mask]"),v_lanMask,1);
			}
			if (v_dhcpStart!="") decomIP($(":input[name=sip]"),v_dhcpStart,1);
			if (v_dhcpEnd!="") decomIP($(":input[name=eip]"),v_dhcpEnd,1);		
			dhcpTypeSwitch();
			if (rJson['operationMode']!=1&&rJson['operationMode']!=2){
				$("#div_dhcp_server").show();
				if(rJson['dhcpServer']==0){
					$("#div_dhcp_setting").hide();
				}else{		 
					$("#div_dhcp_setting").show();
				}
			}else{
				$("#div_dhcp_server,#div_dhcp_setting").hide();
			}
			if(rJson['operationMode']==1 || rJson['operationMode']==2){
				v_lanGw=rJson['lanGateway'];
				v_priDns=rJson['lanPriDns'];
				v_secDns=rJson['lanSecDns'];
				setJSONValue({
				'lanMode'	: 	rJson['lanMode'],	
				'lanGateway'		:	rJson['lanGateway'],
				'lanPriDns'		:	rJson['lanPriDns'],
				'lanSecDns'		:	rJson['lanSecDns']		
				});
				if (v_lanGw!="") decomIP($(":input[name=gateway]"),v_lanGw,1);
				if (v_priDns!="") decomIP($(":input[name=pridns]"),v_priDns,1);
				if (v_secDns!="") decomIP($(":input[name=secdns]"),v_secDns,1);
				$("#div_lan_mode,#div_gateway,#div_pridns,#div_secdns").show();
				dhcpTypeSwitch();
			}else{
				$("#div_lan_mode,#div_gateway,#div_pridns,#div_secdns").hide();
			}
			if (rJson['languageType']=='vn'){
				$("#dhcpClient").attr('class','button_big2');
			}else{
				$("#dhcpClient").attr('class','button_big');
			}	
			$("#dhcpClient").hide();
		}
    });	
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

var lanip='';
var wtime=50;
function do_count_down(){
	supplyValue('show_sec',wtime);
	if(wtime==0){
		parent.location.href='http://'+lanip+'/login.asp'; return false;
	}
	if(wtime > 0){wtime--;setTimeout('do_count_down()',1000);}
}

function doSubmit(){
	if(saveChanges()==false) return false;
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setLanConfig"};
	postVar['lanIp']=$('#lanIp').val();
	postVar['lanNetmask']=$('#lanNetmask').val();

	if(rJson['operationMode']==1 || rJson['operationMode']==2){
		postVar['lanMode']=$('#lanMode').val();
		postVar['lanGateway']=$('#lanGateway').val();
		postVar['lanPriDns']=$('#lanPriDns').val();
		postVar['lanSecDns']=$('#lanSecDns').val();	
	}else{
		postVar['dhcpServer']=$('#dhcpServer').val();
	}
	postVar['dhcpStart']=$('#dhcpStart').val();
	postVar['dhcpEnd']=$('#dhcpEnd').val();
	postVar['dhcpLease']=$("#dhcpLease").val();

	if ($('#lanIp').val()==v_lanIp){
		$("#show_msg").html(JS_msg75);
	}else{
		$("#show_msg").html(JS_msg77);
	}
	lanip=$('#lanIp').val();
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){});
	$("#div_body_setting").hide();
	$("#div_wait").show();
	do_count_down();	
}

function dhcpTypeSwitch(){
	if($("#lanMode").val()==1){ 
		setDisabled(":input[type=text]",true);
	}else{
		setDisabled(":input[type=text]",false);
	}
}
// show dhcplist info
$(function(){
	$('#dhcpClient').on('click', function(event) {
		event.preventDefault();
		$('#show_arpinfo').show();
		var postVar = { topicurl : "setting/getDhcpCliList"};
	    postVar = JSON.stringify(postVar);
		$.ajax({  
	       	type : "post",  
	        url : " /cgi-bin/cstecgi.cgi",
	        data : postVar,
	        beforeSend:function(){
	        	$("#dhcplistTable").html('<tr><td colspan=3><p style="text-align:center"><img src="../style/load.gif" alt="" /></p></td></tr>');
	        },
	        success : function(Data){
				arpJson = JSON.parse(Data);
				var _html = '';
				for(var i=0;i<arpJson.length;i++){	
					expires=arpJson[i].expires;
					expires=expires.replace("days",MM_days);
					expires=expires.replace("MM_Always",MM_Always);
					if(expires=="") continue;
					_html += "<tr align=center class=item_list>";
					_html += "<td>"+arpJson[i].ip+"</td>";
					_html += "<td>"+arpJson[i].mac.toUpperCase()+"</td>";
					_html += "<td>"+expires+"</td>";
					_html += "</tr>";
				}
				$("#dhcplistTable").html(_html);
			}
	    });
	});
	$('#refresh_arpinfo').on('click', function(event) {
		event.preventDefault();
		$('#dhcpClient').trigger('click');
	});
	$('#close_arp_iframe').on('click', function(event) {
		event.preventDefault();
		$('#show_arpinfo').hide();
	});
});
</script>
</head>
<body class="mainbody">
<div id="div_body_setting">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<form name="lanCfg">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_Lan)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_Lan)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%"> 
<tr id="div_lan_mode" style="display:none;">
<td class="item_left"><script>dw(MM_LanNetworkMode)</script></td>
<td><select class="select" id="lanMode" onChange="dhcpTypeSwitch()">
<option value="0"><script>dw(MM_Manual)</script></option>
<option value="1"><script>dw(MM_Auto)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Ip)</script></td>
<td><input type="hidden" id="lanIp"><input type="text" class="text3" maxlength="3" id="ip1" name="ip" onKeyDown="return ipVali(event,this.name,0);" onChange="autoChangePool();"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="ip2" name="ip" onKeyDown="return ipVali(event,this.name,1);" onChange="autoChangePool();"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="ip3" name="ip" onKeyDown="return ipVali(event,this.name,2);" onChange="autoChangePool();"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="ip4" name="ip" onKeyDown="return ipVali(event,this.name,3);" onChange="autoChangePool();"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Mask)</script></td>
<td><input type="hidden" id="lanNetmask"><input type="text" class="text3" maxlength="3" id="mask1" name="mask" onKeyDown="return ipVali(event,this.name,0);" onChange="autoChangePool();"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="mask2" name="mask" onKeyDown="return ipVali(event,this.name,1);" onChange="autoChangePool();"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="mask3" name="mask" onKeyDown="return ipVali(event,this.name,2);" onChange="autoChangePool();"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="mask4" name="mask" onKeyDown="return ipVali(event,this.name,3);" onChange="autoChangePool();"></td>
</tr>
<tr id="div_gateway" style="display:none;">
<td class="item_left"><script>dw(MM_Gateway)</script></td>
<td><input type="hidden" id="lanGateway"><input type="text" class="text3" maxlength="3" name="gateway" onKeyDown="return ipVali(event,this.name,0);" ><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="gateway" onKeyDown="return ipVali(event,this.name,1);" ><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="gateway" onKeyDown="return ipVali(event,this.name,2);" ><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="gateway" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_pridns" style="display:none;">
<td class="item_left"><script>dw(MM_PriDns)</script></td>
<td><input type="hidden" id="lanPriDns"><input type="text" class="text3" maxlength="3" name="pridns" onKeyDown="return ipVali(event,this.name,0);" ><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pridns" onKeyDown="return ipVali(event,this.name,1);" ><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pridns" onKeyDown="return ipVali(event,this.name,2);" ><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="pridns" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_secdns" style="display:none;">
<td class="item_left"><script>dw(MM_SecDns)</script></td>
<td><input type="hidden" id="lanSecDns"><input type="text" class="text3" maxlength="3" name="secdns" onKeyDown="return ipVali(event,this.name,0);" ><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="secdns" onKeyDown="return ipVali(event,this.name,1);" ><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="secdns" onKeyDown="return ipVali(event,this.name,2);" ><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" name="secdns" onKeyDown="return ipVali(event,this.name,3);" ></td>
</tr>
<tr id="div_dhcp_server" style="display:none;">
<td class="item_left"><script>dw(MM_DhcpServer)</script></td>
<td><select class="select" id="dhcpServer" onChange="dhcpTypeSwitch()">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
</table>

<div id="div_dhcp_setting" style="display:none;">
<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_StartIp)</script></td>
<td><input type="hidden" id="dhcpStart"><input type="text" class="text3" maxlength="3" id="sip1" name="sip" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="sip2" name="sip" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="sip3" name="sip" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="sip4" name="sip" onKeyDown="return ipVali(event,this.name,3);"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_EndIp)</script></td>
<td><input type="hidden" id="dhcpEnd"><input type="text" class="text3" maxlength="3" id="eip1" name="eip" onKeyDown="return ipVali(event,this.name,0);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="eip2" name="eip" onKeyDown="return ipVali(event,this.name,1);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="eip3" name="eip" onKeyDown="return ipVali(event,this.name,2);"><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="eip4" name="eip" onKeyDown="return ipVali(event,this.name,3);"> <script>dw('<input type=button class=button_big id=dhcpClient value="'+BT_Clients+'">')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_LeaseTime)</script></td>
<td><select class="select" id="dhcpLease">
<option value="86400">1 <script>dw(MM_day)</script></option>
<option value="7200">2 <script>dw(MM_hours)</script></option>
<option value="3600">1 <script>dw(MM_hour)</script></option>
<option value="900">15 <script>dw(MM_minutes)</script></option>
<option value="300">5 <script>dw(MM_minutes)</script></option>
</select></td>
</tr>
</table>
</div>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</form>
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

<!-- arp modal -->
<div class="show_arpinfo" id="show_arpinfo" style="display: none;">
	<div class="content">
	<table width=460><tr><td>
		<table border=0 width="100%"> 
			<tr><td class="content_title"><script>dw(MM_DhcpList)</script></td></tr>
			<!--<tr><td class="content_help"><script>dw(MSG_DhcpList)</script></td></tr>-->
			<tr><td height="1" class="line"></td></tr>
		</table>

		<table border=0 width="100%">
			<tr align="center">
                <td class="item_center"><b><script>dw(MM_Ip)</script></b></td>
                <td class="item_center"><b><script>dw(MM_Mac)</script></b></td>
                <td class="item_center"><b><script>dw(MM_ExpiredTime)</script> (s)</b></td>
			</tr>
			<tbody id="dhcplistTable"></tbody>
		</table>

		<table border=0 width="100%"> 
			<tr><td height="1" class="line"></td></tr>
			<tr><td height="10"></td></tr>
			<tr><td align="right"><script>dw('<input id="refresh_arpinfo" type=button class=button value="'+BT_Refresh+'"> &nbsp;&nbsp;<input id="close_arp_iframe" type=button class=button value="'+BT_Close+'" >')</script></td></tr>
		</table>
	</td></tr></table>
	</div>
	<div class="modal-bg"></div>
</div>
</body></html>