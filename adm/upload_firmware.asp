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
var rJson,MWJ_progBar=0,time=0,delay_time=1500,loop_num=0,do_times=0;
var v_flashSize=0;
$(function(){
	var postVar={topicurl:"setting/FirmwareUpgrade"};
	postVar=JSON.stringify(postVar);
	$.ajax({
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);
			v_flashSize=rJson["flashSize"]; 
			$("#fmVersion").html(rJson['fmVersion']);
			$("#buildTime").html(rJson['buildTime']);			
			if(rJson['cloudFw']==1){
				$("#div_cloud_check_button").show();
				if(rJson['cloudFwStatus'] == "Idle"){
					$("#div_cloud_found_result").show();
					$("#cloud_found_result").html(MM_CloudFwLast);
				}else if(rJson['cloudFwStatus'] == "UnNet"){
					$("#div_cloud_found_result").show();
					$("#cloud_found_result").html(MM_CloudUnNet);
				}
			}else{
				$("#div_cloud_check_button").hide();
			}			
		}
    });	
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function progress(){
  	if (loop_num==3){
		return false;
  	}
  	if (time < 1) 
		time=time + 0.033;
  	else{
		time=0;
		loop_num++;
		$("#progress_div").hide();
  	}
  	setTimeout('progress()',delay_time);  
  	myProgBar.setBar(time); 
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

    var size = fileSize/(v_flashSize*1024*1024); 
    if(size>=1){   
        alert(MM_FwFileErr);   
        //var file=document.getElementById(id);   
		//file.outerHTML=file.outerHTML;
		return false;
    }      
}

function uploadFirmwareClick(){
	if ($("#filename").val()==""){alert(JS_msg80);return false;}	
	if ($("#filename").val().indexOf("web")<0&&$("#filename").val().indexOf("bin")<0){alert(JS_msg81);return false;}
	if(!confirm(JS_msg116+v_flashSize+JS_msg117)) return false;	
	if ($("#updateWithConfig").is(':checked')){
		document.uploadFirmware.action="/cgi-bin/cstecgi.cgi?action=upload&upgrade"+"&flag=1";
	}else{
		document.uploadFirmware.action="/cgi-bin/cstecgi.cgi?action=upload&upgrade"+"&flag=0";
	}		
	document.uploadFirmware.submit();
  	$("#progress_div").show();   
  	progress();
	showMessage();
	$(":input").attr("disabled",true);
	return true;
}

function errorTips(msg){
	var str="";
	str+="<table width=700><tr><td><table border=0 width=\"700\"><tr>\n";
	str+="<td style=\"font-weight:bold; font-size:14px;\"><b>"+MM_ErrTips+"</b></td></tr>\n";
	str+="<tr><td><hr size=1 noshade align=top></td></tr></table><table border=0 width='700'>\n";
	str+="<tr><td>"+msg+"</td></tr>\n";
	str+="<tr><td colspan=2><hr size=1 noshade align=top></td></tr>\n";
	str+="<tr><td align=right colspan=2>\n";
	str+="<input type=button class=button id=apply value="+BT_Back+" onClick=top.frames['view'].location.reload(true)></td></tr>\n";
	str+="</table></td></tr></table>\n";
	return str;
}

