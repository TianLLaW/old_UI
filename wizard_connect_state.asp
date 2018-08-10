<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="style/style.css" rel="stylesheet" type="text/css">
<link href="style/normal_ws.css" rel="stylesheet" type="text/css">
<link rel="shortcut icon" href="style/favicon.ico">
<script src="/js/jquery.min.js"></script>
<script src="/js/json2.min.js"></script>
<script src="/js/load.js"></script>
<script src="/js/jcommon.js"></script>
<script>
function backClick(){self.location.href="wizard.asp";}
function finishClick(){self.location.href="home.asp";}
function tryAgainClick(){window.location.reload();};
var helpUrl="";
$(function(){
	var postVar={ "topicurl" : "setting/getLanguageCfg"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : "/cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			var rJson=JSON.parse(Data);
			document.title=rJson['webTitle'];
			$("#productModel").html(rJson['productName']+" ("+MM_Firmware+"  "+rJson['fmVersion']+")");
			var tmpCsid=rJson['CSID'];
			if(tmpCsid=="CS13KR"){
				CreateLangOption();
			}else{
				CreateLanguageOption(rJson['multiLangBt']);
			}
			if (rJson['multiLangBt'].split(",").length>1) $("#div_multi_language").show();
			if(tmpCsid=="CS13KR"||tmpCsid=="CS13JR"){
				$("#langType").val(localStorage.language);
				if (localStorage.language=="vn"&&loadMultiLangBt.indexOf("vn")>-1){
					helpUrl="www.totolink.vn";
				}else if (localStorage.language=="ru"&&loadMultiLangBt.indexOf("ru")>-1){
					helpUrl="www.totolink.ru";
				}else if (localStorage.language=="jp"&&loadMultiLangBt.indexOf("jp")>-1){
					helpUrl="www.totolink.jp";
				}else if (localStorage.language=="cn"&&loadMultiLangBt.indexOf("cn")>-1){
					helpUrl="www.totolink.cn";
				}else if (localStorage.language=="ct"&&loadMultiLangBt.indexOf("ct")>-1){
					helpUrl="www.totolink.tw";
				}else{
					helpUrl="www.totolink.net";
				}
			}else{
				if (rJson['langFlag']==1){ 
					$("#langType").val(localStorage.language);
				}else{
					$("#langType").val("auto");
				}
				if (localStorage.language=="vn"&&loadMultiLangBt.indexOf("vn")>-1){
					helpUrl=rJson['helpUrl_vn'];
				}else if (localStorage.language=="ru"&&loadMultiLangBt.indexOf("ru")>-1){
					helpUrl=rJson['helpUrl_ru'];
				}else if (localStorage.language=="jp"&&loadMultiLangBt.indexOf("jp")>-1){
					helpUrl=rJson['helpUrl_jp'];
				}else if (localStorage.language=="cn"&&loadMultiLangBt.indexOf("cn")>-1){
					helpUrl=rJson['helpUrl_cn'];
				}else if (localStorage.language=="ct"&&loadMultiLangBt.indexOf("ct")>-1){
					helpUrl=rJson['helpUrl_ct'];
				}else{
					helpUrl=rJson['helpUrl_en'];
				}
			}
			if (rJson['helpBt']==1 && helpUrl!="") $("#div_help").show();
			$("#helpUrl").attr("href",'http://'+helpUrl);
			$("#div_connect_succes,#div_connect_failed").hide();
			if (rJson['wanConnStatus']=="connected"){
				$("#div_connect_succes").show();
			}else{
				$("#div_connect_failed").show();
			}
		}
    }); 
	$("#langType").change(function(){
		var val=$(this).val();
		if (val=="auto"){
			autoLanguage(1);
		}else{
			if (val!=""){
				setLanguage(1,val);
			}
		}		
	});
});
</script>
</head>
<body style="overflow-x:hidden">
<div id="div_mainbody">
<table height="96" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="top_left">&nbsp;</td>
<td class="top_center">&nbsp;</td>
<td class="top_right" align="right">&nbsp;</td>
</tr>
</table>

<table height="44" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="6"></td>
<td class="first_table"><table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="title_down_left" id="productModel"></td>
<td class="title_down_center">&nbsp;</td>
<td class="title_down_right" align="right"><span id="div_multi_language" style="display:none"><select class="select5" id="langType"></select></span>&nbsp;&nbsp;<span id="div_help" style="display:none"><a href="" id="helpUrl" target="_blank"><div class="help_button"><div class="help_title"><script>dw(BT_Help)</script></div></div></a></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</table></td>
<td width="6"></td>
</tr>
</table>

<table id="div_main" height="751" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="6"></td>
<td valign="top" class="first_table">
<div id="div_connect_succes" style="display:none" align="center">
<table border=0 align="center">
<tr><td>&nbsp;</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><img src="style/easysetup_connect.gif"></td></tr>
<tr><td height="10"></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><span class="wz_title_2"><script>dw(MSG_EasyWizardInfo1)</script></span></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="center"><span class="wz_title_1"><script>dw(MSG_EasyWizardInfo2)</script></span></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><script>dw('<input type=button class=button value="'+BT_Back+'" onClick="backClick()">&nbsp;&nbsp;<input type=button class=button value="'+BT_Finish+'" onClick="finishClick()">')</script></td></tr>
</table>
</div>

<div id="div_connect_failed" style="display:none" align="center">
<table border=0 align="center">
<tr><td>&nbsp;</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><img src="style/easysetup_failed.gif"></td></tr>
<tr><td height="10"></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><span class="wz_title_3"><script>dw(MSG_EasyWizardInfo3)</script></span></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="center"><span class="wz_title_1"><script>dw(MSG_EasyWizardInfo4)</script></span></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><script>dw('<input type=button class=button value="'+BT_Back+'" onClick="backClick()">&nbsp;&nbsp;<input type=button class=button value="'+BT_TryAgain+'" onClick="tryAgainClick()">')</script></td></tr>
</table>
</div>
</td>
<td width="6"></td>
</tr>
</table>

<table height="41" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="bottom_left">&nbsp;</td>
<td class="bottom_center1">&nbsp;</td>
<td class="bottom_center">&nbsp;</td>
<td class="bottom_center1">&nbsp;</td>
<td class="bottom_right">&nbsp;</td>
</tr>
</table>
</div>

<div id="div_wait_lang" style="display:none">
<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
<center>
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><span id="show_lang_title"></span></td></tr>
<tr><td height="1" class="line"></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title></td></tr>
<tr><td><span id="show_lang_msg"></span></td></tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table></td></tr></table>
</center>
</div>
<script>
	$(function(){
		$('#div_main').height($(window).height()-181);
	});
	$(window).resize(function(event) {
		$('#div_main').height($(window).height()-181);
	});
</script>
</body>
</html>
