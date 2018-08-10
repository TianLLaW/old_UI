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
var rJson,rules_num=0,v_lanip,v_lanmsk,netip;
var ipStart,ipEnd;
function disableAddFiled(){
	setDisabled("#ipstart,#ipend,#upBandwidth,#dwBandwidth,#comment,#add,#scan",true);
}
function disableDelButton(){
	setDisabled("#delsel,#delreset",true);
}

function IpRangeCheck(s1,s2){
	var ip1=s1.split(".");
	var ip2=s2.split(".");
	for(var k=0;k<4;k++){
		var a=Number(ip1[3]);
		var b=Number(ip2[3]);
      	if(a>b){alert(JS_msg100); return 0;}
	}
	return 1;
}

function initValue(){
	rules_num=rJson.length-1;
	var tmp=rJson[0];
	v_lanip=tmp['lanIp'];
	v_lanmsk=tmp['lanNetmask'];
	netip=v_lanip.replace(/\.\d{1,3}$/,".");
	setJSONValue({
		"enable"				:tmp['enable'],
		"manualUplinkSpeed"  	:tmp['manualUpSpeed'],
		"manualDownlinkSpeed"	:tmp['manualDwSpeed']
	});
	if (tmp['enable']==0){
		setDisabled("#manualUplinkSpeed,#manualDownlinkSpeed",true);
		disableAddFiled();
		disableDelButton();
	}
	if (rules_num==0) disableDelButton();
	if (v_lanip !="") decomIP2($(":input[name=ips]"),v_lanip,0);
	var trNode,tdNode;
	var qosListTab=$("#div_qosList").get(0);
	for(var i=1;i<rJson.length;i++){
		tmp=rJson[i];
		trNode=qosListTab.insertRow(-1);
		trNode.align="center";
		trNode.className="item_center2";
		trNode.insertCell(0).innerHTML=tmp.idx;		
		trNode.insertCell(1).innerHTML=tmp.ip;
		tdNode=trNode.insertCell(2);
		tdNode.innerHTML=tmp.upBandwidth;
		tdNode.id="td_upbandwidth"+Number(i-1);
		tdNode=trNode.insertCell(3);
		tdNode.innerHTML=tmp.dwBandwidth;
		tdNode=tdNode.id="td_downbandwidth"+Number(i-1);
		trNode.insertCell(4).innerHTML=tmp.comment;
		trNode.insertCell(5).innerHTML='<input type=checkbox id=\"'+tmp.delRuleName+'\" value=\"'+tmp.delRuleName+'\">';	
	}
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
}

