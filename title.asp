<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="style/style.css" rel="stylesheet" type="text/css">
<link href="style/normal_ws.css" rel="stylesheet" type="text/css">
<script src="/js/jquery.min.js"></script>
<script src="/js/json2.min.js"></script>
<script src="/js/load.js"></script>
<script src="/js/jcommon.js"></script>
<script>
var tmp_parent=parent.frames["view"];
window.onerror=function(){return true;}
var rJson;
function openEasysetup(){
	top.location.href="wizard.asp";
}
var helpUrl="";
function initValue(){	
	$("#productModel").html(rJson['productName']+" ("+MM_Firmware+"  "+rJson['fmVersion']+")");	
	if (rJson['operationMode']==0) $("#div_easysetup").show();
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
	if(rJson['cloudFwStatus']=="New"){
		$("#div_cloud_found_new").show();
		$("#new_version").html(MM_FoundNewFw+"("+rJson['new_version']+") "+MM_ManualUpgrade);
	}else{
		$("#div_cloud_found_new").hide();
	}
}
$(function(){
	var postVar={ "topicurl" : "setting/getLanguageCfg"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : "/cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);
			initValue();				
		}
    }); 
	$("#langType").change(function(){
		var val=$(this).val();
		if (val=="auto"){
			autoLanguage(0);
		}else{
			if (val!=""){
				setLanguage(0,val);
			}
		}		
	});
	$("#cloud_update").click(function(){
		top['view'].location.href="adm/cloud_update.asp";
	});
});
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="title_down_left"><span id="productModel"></span><span id="div_cloud_found_new" style="display:none">&nbsp;&nbsp;&nbsp;&nbsp;<span id="new_version"></span><button type="button" class="button" id="cloud_update"><script>dw(BT_Upgrade)</script></button></span></td>
<td class="title_down_center">&nbsp;</td>
<td class="title_down_right" align="right"><span id="div_multi_language" style="display:none"><select class="select" id="langType"></select></span>&nbsp;&nbsp;<span id="div_easysetup" style="display:none"><button type="button" class="easysetup_button" onclick="openEasysetup()"><script>dw(BT_EasySetup)</script></button></span>&nbsp;&nbsp;<span id="div_help" style="display:none"><a href="" id="helpUrl" target="_blank"><div class="help_button"><div class="help_title"><script>dw(BT_Help)</script></div></div></a></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</table>
</body>
</html>