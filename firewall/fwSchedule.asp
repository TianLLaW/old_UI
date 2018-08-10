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
var scheduleRulesListAdd;
var scheduleRulesListDel;
var scheduleMac_conut=0, scheduleIp_conut=0;

function addClick(){	
	var timestr="";
	var week;
	var countWeekdays=0;
	var weekdaysItem=getElements("weekdays");
	var timeItem=getElements("timeItem");
	var objSelect=document.getElementById("chooseRule");
	if(objSelect.options.length==0){
		alert(JS_msg122);
		return false;
	}
	if(getElements('timeAllowed')[0].checked){//alway
		timestr="255,00:00,23:59";
	}else{
		for(var i=0;i< weekdaysItem.length;i++){
			if(weekdaysItem[i].checked){
			//	timestr += weekdaysItem[i].value+","
				week |= (0x1<<weekdaysItem[i].value);
			}else{
				countWeekdays++
			}
		}
		timestr=week;
		timestr += ","+timeItem[0].value+":"+timeItem[1].value;
		timestr += "-"+timeItem[2].value+":"+timeItem[3].value;
	}
	
	if(getElements('timeAllowed')[1].checked){//manual
		if(countWeekdays==7){
			alert(JS_msg123);
			return false;
		}
		if(timeItem[0].value=="" || timeItem[1].value=="" || timeItem[2].value=="" || timeItem[3].value==""){
			alert(JS_msg124);
			return false;
		}

		if (!checkVaildVal.isNumber(timeItem[0].value) || !checkVaildVal.isNumber(timeItem[1].value) || !checkVaildVal.isNumber(timeItem[2].value) || !checkVaildVal.isNumber(timeItem[3].value)){
			alert(JS_msg125);
			return false;
		}

		var time1=parseInt(timeItem[0].value);
		var time2=parseInt(timeItem[1].value);
		var time3=parseInt(timeItem[2].value);
		var time4=parseInt(timeItem[3].value);

		if (time1 > 23 || time2 >59 || time3 > 23 || time4 > 59){
			alert(JS_msg125);
			return false;
		}

		if (time1 > time3){
			alert(JS_msg127);
			return false;
		}
		
		if (time1== time3){
			if (time2 > time4){
				alert(JS_msg128);
				return false;
			}
		}		
	}	

	getAllItemValues("chooseRule",timestr);	
  	return true;
}

function selectToSelect(fromObjSelectId, toObjectSelectId){  
 	var objSelect=document.getElementById(fromObjSelectId);
 	var delNum=0;
    if (null != objSelect && typeof(objSelect) != "undefined"){
    	for(var i=0;i<objSelect.options.length;i=i+1){  
            if(objSelect.options[i].selected){  
                addItemToSelect(toObjectSelectId,objSelect.options[i].text,objSelect.options[i].value)
                objSelect.options.remove(i);
                i=i - 1;
            }
        }         
  	} 
}

function addItemToSelect(objSelectId,objItemText,objItemValue){  
 	var objSelect=document.getElementById(objSelectId);
    if (null != objSelect && typeof(objSelect) != "undefined"){
     	if(0){  //isSelectItemExit(objSelectId,objItemValue)
         	alert(JS_msg129);
     	}else {
         	var varItem=new Option(objItemText,objItemValue);  
         	objSelect.options.add(varItem);  
     	}  
    } 
}

function isSelectItemExit(objSelectId,objItemValue){  
 	var objSelect=document.getElementById(objSelectId);
    var isExit=false;  
    if (null != objSelect && typeof(objSelect) != "undefined"){
     	for(var i=0;i<objSelect.options.length;i++){  
         	if(objSelect.options[i].value==objItemValue){  
             	isExit=true;  
             	break;  
         	}  
     	}  
    }
    return isExit; 
}
 
function clearSelect(objSelectId){  
 	var objSelect=document.getElementById(objSelectId);
   	if (null != objSelect && typeof(objSelect) != "undefined"){
        for(var i=0;i<objSelect.options.length;){  
          	objSelect.options.remove(i);  
        }         
    } 
}

function changeTime(){
	var timeIetm=getElements("timeAllowed");
	if(timeIetm[0].checked)
		$("#weekID,#timeID").hide();
	else
		$("#weekID,#timeID").show();
}
var weekdaystr={'Mon':MM_Week1,'Tue':MM_Week2,'Wed':MM_Week3,'Thu':MM_Week4,'Fri':MM_Week5,'Sat':MM_Week6,'Sun':MM_Week7};