var loadimg = "data:image/gif;base64,R0lGODlhIAAgALMLAAEBATQ0NBsbG8TExJeXl1RUVIGBgbq6utbW1uHh4bOzs////wAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh/wtYTVAgRGF0YVhNUDw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYwIDYxLjEzNDc3NywgMjAxMC8wMi8xMi0xNzozMjowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoyQkJGQzdFNUM3NEFFMzExOTM0NDlBOUE4MzM3MUQ0MyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDozMjMzM0RGNTRBQ0QxMUUzOEUwMkVGQTcxQkFDNDBGOCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDozMjMzM0RGNDRBQ0QxMUUzOEUwMkVGQTcxQkFDNDBGOCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IFdpbmRvd3MiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo1QkI0NkIyN0NENEFFMzExOTM0NDlBOUE4MzM3MUQ0MyIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDoyQkJGQzdFNUM3NEFFMzExOTM0NDlBOUE4MzM3MUQ0MyIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PgH//v38+/r5+Pf29fTz8vHw7+7t7Ovq6ejn5uXk4+Lh4N/e3dzb2tnY19bV1NPS0dDPzs3My8rJyMfGxcTDwsHAv769vLu6ubi3trW0s7KxsK+urayrqqmop6alpKOioaCfnp2cm5qZmJeWlZSTkpGQj46NjIuKiYiHhoWEg4KBgH9+fXx7enl4d3Z1dHNycXBvbm1sa2ppaGdmZWRjYmFgX15dXFtaWVhXVlVUU1JRUE9OTUxLSklIR0ZFRENCQUA/Pj08Ozo5ODc2NTQzMjEwLy4tLCsqKSgnJiUkIyIhIB8eHRwbGhkYFxYVFBMSERAPDg0MCwoJCAcGBQQDAgEAACH5BAUFAAsALAAAAAAgACAAAATncMlJKQGk6s2nAEKFJJ2mGBWgUoOilFQiCAWlAlPiHjA1Cy/JbXJwIXoTwywwGS4QOyQlMEMtnC4FSSpR/EhDqGJAEW8XikAgMylUNbpc0TghqAOF4EDA7rSyZBQFd3hHPVkKB2cUCoN3SGKGHXYBQT2SMAlWXJxciDsJAwQGpKWcnzulqptIqIqiq6ydsx2YMLa1dCWRSHOJi3JZPEh/LoETxYm3lgm+kmK/E1oaYsdPRWc6Cph/R1ldLsA92kHfT1Gcc4bmC+pcYsNoLjnsPXNn9X+eY4zzZeIdEtgqEo/WhmYAN0QAACH5BAUFAAsALAAAAAAeABcAAASScMlJqQqq6s1XCUVlZN2EHFWgUoUglJMxUmowKa4NL7KBTDWgy7BbHHrAFS9XlBBkqEUw4RKQJokOAildGVyhGABAWCQUh9/kOasQBAOnYAwgIhT4Q9ZsiHcGAXQAOgsDeHgDezCCVhUJB4dRMAZjRBx3Cmo7BZpaTZ+gG4+Hh6EVkKR4phSjqauvsLGys7B+qxEAIfkEBQUACwAsBwAAABkAGAAABIlwybkQQTTrrQjJB7Yl4uR9pmFsi6IM1Dkh6sq5ielN9cEiLp9EtjjUWJKDS0SslUYuxXCnUKGGgYB0MlhqBoZcq5ANXCWKpwZBLheQyHKgIJxs4QtC9ozfhPuAgXAChIVmghKFigKIC4sCWo2SfmqNBgAANpOYmAJ8gQMBnAABk3kCnJqSlwBSEQAh+QQFBQALACwOAAAAEgAgAAAEkzCdtKq9+KiDEcWVIl7DCC6iYiUid6aWpiAnaiJtbav79444xeAS9F1YK9lMt0iUUkNmamOsBWlMYnbLNXi/hGjtSzYwy4Ywd12pSgMBwhoOL/CYiAI9UKgRBFEKenByGAYCAn0WBHAWAI9NiAJ3II8AFYcCATqWFgGIZiedIZI1oxUFiG4Lp5iUFwIAAmwEAIVbEQAh+QQFBQALACwCAA4AHgASAAAEhXDJSatdKuuTrr9aeHzkFGZcqa6shKhIwSLZ6xkAYKzH1lEKQS63SgxCg0lgCAgkPwPDL9GrLXA5AcGltSgMhu0E0esQcrtJQSDYBd4SsMF2+ZnYgs47IDnIWwFsaXsTBGAjKgZsfBKELn8qgQIKSnCFYCtsMpWMEwd0JF8VBQGbLaGdKhEAIfkEBQUACwAsAAAIABkAGAAABIFwKQDMujjrbSgQxCaKgQcEw6hehGCucFfBMGLReM66JqBfPc9v0QoOj7nEDUkMBELHQ8HpPE6pBcQKodAQsN2FMqXhKsgXhRPKMhi6ing6nti6b/Gw+bC68yVyFwdxWiIHdxh5GAmKIneFgGEXA4EcbxmNGAh1Ilwag39MCQecGhEAOw==";
function showRebootMsg(){
	var str="";
	str+="<table width=700><tr><td><table border=0 width=\"100%%\">\n";
	str+="<tr><td style=\"font-weight:bold; font-size:14px;\">"+MM_ChangeSetting+"</td></tr>\n";
	str+="<tr><td><hr size=1 noshade align=top></td></tr>\n";
	str+="</table><table border=0 width=\"100%%\">\n";
	str+="<tr><td rowspan=2 width=100 align=center><img src="+loadimg+"></td>\n";
	str+="<td>"+MM_UpgradeFirmware+"</td></tr>\n";
	str+="<tr><td>"+MM_PleaseWait+"&nbsp;<span id=show_sec>"+wtime+"</span>&nbsp;"+MM_seconds+" ...</td></tr>\n";
	str+="<tr><td colspan=2><hr size=1 noshade align=top></td></tr>\n";
 	str+="</table></td></tr></table>\n";
	return str;
}

