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
var v_ntpServerIp,tmp;

function getDateString(str){
	var month=["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
	var yy, mo, dd, hh, mi, ss;	
	var s1, s2;
	if ((str.substring(8,9))==" "){
		s1=str.substring(0,8);
		s2=str.substring(9,str.length);
		str=s1.concat(s2);
	}else{
		str=str;
	}	
	
	var p=str.split(" ");
	yy=p[5];
	for (var j=0; j<12; j++){
		if (p[1]==month[j]) 
			mo=j + 1;
	}

	dd=p[2];
	hh=p[3].split(":")[0];
	mi=p[3].split(":")[1];
	ss=p[3].split(":")[2];

	setJSONValue({
		'cn_yy'			:	yy,
		'cn_mo'			:	mo,
		'cn_dd'         :   dd,
		'cn_hh'         :   hh,
		'cn_mi'         :	mi,
		'cn_ss'         :	ss,
		'en_yy'			:	yy,
		'en_mo'			:	mo,
		'en_dd'         :   dd,
		'en_hh'         :   hh,
		'en_mi'         :	mi,
		'en_ss'         :	ss
	});
}

function updateState(){
	if ($("#ntpClientEnabled").is(':checked')){
		$("#ntpServerIp1,#ntpServerIp2,#ntpServerIp3").attr('disabled',false);
		$("#ntpClientEnabled").val("ON");
	}else{
		$("#ntpServerIp1,#ntpServerIp2,#ntpServerIp3").attr('disabled',true)
		$("#ntpClientEnabled").val("");
	}
}

$(function(){
	var postVar={topicurl:"setting/getNTPCfg"};
	postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			var rJson=JSON.parse(Data);
			setJSONValue({
				"currentTime"	: rJson['currentTime'],
				"tz"         	: rJson['tz']
			});
			
			v_ntpServerIp=rJson['ntpServerIp'];
			var substringArray = v_ntpServerIp.split("*");
			$("#ntpServerIp1").val(substringArray[0]);
			$("#ntpServerIp2").val(substringArray[1]);
			$("#ntpServerIp3").val(substringArray[2]);
			
			if (rJson['ntpClientEnabled']==1){
				$("#ntpClientEnabled").attr('checked',true);
			}
			if (rJson['languageType']=='cn'||rJson['languageType']=='ct'||rJson['languageType']=='jp'){
				$("#manNTPSyncWithHost").attr('class','button_big');
				$("#div_date_cn").show();
				$("#div_date_en").hide();
			}else{
				if (rJson['languageType']=='vn'||rJson['languageType']=='es'){
					$("#manNTPSyncWithHost").attr('class','button_big3');
				}else{
					$("#manNTPSyncWithHost").attr('class','button_big');
				}
				$("#div_date_cn").hide();
				$("#div_date_en").show();
			}
			getDateString(rJson['currentTime']);
			updateState();
		}
    });
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function saveChanges(){
	$("#ntpClientEnabled").focus();
	var ntpserverNum = 0;
	if ($("#ntpClientEnabled").is(':checked')){
		if (($("#ntpServerIp1").val()).length==0){
			alert(MM_NtpServer + "1" + JS_msg1);
			return false;
		}
		if (!checkVaildVal.isString( $("#ntpServerIp1").val())){
			alert(MM_NtpServer + JS_msg98);
			return false;
		}else{
			tmp = $("#ntpServerIp1").val();
		}
		if($("#ntpServerIp2").val()!=""){	
			if(!checkVaildVal.isString($("#ntpServerIp2").val())){
				alert(MM_NtpServer + "2" + JS_msg98);
				return false;
			}else{
				tmp += "*"+$("#ntpServerIp2").val();
			}
		}
		if($("#ntpServerIp3").val()!=""){
			if($("#ntpServerIp2").val().length==0){
				alert(MM_NtpServer + "2" + JS_msg1);
				return false;
			}
			if(!checkVaildVal.isString($("#ntpServerIp3").val())){
				alert(MM_NtpServer + "3" + JS_msg98);
				return false;
			}else{
				tmp += "*"+$("#ntpServerIp3").val();
			}
		}
	}		
	return true;
}

function doSubmit(){
	if(saveChanges()==false) return false;
	$(".select2").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setNTPCfg"};
	postVar['tz']=$("#tz").val();
	postVar['ntpServerIp']=tmp;
	postVar['ntpClientEnabled']=$("#ntpClientEnabled").val();
	uiPost(postVar);
}

function syncWithHost(){
	var currentTime=new Date();
	var seconds=currentTime.getSeconds();
	var minutes=currentTime.getMinutes();
	var hours=currentTime.getHours();
	var month=currentTime.getMonth() + 1;
	var day=currentTime.getDate();
	var year=currentTime.getFullYear();

	var seconds_str=" ";
	var minutes_str=" ";
	var hours_str=" ";
	var month_str=" ";
	var day_str=" ";
	var year_str=" ";

	if(seconds < 10)
		seconds_str="0" + seconds;
	else
		seconds_str=""+seconds;

	if(minutes < 10)
		minutes_str="0" + minutes;
	else
		minutes_str=""+minutes;

	if(hours < 10)
		hours_str="0" + hours;
	else
		hours_str=""+hours;

	if(month < 10)
		month_str="0" + month;
	else
		month_str=""+month;

	if(day < 10)
		day_str="0" + day;
	else
		day_str=day;

	setJSONValue({
		'cn_yy'			:	year,
		'cn_mo'			:	month_str,
		'cn_dd'         :   day_str,
		'cn_hh'         :   hours_str,
		'cn_mi'         :	minutes_str,
		'cn_ss'         :	seconds_str,
		'en_yy'			:	year,
		'en_mo'			:	month_str,
		'en_dd'         :   day_str,
		'en_hh'         :   hours_str,
		'en_mi'         :	minutes_str,
		'en_ss'         :	seconds_str
	});
	return year+"-"+month_str+"-"+day_str+" "+hours_str+":"+minutes_str+":"+seconds_str;
}

