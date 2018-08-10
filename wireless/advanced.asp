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
var wifiIdx="0";
$(function(){
	var postVar={topicurl:"setting/getWiFiAdvancedConfig"};
	postVar['wifiIdx']=wifiIdx;
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);	
			setJSONValue({
				'bgProtection'			:	rJson['bgProtection'],
				'beaconPeriod'			:	rJson['beaconPeriod'],
				'dtimPeriod'			:	rJson['dtimPeriod'],
				'fragThreshold'			:	rJson['fragThreshold'],
				'rtsThreshold'			:	rJson['rtsThreshold'],
				'txPower'				:	rJson['txPower'],
				'noForwarding'			:	rJson['noForwarding'],
				'htBSSCoexistence'		:	rJson['htBSSCoexistence'],	
				'wmmCapable'			:	rJson['wmmCapable'],
				'txPreamble'			:	rJson['txPreamble']
			});
			if (rJson['band']==9||rJson['band']==6){
				$('#div_2040_coexit').show();
			}		
		}
    });
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function saveChanges(){
	if (!checkVaildVal.IsVaildNumberRange($('#beaconPeriod').val(),MM_Beacon,20,999)) return false;
	if (!checkVaildVal.IsVaildNumberRange($('#dtimPeriod').val(),MM_DataBeaconRate,1,255)) return false;
	if (!checkVaildVal.IsVaildNumberRange($('#fragThreshold').val(),MM_Fragment,256,2346)) return false;	
	if (!checkVaildVal.IsVaildNumberRange($('#rtsThreshold').val(),MM_Rts,1,2347)) return false;	
	return true;
}

function doSubmit(){
	if (saveChanges()==false) return false;	
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setWiFiAdvancedConfig"};
	postVar['bgProtection']=$('#bgProtection').val();
	postVar['beaconPeriod']=$('#beaconPeriod').val();
	postVar['dtimPeriod']=$('#dtimPeriod').val();
	postVar['fragThreshold']=$('#fragThreshold').val();
	postVar['rtsThreshold']=$('#rtsThreshold').val();
	postVar['txPower']=$('#txPower').val();
	postVar['noForwarding']=$('#noForwarding').val();
	postVar['htBSSCoexistence']=$('#htBSSCoexistence').val();
	postVar['wmmCapable']=$('#wmmCapable').val();
	postVar['txPreamble']=$('#txPreamble').val();
	postVar['wifiIdx']=wifiIdx;
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_Advanced)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_Advanced)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%"> 
<tr> 
<td class="item_left"><script>dw(MM_BgpMode)</script></td>
<td><select class="select" id="bgProtection">
<option value=0><script>dw(MM_Auto)</script></option>
<option value=1><script>dw(MM_Off)</script></option>
</select></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_Beacon)</script></td>
<td><input type="text" class="text" id="beaconPeriod" maxlength=3> ms 
<font color="#808080">(<script>dw(MM_Range)</script> 20 - 999, <script>dw(MM_Default)</script> 100)</font></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_DataBeaconRate)</script> (DTIM)</td>
<td><input type="text" class="text" id="dtimPeriod" maxlength=3> ms 
<font color="#808080">(<script>dw(MM_Range)</script> 1 - 255, <script>dw(MM_Default)</script> 1)</font></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_TxPreamble)</script></td>
<td><select class="select" id="txPreamble">
<option value=0><script>dw(MM_LongTxPreamble)</script></option>
<option value=1><script>dw(MM_ShortTxPreamble)</script></option>
</select></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_Fragment)</script></td>
<td><input type="text" class="text" id="fragThreshold" maxlength=4> 
<font color="#808080">(<script>dw(MM_Range)</script> 256 - 2346, <script>dw(MM_Default)</script> 2346)</font></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_Rts)</script></td>
<td><input type="text" class="text" id="rtsThreshold" maxlength=4> 
<font color="#808080">(<script>dw(MM_Range)</script> 1 - 2347, <script>dw(MM_Default)</script> 2347)</font></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_TxPower)</script></td>
<td><select class="select" id="txPower">
<option value=0>100%</option>
<option value=1>75%</option>
<option value=2>50%</option>
<option value=3>35%</option>
<option value=4>15%</option>
</select></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_ApIsolated)</script></td>
<td><select class="select" id="noForwarding">
<option value=0><script>dw(MM_Disable)</script></option>
<option value=1><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr id="div_2040_coexit" style="display:none"> 
<td class="item_left"><script>dw(MM_2040Coexistence)</script></td>
<td><select class="select" id="htBSSCoexistence">
<option value=0><script>dw(MM_Disable)</script></option>
<option value=1><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_Wmm)</script></td>
<td><select class="select" id="wmmCapable">
<option value=0><script>dw(MM_Disable)</script></option>
<option value=1><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</td></tr></table>
</body></html>