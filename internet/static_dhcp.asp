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
var rJson,rules_num=0,v_lanip,v_lanmsk,v_enabled;
function disableAddFiled(){	
	$("#mac1,#mac2,#mac3,#mac4,#mac5,#mac6,#ip,#add,#scan").attr("disabled",true);
}
function disableDelButton(){	
	$("#delsel,#delreset").attr("disabled",true);
}

function initValue(){
	v_lanip=rJson[0]['lanIp'];
	v_lanmsk=rJson[0]['lanNetmask'];
	v_enabled=rJson[0]['enable'];		
	rules_num=rJson.length-1;
	supplyValue("enable",v_enabled);
	if (v_enabled==0){
		disableAddFiled();
		disableDelButton();
	}
	if (rules_num==0) disableDelButton();
	if (v_lanip !="") decomIP2($(":input[name=ips]"),v_lanip,0);
	var dhcpListTab=$("#div_staticDhcpList").get(0);
	var trNode;
	for(var i=1;i<rJson.length;i++){
		trNode=dhcpListTab.insertRow(-1);
		trNode.align="center";
		trNode.className="item_center2";
		trNode.insertCell(0).innerHTML=rJson[i].idx;
		trNode.insertCell(1).innerHTML=rJson[i].ip;
		trNode.insertCell(2).innerHTML=rJson[i].mac;
		trNode.insertCell(3).innerHTML='<input type=\"checkbox\" id=\"'+rJson[i].delRuleName+'\" value=\"'+rJson[i].delRuleName+'\">';	
	}
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
}

