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
var rJson,rules_num=0,v_lanip,v_lanmsk;
var proto={TCP:"1",UDP:"2",ICMP:"4",ALL:"3"};
function disableAddFiled(){
	setDisabled("#sip,#protocol,#comment,#dFromPort,#dToPort,#add,#scan",true);
	$("#protocol").css('backgroundColor','#ebebe4');
}
function disableDelButton(){
	setDisabled("#delsel,#delreset",true);
}

function initValue(){
	v_lanip=rJson[0]['lanIp'];
	v_lanmsk=rJson[0]['lanNetmask'];
	rules_num=rJson.length-1;
	supplyValue("enable",rJson[0].enable);
	if (rJson[0].enable==0){
		disableAddFiled();
		disableDelButton();
	}
	if (rules_num==0) disableDelButton();
	var trNode;
	var ipportListTab=$("#div_ipportList").get(0);
	for(var i=1;i<rJson.length;i++){
		trNode=ipportListTab.insertRow(-1);
		trNode.align="center";
		trNode.className="item_center2";
		trNode.insertCell(0).innerHTML=rJson[i].idx;		
		trNode.insertCell(1).innerHTML=rJson[i].ip;
		trNode.insertCell(2).innerHTML=rJson[i].proto;
		trNode.insertCell(3).innerHTML=rJson[i].portRange;
		trNode.insertCell(4).innerHTML=rJson[i].comment;
		trNode.insertCell(5).innerHTML='<input type=\"checkbox\" id=\"'+rJson[i].delRuleName+'\" value=\"'+rJson[i].delRuleName+'\">';	
	}
	if (v_lanip !="") decomIP2($("input[name=ips]"),v_lanip,0);
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
}
$(function(){
	var postVar={topicurl:"setting/getIpPortFilterRules"};
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
	$("#ipAddress").val( netip+$("#sip").val());
	if (!checkVaildVal.IsVaildIpAddr($("#ipAddress").val(), MM_Ip)) return false;
	if (!checkVaildVal.IsIpSubnet($("#ipAddress").val(),v_lanmsk,v_lanip)){alert(JS_msg38);return false;}
	if ($("#ipAddress").val()==v_lanip){alert(JS_msg39); return false;}
	if ($("#protocol").get(0).selectedIndex==0 || $("#protocol").get(0).selectedIndex==1 || $("#protocol").get(0).selectedIndex==2){
		if (!checkVaildVal.IsVaildPort($("#dFromPort").val(),MM_StartPort)) return false;
		if ($("#dToPort").val() != ""){
			if (!checkVaildVal.IsVaildPort($("#dToPort").val(),MM_EndPort)) return false;
			if (!checkVaildVal.IsPortRange($("#dFromPort").val(), $("#dToPort").val())) return false;
		}
	}	
	var pf=Number($("#dFromPort").val());
	var pt=Number($("#dToPort").val());
	for (var i=1; i<rJson.length; i++){		
		var temp=rJson[i].portRange.split("-");
		if($("#ipAddress").val()==rJson[i].ip){
			if ($("#dToPort").val() != ""){
				if(pf==Number(temp[0])||pt==Number(temp[1])||pt==Number(temp[0])||pf==Number(temp[1])){alert(JS_msg104);return false;}
				if (pf < Number(temp[0]) && pt > Number(temp[0])){alert(JS_msg104);return false;}
				if (pf > Number(temp[0]) && pf < Number(temp[1])){alert(JS_msg104);return false;}
			}else{
				if (pf==Number(temp[0]) || pf==Number(temp[1])){alert(JS_msg104);return false;}				
				if (pf >Number(temp[0]) && pf < Number(temp[1])){alert(JS_msg104);return false;}
			}	 
		}	
   	}
	if ($("#comment").val()!=""){if (!checkVaildVal.IsVaildString($("#comment").val(), MM_Comment,2)) return false;}
	return true;
}

function doSubmit(){	
	if (saveChanges()==false) return false;
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setIpPortFilterRules"};
	postVar['ipAddress']=$("#ipAddress").val();
	postVar['dFromPort']=$("#dFromPort").val();
	postVar['dToPort']=$("#dToPort").val();
	postVar['protocol']=$("#protocol").val();
	postVar['comment']=$("#comment").val();
	postVar['addEffect']="0";
	uiPost(postVar);
}

function updateState(){
	if ($("#enable").get(0).selectedIndex==0){
		disableAddFiled();
		disableDelButton();
	}
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setIpPortFilterRules"};
	postVar['enable']=$("#enable").val();
	postVar['addEffect']="1";
	uiPost(postVar);
}

function deleteClick(){	
	var flg=0;
	var postVar={"topicurl":"setting/delIpPortFilterRules"};
    for (i=0; i< rules_num; i++){
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
		$(".select").css('backgroundColor','#ebebe4');
		uiPost(postVar);
	}
}
// show arp info
// onClick=arpTblClick(\"arpinfo.asp#flag=2\")
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
					_html += "<tr align=center class=item_list onclick=selectArpTbl('"+arpJson[i].ip+"')>\n";
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
function selectArpTbl(ip){
	$("#sip").val(ip.split(".")[3]);
	$('#show_arpinfo').hide();
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_PortFiltering)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_PortFiltering)</script></td></tr>
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
<tr><td colspan="2"><b><script>dw(MM_AddRule)</script></b></td></tr>
<tr>
<td class="item_left"><script>dw(MM_Ip)</script></td>
<td><input type="hidden" id="ipAddress"><input type="text" class="text3" id="ips" name="ips" maxlength="3" disabled><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" id="ips" name="ips" maxlength="3" disabled><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" id="ips" name="ips" maxlength="3" disabled><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" id="sip" name="sip" maxlength="3"> <script>dw('<input type=button class=button_small id=scan value="'+BT_Scan+'" >')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Protocol)</script></td>
<td><select class="select" id="protocol">
<option value="ALL">TCP+UDP</option>
<!--
<option value="TCP">TCP</option>
<option value="UDP">UDP</option>
-->
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_PortRange)</script></td>
<td><input type="text" class="text4" id="dFromPort" maxlength="5"> - <input type="text" class="text4" id="dToPort" maxlength="5"> (1-65535)</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Comment)</script></td>
<td><input type="text" class="text" id="comment" maxlength="20"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Add+'" id="add" onClick="doSubmit()">')</script></td></tr>
</table>

<table border=0 width="100%"> 
<tr><td colspan="6"><b><script>dw(MM_PortFilteringTbl)</script>&nbsp;<script>dw(JS_msg59)</script></b></td></tr>
<tr><td colspan="6" height="1" class="line"></td></tr>
<tr><td colspan="6" height="2"></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_Ip)</script></b></td>
<td class="item_center"><b><script>dw(MM_Protocol)</script></b></td>
<td class="item_center"><b><script>dw(MM_PortRange)</script></b></td>
<td class="item_center"><b><script>dw(MM_Comment)</script></b></td>
<td class="item_center"><b><script>dw(MM_Select)</script></b></td>
</tr>
<tbody id="div_ipportList"></tbody>
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