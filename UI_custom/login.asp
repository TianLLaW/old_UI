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
if(window.top != window.self){
	top.location.href = location.href;
}
var helpUrl="";
$(function(){
	var postVar={ "topicurl" : "setting/getLanguageCfg"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : "/cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			var rJson=JSON.parse(Data);
			document.title=rJson['webTitle'];
			if (rJson['copyRight']!=""){
				var curDate = new Date();
				$("#copyRight").html("Copyright &copy; "+curDate.getFullYear()+" "+rJson['copyRight']);
			}
			$("#productModel").html(rJson['productName']+" ("+MM_Firmware+"  "+rJson['fmVersion']+")");
			CreateLanguageOption(rJson['multiLangBt']);
			if (rJson['multiLangBt'].split(",").length>1) $("#div_multi_language").show();
			if (rJson['langFlag']==1){ 
				$("#langType").val(localStorage.language);
			}else{
				$("#langType").val("auto");
			}
			if ((localStorage.language=="vn"&&loadMultiLangBt.indexOf("vn")>-1)||(localStorage.language=="ru"&&loadMultiLangBt.indexOf("ru")>-1)){
				$("#username,#password").toggleClass("login_input2");
			}else{
				$("#username,#password").toggleClass("login_input");
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
			if (rJson['helpBt']==1 && helpUrl!="") $("#div_help").show();
			$("#helpUrl").attr("href",'http://'+helpUrl);
			if (rJson['wanConnStatus']=="connected"){
				$("#div_loginIp").html(window.location.hostname);
			}else{
				$("#div_loginIp").html(rJson['lanIp']);
			}
			if (loadLoginFlag==1){
			 	$("#div_loginErr").html(JS_msg52);
			}else{
			 	$("#div_loginErr").html("");
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
	$("#username,#password").click(function(){
		$("#div_loginErr").html("");
	});
	$("#login").click(function(){
		if($("#username").val()==""||$("#password").val()==""){$("#div_loginErr").html(JS_msg51);return false;}
		$("#loginfrm").submit();
		return true;
	});
});
function doForgot(){
	alert(MB_Quickly);
}
</script>
</head>
<body style="overflow-x:hidden">
<div id="div_mainbody">
<form method="post" id="loginfrm" action="/cgi-bin/cstecgi.cgi?action=login">
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
<td class="title_down_left"><span id="productModel"></span></td>
<td class="title_down_center">&nbsp;</td>
<td class="title_down_right" align="right"><span id="div_multi_language" style="display:none"><select class="select5" id="langType"></select></span>&nbsp;&nbsp;<span id="div_help" style="display:none"><a href="" id="helpUrl" target="_blank"><div class="help_button"><div class="help_title"><script>dw(BT_Help)</script></div></div></a></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</table>

<table id="div_main" height="751" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td valign="top" class="first_table"><div align="center">
<table border=0 width="370" align="center">
<tr><td height="80"></td></tr>
<tr><td class="login_title"><script>dw(MM_UserLogin)</script></td></tr>
<tr><td class="login_help"><script>dw(MSG_LoginLeft)</script>&nbsp;<span id="div_loginIp"></span>&nbsp;<script>dw(MSG_LoginRight)</script></td></tr>
<tr><td height="10"></td></tr>
</table>

<table width="370" height="227" border="0" cellpadding="0" cellspacing="0">
<tr>
<td colspan="3" background="style/login.gif" width="370" height="227"><table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td colspan="2" height="30"></td></tr>
<tr>
<td class="login_label"><script>dw(MM_UserName)</script></td>
<td><input style="margin-left:-50px" class="text5 login_input" type="text" name="username" id="username"></td>
</tr>
<tr><td colspan="2" height="20"></td></tr>
<tr>
<td class="login_label"><script>dw(MM_Password)</script></td>
<td><input style="margin-left:-50px" class="text5 login_input" type="password" name="password" id="password" onKeyDown="if(event.keyCode==13) $('#login').click();"></td>
</tr>
<tr><td colspan="2" height="2"></td></tr>
<tr><td colspan="2" height="52" align="center"><span id="div_loginErr" style="color:red"></span></td></tr>
<tr><td colspan="2" height="15"></td></tr>
<tr><td colspan="2" align="center"><button type="button" class="login_button" id="login"><script>dw(BT_Login)</script></button></td></tr>
</table></td>
</tr>
<tr><td colspan="3" align="center"><a href="javascript:doForgot()"><script>dw(MB_Forgot)</script></a></td></tr>
</table>
</div></td>
</tr>
</table></td>
<td width="6"></td>
</tr>
</table>

<table height="41" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="bottom_left">&nbsp;</td>
<td class="bottom_center"><span id="copyRight"></span></td>
<td class="bottom_right">&nbsp;</td>
</tr>
</table>
</form>
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