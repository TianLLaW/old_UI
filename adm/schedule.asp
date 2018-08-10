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
var idx,i,mode;
var rJson;
function updateStateSchReboot(){
	idx = $('input[name="mode"]:checked').val();
 	if (idx == 0){
		$("#div_week,#div_time").hide();
		$("#div_down,#div_count,#div_systime").hide();
	}
	else if(idx == 1){
		$("#div_week,#div_time").show();
		$("#div_down,#div_count,#div_systime").hide();	
	}else{
		$("#div_week,#div_time").hide();
		$("#div_down,#div_systime").show();
		if(rJson['countDownTime']!=undefined)	
	  		$("#div_count").show();
	  	else
	  		$("#div_count").hide();
	}
}

function dispalyFromHourOption(){
	var strTmp;
	for(var i=0; i<24; i++){
		if(i<10)
			strTmp="<option value="+i+">0"+i+"</option>";
		else
			strTmp="<option value="+i+">"+i+"</option>";
		document.write(strTmp);
	}	
}
function dispalyFromMinOption(){
	var strTmp;
	for(var i=0; i<60; i++){
		if(i<10)
			strTmp="<option value="+i+">0"+i+"</option>";
		else
			strTmp="<option value="+i+">"+i+"</option>";
		document.write(strTmp);
	}	
}

function initValue(){
	v_mode=rJson['mode'];
	v_upTime=rJson['upTime'];
	setJSONValue({ 
			'upTime'		:	showTimeFormat(rJson['upTime'].split(';'))
		});
  	if(v_mode==1){
		$("input:radio[name=mode][value=1]").attr("checked",true);
		setJSONValue({
 			'scheWeek'		:	rJson['week'],
			'scheHour'		:	rJson['hour'],
			'scheMin'			:	rJson['minute'], 
 		});
 	}else if(v_mode==2){
		$("input:radio[name=mode][value=2]").attr("checked",true);
		setJSONValue({
				'recHour'		:	rJson['recHour'],
 				'CountDownTime'	:	showTimeFormat(rJson['countDownTime'].split(';'))
			});
   	}else{
		$("input:radio[name=mode][value=0]").attr("checked",true);
 	}
	updateStateSchReboot();
}

$(function(){
	$("input:radio").click(function () {
		updateStateSchReboot();
	});
	var postVar={topicurl:"setting/getRebootScheCfg"};
	postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson = JSON.parse(Data);
			initValue();
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
var lanip='',wtime=60;
function uiPost1(postVar){
	postVar = JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	setTimeout('waitpage()',1000);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		var responseJson = JSON.parse(Data);
		lanip=responseJson['lan_ip'];
		wtime=60;
		do_count_down();
	});
}
function do_count_down(){
	document.getElementById("show_sec").innerHTML = wtime;
	if(wtime == 0) {parent.location.href='http://'+lanip+'/home.asp'; return false;}
	if(wtime > 0) {wtime--;setTimeout('do_count_down()',1000);}
}
function doSubmit(){
	if (mode==1&&v_ntpEnabled==0){
		alert(JS_msg31);
		return false;
	}
	$(".select").css('backgroundColor','#ebebe4');
	mode = $('input[name="mode"]:checked').val();
 	var postVar={"topicurl":"setting/setRebootScheCfg"};
	postVar['mode']=mode;
	postVar['week']=$('#scheWeek').val();
	postVar['hour']=$('#scheHour').val();
	postVar['minute']=$('#scheMin').val();
	postVar['recHour']=$('#recHour').val();
	if(mode==2){
		if (!checkVaildVal.IsVaildNumberRange($('#recHour').val(),MM_countdown , 1, 240)) return false;
		var tmpTime=v_upTime.split(';');
		var tmpRecHout = $('#recHour').val();
		var tmpSys = ((Number(tmpTime[0])*24+Number(tmpTime[1]))*60+Number(tmpTime[2]))*60+Number(tmpTime[3]);
		var tmpSet = Number(tmpRecHout)*3600;
		if(tmpSet<=tmpSys){
			if ( !confirm(JS_msg134) ) 	return false;
			$("#show_msg").html(JS_msg83);
			uiPost1(postVar);
			return
		}
	}
	uiPost(postVar);
}
</script>
</head>

<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="700"> 
<div id="div_setting">
<tr><td class="content_title"><script>dw(MM_RebootSchedule)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_RebootSchedule)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_reboot_mode)</script></td>
<td>
<input type=radio name="mode" id="mode" value="0"><span></span>&nbsp;<script>dw(MM_Disable)</script>&nbsp;&nbsp;&nbsp;&nbsp;
<input type=radio name="mode" id="mode" value="1"><span></span>&nbsp;<script>dw(MM_spec_time)</script>&nbsp;&nbsp;&nbsp;&nbsp;
<input type=radio name="mode" id="mode" value="2"><span></span>&nbsp;<script>dw(MM_countdown)</script>&nbsp;&nbsp;&nbsp;&nbsp;
</td>
</tr>
<tr id="div_week" style="display:none">
<td class="item_left"><script>dw(MM_Week)</script></td>
<td><select class="select" id="scheWeek">
<option value="7"><script>dw(MM_Week7)</script></option>
<option value="1"><script>dw(MM_Week1)</script></option>
<option value="2"><script>dw(MM_Week2)</script></option>
<option value="3"><script>dw(MM_Week3)</script></option>
<option value="4"><script>dw(MM_Week4)</script></option>
<option value="5"><script>dw(MM_Week5)</script></option>
<option value="6"><script>dw(MM_Week6)</script></option>
<option value="0"><script>dw(MM_All)</script></option>
</select></td>
</tr>

<tr id="div_time" style="display:none">
<td class="item_left"><script>dw(MM_Time)</script></td>
<td><select class="select3" id="scheHour"><script>dispalyFromHourOption();</script></select>&nbsp;<img src="../style/colon.png" border="0" align="absbottom" />&nbsp;<select class="select3" id="scheMin"><script>dispalyFromMinOption();</script></select>&nbsp;(<script>dw(MM_hour)</script>:<script>dw(MM_min)</script>)</td>
</tr> 

<tr id="div_down" style="display:none">
<td class="item_left"><script>dw(MM_countdown)</script></td>
<td><input type=text class="text" name="recHour" id="recHour" size=5 maxlength=3 ><script>dw(MM_hour)</script>
<font color="#808080">(<script>dw(MM_range)</script> 1 - 240)</font></td>
</tr>
<tr id="div_systime" style="display:none">
<td class="item_left"><script>dw(MM_Uptime)</script></td>
<td><span id="upTime"></span></td>
</tr>
<tr id="div_count" style="display:none">
<td class="item_left"><script>dw(MM_RebootSchCountDown)</script></td>
<td><span id="CountDownTime"></span></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</td></tr></table>
</div>
<div id="div_wait" style="display:none">
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_ChangeSetting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><span id=show_msg></span></td></tr>
<tr><td><script>dw(MM_PleaseWait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan=2><hr size=1 noshade align=top class=bline></td></tr>
</table></td></tr></table>
</div>
</body></html>