var wtime=90;
function count_down(){
	wtime--;
	var iframeObj = document.getElementById("ifmShowMessage");
	var subObj=(iframeObj.document?iframeObj.document.body:iframeObj.contentDocument.body);
	subObj.innerHTML=showRebootMsg();
	if(wtime == 0) {parent.location.href='http://'+rJson['lanIp']+'/login.asp'; return false;}
	if(wtime > 0) {setTimeout('count_down()',1000);}
}

function showuploasuccess(){
	$("#div_main").hide();
	count_down();
	$("#div_showMessage").show();
}

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
	if(rJsonM!=""&&rJsonM.indexOf("web_timeout!")<0&&(rJsonM.indexOf("upgradeStatus")>=0||rJsonM.indexOf("upgradeERR")>=0)){
		var rJsonMsg=JSON.parse(rJsonM);
		if(rJsonMsg['upgradeStatus']=="1"){
			setTimeout("showuploasuccess();",15000);
		}else{ 
			var message=eval(rJsonMsg['upgradeERR']);
			if(message!=""&& typeof(message)!="undefined"){
				$("#div_main").hide();
				$("#div_showMessage").show();
				subObj.innerHTML=errorTips(message);
			}
		}
	}else{
		setTimeout("showMessage();",1000);
	}
}

function showMessageCloud(rJsonMsg){
	var iframeObj=document.getElementById("ifmShowMessage");
	var subObj="";
	try{
		subObj=(iframeObj.Document?iframeObj.Document.body:iframeObj.contentDocument.body);	
	}catch(e){
        resetForm();			
	}
	if(rJsonMsg['upgradeStatus']=="1"){
		setTimeout("showuploasuccess();",15000);					
	}else{ 
		var message=eval(rJsonMsg['upgradeERR']);
		if(message!=""){		
			$("#div_main").hide();
			$("#div_showMessage").show();
			subObj.innerHTML=errorTips(message);
		}
	}
}

function check_cloud_update_fw(){
	var postVar={"topicurl":"setting/CloudSrvVersionCheck"};
	postVar=JSON.stringify(postVar);
	$("#div_cloud_found_new,#div_cloud_found_result").hide();
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		var result=JSON.parse(Data);
		if(result['cloudFwStatus']=="New"){
			$("#div_cloud_found_new").show();
			$("#div_web_config").hide();
			$("#new_version").html(MM_FoundNewFw+"("+result['new_version']+") "+MM_ManualUpgrade);
			$("#filename,#upgrade").attr('disabled',true);	
		}else{
			$("#div_cloud_found_result").show();
		 	if(result['cloudFwStatus']=="UnNet"){
				$("#cloud_found_result").html(MM_CloudUnNet);
			}else if(result['cloudFwStatus']=="Update"){
				$("#cloud_found_result").html(MM_CloudUpdateing);
			}else{
				$("#cloud_found_result").html(MM_CloudFwLast);
			}
		}
	});
}