$(function(){
	var postVar={topicurl:"setting/getIpQosRules"};
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

function updateState(){
	if ($("#enable").val()==0){
		setDisabled("#manualUplinkSpeed,#manualDownlinkSpeed",true);
	}else {
		setDisabled("#manualUplinkSpeed,#manualDownlinkSpeed",false);
	}
}	

function saveChanges(){
	if ($("#enable").val()==1){	
		if (!checkVaildVal.IsVaildNumber($("#manualUplinkSpeed").val(),MM_TotalUplinkSpeed)) return false;
		if (!checkVaildVal.IsVaildNumberRange($("#manualUplinkSpeed").val(),MM_TotalUplinkSpeed,100,100000)) return false;
		if (!checkVaildVal.IsVaildNumber($("#manualDownlinkSpeed").val(),MM_TotalDownlinkSpeed)) return false;
		if (!checkVaildVal.IsVaildNumberRange($("#manualDownlinkSpeed").val(),MM_TotalDownlinkSpeed,100,100000))return false;
		var totaUpbandwidth=$("#manualUplinkSpeed").val();
		var totaDownbandwidth=$("#manualDownlinkSpeed").val();
		if(rules_num>0){
			var tmp_up_bd=0;
			var tmp_down_bd=0;
			for(var i=0; i<rules_num; i++){				
				tmp_up_bd+=Number($("#td_upbandwidth"+i).html());
				tmp_down_bd+=Number($("#td_downbandwidth"+i).html());
				if(tmp_up_bd>Number(totaUpbandwidth)){alert(JS_msg107);$("#manualUplinkSpeed").focus();return false;}
				if(tmp_down_bd>Number(totaDownbandwidth)){alert(JS_msg108);$("#manualDownlinkSpeed").focus();return false;}
			}
		}
	}
	return true;
}

function doSubmit(){	
	if (saveChanges()==false) return false;
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setIpQos"};
	postVar['enable']=$("#enable").val();
	postVar['manualUplinkSpeed']=$("#manualUplinkSpeed").val();
	postVar['manualDownlinkSpeed']=$("#manualDownlinkSpeed").val();
	uiPost(postVar);
}

function addClick(){
	if ( rules_num >= 10 ){
		alert(JS_msg28);
		return false;
	}
	ipStart=netip+$("#ipstart").val();
	ipEnd=netip+$("#ipend").val();
	setJSONValue({
		"ipStart" : ipStart,
		"ipEnd"   : ipEnd
	});
	if (!checkVaildVal.IsVaildIpAddr(ipStart,MM_StartIp)) return false;	
	if (!checkVaildVal.IsIpSubnet(ipStart,v_lanmsk,v_lanip)){alert(JS_msg38);return false;}		
	if (ipStart==v_lanip){alert(JS_msg39);return false;}
	if (ipEnd==v_lanip){alert(JS_msg39);return false;}		
	if(ipEnd==netip){
		supplyValue("ipEnd", ipStart);
	}else{	
		if (!checkVaildVal.IsVaildIpAddr(ipEnd,MM_EndIp)) return false;
		if (!checkVaildVal.IsIpSubnet(ipEnd,v_lanmsk,v_lanip)){alert(JS_msg38);return false;}
		if (!IpRangeCheck(ipStart,ipEnd)) return false;
		if (ipStart==v_lanip||ipEnd==v_lanip){alert(JS_msg39);return false;}
	}
	if (!checkVaildVal.IsVaildNumber($("#upBandwidth").val(),MM_UploadSpeed)) return false;
	if (!checkVaildVal.IsVaildNumberRange($("#upBandwidth").val(),MM_UploadSpeed, 100,100000)) return false;
	if (!checkVaildVal.IsVaildNumber($("#dwBandwidth").val(),MM_DownloadSpeed)) return false;
	if (!checkVaildVal.IsVaildNumberRange($("#dwBandwidth").val(),MM_DownloadSpeed, 100,100000)) return false;
	for(var i=1;i<rJson.length;i++){
		v=rJson[i]['ip'].split("-");
		for (var j=0; j<v.length; j++){	
			var ips=Number(ipStart.split(".")[3]);
			var ipe=Number(ipEnd.split(".")[3]);
			var v0=Number(v[0].split(".")[3]);
			var v1=Number(v[1].split(".")[3]);					
			if (ips==v0 || ips==v1 || ipe==v0 || ipe==v1){alert(JS_msg105);return false;}								
			if (ips < v0 && ipe > v0){alert(JS_msg105);return false;}	
			if (ips > v0 && ips < v1){alert(JS_msg105);return false}		
		}
	}
	var totaUpbandwidth=rJson[0]['manualUpSpeed'];
	var totaDownbandwidth=rJson[0]['manualDwSpeed'];
	var tmp_up_bd=Number($("#upBandwidth").val());
	var tmp_down_bd=Number($("#dwBandwidth").val());
	if(rules_num==0){
		if($("#upBandwidth").val() > Number(totaUpbandwidth)){alert(JS_msg101);$("#upBandwidth").focus();return false;}
		if($("#dwBandwidth").val() > Number(totaDownbandwidth)){alert(JS_msg102);$("#dwBandwidth").focus();return false;}
	}else if(rules_num>0){
		for(var i=0; i<=rules_num; i++){
			var rule_up=$("#td_upbandwidth"+i).html();
			var rule_down=$("#td_downbandwidth"+i).html();
			tmp_up_bd+=Number(rule_up);
			tmp_down_bd+=Number(rule_down);
			if(tmp_up_bd>Number(totaUpbandwidth)){alert(JS_msg101);$("#upBandwidth").focus();return false;}
			if(tmp_down_bd>Number(totaDownbandwidth)){alert(JS_msg102);$("#dwBandwidth").focus();return false;}
		}
	}
	if ($("#comment").val()!=""){if (!checkVaildVal.IsVaildString($("#comment").val(), MM_Comment,2)) return false;}	
	setDisabled("#add,#scan",true);
}

function doSubmitAdd(){	
	if (addClick()==false) return false;
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setIpQosRules"};
	postVar['ipStart']=ipStart;
	postVar['ipEnd']=$("#ipEnd").val();
	postVar['upBandwidth']=$("#upBandwidth").val();
	postVar['dwBandwidth']=$("#dwBandwidth").val();
	postVar['comment']=$("#comment").val();
	uiPost(postVar);
}

function deleteClick(){	
	var flg=0;
    var postVar={"topicurl":"setting/delIpQosRules"};
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
	$("#ipstart,#ipend").val(ip.split(".")[3]);
	$('#show_arpinfo').hide();
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<input type="hidden" id="ipStart">
<input type="hidden" id="ipEnd">
<table border=0 width="100%"> 
<tr><td class="content_title">QoS</td></tr>
<tr><td class="content_help"><script>dw(MSG_Qos)</script></td></tr>
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
<tr>
<td class="item_left"><script>dw(MM_TotalUplinkSpeed)</script></td>
<td><input type="text" class="text" id="manualUplinkSpeed" maxlength="6"> (100-100000Kbps)</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_TotalDownlinkSpeed)</script></td>
<td><input type="text" class="text" id="manualDownlinkSpeed" maxlength="6"> (100-100000Kbps)</td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="doSubmit();">')</script></td></tr>
</table>

<table border=0 width="100%">
<tr><td colspan="2"><b><script>dw(MM_AddRule)</script></b></td>
<tr>
<td class="item_left"><script>dw(MM_Ip)</script></td>
<td><input type="text" class="text3" name="ips" maxlength="3" disabled><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" name="ips" maxlength="3" disabled><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" name="ips" maxlength="3" disabled><img src="../style/period.png" border="0" align="absbottom" /><input type="text" class="text3" id="ipstart" name="ipstart" maxlength="3"> - <input type="text" class="text3" id="ipend" name="ipend" maxlength="3"> <script>dw('<input type=button class=button_small id=scan value="'+BT_Scan+'" >')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_UploadSpeed)</script></td>
<td><input type="text" class="text" id="upBandwidth" maxlength="6"> (100-100000Kbps)</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_DownloadSpeed)</script></td>
<td><input type="text" class="text" id="dwBandwidth" maxlength="6"> (100-100000Kbps)</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Comment)</script></td>
<td><input type="text" class="text" id="comment" maxlength="20"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Add+'" id=add onClick="doSubmitAdd()">')</script></td></tr>
</table>

<table border=0 width="100%">
<tr><td colspan="6"><b><script>dw(MM_QosTbl)</script>&nbsp;&nbsp;<script>dw(JS_msg59)</script></b></td></tr>
<tr><td colspan="6" height="1" class="line"></td></tr>
<tr><td colspan="6" height="2"></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_Ip)</script></b></td>
<td class="item_center"><b><script>dw(MM_UploadSpeed)</script></b></td>
<td class="item_center"><b><script>dw(MM_DownloadSpeed)</script></b></td>
<td class="item_center"><b><script>dw(MM_Comment)</script></b></td>
<td class="item_center"><b><script>dw(MM_Select)</script></b></td>
</tr>
<tbody id="div_qosList"></tbody>
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