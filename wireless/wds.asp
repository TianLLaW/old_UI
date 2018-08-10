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
var v_wdsEnable,v_wdsList;
var rJson,rules_num=0;
function disableAddFiled(){
	setDisabled("#mac1,#mac2,#mac3,#mac4,#mac5,#mac6,#add,#scan",true);
}
function disableDelButton(){
	setDisabled("#delsel,#delreset",true);
}

var wifiIdx="0";
function initValue(){
	v_wdsEnable=rJson['wdsEnable'];	
	v_wdsList=rJson['wdsList'];					
	setJSONValue({ 
		'wdsEnable'		:	v_wdsEnable,
		'wdsList'		:	v_wdsList
	});
	if (v_wdsEnable==0){
		disableAddFiled();
		disableDelButton();	
	}
	if (v_wdsList!=""){	
		var data=new Array();
		data=v_wdsList.split(";");
		rules_num=data.length;
		var _html="";
		for (i=0; i<data.length; i++){
			_html="<tr align=center>\n";
			_html+="<td class=item_center2>"+(i+1)+"</td>\n";
			_html+="<td class=item_center2>"+data[i]+"</td>\n";
			_html+="<td class=item_center2><input type=checkbox id=DR"+i+"></td>\n";
			_html+="</tr>\n";
			$("#div_wdslist").append(_html);
		}
	}
	if (rules_num==0) disableDelButton();
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
}