function cloud_update_fw(){
	var postVar={"topicurl":"setting/CloudACMunualUpdate"};
	postVar['Flags'] = "0";
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);	
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		$("#progress_div").show();   
  		progress();
		var rJson=JSON.parse(Data);
		showMessageCloud(rJson);
	});
	$("#div_cloud_found_new").hide();
	$("#div_cloud_found_download").show();
	self.setInterval("cloud_found_download()", 500);
	return true;
}

function cloud_found_download(){
    if (do_times==0){
		do_times++;
		$("#cloud_found_download").html(MM_DownloadFw);
	}else if(do_times==1){
		do_times++;
		$("#cloud_found_download").html(MM_DownloadFw1);
	}else if(do_times==2){
		do_times++;
		$("#cloud_found_download").html(MM_DownloadFw2);
	}else if(do_times==3){	
		do_times=0;
		$("#cloud_found_download").html(MM_DownloadFw3);
	}
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<div id="div_main">
<table width="700"><tr><td>
<form method=post name="uploadFirmware" action="/cgi-bin/cstecgi.cgi?action=upload&upgrade" enctype="multipart/form-data" target="ifmShowMessage">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_UpgradeFirmware)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_UpgradeFirmware)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_FirmwareVer)</script></td>
<td><span id="fmVersion"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="div_cloud_check_button" style="display:none"><script>dw('<input type=button class=button value="'+MM_CloudCheckNewVersion+'" onClick="check_cloud_update_fw()">')</script></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_BuildTime)</script></td>
<td><span id="buildTime">&nbsp;</span></td>
</tr>
<tr id="div_cloud_found_new" style="display:none">
<td class="item_left"><script>dw(MM_CloudCheckResult)</script></td>
<td><span id="new_version"></span><script>dw('<input type=button class=button value="'+BT_Upgrade+'" onClick="cloud_update_fw()">')</script></td>
</tr>
<tr id="div_cloud_found_result" style="display:none">
<td class="item_left"><script>dw(MM_CloudCheckResult)</script></td>
<td><span id="cloud_found_result"></span></td>
</tr>
<tr id="div_cloud_found_download" style="display:none">
<td class="item_left"><script>dw(MM_CloudCheckResult)</script></td>
<td><span id="cloud_found_download">&nbsp;</span></td>
</tr>
<tr>
<td class="item_left"></td>
<td><input type="checkbox" id="updateWithConfig"> <script>dw(MM_UpgradeWithConfig)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_FwFile)</script></td>
<td><div class="uploader cs-gray"><input type="text" class="filename"><script>dw('<input type=button class=button_up name="file" value="'+BT_SelectFile+'">')</script><input type="file" id="filename" name="filename" size="30" onChange="fileChange(this,this.id)"></div><script>dw('<input type=button class="button cs-up-submit" value="'+BT_Upgrade+'" id=upgrade onClick="uploadFirmwareClick()">')</script></td>
</tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table>
</form>

<script>
//  uploader
$(function(){
	$("input[type=file]").change(function(){$(this).parents(".uploader").find(".filename").val($(this).val());});
	$("input[type=file]").each(function(){
		if($(this).val()==""){$(this).parents(".uploader").find(".filename").val(MM_NoSelectFile);}
	});
});
</script>
<br />
<script language="javascript1.2">
var myProgBar=new progressBar(
1,         //border thickness
'#000000', //border colour
'#ffffff', //background colour
'#000000', //bar colour
300,       //width of bar (excluding border)
15,        //height of bar (excluding border)
1          //direction of progress: 1=right, 2=down, 3=left, 4=up
);
</script>
</td></tr></table>
</div>
<div id="div_showMessage" style="display:none">
<iframe id="ifmShowMessage" name="ifmShowMessage" src="#" onload="" marginheight="0" marginwidth="0" frameBorder="0" width="100%" height="700"></iframe>
</div>
</body></html>