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
$(function(){
	var postVar={topicurl:"setting/getPasswordCfg"};
	postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);
			supplyValue("admuser",rJson['admuser']);
		}
    });		
	$("#div_admpass11,#div_admpass21").show();//p
	$("#div_admpass12,#div_admpass22").hide();//t
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function saveChanges(){
	var checkbox = $('input[id="checkboxPass1"]:checked').val();
	if(checkbox == "on"){
		$("#admpass").val($("#admpass12").val());
	}else{
		$("#admpass").val($("#admpass11").val());
	}
	var checkbox = $('input[id="checkboxPass2"]:checked').val();
	if(checkbox == "on"){
		$("#admpass2").val($("#admpass22").val());
	}else{
		$("#admpass2").val($("#admpass21").val());
	}
	if (!checkVaildVal.IsVaildString($("#admuser").val(),MM_UserName,1)) return false;	
	if (!checkVaildVal.IsVaildString($("#oldadmpass").val(),MM_OrigPassword,1)) return false;
	if ($("#oldadmpass").val()!=rJson['admpass']){alert(JS_msg49);return false;}
	if (!checkVaildVal.IsVaildString($("#admpass").val(),MM_NewPassword,3)) return false;	
	if ($("#admpass2").val()!=$("#admpass").val()){alert(JS_msg50);return false;}
	return true;
}

function doSubmit(){
	if(saveChanges()==false) return false;
	var postVar={"topicurl":"setting/setPasswordCfg"};
	postVar['admuser']=$("#admuser").val();
	postVar['admpass']=$("#admpass").val();
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		var rJsonP=JSON.parse(Data);
		if(true==rJsonP['success']){
			parent.location.href='http://'+rJsonP['lan_ip']+'/formLogoutAll.htm';
			return false;
		}
	});
}

function updatePassType(index){
	if(index == 1){
		var checkbox = $('input[id="checkboxPass1"]:checked').val();
		if(checkbox == "on"){
			$("#admpass12").val($("#admpass11").val()); 
			$("#admpass").val($("#admpass11").val());
			$("#div_admpass11").hide();
			$("#div_admpass12").show();
		}else{
			$("#admpass11").val($("#admpass12").val());
			$("#admpass").val($("#admpass12").val());
			$("#div_admpass11").show();//p
			$("#div_admpass12").hide();//t
		}
	}else if(index == 2){
		var checkbox = $('input[id="checkboxPass2"]:checked').val();
		if(checkbox == "on"){
			$("#admpass22").val($("#admpass21").val()); 
			$("#admpass2").val($("#admpass21").val());
			$("#div_admpass21").hide();
			$("#div_admpass22").show();
		}else{
			$("#admpass21").val($("#admpass22").val());
			$("#admpass2").val($("#admpass22").val());
			$("#div_admpass21").show();//p
			$("#div_admpass22").hide();//t
		}
	}
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_Administrator)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_Administrator)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr style="display:none">
<td class="item_left"><script>dw(MM_UserName)</script></td>
<td><input type="text" class="text" id="admuser" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_OrigPassword)</script></td>
<td><input type="password" class="text" id="oldadmpass" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_NewPassword)</script></td>
<td><input type="hidden" id="admpass"><span id="div_admpass11"><input type="password" class="text" id="admpass11" maxlength="32"></span><span id="div_admpass12" style="display:none"><input type="text" class="text" id="admpass12" maxlength="32"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="checkboxPass1" onChange="updatePassType(1)"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ConfirmPassword)</script></td>
<td><input type="hidden" id="admpass2"><span id="div_admpass21"><input type="password" class="text" id="admpass21" maxlength="32"></span><span id="div_admpass22" style="display:none"><input type="text" class="text" id="admpass22" maxlength="32"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="checkboxPass2" onChange="updatePassType(2)"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</td></tr></table>
</body></html>