function postWithHost(){
	var tmp=syncWithHost();
	var postVar={"topicurl":"setting/NTPSyncWithHost"};
	postVar['hostTime']=tmp;	
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<input type="hidden" id="currentTime">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_Ntp)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_Ntp)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_CurrentTime)</script></td>
<td><span id="div_date_cn"><input type="text" class="text2" maxlength="4" id="cn_yy" name="cn_yy"> -
<input type="text" class="text3" maxlength="4" id="cn_mo" name="cn_mo"> -
<input type="text" class="text3" maxlength="2" id="cn_dd" name="cn_dd">&nbsp;&nbsp;
<input type="text" class="text3" maxlength="2" id="cn_hh" name="cn_hh"> :
<input type="text" class="text3" maxlength="2" id="cn_mi" name="cn_mi"> :
<input type="text" class="text3" maxlength="2" id="cn_ss" name="cn_ss"></span>
<span id="div_date_en" style="display:none"><input type="text" class="text3" maxlength="2" id="en_mo" name="en_mo"> -
<input type="text" class="text3" maxlength="2" id="en_dd" name="en_dd"> -
<input type="text" class="text2" maxlength="4" id="en_yy" name="en_yy">&nbsp;&nbsp;
<input type="text" class="text3" maxlength="2" id="en_hh" name="en_hh"> :
<input type="text" class="text3" maxlength="2" id="en_mi" name="en_mi"> :
<input type="text" class="text3" maxlength="2" id="en_ss" name="en_ss"></span></td>
</tr>
<tr>
<td class="item_left"></td>
<td><script>dw('<input type="button" class="button_big" value="'+BT_CopyPcTime+'" id="manNTPSyncWithHost" onClick="postWithHost()">')</script></td>
</tr>
</table>

<div id="div_ntp_setting">
<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_TimeZone)</script></td>
<td><select class="select2" id="tz">
<option value="UTC+12">(UTC-12:00) <script>dw(MM_ntp25)</script></option>
<option value="UTC+11">(UTC-11:00) <script>dw(MM_ntp1)</script></option>
<option value="UTC+10">(UTC-10:00) <script>dw(MM_ntp2)</script></option>
<option value="UTC+9">(UTC-09:00) <script>dw(MM_ntp3)</script></option>
<option value="UTC+8">(UTC-08:00) <script>dw(MM_ntp4)</script></option>
<option value="UTC+7">(UTC-07:00) <script>dw(MM_ntp5)</script></option>
<option value="UTC+6">(UTC-06:00) <script>dw(MM_ntp6)</script></option>
<option value="UTC+5">(UTC-05:00) <script>dw(MM_ntp7)</script></option>
<option value="UTC+4">(UTC-04:00) <script>dw(MM_ntp8)</script></option>
<option value="UTC+3">(UTC-03:00) <script>dw(MM_ntp9)</script></option>
<option value="UTC+2">(UTC-02:00) <script>dw(MM_ntp10)</script></option>
<option value="UTC+1">(UTC-01:00) <script>dw(MM_ntp11)</script></option>
<option value="UTC+0">(UTC+0) <script>dw(MM_ntp12)</script></option>
<option value="UTC-1">(UTC+01:00) <script>dw(MM_ntp13)</script></option>
<option value="UTC-2">(UTC+02:00) <script>dw(MM_ntp14)</script></option>
<option value="UTC-3">(UTC+03:00) <script>dw(MM_ntp15)</script></option>
<option value="UTC-4">(UTC+04:00) <script>dw(MM_ntp16)</script></option>
<option value="UTC-5">(UTC+05:00) <script>dw(MM_ntp17)</script></option>
<option value="UTC-6">(UTC+06:00) <script>dw(MM_ntp18)</script></option>
<option value="UTC-7">(UTC+07:00) <script>dw(MM_ntp19)</script></option>
<option value="UTC-8">(UTC+08:00) <script>dw(MM_ntp20)</script></option>
<option value="UTC-9">(UTC+09:00) <script>dw(MM_ntp21)</script></option>
<option value="UTC-10">(UTC+10:00) <script>dw(MM_ntp22)</script></option>
<option value="UTC-11">(UTC+11:00) <script>dw(MM_ntp23)</script></option>
<option value="UTC-12">(UTC+12:00) <script>dw(MM_ntp24)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left">&nbsp;</td>
<td><input type="checkbox" id="ntpClientEnabled" onClick="updateState()"> <script>dw(MM_NtpClientUpdate)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_NtpServer+" 1")</script></td>
<td><input type="text" class="text" maxlength="32" id="ntpServerIp1"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_NtpServer+" 2")</script></td>
<td><input type="text" class="text" maxlength="32" id="ntpServerIp2"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_NtpServer+" 3")</script></td>
<td><input type="text" class="text" maxlength="32" id="ntpServerIp3"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</div>
</td></tr></table>
</body></html>