function formmatTime(tmv){
	var timeStr=tmv.split("|");
	var weeks=timeStr[1];
	var fromTime=timeStr[2];
	var toTime=timeStr[3];
	var timeSring="";
	weeks=weeks.split(",");
	for(var i=0;i<weeks.length;i++){
		timeSring+=weekdaystr[weeks[i]]+",";
	}
	timeSring=timeSring.substring(0,timeSring.lastIndexOf(','));
	return timeSring+=" "+fromTime+"-"+toTime;
}

function showItemList(){
	var showSchedule=document.getElementById("scheduleList");
	var trNode={};
	var tdNode={};
	var schTime="";
	var itemText="";
	var itemValue="";
	var obj={},len;
	clearSelect("chooseRule");
	clearSelect("ruleList");
	
	len=rJson.length;
	if ((len-1)>0){
		for(var i=1;i<len;i++){
			if(rJson[i]["firewallMode"]=="IPPORT"){
				itemText = rJson[i]['ip']+" "+rJson[i]['proto']+" "+rJson[i]['portRange'];
				itemValue=rJson[i]['delRuleName'];
				addItemToSelect('ruleList',itemText,itemValue);
			}
			if(rJson[i]["schFirewallMode"]=="IPPORT"){
				scheduleIp_conut++;	
				trNode=showSchedule.insertRow(-1);
				trNode.insertCell(0).innerHTML='<input type=hidden id=\"scheDelValue'+i+'\" value=\"'+rJson[i]['schIp']+'\">'+rJson[i]['schIp'];
				trNode.insertCell(1).innerHTML='<input type=hidden id=\"scheDelProto'+i+'\" value=\"'+rJson[i]['schProto']+'\">'+rJson[i]['schProto'];
				trNode.insertCell(2).innerHTML='<input type=hidden id=\"scheDelPort'+i+'\" value=\"'+rJson[i]['schPortRange']+'\">'+rJson[i]['schPortRange'];
				trNode.insertCell(3).innerHTML="--";
				trNode.insertCell(4).innerHTML=rJson[i]['schWeek']+" "+rJson[i]['schTime'];
				trNode.insertCell(5).innerHTML='<input type=\"checkbox\" name=\"scheduleDel\"  id=\"scheduleDel'+i+'\"  value=\"'+itemValue+'\" >';
			}
			if(rJson[i]["firewallMode"]=="MAC"){
				itemText = rJson[i]['mac'];
				itemValue=rJson[i]['delRuleName'];
				addItemToSelect('ruleList',itemText,itemValue);
			}
			if(rJson[i]["schFirewallMode"]=="MAC"){
				scheduleMac_conut++;
				trNode=showSchedule.insertRow(-1);
				trNode.insertCell(0).innerHTML="--";
				trNode.insertCell(1).innerHTML="--";
				trNode.insertCell(2).innerHTML="--";
				trNode.insertCell(3).innerHTML='<input type=hidden id=\"scheDelValue'+i+'\" value=\"'+rJson[i]['schMac']+'\">'+rJson[i]['schMac'];
				trNode.insertCell(4).innerHTML=rJson[i]['schWeek']+" "+rJson[i]['schTime'];
				trNode.insertCell(5).innerHTML='<input type=\"checkbox\" name=\"scheduleDel\" id=\"scheduleDel'+i+'\" value=\"'+itemValue+'\" >';
			}
		}
	}

	var scheduleLen=showSchedule.rows.length;
	var submitStr="";
	var timeStr="";
	var weekSrt="";
	var fromto=""
	var tmp="";
	for(var k=0;k<scheduleLen;k++){
		timeStr=showSchedule.rows[k].cells[4].innerHTML;
		tmp="";
		if(timeStr != "Mon Tue Wed Thu Fri Sat Sun 00:00-23:59"){
			weekSrt=timeStr.split(" ");
			for(var m=0;m<weekSrt.length-1;m++){
				tmp+=weekdaystr[weekSrt[m]]+" ";
			}
			timeStr=tmp+weekSrt[weekSrt.length-1];
		}else{
			timeStr = MM_Always;
		}
		showSchedule.rows[k].cells[4].innerHTML=timeStr;
	}
	showSchedule.style.display = "";
}

