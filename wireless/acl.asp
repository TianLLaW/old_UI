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
var v_authMode,v_authList; 
var rJson,rules_num=0;
function disableAddFiled(){
	setDisabled("#mac1,#mac2,#mac3,#mac4,#mac5,#mac6,#add,#scan",true);
}
function disableDelButton(){
	setDisabled("#delsel,#delreset",true);
}

var wifiIdx="0";
function initValue(){
	v_authMode=rJson['authMode'];
	v_authList=rJson['authList'];
	setJSONValue({
		'authMode'	:	v_authMode,
		'authList'		:	v_authList
	});
	if (v_authMode==0){
		disableAddFiled();
		disableDelButton();
	}
	if(v_authMode==1){
		$("#scan").hide();
	}else{
		$("#scan").show();
	}
	if (v_authList!=""){
		var data=new Array();
		data=v_authList.substring(0,v_authList.length).split(";");
		rules_num=data.length;				
		var strTmp="";
		for (i=0; i<data.length; i++){	
			strTmp="<tr align=center>\n";
			strTmp+="<td class=item_center2>"+(i+1)+"</td>\n";
			strTmp+="<td class=item_center2>"+data[i].split(",")[0]+"</td>\n";
			strTmp+="<td class=item_center2><input type=checkbox id=DR"+i+"></td>\n";
			strTmp+="</tr>\n";
			$("#div_acllist").append(strTmp);
		}
	}
	if (rules_num==0) disableDelButton();
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
}

$(function(){
	var postVar={topicurl:"setting/getWiFiAclAddConfig"};
	postVar["wifiIdx"]=wifiIdx;
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
	if (rules_num >= 10){
		alert(JS_msg28);
		return false;
	}
	$("#macAddress").val(combinMAC2($("#mac1").val(),$("#mac2").val(),$("#mac3").val(),$("#mac4").val(),$("#mac5").val(),$("#mac6").val()));
	if(!checkVaildVal.IsVaildMacAddr($("#macAddress").val())) return false;
	var p=v_authList.split(";");	
	for (var j=0; j<p.length; j++){
		var q=p[j].split(",");
		if (($("#macAddress").val()==q[0])||($("#macAddress").val().toLowerCase()==q[0].toLowerCase())){
			alert(JS_msg29);
			return false;
		}
	}
	return true;
}

function doSubmit(){
	if (saveChanges()==false) return false; 
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setWiFiAclAddConfig"};
	postVar['macAddress']=$("#macAddress").val();
	postVar['addEffect']="0";
	postVar["wifiIdx"]=wifiIdx;	
	uiPost(postVar);
}

function updateState(){
	if ($("#authMode").val()==1){
		if (!confirm(JS_msg103)){
			$("#authMode").val(v_authMode);
			return false;
		}
	}
	if($("#authMode").val()==1){
		$("#scan").hide();
	}else{
		$("#scan").show();
	}
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setWiFiAclAddConfig"};
	postVar['authMode']= $("#authMode").val();
	postVar['addEffect']="1";
	postVar["wifiIdx"]=wifiIdx;
	uiPost4(postVar);
}	

function deleteClick(){
	$(".select").css('backgroundColor','#ebebe4');
	var flg=0;
	var postVar={"topicurl":"setting/setWiFiAclDeleteConfig"};
	for (i=0; i< rules_num; i++){	
		var tmp =$("#DR"+i).get(0);
		if (tmp.checked==true){
			postVar['DR'+i]=i;
			flg=1;
		}
	}
	if(flg==0){
		alert(JS_msg36);
	 	return false;
	}
	if( !confirm(JS_msg130) )	return false;
	if(flg==1){
		postVar["wifiIdx"]=wifiIdx;
		uiPost(postVar);
	}
}

// show mac info
$(function(){
	$('#scan').on('click', function(event) {
		event.preventDefault();
		$('#show_arpinfo').show();
		var postVar = { topicurl : "setting/getWiFiIpMacTable"};
		postVar['wifiIdx']=wifiIdx;
	   	postVar = JSON.stringify(postVar);
		$.ajax({  
	       	type : "post",  
			url : " /cgi-bin/cstecgi.cgi",  
			data : postVar,
			beforeSend:function(){
	        	$("#arpTable").html('<tr><td colspan=2 ><p style="text-align:center"><img src="../style/load.gif" alt="" /></p></td></tr>');
	        },
			success : function(Data){
				arpJson = JSON.parse(Data);
				var _html = '';
				for(var i=1;i<arpJson.length;i++){	
					if(!arpJson[i].ip) continue;
					if(arpJson[i].mac=="00:00:00:00:00:00") continue;
					_html += "<tr align=center class=item_list onclick=selectArpTbl('"+arpJson[i].mac.toUpperCase()+"')>\n";
					_html += "<td>"+arpJson[i].mac.toUpperCase()+"</td>";
					_html += "</tr>";
				}
				$("#arpTable").html(_html);
			}
		}); 
	});
	$('#refresh_arpinfo').on('click', function(event) {
		event.preventDefault();
		$('#scan').trigger('click');
	});
	$('#close_arp_iframe').on('click', function(event) {
		event.preventDefault();
		$('#show_arpinfo').hide();
	});
});
function selectArpTbl(mac){
	$("#mac1").val(mac.split(":")[0]);
	$("#mac2").val(mac.split(":")[1]);
	$("#mac3").val(mac.split(":")[2]);
	$("#mac4").val(mac.split(":")[3]);
	$("#mac5").val(mac.split(":")[4]);
	$("#mac6").val(mac.split(":")[5]);
	$('#show_arpinfo').hide();
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_Acl)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_Acl)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_AuthMode)</script></td>
<td><select class="select" id="authMode" onChange="updateState()">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_AllowList)</script></option>
<option value="2"><script>dw(MM_DenyList)</script></option>
</select></td>
</tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr><td colspan="2"><b><script>dw(MM_AddRule)</script></b></td></tr>
<tr>
<td class="item_left"><script>dw(MM_Mac)</script></td>
<td><input type="hidden" id="authList"><input type="hidden" id="macAddress"><input type="text" class="text3" maxlength="2" name="mac1" id="mac1" onFocus="this.select();" onKeyUp="HWKeyUp('mac',1,event);" onKeyDown="return HWKeyDown('mac', 1,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac2" id="mac2" onFocus="this.select();" onKeyUp="HWKeyUp('mac',2,event);" onKeyDown="return HWKeyDown('mac', 2,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac3" id="mac3" onFocus="this.select();" onKeyUp="HWKeyUp('mac',3,event);" onKeyDown="return HWKeyDown('mac', 3,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac4" id="mac4" onFocus="this.select();" onKeyUp="HWKeyUp('mac',4,event);" onKeyDown="return HWKeyDown('mac', 4,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac5" id="mac5" onFocus="this.select();" onKeyUp="HWKeyUp('mac',5,event);" onKeyDown="return HWKeyDown('mac', 5,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac6" id="mac6" onFocus="this.select();" onKeyUp="HWKeyUp('mac',6,event);" onKeyDown="return HWKeyDown('mac', 6,event)"> <script>dw('<input type=button class=button_small id=scan value="'+BT_Scan+'" >')</script></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Add+'" id="add" onClick="doSubmit()">')</script></td></tr>
</table>

