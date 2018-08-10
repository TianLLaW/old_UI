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
var rJson,v_wifiScheduleEn,v_wifiScheduleNum,v_ntpValid;
var rule=new Array();
$(function(){
	var postVar={"topicurl" : "setting/getWiFiScheduleConfig"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);
			v_wifiScheduleEn=rJson['wifiScheduleEn'];
			v_wifiScheduleNum=rJson['wifiScheduleNum'];
			v_ntpValid=rJson['ntpValid'];
			supplyValue("wifiScheduleEn",v_wifiScheduleEn);
			var strTmp="";
			var weekDay=[MM_Week7,MM_Week1,MM_Week2,MM_Week3,MM_Week4,MM_Week5,MM_Week6,MM_All];
			for(var i=0;i<v_wifiScheduleNum;i++){
				strTmp+="<tr align='center'><td class='item_center2'>\n";
				strTmp+="<input type='hidden' name='enable"+i+"' id='enable"+i+"'>\n";
				strTmp+="<input type='checkbox' name='wifiOn"+i+"' id='wifiOn"+i+"'></td>\n";
				strTmp+="<td class='item_center2'>\n";
				strTmp+="<select class='select3' name='week"+i+"' id='week"+i+"' size='1'>\n";
				strTmp+="<option value='0'>"+weekDay[0]+"</option>\n";
				for(var j=1;j<=6;j++){
					strTmp +="<option value="+j+">"+weekDay[j]+"</option>\n";
				}	
				strTmp+="<option value='7'>"+weekDay[7]+"</option>\n";
				strTmp+="</select> </td>\n";
				strTmp+="<td class='item_center2'>\n";
				strTmp+="<select class='select3' name='startHour"+i+"' id='startHour"+i+"' size='1'>\n";
				for(var k=0;k<24;k++){
					if(k<10)
						strTmp +="<option value="+k+">"+"0"+k+"</option>\n";
					else
						strTmp+="<option value="+k+">"+k+"</option>\n";
				}
				strTmp+="</select>&nbsp;<img src=\"../style/colon.png\" border=\"0\" align=\"absbottom\" />&nbsp;\n";
				strTmp+="<select class='select3' name='startMinute"+i+"' id='startMinute"+i+"' size='1'>\n";
				for(var h=0;h<60;h++){
					if(h<10)
						strTmp +="<option value="+h+">"+"0"+h+"</option>\n";
					else
						strTmp +="<option value="+h+">"+h+"</option>\n";
				}
				strTmp+="</select></td>\n";
				strTmp+="<td class='item_center2'>\n";
				strTmp+="<select class='select3' name='endHour"+i+"' id='endHour"+i+"' size='1'>\n";
				for(var m=0;m<24;m++){
					if(m<10)
						strTmp +="<option value="+m+">"+"0"+m+"</option>\n";
					else
						strTmp+="<option value="+m+">"+m+"</option>\n";
				}	
				strTmp+="</select>&nbsp;<img src=\"../style/colon.png\" border=\"0\" align=\"absbottom\" />&nbsp;\n";
				strTmp+="<select class='select3' name='endMinute"+i+"' id='endMinute"+i+"' size='1'>\n";
				for(var n=0;n<60;n++){
					if(n<10)
						strTmp +="<option value="+n+">"+"0"+n+"</option>\n";
					else
						strTmp +="<option value="+n+">"+n+"</option>\n";
				}
				strTmp+="</select></td></tr>\n";
			}
			$("#div_schlist").append(strTmp);
		
			if (v_wifiScheduleEn==1){
				rule[0]=rJson['wifiScheduleRule0'];
				rule[1]=rJson['wifiScheduleRule1'];
				rule[2]=rJson['wifiScheduleRule2'];
				rule[3]=rJson['wifiScheduleRule3'];
				rule[4]=rJson['wifiScheduleRule4'];
				rule[5]=rJson['wifiScheduleRule5'];
				rule[6]=rJson['wifiScheduleRule6'];
				rule[7]=rJson['wifiScheduleRule7'];
				rule[8]=rJson['wifiScheduleRule8'];
				rule[9]=rJson['wifiScheduleRule9'];
			
				for(var i=0;i<v_wifiScheduleNum;i++){	
					$("#wifiScheduleRule"+i).val(rule[i]);
					if(rule[i].split(",")[0]==1){
						$("#enable"+i).val("1");
						$("#wifiOn"+i).attr("checked",true);
					}
					else{
						$("#enable"+i).val("0");
						$("#wifiOn"+i).attr("checked",false);
					}
					$("#week"+i).val(rule[i].split(",")[1]);
					$("#startHour"+i).val(rule[i].split(",")[2]);
					$("#startMinute"+i).val(rule[i].split(",")[3]);
					$("#endHour"+i).val(rule[i].split(",")[4]);
					$("#endMinute"+i).val(rule[i].split(",")[5]);
				}
			}
			if(v_wifiScheduleEn==1){
				$("#div_sch_rules").show();
				if (v_ntpValid==0){
					alert(JS_msg31);
					setDisabled("#apply",true);
				}
			}else{
				$("#div_sch_rules").hide();
			}
		}
    });
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function updateState(){
	$(".select,.select3").css('backgroundColor','#ebebe4');
	var postVar={"topicurl" : "setting/setWiFiScheduleConfig"};
	postVar['wifiScheduleEn']=$("#wifiScheduleEn").val();
	postVar['addEffect']="1";
	uiPost(postVar);
}	

