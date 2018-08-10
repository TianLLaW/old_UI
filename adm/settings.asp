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
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

var lanip='',wtime=50;
function waitpage(){
	$("#div_setting").hide();
	$("#div_wait").show();
	do_count_down();
}

function do_count_down(){
	$('#show_sec').html(wtime);
	if(wtime==0){parent.location.href='http://'+lanip+'/home.asp'; return false;}
	if(wtime>0){wtime--;setTimeout('do_count_down()',1000);}
}

function uiPost2(postVar){
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		var rJson=JSON.parse(Data);
		lanip=rJson['lan_ip'];
	});
	waitpage();
}

function loadDefaultClick(){
	if ( !confirm(JS_msg85) ) return false;
	var postVar={"topicurl":"setting/LoadDefSettings"};
	$("#show_msg").html(JS_msg84);
	uiPost2(postVar);
}

function rebootClick(){
	if ( !confirm(JS_msg82) ) return false;
	var postVar={"topicurl":"setting/RebootSystem"};
	$("#show_msg").html(JS_msg83);
	uiPost2(postVar);
}

function fileChange(target,id) {     
    var fileSize = 0; 
	var isIE = /msie/i.test(navigator.userAgent) && !window.opera;         
    if (isIE && !target.files) {      
        var filePath = target.value;  
		try{   
			var fileSystem = new ActiveXObject("Scripting.FileSystemObject"); 
			var file = fileSystem.GetFile (filePath);  
			fileSize = file.Size;  
        }catch(e){}       
    } else {   		
          fileSize = target.files[0].size;  
    }    

    var size = fileSize/(1024*1024); 
    if(size>1){   
        alert(MM_ConfigFileErr);   
        //var file=document.getElementById(id);   
		//file.outerHTML=file.outerHTML;
		return false;
    }      
}

function updateConfigClick(){
	if ($("#filename").val()==""){
		alert(JS_msg80);
		return false;
	}		
	if ($("#filename").val().toLowerCase().indexOf(".dat")==-1){
		alert(JS_msg81);
		return false;
	}	
	return true;
}

function errorTips(msg){
	var str="";
	str+="<table width=700><tr><td><table border=0 width=\"700\"><tr>\n";
	str+="<td style=\"font-weight:bold; font-size:14px;\"><b>"+MM_ErrTips+"</b></td></tr>\n";
	str+="<tr><td><hr size=1 noshade align=top></td></tr></table><table border=0 width='700'>\n";
	str+="<tr><td>"+eval(msg)+"</td></tr>\n";
	str+="<tr><td colspan=2><hr size=1 noshade align=top></td></tr>\n";
	str+="<tr><td align=right colspan=2>\n";
	str+="<input type=button class=button id=apply value="+BT_Back+" onClick=top.frames['view'].location.reload(true)></td></tr>\n";
	str+="</table></td></tr></table>\n";
	return str;
}

var flag=0;
function showMessage(){
	var iframeObj=document.getElementById("ifmShowMessage");
	var subObj="";
	var rJsonM="";
	try{
		subObj=(iframeObj.Document?iframeObj.Document.body:iframeObj.contentDocument.body);
		rJsonM=subObj.innerHTML.replace(/<(.*)>/ig,"");
	}catch(e){
        resetForm();
	}
	
	try{
		var rJsonMsg=JSON.parse(rJsonM);
		var message=rJsonMsg['settingERR'];
		if(message=="1" &&flag==0){
			flag=1;	
			$("#div_setting").hide();
			$("#div_wait").show();
			wtime=rJsonMsg['wtime'];
			lanip=rJsonMsg['lan_ip'];
			do_count_down();	
		}else{
			if(rJsonM.indexOf("web_timeout!")<0 &&flag==0){		
				if(message!=""){
					flag=1;			
					$("#div_setting").hide();
					$("#div_showMessage").show();			
					subObj.innerHTML=errorTips(message);
				}			
			}
		}
	}catch(e){
		setTimeout("showMessage();",1000);
	}
}
</script>
</head>
<body class="mainbody">
<div id="div_setting">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_SystemSettings)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_SystemSettings)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<form method="post" action="/cgi-bin/cstecgi.cgi?action=save&setting">
<tr>
<td class="item_left"><script>dw(MM_SaveConfigFile)</script></td>
<td><script>dw('<input type=submit class="button_big" value="'+BT_Save+'">')</script></td>
</tr>
</form>

<form method="post" name="ImportSettings" action="/cgi-bin/cstecgi.cgi?action=upload&setting" enctype="multipart/form-data" target="ifmShowMessage">
<tr>
<td class="item_left"><script>dw(MM_UpdateConfigFile)</script></td>
<td><div class="uploader cs-gray"><input type="text" class="filename"><script>dw('<input type=button class=button_up name="file" value="'+BT_SelectFile+'">')</script><input type="file" id="filename" name="filename" size="30" onChange="fileChange(this,this.id)"></div><script>dw('<input type=submit class="button_big cs-up-submit" value="'+BT_Update+'" onClick="return updateConfigClick()">')</script></td>
</tr>
</form>
<tr>
<td class="item_left"><script>dw(MM_RestoreFactoryDefault)</script></td>
<td><script>dw('<input type=button class=button_big value="'+BT_Restore+'" onClick="loadDefaultClick()">')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_RebootSystem)</script></td>
<td><script>dw('<input type=button class=button_big value="'+BT_Reboot+'" onClick="rebootClick()">')</script></td>
</tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table>
</td></tr></table>
</div>

<script>
//  uploader
$(function(){
	$("input[type=file]").change(function(){$(this).parents(".uploader").find(".filename").val($(this).val());});
	$("input[type=file]").each(function(){
		if($(this).val()==""){$(this).parents(".uploader").find(".filename").val(MM_NoSelectFile);}
	});
});
</script>

<div id="div_wait" style="display:none">
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_ChangeSetting)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><span id=show_msg></span></script></td></tr>
<tr><td><script>dw(MM_PleaseWait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table></td></tr></table>
</div>
<div id="div_showMessage" style="display:none">
<iframe id="ifmShowMessage" name="ifmShowMessage" src="#" onload="showMessage()" marginheight="0" marginwidth="0" frameBorder="0" width="100%" height="700">
</iframe>
</div>
</body></html>