function getAllItemValues(objSelectId,timestr){
	var submitValue="";
 	var objSelect = document.getElementById(objSelectId);
 	var objSchedule = document.getElementById("submitFilterList");
 	var tmpNode={};
 	if (null != objSelect && typeof(objSelect) != "undefined") {
      	var length = objSelect.options.length
        for(var i = 0; i < length; i = i + 1) {  
			var text=objSelect.options[i].text;
			if(typeof(text.split(" ")[1])!="undefined")
				submitValue+=objSelect.options[i].value+","+timestr+","+text.split(" ")[0]+","+text.split(" ")[1]+","+text.split(" ")[2]+";";
			else
				submitValue+=objSelect.options[i].value+","+timestr+","+text.split(" ")[0]+";";
        }   
		tmpNode = document.createElement("input");
		tmpNode.setAttribute( "type" , "text") ;
		tmpNode.setAttribute( "name" , "scheduleRulesList") ;
		tmpNode.setAttribute( "value" , submitValue) ;
		objSchedule.appendChild(tmpNode);
		scheduleRulesListAdd=submitValue;
   	}  
  	return true;
}

function getAllDelItem(timestr){
	var objScheduleDel = document.getElementById("submitDelList");
	var tmpNode={};
	var submitValue="";
	var delList=getElements("scheduleDel");
	for(var i=delList.length - 1;i >= 0;i--){
		if(delList[i].checked){
		//	if($("#scheDelValue"+(i+1)).val().indexOf(":")>=0)
		//		submitValue+=delList[i].value+","+timestr+","+$("#scheDelValue"+(i+1)).val()+";";
		//	else
		//		submitValue+=delList[i].value+","+timestr+","+$("#scheDelValue"+(i+1)).val()+","+$("#scheDelProto"+(i+1)).val()+","+$("#scheDelPort"+(i+1)).val()+";";
			submitValue+="delRuleName,"+i+";";
		}	
	}
	tmpNode = document.createElement("input");
	tmpNode.setAttribute( "type" , "text") ;
	tmpNode.setAttribute( "name" , "scheduleDelRulesList") ;
	tmpNode.setAttribute( "value" , submitValue) ;
	objScheduleDel.appendChild(tmpNode);
	scheduleRulesListDel=submitValue;	
}

function deleteClick(){
	var flg=0;
	for(var i=1;i<=(scheduleMac_conut+scheduleIp_conut);i++){
		var tmp =$("#scheduleDel"+i).get(0);
		if (tmp.checked==true){
			flg=1;
		}
	}
	
	if(flg==0){
		alert(JS_msg36);
		return false;
	}
	if ( !confirm(JS_msg130) )	return false;
  	else{
		//$("#ScheduleTime1").val("255,00:00-23:59");//0|1,2,3,4,5,6,7|00:00:00|23:59:59		
		getAllDelItem("255,00:00-23:59");
		return true;
	}
}

function disableDelButton(){
	for (var i=0;i<document.forms[0].length;i++)
		document.forms[0].elements[i].disabled=true;
			
	for (var i=0;i<document.forms[1].length;i++)
		document.forms[1].elements[i].disabled = true;
}

function initValue(){
	changeTime();
	showItemList();
	var len=rJson.length;
	if (len<=1)
		disableDelButton();
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}	
}

$(function(){
	var postVar={topicurl:"setting/getScheduleRules"};
    postVar=JSON.stringify(postVar);	
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson = JSON.parse(Data);							
		}
    });	
	initValue();
});

function doSubmit(){
	if(addClick()==false) return false;
	var postVar={"topicurl":"setting/setScheduleRules"};
	postVar['scheduleRulesList']= scheduleRulesListAdd;
	postVar['actionType']= "add";
	uiPost(postVar);
}

function delRules(){
	var flg=0;
	if(deleteClick()==false) return false;
	var postVar ={"topicurl":"setting/setScheduleRules"};
	postVar['scheduleDelRulesList']= scheduleRulesListDel;
	postVar['actionType']="del";
	uiPost(postVar);
}