function doSubmit(){
	$(".select,.select3").css('backgroundColor','#ebebe4');		
	var postVar={"topicurl" : "setting/setWiFiScheduleConfig"};
	if($("#wifiScheduleEn").val()==1){	
		for(var i=0;i<v_wifiScheduleNum;i++){
			if($("#wifiOn"+i).is(':checked')){
				$("#enable"+i).val("1");
			}else{
				$("#enable"+i).val("0");
			}
			if(($("#enable"+i).val()==1)&&
				((parseInt($("#startHour"+i).val())>parseInt($("#endHour"+i).val()))||
				(((parseInt($("#startHour"+i).val())==parseInt($("#endHour"+i).val()))&&
				(parseInt($("#startMinute"+i).val())>=parseInt($("#endMinute"+i).val())))))){
				alert(JS_msg33);
				return false;
			}
		}
		for(var i=0;i<10;i++){
			postVar['enable'+i]=$("#enable"+i).val();
			postVar['week'+i]=$("#week"+i).val();
			postVar['startHour'+i]=$("#startHour"+i).val();
			postVar['startMinute'+i]=$("#startMinute"+i).val();
			postVar['endHour'+i]=$("#endHour"+i).val();
			postVar['endMinute'+i]=$("#endMinute"+i).val();
		}
		for(var i=0; i<10; i++){
			if(postVar['enable'+i]==1){
				for(var j=i+1; j<10; j++){
					if((parseInt($("#week"+i).val())==parseInt($("#week"+j).val()))&& postVar['enable'+j]==1){
						if(!((parseInt($("#startHour"+i).val())>=parseInt($("#endHour"+j).val()))||(parseInt($("#endHour"+i).val())<=parseInt($("#startHour"+j).val()))) ){
							alert(JS_msg131);
							return false;
						
						}
						if((parseInt($("#startHour"+i).val())==parseInt($("#startHour"+j).val()))&&(parseInt($("#endHour"+i).val())==parseInt($("#endHour"+j).val()))){
							if(!((parseInt($("#startMinute"+i).val())>=parseInt($("#endMinute"+j).val()))||(parseInt($("#endMinute"+i).val())<=parseInt($("#startMinute"+j).val())))){
								alert(JS_msg131);
								return false;
							}
						} 
					}
				}
			}
		}
	}		
	postVar['addEffect']="0";
	uiPost(postVar);
}	
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="700">
<tr><td class="content_title"><script>dw(MM_WiFiSchedule)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_WiFiSchedule)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_OnOff)</script></td>
<td><select class="select" id="wifiScheduleEn" onChange="updateState();">
<option value=0><script>dw(MM_Disable)</script></option>
<option value=1><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table>

<div id="div_sch_rules" style="display:none">
<table border=0 width="100%" id="div_schlist">
<tr><td colspan="4"><b><script>dw(MM_WiFiScheduleList)</script></b></td></tr>
<tr><td colspan="4" height="1" class="line"></td></tr>
<tr><td colspan="4" height="2"></td></tr>
<tr align="center">
<td class="item_center"><b><script>dw(MM_Enable)</script></b></td>
<td class="item_center"><b><script>dw(MM_Week)</script></b></td>
<td class="item_center"><b><script>dw(MM_StartTime)</script> (<script>dw(MM_hour)</script>: <script>dw(MM_min)</script>)</b></td>
<td class="item_center"><b><script>dw(MM_EndTime)</script> (<script>dw(MM_hour)</script>: <script>dw(MM_min)</script>)</b></td>
</tr>
<tr><td colspan="4" height="2"></td></tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button id="apply" value="'+BT_Apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</div>
</td></tr></table>
</body></html>
