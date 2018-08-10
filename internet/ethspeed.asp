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
var rJson;
function CreateEthSpeed(){
	var new_options,new_values;
	new_options=[MM_Auto,"10M "+MM_Half,"10M "+MM_Full,"100M "+MM_Half,"100M "+MM_Full];
	new_values=['0','1','2','3','4'];	
	CreateOptions('wanSpeed',new_options,new_values);
	CreateOptions('lan1Speed',new_options,new_values);
	CreateOptions('lan2Speed',new_options,new_values);
	CreateOptions('lan3Speed',new_options,new_values);
	CreateOptions('lan4Speed',new_options,new_values);
}

$(function(){
	var postVar={topicurl:"setting/getEthSpeedConfig"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);
			CreateEthSpeed();
			setJSONValue({
				'wanSpeed'		:	rJson['wanSpeed'],				
				'lan1Speed'		:	rJson['lan1Speed'],			
				'lan2Speed'		:	rJson['lan2Speed'],			
				'lan3Speed'		:	rJson['lan3Speed'],
				'lan4Speed'		:	rJson['lan4Speed']
			});
			if (rJson['operationMode']==0){
				supplyValue("div_wanorlan",MM_WanPort);
			}else{ 
				supplyValue("div_wanorlan",MM_LanPort);
			}
		}
   	});	
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function waitpage(){
	$("#div_setting").hide();
	$("#div_wait").show();
}

var lanip='',wtime=0;
function uiPost2(postVar){
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	setTimeout('waitpage()',4000);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		var rJson=JSON.parse(Data);
		lanip=rJson['lan_ip'];
		wtime=rJson['wtime'];
		do_count_down();
	});
}

function do_count_down(){
	$("#show_sec").html(wtime);
	if(wtime==0){resetForm(); return false;}
	if(wtime > 0){wtime--;setTimeout('do_count_down()',1000);}
}

function doSubmit(){
	var postVar={"topicurl":"setting/setEthSpeedConfig"};
	postVar['wanSpeed']=$('#wanSpeed').val();
	postVar['lan1Speed']=$('#lan1Speed').val();
	postVar['lan2Speed']=$('#lan2Speed').val();
	postVar['lan3Speed']=$('#lan3Speed').val();
	postVar['lan4Speed']=$('#lan4Speed').val();
	uiPost2(postVar);
}
</script>
</head>
<body class="mainbody">
<div id="div_setting">
<script>showLanguageLabel()</script>
<table width=700><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_EthSpeed)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_EthSpeed)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>
<table border=0 width="100%">
<tr>
<td class="item_left"><span id="div_wanorlan"></span></td>
<td><select class="select" id="wanSpeed"></select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_LanPort)</script> 4</td>
<td><select class="select" id="lan1Speed"></select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_LanPort)</script> 3</td>
<td><select class="select" id="lan2Speed"></select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_LanPort)</script> 2</td>
<td><select class="select" id="lan3Speed"></select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_LanPort)</script> 1</td>
<td><select class="select" id="lan4Speed"></select></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'"onClick="doSubmit()" />')</script></td></tr>
</table>
</td></tr></table>
</div>

<div id="div_wait" style="display:none">
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_ChangeSetting)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><script>dw(JS_msg75)</script></td></tr>
<tr><td><script>dw(MM_PleaseWait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table></td></tr></table>
</div>
</body></html>