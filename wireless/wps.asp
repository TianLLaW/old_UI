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
var rJson,rJsonWps;
var timerID=null;
function updateWpsMode(){
	if ($(":radio[name=wscMode]:checked").val()==1){
		$("#div_wps_pin").show();
	}else{
		$("#div_wps_pin").hide();
	}
}

var wifiIdx="0";
$(function(){
	var postVar={"topicurl" : "setting/getWiFiWpsSetupConfig"};
	postVar['wifiIdx']=wifiIdx;
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);
			setJSONValue({
				"wscDisabled"  : rJson['wscDisabled'],
				"wscPin" 	   : rJson['wscPin']
			});			
			if(rJson['wscDisabled']==0){
				$("#div_wps_setting").show();					
				updateWpsMode();
			}
			if(rJson['wscFlag']==1){
				$(".select").css('backgroundColor','#ebebe4');
				$(":input").attr('disabled',true);
				$("#div_wps_setting").hide();	
			}
		}
    });
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function clearStyle(){
	clearInterval(timerID);
	$("#div_wait").hide();
	$(":input").attr('disabled',false);
	$(".select").css('backgroundColor','#ffffff');
}

function updateWPS(){
	var postVar={"topicurl" : "setting/getWiFiWpsConfig"};
	postVar['wifiIdx']=wifiIdx;
    postVar=JSON.stringify(postVar);
	$.ajax({ 
		type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : true, success : function(Data){ 
			rJsonWps=JSON.parse(Data); 
			$("#div_wps_status").show();
			var wscResult=rJsonWps['wscResult'];
			var wscStatus=rJsonWps['wscStatus'];
			if (wscResult=="1"){
				$("#wscStatus").html(MM_WpsSuccess).attr('class','blue');
				clearStyle();
			}else if (wscResult=="0"){				
				if (wscStatus=="Not used"||wscStatus=="Idle"){	
					$("#div_wps_status").hide();
					if (wscStatus=="Not used"){
						supplyValue("wscStatus",MM_NotUsed);
					}else{
						supplyValue("wscStatus",MM_Idle);
					}
					clearStyle();
				}else{
					$("#div_wait").show();
					$("#wscStatus").html(MM_StartWpsProcess);
				}
			}else{
				$("#wscStatus").html(MM_WpsFail).attr('class','red');
				clearStyle();
			}

		} 
	});
}

function ValidateChecksum(pin){
    var accum=0;
    var tmp_str=pin.replace("-", "");
    var pincode=tmp_str.replace(" ", "");
	supplyValue("pin", pincode);
    if (pincode.length==4) return 1;
    if (pincode.length != 8) return 0;
    accum += 3 * (parseInt(pincode / 10000000) % 10);
    accum += 1 * (parseInt(pincode / 1000000) % 10);
    accum += 3 * (parseInt(pincode / 100000) % 10);
    accum += 1 * (parseInt(pincode / 10000) % 10);
    accum += 3 * (parseInt(pincode / 1000) % 10);
    accum += 1 * (parseInt(pincode / 100) % 10);
    accum += 3 * (parseInt(pincode / 10) % 10);
    accum += 1 * (parseInt(pincode / 1) % 10);
	return ((accum % 10)==0);
}

function saveChanges(){
	if ($(":radio[name=wscMode]:checked").val()==1){
		if (!checkVaildVal.IsVaildNumber($("#pin").val(),MM_EnterPin)) return false;	
		if ($("#pin").val().length<8){alert(JS_msg42);return false;}	
		if (!ValidateChecksum($("#pin").val())){alert(JS_msg32);return false;}
		return true;
	}
}

function updateState(){
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl" : "setting/setWiFiWpsSetupConfig"};
	postVar['wifiIdx']=wifiIdx;
	postVar['wscDisabled']=$('#wscDisabled').val();
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){resetForm();});
}

function startWPS(){
	var wscMode=$(":radio[name=wscMode]:checked").val();
	var postVar={"topicurl" : "setting/setWiFiWpsConfig"};
	postVar['wifiIdx']=wifiIdx;
	postVar['wscMode']=wscMode;
	postVar['wscPinMode']="1";
	if (wscMode=="1"){
		if (saveChanges()==false) return false;
		postVar['pin']=$('#pin').val();
	}
	$(".select").css('backgroundColor','#ebebe4');
	$("#div_wait,#div_wps_status").show();
	$("#wscStatus").html(MM_StartWpsProcess);
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		timerID=self.setInterval("updateWPS()",5000);
	});
}

var wtime=20;
function waitpage(){
	$("#div_setting").hide();
	$("#div_wait2").show();
}
function do_count_down(){
	$("#show_sec").html(wtime);
	if(wtime==0){location.href=addURLTimestamp(location.href);}
	if(wtime>0){wtime--;setTimeout('do_count_down()',1000);}
}
function getDefaultPIN(){
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl" : "setting/getDefaultPIN"};
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		waitpage();
		do_count_down();
	});
}
function setGeneratePIN(){
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl" : "setting/setGeneratePIN"};
	postVar['wifiIdx']=wifiIdx;
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		waitpage();
		do_count_down();
	});
}
</script>
</head>
<body class="mainbody">
<div id="div_setting">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<form name="wirelessWsc">
<table border=0 width="100%"> 
<tr><td class="content_title">WPS</td></tr>
<tr><td class="content_help"><script>dw(MSG_Wps)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_OnOff)</script></td>
<td><select class="select" id="wscDisabled" onChange="updateState()">
<option value="1"><script>dw(MM_Disable)</script></option>
<option value="0"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table>

<table id="div_wps_setting" style="display:none" border=0 width="100%">
<tr>
<td class="item_left">PIN</td>
<td><b><span class="blue" id="wscPin"></span></b>&nbsp;&nbsp;&nbsp;<script>dw('<input type=button class=button value="'+BT_Regenerate+'" onClick="setGeneratePIN()">&nbsp;&nbsp;<input type=hidden class=button value="'+BT_Default+'" onClick="getDefaultPIN()">')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_WpsMode)</script></td>
<td><input type="radio" name="wscMode" value="0" checked onClick="updateWpsMode()"> <script>dw(MM_WpsPBC)</script>&nbsp;&nbsp;<input type="radio" name="wscMode" value="1" onClick="updateWpsMode()"> PIN</td>
</tr>
<tr id="div_wps_pin" style="display:none">
<td class="item_left"><script>dw(MM_EnterPin)</script></td>
<td><input type="text" class="text" id="pin" maxlength="8"></td>
</tr>
<tr><td colspan="2" height="10"></td></tr>
<tr>
<td class="item_left">&nbsp;</td>
<td><script>dw('<input type=button class=button value="'+BT_Connect+'" onClick="startWPS()">')</script>&nbsp;&nbsp;<span id="div_wait" style="display:none"><img src="/style/load.gif" align="middle" /></span></td>
</tr>
<tr id="div_wps_status" style="display:none">
<td class="item_left"><script>dw(MM_WpsStatus)</script></td>
<td><span id="wscStatus"><script>dw(MM_NotUsed)</script></span></td>
</tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table>
</form>
</td></tr></table>
</div>

<div id="div_wait2" style="display:none">
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