<table border=0 width="100%" id="div_acllist">
<tr><td colspan="3"><b><script>dw(MM_AclTbl)</script> <script>dw(JS_msg59)</script></b></tr>
<tr><td colspan="3" height="1" class="line"></td></tr>
<tr><td colspan="3" height="2"></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_Mac)</script></b></td>
<td class="item_center"><b><script>dw(MM_Select)</script></b></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Delete+'" id="delsel" onClick="deleteClick()">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="button" value="'+BT_Reset+'" id="delreset" onClick="resetForm()">')</script></td></tr>
</table>
</td></tr></table>

<!-- arp modal -->
<div class="show_arpinfo" id="show_arpinfo" style="display: none;">
	<div class="content">
	<table width=460><tr><td>
		<table border=0 width="100%"> 
			<tr><td class="content_title"><script>dw(MM_IpMacList)</script></td></tr>
			<!--<tr><td class="content_help"><script>dw(MSG_IpMacList)</script></td></tr>-->
			<tr><td height="1" class="line"></td></tr>
		</table>

		<table border=0 width="100%" id="div_acllist">
			<tr align="center">
                <td class="item_center"><b><script>dw(MM_Mac)</script></b></td>
			</tr>
			<tbody id="arpTable"></tbody>
		</table>

		<table border=0 width="100%"> 
			<tr><td height="1" class="line"></td></tr>
			<tr><td height="10"></td></tr>
			<tr><td align="right"><script>dw('<input id="refresh_arpinfo" type=button class=button value="'+BT_Refresh+'"> &nbsp;&nbsp;<input id="close_arp_iframe" type=button class=button value="'+BT_Close+'" >')</script></td></tr>
		</table>
	</td></tr></table>
	</div>
	<div class="modal-bg"></div>
</div>
</body></html>