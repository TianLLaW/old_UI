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
$(function(){
	var postVar={topicurl:"setting/FirmwareUpgrade"};
	postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : true, success : function(Data){
			rJson=JSON.parse(Data);		
		}
    });	
	cloud_update_fw();
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

function showRebootMsg(){
	var str="";
	str+="<table width=700><tr><td><table border=0 width=\"100%%\">\n";
	str+="<tr><td style=\"font-weight:bold; font-size:14px;\">"+MM_ChangeSetting+"</td></tr>\n";
	str+="<tr><td><hr size=1 noshade align=top></td></tr>\n";
	str+="</table><table border=0 width=\"100%%\">\n";
	str+="<tr><td rowspan=2 width=100 align=center><img src=\"/style/load.gif\" /></td>\n";
	str+="<td>"+MM_UpgradeFirmware+"</td></tr>\n";
	str+="<tr><td>"+MM_PleaseWait+"&nbsp;<span id=show_sec>"+wtime+"</span>&nbsp;"+MM_seconds+" ...</td></tr>\n";
	str+="<tr><td colspan=2><hr size=1 noshade align=top></td></tr>\n";
 	str+="</table></td></tr></table>\n";
	return str;
}

var wtime=130;
function count_down(){
	wtime--;
	var iframeObj=document.getElementById("ifmShowMessage");
	var subObj=(iframeObj.document?iframeObj.document.body:iframeObj.contentDocument.body);
	subObj.innerHTML=showRebootMsg();
	if(wtime==0){parent.location.href='http://'+rJson['lanIp']+'/login.asp'; return false;}
	if(wtime>0){setTimeout('count_down()',1000);}
}

function showuploasuccess(){
	$("#div_main").hide();
	count_down();
	$("#div_showMessage").show();
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

function cloud_update_fw(){
	top['title'].$("#div_cloud_found_new").hide();
	self.setInterval("cloud_found_download()", 500);
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
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_CloudUpdate)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_CloudUpdate)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<br>
<table border=0 width="100%">
<tr><td><span id="cloud_found_download"></span></td></tr>
</table>

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
<iframe id="ifmShowMessage" name="ifmShowMessage" onload="" marginheight="0" marginwidth="0" frameBorder="0" width="100%" height="700"></iframe>
</div>
</body></html>