var getElements=function(name){	return document.getElementsByName(name);}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<form method=POST name="formFilterAdd">
<input type="hidden" name="ScheduleTime" id="ScheduleTime">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_RuleSchedule)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_RuleSchedule)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr align="center">
<td><b><script>dw(MM_CurrentList)</script></b></td>
<td>&nbsp;</td>
<td><b><script>dw(MM_ChoosedList)</script></b></td>
</tr>
<tr>
<td><select id="ruleList" multiple="multiple" style="width:300px;height:230px;"><option value="1"></option></select></td> 
<td align="center"><input type="button" class="button_small" name="operationtol" value="&nbsp;&nbsp;<<&nbsp;&nbsp;" onClick="selectToSelect('chooseRule','ruleList');">&nbsp;&nbsp;&nbsp;&nbsp;</br></br><input type="button" class="button_small" name="operationtor" value="&nbsp;&nbsp;>>&nbsp;&nbsp;" onClick="selectToSelect('ruleList','chooseRule');">&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td><select id="chooseRule" multiple="multiple" style="width:300px;height:230px;"><option value="1"></option></select></td>
</tr>
</table>

<table width="100%" border="0">
<tr><td class="item_left">&nbsp;</td></tr>
<tr style="display:none;">
<td class="item_left"><script>dw(MM_ScheduleTbl)</script></td>
<td align="left" colspan="2"><input type="radio" name="timeAllowed" id="timeAllowed1" onClick="changeTime(this);" value="1"> <script>dw(MM_Always)</script><input type="radio" name="timeAllowed" id="timeAllowed2" onClick="changeTime(this);" value="2" checked> <script>dw(MM_Manual)</script></td>
</tr>
<tr id="weekID">
<td class="item_left"><script>dw(MM_Week)</script></td>
<td align="left" colspan="2"><input type="checkbox" name="weekdays" value="1"> <script>dw(MM_Week1)</script>&nbsp;
<input type="checkbox" name="weekdays" value="2"> <script>dw(MM_Week2)</script>&nbsp;
<input type="checkbox" name="weekdays" value="3"> <script>dw(MM_Week3)</script>&nbsp;
<input type="checkbox" name="weekdays" value="4"> <script>dw(MM_Week4)</script>&nbsp;
<input type="checkbox" name="weekdays" value="5"> <script>dw(MM_Week5)</script>&nbsp;
<input type="checkbox" name="weekdays" value="6"> <script>dw(MM_Week6)</script>&nbsp;
<input type="checkbox" name="weekdays" value="7"> <script>dw(MM_Week7)</script></td>
</tr>
<tr id="timeID">
<td class="item_left"><script>dw(MM_Time)</script></td>
<td align="left" colspan="2"><input type="text" class="text3" name="timeItem" maxlength="2">:
<input type="text" class="text3" name="timeItem" maxlength="2">&nbsp;&nbsp;--&nbsp;&nbsp;
<input type="text" class="text3" name="timeItem" maxlength="2">:
<input type="text" class="text3" name="timeItem" maxlength="2">&nbsp;&nbsp;&nbsp;&nbsp;(HH:MM -- HH:MM)</td>
</tr>
</table>

<div id="submitFilterList" style="display:none;"></div>
<table border=0 width="100%">
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Add+'" onClick="doSubmit();">')</script></td></tr>
</table>
</form>

<br>
<form method=POST name="formFilterDel">
<input type="hidden" name="ScheduleTime" id="ScheduleTime1">
<table border=0 width="100%">
<tr><td colspan="6"><b><script>dw(MM_RuleScheduleList)</script></b></td></tr>
<tr><td colspan="6" height="1" class="line"></td></tr>
<tr><td colspan="6" height="2"></td></tr>
<tr align=center>
<td class="item_center"><b><script>dw(MM_Ip)</script></b></td>
<td class="item_center"><b><script>dw(MM_Protocol)</script></b></td>
<td class="item_center"><b><script>dw(MM_PortRange)</script></b></td>
<td class="item_center"><b><script>dw(MM_Mac)</script></b></td>
<td class="item_center"><b><script>dw(MM_Time)</script></b></td>
<td class="item_center"><b><script>dw(MM_Select)</script></b></td>
</tr>
<tbody id="scheduleList" align="center" style="display:none;"></tbody>
</table>

<div id="submitDelList" style="display:none;"></div>

<table border=0 width="100%">
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type="button" class="button" value="'+BT_Delete+'" onClick="delRules();">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="button" value="'+BT_Reset+'" onClick="resetForm()">')</script></td></tr>
</table>
</form>
</td></tr></table>
</body></html>