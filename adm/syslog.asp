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
	var postVar={topicurl:"setting/getSyslogCfg"};
	postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			var rJson=JSON.parse(Data);
			supplyValue("syslogEnabled",rJson['syslogEnabled']);
			var syslog=rJson['syslog'];
			if (rJson['syslogEnabled']==1){
				$("#div_log").show();
				if(navigator.userAgent.indexOf("MSIE")>0) 
					if(navigator.userAgent.indexOf("MSIE 10.0")<0) 
						syslog=syslog.replace(/\n/g,"<br/>");
				$("#syslog").html(syslog);					
			}else{
				$("#div_log").hide();
			}
		}
    });		
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function doSubmit(){
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setSyslogCfg"};
	postVar['syslogEnabled']=$('#syslogEnabled').val();
	uiPost(postVar);
}

function clearLogClick(){
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/clearSyslog"};
	uiPost(postVar);
}

function refreshLogClick(){
	window.location.reload();
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_SystemLog)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_SystemLog)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_OnOff)</script></td>
<td><select class="select" id="syslogEnabled">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="doSubmit()">')</script></td></tr>
</table>

<div id="div_log" style="display:none">
<table border=0 width="100%">
<tr><td><textarea id="syslog" style="font-size:9pt;width:100%" rows="20" wrap="off" readonly></textarea></td></tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Clear+'" onClick="clearLogClick()">&nbsp;&nbsp;<input type=button class=button value="'+BT_Refresh+'" onClick="return refreshLogClick()">')</script></td></tr>
</table>
</div>
</td></tr></table>
</body></html>