$(function(){
	var postVar={topicurl:"setting/getWiFiWdsAddConfig"};
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
	if (rules_num > 3){
		alert(JS_msg30);
		return false;
	}			
	$("#macAddress").val(combinMAC2($("#mac1").val(),$("#mac2").val(),$("#mac3").val(),$("#mac4").val(),$("#mac5").val(),$("#mac6").val()));
	if(!checkVaildVal.IsVaildMacAddr($("#macAddress").val())) return false;
	var p=v_wdsList.split(";");
	for (var i=0; i<p.length; i++){
		if ($("#macAddress").val()==p[i].toUpperCase()){
			alert(JS_msg29);
			return false;
		}
	}
	var macVal=$("#macAddress").val();
	if (rules_num==0)
		$("#wdsList").val(macVal);
	else if (rules_num==1)	
		$("#wdsList").val(p[0]+";"+macVal);
	else if (rules_num==2)
		$("#wdsList").val(p[0]+";"+p[1]+";"+macVal);
	else if (rules_num==3)
		$("#wdsList").val(p[0]+";"+p[1]+";"+p[2]+";"+macVal);
	return true;
}

function doSubmit(){
	if (saveChanges()==false) return false; 
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setWiFiWdsAddConfig"};
	postVar['wdsList']=$("#wdsList").val();
	postVar['addEffect']="0";
	postVar["wifiIdx"]=wifiIdx;
	uiPost(postVar);
}

function updateState(){
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setWiFiWdsAddConfig"};
	postVar['wdsEnable']=$('#wdsEnable').val();
	postVar['addEffect']="1";
	postVar["wifiIdx"]=wifiIdx;
	uiPost(postVar);
}

function deleteClick(){
	$(".select").css('backgroundColor','#ebebe4');
	var flg=0;
	var postVar={"topicurl":"setting/setWiFiWdsDeleteConfig"};
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
		var postVar = { topicurl : "setting/getWiFiApcliScan"};
		postVar['wifiIdx']=wifiIdx;
	    postVar = JSON.stringify(postVar);
		$.ajax({  
	       	type : "post",  
	        url : " /cgi-bin/cstecgi.cgi",  
	        data : postVar,
			beforeSend:function(){
	        	$("#arpTable").html('<tr><td colspan=2><p style="text-align:center"><img src="../style/load.gif" alt="" /></p></td></tr>');
	        	$("#arpTable_1").html('');
	        },
	        success : function(Data){
				rJson=JSON.parse(Data);
				var _html='';
				for (var i=0;i<rJson.length;i++) {
					_html+='<tr align=center class=item_list data-wifi="'+rJson[i].bssid+'" onclick=selectArpTbl(this)>\n';
					_html+='<td>'+showSsidFormat(rJson[i].ssid)+'</td>\n';
					_html+='<td>'+rJson[i].bssid+'</td>\n';
					_html+='</tr>\n';
				}
				$("#arpTable,#arpTable_1").empty().append(_html);
				$('#div_aplist_1').width($("#arpTable").width());
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
function selectArpTbl(data){
	var mac=$(data).data('wifi');
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
<tr><td class="content_title">WDS</td></tr>
<tr><td class="content_help"><script>dw(MSG_Wds)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_OnOff)</script></td>
<td><select class="select" id="wdsEnable" onChange="updateState()">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table>

<table border=0 width="100%"> 
<tr><td colspan="2"><b><script>dw(MM_AddRule)</script></b></td></tr>
<tr> 
<td class="item_left"><script>dw(MM_Mac)</script></td>
<td><input type="hidden" id="wdsList"><input type="hidden" id="macAddress"><input type="text" class="text3" maxlength="2" name="mac1" id="mac1" onFocus="this.select();" onKeyUp="HWKeyUp('mac',1,event);" onKeyDown="return HWKeyDown('mac',1,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac2" id="mac2" onFocus="this.select();" onKeyUp="HWKeyUp('mac',2,event);" onKeyDown="return HWKeyDown('mac',2,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac3" id="mac3" onFocus="this.select();" onKeyUp="HWKeyUp('mac',3,event);" onKeyDown="return HWKeyDown('mac',3,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac4" id="mac4" onFocus="this.select();" onKeyUp="HWKeyUp('mac',4,event);" onKeyDown="return HWKeyDown('mac',4,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac5" id="mac5" onFocus="this.select();" onKeyUp="HWKeyUp('mac',5,event);" onKeyDown="return HWKeyDown('mac',5,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac6" id="mac6" onFocus="this.select();" onKeyUp="HWKeyUp('mac',6,event);" onKeyDown="return HWKeyDown('mac',6,event)"> <script>dw('<input type=button class=button_small id=scan value="'+BT_Scan+'" >')</script></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Add+'" id="add" onClick="doSubmit()">')</script></td></tr>
</table>

<table border=0 width="100%" id="div_wdslist"> 
<tr><td colspan="3"><b><script>dw(MM_WdsTbl)</script> <script>dw(JS_msg70)</script></b></td></tr>
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
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Delete+'" id=delsel onClick="deleteClick()">&nbsp;&nbsp;&nbsp;&nbsp;<input type=button class=button value="'+BT_Reset+'" id="delreset" onClick="resetForm()">')</script></td></tr>
</table>
</td></tr></table>

<!-- arp modal -->
<div class="show_arpinfo" id="show_arpinfo" style="display: none;">
	<div class="content">
	<table width="500"><tr><td>
		<table border=0 width="100%"> 
            <tr><td class="content_title"><script>dw(MM_APList)</script></td></tr>
            <!--<tr><td class="content_help"><script>dw(MSG_ScanAp)</script></td></tr>-->
            <tr><td height="1" class="line"></td></tr>
		</table>
		<div style="overflow: hidden;height: 40px;position: relative;z-index: 2;">
		<table border=0 width="100%" id="div_aplist_1">
            <tr align="center">
                <td class="item_center"><b><script>dw(MM_Ssid)</script></b></td>
                <td class="item_center"><b><script>dw(MM_Mac)</script></b></td>
            </tr>
            <tbody id="arpTable_1"></tbody>
		</table>
		</div>
		<div style="overflow: auto;height: 250px;position: relative;margin-top: -40px;z-index: 1;">
		<table border=0 width="100%" id="div_aplist">
            <tr align="center">
                <td class="item_center"><b><script>dw(MM_Ssid)</script></b></td>
                <td class="item_center"><b><script>dw(MM_Mac)</script></b></td>
            </tr>
			<tbody id="arpTable"></tbody>
		</table>
		</div>

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
