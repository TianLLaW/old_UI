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
var v_dmzEnable,v_dmzAddress,v_lanNetmask,v_lanIp,v_stationIp;
function selectMyIP(){
	if ($("#dmzMyIp").is(":checked")){
		supplyValue("dmzip4",$("#myip").html().split(".")[3]);
	}else if(v_dmzAddress ==""||v_dmzAddress =="undefined"){
    	supplyValue("dmzip4","");
	}else{
		supplyValue("dmzip4",v_dmzAddress.split(".")[3]);
	}
}  

function updateState(){
	if ($("#dmzEnabled").val()==1){
		$("#div_dmzip,#div_pcip").show();
		setDisabled("#dmzMyIp,#dmzip4",false);
	}else{
		$("#div_dmzip,#div_pcip").hide();
		setDisabled("#dmzMyIp,#dmzip4",true);
	}
}
function initValue(){
	v_dmzEnable=rJson['dmzEnabled'];
	v_dmzAddress=rJson['dmzAddress'];
	v_lanNetmask=rJson['lanNetmask'];
	v_lanIp=rJson['lanIp'];
	v_stationIp=rJson['stationIp'];
	supplyValue("dmzEnabled",v_dmzEnable);
	supplyValue("myip",v_stationIp);
	if (v_dmzEnable=="0"){
		$("#div_dmzip,#div_pcip").hide();
		setDisabled("#dmzMyIp,#dmzip4",true);
	}else{
		$("#div_dmzip,#div_pcip").show();
		setDisabled("#dmzMyIp,#dmzip4",false);
	}
	if(v_dmzAddress != "") supplyValue("dmzip4",v_dmzAddress.split(".")[3]);
	if (v_lanIp !="") decomIP2($(":input[name=ips]"),v_lanIp,0);
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
}
$(function(){
	var postVar={topicurl:"setting/getDMZCfg"};
    postVar=JSON.stringify(postVar);	
	$.when( $.post( " /cgi-bin/cstecgi.cgi", postVar))
    .done(function( Data) {
		rJson = JSON.parse(Data);
		initValue();
	})
	.fail(function(){
		setTimeout("resetForm();","3000");
	});
});

function saveChanges(){
	supplyValue("dmzAddress", v_lanIp.replace(/\.\d{1,3}$/,".")+$("#dmzip4").val());
	if ($("#dmzEnabled").val()=="1"){
		var dmzAddress=$("#dmzAddress").val();
		if (!checkVaildVal.IsVaildIpAddr(dmzAddress, MM_HostIp)) return false;		
		if (!checkVaildVal.IsIpSubnet(dmzAddress, v_lanNetmask, v_lanIp)){alert(JS_msg38); return false;}		
		if (dmzAddress==v_lanIp){alert(JS_msg39);return false;}
	}	
	return true;
}

function doSubmit(){
	if(!saveChanges()) return false;
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setDMZCfg"};
	postVar['dmzEnabled']=$("#dmzEnabled").val();
	postVar['dmzAddress']=$("#dmzAddress").val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%">
<tr><td class="content_title">DMZ</td></tr>
<tr><td class="content_help"><script>dw(MSG_Dmz)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_OnOff)</script></td>
<td><select class="select" id="dmzEnabled" onChange="updateState()">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr id="div_dmzip" style="display:none">
<td class="item_left"><script>dw(MM_HostIp)</script></td>
<td><input type="hidden" id="dmzAddress"><input type="text" class="text3" name="ips" maxlength="3" disabled><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" name="ips" maxlength="3" disabled><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" name="ips" maxlength="3" disabled><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="3" id="dmzip4" name="dmzip4"></td>
</tr>
<tr id="div_pcip" style="display:none">
<td class="item_left">&nbsp;</td>
<td><input type="checkbox" id="dmzMyIp" onClick="selectMyIP()"> <script>dw(MM_CurrentPC)</script> <span id="myip"></span></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="return doSubmit();">')</script></td></tr>
</table>
</td></tr></table>
</body></html>