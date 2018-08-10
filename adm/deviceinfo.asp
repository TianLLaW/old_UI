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
	var postVar={topicurl:"setting/getDeviceInfo"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			var rJson=JSON.parse(Data);
			var deviceListTab=$("#div_deviceList").get(0);
			var trNode;
			for(var i=0;i<rJson.length;i++){
				trNode=deviceListTab.insertRow(-1);
				trNode.align="center";
				trNode.className="item_center2";
				trNode.insertCell(0).innerHTML=rJson[i].idx;
				trNode.insertCell(1).innerHTML=rJson[i].ip;
				trNode.insertCell(2).innerHTML=rJson[i].mac.toUpperCase();
				trNode.insertCell(3).innerHTML=(rJson[i].type==1)?MM_Wlan:MM_Wired;
			}							
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
<tr><td class="content_title"><script>dw(MM_DeviceInfo)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_DeviceInfo)</script></td></tr>
</table>

<br>
<table border=0 width="100%">
<tr><td colspan="4"><b><script>dw(MM_DeviceInfo)</script></b></td></tr>
<tr><td colspan="4" height="1" class="line"></td></tr>
<tr><td colspan="4" height="2"></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_Ip)</script></b></td>
<td class="item_center"><b><script>dw(MM_Mac)</script></b></td>
<td class="item_center"><b><script>dw(MM_AccessType)</script></b></td>
</tr>
<tbody id="div_deviceList"></tbody>
</table>
<br>
</td></tr></table>
</body></html>