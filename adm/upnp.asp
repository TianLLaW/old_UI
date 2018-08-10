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
var rJson,v_UpnpList;
$(function(){
	var postVar={topicurl:"setting/getMiniUPnPConfig"};
	postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);
			supplyValue("upnpEnabled",rJson['upnpEnabled']);
			if (rJson['upnpEnabled']==1){
				$("#div_upnplist").show();
			}else{
				$("#div_upnplist").hide();
			}
			v_UpnpList=rJson['getUpnpTable'];
			var trNode;
			var tab=$("#div_upnptable").get(0);
			if(v_UpnpList!="none"){
				var tmpRule=v_UpnpList.split("#m1t7k|");
				for(var i=0;i<tmpRule.length;i++){
					var tmp=tmpRule[i].split(":m1t7k|");
					trNode=tab.insertRow(-1);
					trNode.align="center";
					trNode.className="item_center2";
					trNode.insertCell(0).innerHTML=i+1;		
					trNode.insertCell(1).innerHTML=tmp[0];
					trNode.insertCell(2).innerHTML=tmp[1];
					trNode.insertCell(3).innerHTML=tmp[2];
					trNode.insertCell(4).innerHTML=tmp[3];
					trNode.insertCell(5).innerHTML=tmp[4]==0?MM_Disable:MM_Active;
					trNode.insertCell(6).innerHTML=tmp[5];
				}
			}
		}
    });
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function doSubmit(){
	var postVar={"topicurl":"setting/setMiniUPnPConfig"};
	$(".select").css('backgroundColor','#ebebe4');
	postVar['upnpEnabled']=$('#upnpEnabled').val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title">UPnP</td></tr>
<tr><td class="content_help"><script>dw(MSG_Upnp)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_OnOff)</script></td>
<td><select class="select" id="upnpEnabled" onChange="doSubmit()">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table>

<div id="div_upnplist" style="display:none">
<br />
<table border=0 width="100%">
<tr><td colspan="7"><b><script>dw(MM_UpnpTbl)</script></b></td></tr>
<tr><td colspan="7" height="1" class="line"></td></tr>
<tr><td colspan="7" height="2"></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_Protocol)</script></b></td>
<td class="item_center"><b><script>dw(MM_ExternalPort)</script></b></td>
<td class="item_center"><b><script>dw(MM_Ip)</script></b></td>
<td class="item_center"><b><script>dw(MM_InternalPort)</script></b></td>
<td class="item_center"><b><script>dw(MM_Status)</script></b></td>
<td class="item_center"><b><script>dw(MM_Comment)</script></b></td>
</tr>
<tbody id="div_upnptable"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Refresh+'" onClick="window.location.reload()">')</script></td></tr>
</table>
</div>
</td></tr></table>
</body></html>