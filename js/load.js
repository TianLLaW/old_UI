var rJsonLang;
var loadMultiLangBt,loadLangFlag,loadLanguageType,loadLoginFlag;
function loadLanguage(){
	var postVar={ "topicurl" : "setting/getLanguageCfg"};
	postVar=JSON.stringify(postVar);
	$.ajax({  
		type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJsonLang=JSON.parse(Data);
			loadMultiLangBt=rJsonLang['multiLangBt'];
			loadLangFlag=rJsonLang['langFlag'];
			loadLanguageType=rJsonLang['languageType'];
			loadLoginFlag=rJsonLang['loginFlag'];
		}
	});
}
loadLanguage();
var applang=(navigator.language||navigator.browserLanguage).toLowerCase();
//console.log("applang=="+applang);
if (loadMultiLangBt.split(",").length>1&&loadLangFlag==0){
	if(applang=="ru"){
		localStorage.language="ru";
	}else if(applang=="vi"){
		localStorage.language="vn";
	}else if(applang=="ja"){
		localStorage.language="jp";
	}else if(applang=="zh-tw"||applang=="zh-hk"){
		localStorage.language="ct";
	}else if(applang=="zh-cn"){
		localStorage.language="cn";
	}else{
		localStorage.language="en";
	}
	if(applang=="ru"&&loadMultiLangBt.indexOf("ru")>-1){
		document.write("<script src=/js/language_ru.js></script>");
	}else if(applang=="vi"&&loadMultiLangBt.indexOf("vn")>-1){
		document.write("<script src=/js/language_vn.js></script>");
	}else if(applang=="ja"&&loadMultiLangBt.indexOf("jp")>-1){
		document.write("<script src=/js/language_jp.js></script>");
	}else if((applang=="zh-tw"||applang=="zh-hk")&&loadMultiLangBt.indexOf("ct")>-1){
		document.write("<script src=/js/language_ct.js></script>");		
	}else if(applang=="zh-cn"&&loadMultiLangBt.indexOf("cn")>-1){
		document.write("<script src=/js/language_cn.js></script>");	
	}else{
		document.write("<script src=/js/language_en.js></script>");
	}
}else{
	localStorage.language=loadLanguageType;
	if(loadLanguageType=="ru"){
		document.write("<script src=/js/language_ru.js></script>");
	}else if(loadLanguageType=="vn"){
		document.write("<script src=/js/language_vn.js></script>");
	}else if(loadLanguageType=="jp"){
		document.write("<script src=/js/language_jp.js></script>");
	}else if(loadLanguageType=="ct"){
		document.write("<script src=/js/language_ct.js></script>");		
	}else if(loadLanguageType=="cn"){
		document.write("<script src=/js/language_cn.js></script>");
	}else{
		document.write("<script src=/js/language_en.js></script>");
	}
}