$(function(){
	var postVar={topicurl:"setting/getStaticDhcpConfig"};
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
	var netip=v_lanip.replace(/\.\d{1,3}$/,".");
	$("#ipAddress").val(netip+$("#ip").val());	
	if (!checkVaildVal.IsVaildIpAddr($("#ipAddress").val(),MM_Ip)) return false;
	if (!checkVaildVal.IsSameIp($("#ipAddress").val(),v_lanmsk,v_lanip)){alert(JS_msg38);return false;}
	if ($("#ipAddress").val()==v_lanip){alert(JS_msg39);return false;}
	$("#macAddress").val(combinMAC2($("#mac1").val(),$("#mac2").val(),$("#mac3").val(),$("#mac4").val(),$("#mac5").val(),$("#mac6").val()));
	if (!checkVaildVal.IsVaildMacAddr($("#macAddress").val()))	return false;
	for (var i=1; i<rJson.length; i++){
		if (($("#macAddress").val().toUpperCase()==rJson[i].mac)||($("#ipAddress").val()==rJson[i].ip)){
			alert(JS_msg29);
			return false;
		}
	}
	return true;
}

function doSubmit(){
	if (saveChanges()==false) return false;
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setStaticDhcpConfig"};
	postVar['ipAddress']=$("#ipAddress").val();
	postVar['macAddress']=$("#macAddress").val();
	postVar['addEffect']="0";
	uiPost(postVar);
}

function updateState(){
	if ($("#enable").val()=="0"){
		disableAddFiled();
		disableDelButton();
	}
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setStaticDhcpConfig"};
	postVar['enable']=$("#enable").val();
	postVar['addEffect']="1";
	uiPost(postVar);
}

function deleteClick(){
	$(".select").css('backgroundColor','#ebebe4');
	var flg=0;
	var postVar ={"topicurl":"setting/delStaticDhcpConfig"};
	for (i=0; i<rules_num; i++){		
		var tmp=$("#delRule"+i).get(0);
		if (tmp.checked==true){
			postVar['delRule'+i]=i;
			flg=1;
		}
  	}
	if(flg==0){
		alert(JS_msg36);
		return false;
	}
	if( !confirm(JS_msg130) )	return false;
	if(flg==1){
		uiPost(postVar);
	}
}

// show mac info
$(function(){
	$('#scan').on('click', function(event) {
		event.preventDefault();
		$('#show_arpinfo').show();
		var postVar = { topicurl : "setting/getArpTable"};
	    postVar = JSON.stringify(postVar);
		$.ajax({  
	       	type : "post",  
	        url : " /cgi-bin/cstecgi.cgi",
	        data : postVar,
	        beforeSend:function(){
	        	$("#arpTable").html('<tr><td colspan=3><p style="text-align:center"><img src="../style/load.gif" alt="" /></p></td></tr>');
	        },
	        success : function(Data){
				arpJson = JSON.parse(Data);
				var _html = '';
				for(var i=1;i<arpJson.length;i++){	
					if(!arpJson[i].ip) continue;
					if(arpJson[i].mac=="00:00:00:00:00:00") continue;
					_html += "<tr align=center class=item_list onclick=selectArpTbl('"+arpJson[i].ip+"','"+arpJson[i].mac.toUpperCase()+"')>\n";
					_html += "<td>"+arpJson[i].ip+"</td>";
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
function selectArpTbl(ip, mac){
	$("#ip").val(ip.split(".")[3]);
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
<tr><td class="content_title"><script>dw(MM_StaticDhcp)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_StaticDhcp)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_OnOff)</script></td>
<td><select class="select" id="enable" onChange="updateState()">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr><td colspan="2"><b><script>dw(MM_AddRule)</script></b></td>
<tr>
<td class="item_left"><script>dw(MM_Ip)</script></td>
<td><input type="hidden" id="ipAddress"><input type="text" class="text3" name="ips" maxlength="3" disabled><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" name="ips" maxlength="3" disabled><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" name="ips" maxlength="3" disabled><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" id="ip" name="ip" maxlength="3"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Mac)</script></td>
<td><input type="hidden" id="macAddress"><input type="text" class="text3" maxlength="2" name="mac1" id="mac1" onFocus="this.select();" onKeyUp="HWKeyUp('mac',1,event);" onKeyDown="return HWKeyDown('mac', 1,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac2" id="mac2" onFocus="this.select();" onKeyUp="HWKeyUp('mac',2,event);" onKeyDown="return HWKeyDown('mac', 2,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac3" id="mac3" onFocus="this.select();" onKeyUp="HWKeyUp('mac',3,event);" onKeyDown="return HWKeyDown('mac', 3,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac4" id="mac4" onFocus="this.select();" onKeyUp="HWKeyUp('mac',4,event);" onKeyDown="return HWKeyDown('mac', 4,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac5" id="mac5" onFocus="this.select();" onKeyUp="HWKeyUp('mac',5,event);" onKeyDown="return HWKeyDown('mac', 5,event)"><img src="../style/colon.png" border="0" align="absbottom" /><input type="text" class="text3" maxlength="2" name="mac6" id="mac6" onFocus="this.select();" onKeyUp="HWKeyUp('mac',6,event);" onKeyDown="return HWKeyDown('mac', 6,event)"> <script>dw('<input type=button class=button_small id=scan value="'+BT_Scan+'" >')</script></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Add+'" id="add" onClick="doSubmit()">')</script></td></tr>
</table>

<table border=0 width="100%">
<tr><td colspan="4"><b><script>dw(MM_StaticDhcpTbl)</script> <script>dw(JS_msg59)</script></b></td></tr>
<tr><td colspan="4" height="1" class="line"></td></tr>
<tr><td colspan="4" height="2"></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_Ip)</script></b></td>
<td class="item_center"><b><script>dw(MM_Mac)</script></b></td>
<td class="item_center"><b><script>dw(MM_Select)</script></b></td>
</tr>
<tbody id="div_staticDhcpList"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Delete+'" id="delsel" onClick="deleteClick()">&nbsp;&nbsp;&nbsp;&nbsp;<input type=button class=button value="'+BT_Reset+'" id="delreset" onClick="resetForm()">')</script></td></tr>
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

		<table border=0 width="100%">
			<tr align="center">
                <td class="item_center"><b><script>dw(MM_Ip)</script></b></td>
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
