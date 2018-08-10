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
function updateState(){
  	if ($("#NoticeEnabled").val()=="0"){
		$("#div_notice_setting").hide();
  	}else{
		$("#div_notice_setting").show();
  	}
}

var rJson;
$(function(){
	var postVar={topicurl:"setting/getNoticeCfg"};
	postVar=JSON.stringify(postVar);
	$.ajax({
		type : "post", url : "/cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			var rJson=JSON.parse(Data);
			setJSONValue({
				"NoticeEnabled"      :   rJson['NoticeEnabled'],
				"NoticeUrl"          :   rJson['NoticeUrl'],
				"BtnName"            :   rJson['BtnName'],
				"WhiteListUrl1"      :   rJson['WhiteListUrl1'],
				"WhiteListUrl2"      :   rJson['WhiteListUrl2'],
				"WhiteListUrl3"      :   rJson['WhiteListUrl3'],
				"IpFrom"             :   rJson['IpFrom'],
				"IpTo"               :   rJson['IpTo'],
				"LanSubnet"          :   rJson['lanSubnet'],
				"NoticeTimeoutVal"   :   rJson['NoticeTimeoutVal']==0?"120":rJson['NoticeTimeoutVal'],
				"lanIp"         	 :   rJson['lanIp']+'.'
			});
			updateState();
		}
	});		
});

function saveChanges(){
	var re=/^[0-9]*$/;
	var re1=/[\@\#\$\%\^\&\*\{\}\:\"\<\>\?\(\)\[\]\+\=]/;
	var regin=/^([hH][tT]{2}[pP]:\/\/|[hH][tT]{2}[pP][sS]:\/\/)?(www|WWW)(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+$/;	
	if ($("#NoticeEnabled").val()=="1"){
		if (!checkVaildVal.IsEmpty($("#NoticeUrl").val(),MM_NoticeURL)) return false;
		if (!regin.test($("#NoticeUrl").val())){alert(JS_msg149);return false;}
		if (!checkVaildVal.IsEmpty($("#BtnName").val(),MM_NoticeBtnVal)) return false;
		if (re1.test($("#BtnName").val())){alert(JS_msg138);return false;}
		if ($("#WhiteListUrl1").val()!=""){if (!regin.test($("#WhiteListUrl1").val())){alert(JS_msg149);return false;}}
		if ($("#WhiteListUrl2").val()!=""){if (!regin.test($("#WhiteListUrl2").val())){alert(JS_msg149);return false;}}
		if ($("#WhiteListUrl3").val()!=""){if (!regin.test($("#WhiteListUrl3").val())){alert(JS_msg149);return false;}}		
		if ($("#IpFrom").val()!=""){
			if (!re.test($("#IpFrom").val())){alert(JS_msg146);return false;}
			if (parseInt($("#IpFrom").val())<1||parseInt($("#IpFrom").val())>254){alert(JS_msg148);return false;}
		}
		if ($("#IpTo").val()!=""){
			if (!re.test($("#IpTo").val())){alert(JS_msg147);return false;}
			if (parseInt($("#IpTo").val())<1||parseInt($("#IpTo").val())>254){alert(JS_msg148);return false;}
		}		
		if ($("#IpFrom").val()!=""&&$("#IpTo").val()!==""){
			if (parseInt($("#IpFrom").val())>parseInt($("#IpTo").val())){alert(JS_msg134);return flase;}
			if (parseInt($("#IpFrom").val())<=parseInt($("#LanSubnet").val())&&parseInt($("#LanSubnet").val())<=parseInt($("#IpTo").val())){alert(JS_msg139);return false;}	
		} 
		if (!checkVaildVal.IsVaildNumberRange($("#NoticeTimeoutVal").val(),MM_NoticeTimeout,1,1440)) return false;
	}
}

function doSubmit(){
	if (saveChanges()==false) return false;
	var postVar={"topicurl":"setting/setNoticeCfg"};
	postVar['NoticeEnabled']=$("#NoticeEnabled").val();
	postVar['NoticeUrl']=$("#NoticeUrl").val();
	postVar['BtnName']=$("#BtnName").val();
	postVar['WhiteListUrl1']=$("#WhiteListUrl1").val();
	postVar['WhiteListUrl2']=$("#WhiteListUrl2").val();
	postVar['WhiteListUrl3']=$("#WhiteListUrl3").val();
	postVar['IpFrom']=$("#IpFrom").val();
	postVar['IpTo']=$("#IpTo").val();
	postVar['NoticeTimeoutVal']=$("#NoticeTimeoutVal").val();
	uiPost(postVar);
}
</script>
</head>

<body class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_Notice)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_Notice)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_NoticeCtl)</script></td>
<td><select class="select" id="NoticeEnabled" onChange="updateState()">
<option value="0"><script>dw(MM_Disable)</script></option>
<option value="1"><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tbody id="div_notice_setting" style="display:none">
<tr>
<td class="item_left"><script>dw(MM_NoticeURL)</script></td>
<td><input class="text" type="text" id="NoticeUrl" maxlength="127"> <script>dw(JS_msg126)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_NoticeBtnVal)</script></td>
<td><input type="text" class="text" id="BtnName" maxlength="255"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_NoticeWhitelistURL)</script> 1</td>
<td><input type="text" class="text" id="WhiteListUrl1" maxlength="127"> <script>dw(JS_msg145)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_NoticeWhitelistURL)</script> 2</td>
<td><input type="text" class="text" id="WhiteListUrl2" maxlength="127"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_NoticeWhitelistURL)</script> 3</td>
<td><input type="text" class="text" id="WhiteListUrl3" maxlength="127"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ExceptionIP)</script></td>
<td><span id="lanIp"></span><input type="text" class="text8" id="IpFrom" maxlength="3"> - <input type="text" class="text8" id="IpTo" maxlength="3"></td>
</tr>
<tr style="display:none">
<td class="item_left">The host number</td>
<td><input type="text" class="text" id="LanSubnet" maxlength="3"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_NoticeTimeout)</script></td>
<td><input type="text" class="text7" id="NoticeTimeoutVal" maxlength="4"><script>dw(JS_msg150)</script></td>
</tr>
</tbody>
</table>

<table border=0 width="100%">
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</td></tr></table>
</body>
</html>