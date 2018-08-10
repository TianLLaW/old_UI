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
$(function(){
	var postVar={topicurl:"setting/getDhcpCliList"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			var rJson=JSON.parse(Data);
			var dhcpListTab=$("#div_dhcpList").get(0);
			var trNode;
			var expires;
			for(var i=0;i<rJson.length;i++){
				trNode=dhcpListTab.insertRow(-1);
				trNode.align="center";
				trNode.className="item_center2";
				expires=rJson[i].expires;
				expires=expires.replace("days",MM_days);
				expires=expires.replace("MM_Always",MM_Always);
				if(expires=="") continue;
				trNode.insertCell(0).innerHTML=rJson[i].ip;
				trNode.insertCell(1).innerHTML=rJson[i].mac;
				trNode.insertCell(2).innerHTML=expires;
			}							
		}
    });
});
</script>
</head>
<body class="mainbody">
<table width="650"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_DhcpList)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_DhcpList)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr align="center">
<!--<td class="item_center"><b><script>dw(MM_HostName)</script></b></td>-->
<td class="item_center"><b><script>dw(MM_Ip)</script></b></td>
<td class="item_center"><b><script>dw(MM_Mac)</script></b></td>
<td class="item_center"><b><script>dw(MM_ExpiredTime)</script> (s)</b></td>
</tr>
<tbody id="div_dhcpList"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Refresh+'" onClick="window.location.reload()">')</script></td></tr>
</table>
</td></tr></table>
</body></html>