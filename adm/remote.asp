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
function updateState(){
	if ($("#remoteEnabled")[0].selectedIndex==1){
		$("#div_port").show();
	}else{
		$("#div_port").hide();
	}
}

var rJson;
$(function(){
	var postVar={topicurl:"setting/getRemoteCfg"};
	postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);
			setJSONValue({		
				'remoteEnabled'		:	rJson[0]['remoteEnabled'],
				'port'				:	rJson[0]['port']
			});
			updateState();
		}
    });
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function saveChanges(){	
	if ($("#remoteEnabled")[0].selectedIndex==1){
		if(!checkVaildVal.IsVaildNumberRange($("#port").val(),MM_Port,80,65535)) return false;
	}
	var port=Number($("#port").val());	
	var temp1,temp2;	
	for (var i=1; i<rJson.length; i++){	
		temp1=Number(rJson[i].lanPortFrom);
		temp2=Number(rJson[i].wanPortFrom);
		// if (port==temp1){alert(JS_msg104);return false;}
		if (port==temp2){alert(JS_msg104);return false;}
	}
	return true;
}

function doSubmit(){
	if(saveChanges()==false)return false;	
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setRemoteCfg"};
	postVar['remoteEnabled']=$('#remoteEnabled').val();
	postVar['port']=$('#port').val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_Remote)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_Remote)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_OnOff)</script></td>
<td><select class="select" id="remoteEnabled" onChange="updateState()">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr id="div_port" style="display:none">
<td class="item_left"><script>dw(MM_Port)</script></td>
<td><input type="text" class="text" id="port" size="5" maxlength="5"> (80-65535)</td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</td></tr></table>
</body></html>