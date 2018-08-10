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
var rJson,rJsonStatus;
function updateState(){
	if ($("#ddnsEnabled")[0].selectedIndex==1){
		$("#div_ddns_setting").show();
	}else{
		$("#div_ddns_setting").hide();
	}
}

function updateProvider(val){
	$("#ddnsDomain").attr("disabled",false);
	if(1==val){
		var ddns_type= rJson["ddnsProvider"];
		if($("#ddnsProvider").val()!=ddns_type){
			supplyValue("ddnsDomain","");
		}else{
			supplyValue("ddnsDomain",rJson["ddnsDomain"]);
		}
	}
	if ($("#ddnsProvider").val()=="0"){
		$("#div_to_register").html("<a href='http://dyn.com/dns/' target='_blank'>"+MM_Register+"</a>");
	}else if ($("#ddnsProvider").val()=="1"){
		$("#div_to_register").html("<a href='http://www.no-ip.com/newUser.php/' target='_blank'>"+MM_Register+"</a>");
	}else if ($("#ddnsProvider").val()=="2"){
		$("#div_to_register").html("<a href='http://www.pubyun.com/accounts/signup/' target='_blank'>"+MM_Register+"</a>");
	}else{
		$("#div_to_register").html("");
	}
}

function showDDNSStatus(val){
	if (val=="fail"){
		return MM_DdnsFail;
	}else{
		return MM_DdnsSuccess;
	}	
}

var Itimer="";
function RefreshDdnsStatus(){ 
	try{  
	  	var ddnsStatus=rJsonStatus['ddnsStatus'];
	}catch(e){}
	
	parent.menu.counts++;  
	if(ddnsStatus == "disconnected"){
		if(25>parent.menu.counts){
			window.location.reload(); 
			return false;
		}
	}else{
	  	$("#ddns_status").html(ddnsStatus);
		clearTimeout(Itimer);
	}
	$("#ddns_status").html(showDDNSStatus(ddnsStatus));
} 

function updatePassType(){
	var checkbox = $('input[id="checkbox"]:checked').val();
	if(checkbox == "on"){
		$("#ddnsPassword3").val($("#ddnsPassword2").val()); 
		$("#ddnsPassword").val($("#ddnsPassword2").val());
		$("#div_password2").hide();
		$("#div_password3").show();
	}else{
		$("#ddnsPassword2").val($("#ddnsPassword3").val());
		$("#ddnsPassword").val($("#ddnsPassword3").val());
		$("#div_password2").show();//p
		$("#div_password3").hide();//t
	}
}

$(function(){
	var postVar={topicurl:"setting/getDDNSCfg"};
	postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);
			setJSONValue({		
				'ddnsEnabled'			:	rJson['ddnsEnabled'],
				'ddnsProvider'			:	rJson['ddnsProvider'],
				'ddnsDomain'			:	rJson['ddnsDomain'],
				'ddnsAccount'			:	rJson['ddnsAccount'],
				'ddnsPassword2'			:	rJson['ddnsPassword'],
				'ddnsPassword3'			:	rJson['ddnsPassword'],
				'ddnsPassword'			:	rJson['ddnsPassword']
			});		
			$("#div_password2").show();//p
			$("#div_password3").hide();//t
			updateState();
			updateProvider(0);
		}
    });	
	
	if(rJson['ddnsEnabled']==1){
		var postVar={ topicurl : "setting/getDDNSStatus"};
		postVar=JSON.stringify(postVar);
		$.ajax({  
			type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
				rJsonStatus=JSON.parse(Data);				
				if(rJsonStatus['ddnsStatus']=="fail"){
					$("#ddns_status").html(JS_msg90);
					Itimer=window.setTimeout(RefreshDdnsStatus,6000); 
				}else{
					$("#ddns_status").html(MM_DdnsSuccess);
				}				
				if (rJsonStatus['ddnsIp']!=""&&rJsonStatus['ddnsStatus']=="success"){
					$("#ddns_status").html(MM_DdnsSuccess);
					$("#ddns_ip").html(rJsonStatus['ddnsIp']);
				}else{
					$("#ddns_status").html(MM_DdnsFail);
					$("#ddns_ip").html("0.0.0.0");
				}
			}
		});
		$("#div_ddns_status,#div_ddns_ip").show();
	}else{
		$("#ddns_status").html("");
		$("#ddns_ip").html("0.0.0.0");
		$("#div_ddns_status,#div_ddns_ip").hide();
	}
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function saveChanges(){
	var checkbox = $('input[id="checkbox"]:checked').val();
	if(checkbox == "on"){
		$("#ddnsPassword").val($("#ddnsPassword3").val());
	}else{
		$("#ddnsPassword").val($("#ddnsPassword2").val());
	}
	if ($("#ddnsEnabled")[0].selectedIndex==1){
		if (!checkVaildVal.IsVaildString($("#ddnsDomain").val(),MM_DomainName,1)) return false;
		if (!checkVaildVal.IsVaildString($("#ddnsAccount").val(),MM_UserName,1)) return false;
		if (!checkVaildVal.IsVaildString($("#ddnsPassword").val(),MM_Password,1)) return false;		
	}	
	parent.menu.counts=0;
	return true;
}

function doSubmit(){
	if (saveChanges()==false) return false;	
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setDDNSCfg"};
	postVar['ddnsEnabled']=$("#ddnsEnabled").val();
	postVar['ddnsProvider']=$("#ddnsProvider").val();
	postVar['ddnsDomain']=$("#ddnsDomain").val();
	postVar['ddnsAccount']=$("#ddnsAccount").val();
	postVar['ddnsPassword']=$("#ddnsPassword").val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title">DDNS</td></tr>
<tr><td class="content_help"><script>dw(MSG_Ddns)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_OnOff)</script></td>
<td><select class="select" id="ddnsEnabled" onChange="updateState()">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
</table>

<table id="div_ddns_setting" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_Service)</script></td>
<td><select class="select" id="ddnsProvider" onChange="updateProvider(1)">
<option value="0">DynDNS</option>
<option value="1">No-IP</option>
<option value="2">www.3322.org</option>
</select>&nbsp;&nbsp;&nbsp;&nbsp;<span id="div_to_register"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_DomainName)</script></td>
<td><input type="text" class="text" id="ddnsDomain" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_UserName)</script></td>
<td><input type="text" class="text" id="ddnsAccount" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Password)</script></td>
<td><input type="hidden" id="ddnsPassword"><span id="div_password2"><input type="password" class="text" id="ddnsPassword2" maxlength="32"></span><span id="div_password3" style="display:none"><input type="text" class="text" id="ddnsPassword3" maxlength="32"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="checkbox" onChange="updatePassType()"></td>
</tr>
<tr id="div_ddns_status" style="display:none">
<td class="item_left"><script>dw(MM_DdnsStatus)</script></td>
<td><span id="ddns_status"></span></td>
</tr>
<tr id="div_ddns_ip" style="display:none">
<td class="item_left"><script>dw(MM_DdnsInfo)</script></td>
<td><script>dw(MM_DdnsIpAddr)</script> <span id="ddns_ip"></span></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</td></tr></table>
</body></html>