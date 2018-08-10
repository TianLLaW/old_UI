<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="/style/normal_ws.css" rel="stylesheet" type="text/css">
<script src="/js/jquery.min.js"></script>
<script src="/js/load.js"></script>
<script src="/js/jcommon.js"></script>
<script src="/js/json2.min.js"></script>
<script>
var rJson;
function setLanipv6Info(){
	if(rJson['wanEnabled']=="0"){
		setJSONValue({
			"GAddress"  	: "::",
			"LinkAddress" 	: "FE80:"
		});
	}else{
		if(rJson['lan_addr6_global']){
			setJSONValue({
				"GAddress"  	: rJson['lan_addr6_global']+"/"+rJson['lan_addr6_global_prefix'],
				"LinkAddress" 	: rJson['lan_addr6_ll']+"/"+rJson['lan_addr6_ll_prefix']
			});
		}else{
			setJSONValue({
				"GAddress"  	: "::",
				"LinkAddress" 	: rJson['lan_addr6_ll']+"/"+rJson['lan_addr6_ll_prefix']
			});		
		}
	}
}

function setWanipv6Info(){	
	if(rJson['wanEnabled']=="0"){
		setJSONValue({
			"ipv6Origin"		:	"Disable",
			"wan_addr6_global"	:	"::",
			"gw_addr6"			:	"::",
			"wan-dns1-ipv6"		:	"::",
			"wan-dns2-ipv6"		:	"::"
		});
	}else{
		if(rJson['ipv6Origin']==0){
			$("#ipv6Origin").html(MM_StaticIp);
			if (rJson['ipv6_ConnStatus']=="connected"){
				$("#ipv6_wanstatus").css('color','blue');
				$("#ipv6_wanstatus").html(MM_Connected);
			}else{
				$("#ipv6_wanstatus").css('color','red');
				$("#ipv6_wanstatus").html(MM_Disconnected);
			}
			setJSONValue({
				"wan_addr6_global"	:	rJson['ipv6StaWanAddr'],
				"gw_addr6"			:	rJson['ipv6StaWanGwAddr'],
				"wan-dns1-ipv6"		:	rJson['ipv6StaWanDnsAddr1'],
				"wan-dns2-ipv6"		:	rJson['ipv6StaWanDnsAddr2']
			});			
		}else if(rJson['ipv6Origin']==1){
			$("#ipv6Origin").html(MM_DynamicIp);
			if (rJson['wan_addr6_global']){
				$("#ipv6_wanstatus").css('color','blue');
				$("#ipv6_wanstatus").html(MM_Connected);
				setJSONValue({
					"wan_addr6_global"	:	rJson['wan_addr6_global']+"/"+rJson['wan_addr6_global_prefix'],
					"gw_addr6"			:	rJson['gw_addr6']
				});
			}else{
				$("#ipv6_wanstatus").css('color','red');
				$("#ipv6_wanstatus").html(MM_Disconnected);
				setJSONValue({
					"wan_addr6_global"	:	"::",
					"gw_addr6"			:	"::"
				});
			}
			if (rJson['auto-dns']==0){
				$("#wan-dns1-ipv6").html(rJson['ipv6StaWanDnsAddr1']);
				$("#wan-dns2-ipv6").html(rJson['ipv6StaWanDnsAddr2']);
			}else{
				if(rJson['wan_addr6_global']){
					if (rJson['wan-dns-ipv6'])
						$("#wan-dns1-ipv6").html(rJson['wan-dns-ipv6']);
					else
						$("#wan-dns1-ipv6").html("::");
					
					if (rJson['wan-dns2-ipv6'] !== null)
						$("#wan-dns2-ipv6").html(rJson['wan-dns2-ipv6']);
					else
						$("#wan-dns2-ipv6").html("::");
				}else{	
					$("#wan-dns1-ipv6").html("::");
					$("#wan-dns2-ipv6").html("::");
				}
			}		
		}else if(rJson['ipv6Origin']==2){
			$("#ipv6Origin").html("PPPoE");
			if (rJson['wan_addr6_global']){
				$("#ipv6_wanstatus").css('color','blue');
				$("#ipv6_wanstatus").html(MM_Connected);
				setJSONValue({
					"wan_addr6_global"	:	rJson['wan_addr6_global']+"/"+rJson['wan_addr6_global_prefix'],
					"gw_addr6"			:	rJson['gw_addr6']
				});
			}else{
				$("#ipv6_wanstatus").css('color','red');
				$("#ipv6_wanstatus").html(MM_Disconnected);
				setJSONValue({
					"wan_addr6_global"	:	"::",
					"gw_addr6"			:	"::"
				});
			}
			if (rJson['auto-dns']==0){
				$("#wan-dns1-ipv6").html(rJson['ipv6StaWanDnsAddr1']);
				$("#wan-dns2-ipv6").html(rJson['ipv6StaWanDnsAddr2']);
			}else{
				if(rJson['wan_addr6_global']){
					if (rJson['wan-dns-ipv6'])
						$("#wan-dns1-ipv6").html(rJson['wan-dns-ipv6']);
					else
						$("#wan-dns1-ipv6").html("::");
						
					if (rJson['wan-dns2-ipv6'])
						$("#wan-dns2-ipv6").html(rJson['wan-dns2-ipv6']);
					else
						$("#wan-dns2-ipv6").html("::");
				}else{	
					$("#wan-dns1-ipv6").html("::");
					$("#wan-dns2-ipv6").html("::");
				}
			}			
		}
	}
}

$(function(){
	var postVar={topicurl:"setting/getIPv6StaInfo"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);
			setLanipv6Info();
			setWanipv6Info();		
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
<tr><td class="content_title"><script>dw(MM_Ipv6Ststus)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_Ipv6Ststus)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<div id="div_ipv6wan">
<br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_Ipv6WanInfo)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_Ipv6WanConnType)</script></td>
<td><span id="ipv6Origin"></span>&nbsp;&nbsp;<span id="ipv6_wanstatus"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Ipv6Addr)</script></td>
<td><span id="wan_addr6_global"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Gateway)</script></td>
<td><span id="gw_addr6"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_PriDns)</script></td>
<td><span id="wan-dns1-ipv6"></span></td>
</tr>
<tr id="div_dns_addr2">
<td class="item_left"><script>dw(MM_SecDns)</script></td>
<td><span id="wan-dns2-ipv6"></span></td>
</tr>
</table></td></tr>
</table>
</div>

<div id="div_ipv6lan">
<br />
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_Ipv6LanInfo)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_Ipv6AddrType)</script></td>
<td>RADVD+SLAAC</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Ipv6Addr)</script></td>
<td><span id="GAddress"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Ipv6llAddr)</script></td>
<td><span id="LinkAddress"></span></td>
</tr>
</table></td></tr>
</table>
</div>
<br>
</td></tr></table>
</body></html>