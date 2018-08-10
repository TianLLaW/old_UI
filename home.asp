<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="shortcut icon" href="style/favicon.ico">
<script src="/js/jquery.min.js"></script>
<script src="/js/json2.min.js"></script>
<script src="/js/load.js"></script>
<script src="/js/jcommon.js"></script>
<script>
$(function(){
	var postVar={ "topicurl" : "setting/getLanguageCfg"};
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : "/cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			var rJson=JSON.parse(Data);
			document.title=rJson['webTitle'];
		}
    });
})
</script>
</head>
<frameset rows="96,*,40" border="0" framespacing="0" frameborder="NO">
<frame src="top.asp" name="top" id="topasp" frameborder="NO" scrolling="NO" marginwidth="0" marginheight="0">
<frameset cols="6,1,*,1,6" border="0" framespacing="0" frameborder="NO">
	<frame frameborder="NO" name=other1 marginWidth=0 marginheight=0 src="empty3.htm"  scrolling=no  noresize>
	<frame src="empty1.htm" name="empty1" marginwidth="0" marginheight="0" scrolling="NO" frameborder="NO"> 
	<frameset rows="44,*" border="0" framespacing="0" frameborder="NO">
		<frame src="title.asp" name="title" marginwidth="0" marginheight="0" scrolling="NO" frameborder="NO">
		<frameset  cols="224,1,25,*" border="0" framespacing="0" frameborder="NO">
			<frame src="left.asp" name="menu" id="menu" marginwidth="0" marginheight="0" scrolling="AUTO" frameborder="NO" noresize>
			<frame src="empty1.htm" name="empty3" marginwidth="0" marginheight="0" scrolling="NO" frameborder="NO" noresize>
			<frame src="empty2.htm" name="empty4" marginwidth="0" marginheight="0" scrolling="NO" frameborder="NO" noresize> 
			<frame src="adm/status.asp" id="view" name="view" scrolling="Auto" marginwidth="0" topmargin="0" marginheight="0" frameborder="NO" noresize>
		</frameset>
	</frameset>
	<frame src="empty1.htm" name="empty2" marginwidth="0" marginheight="0" scrolling="NO" frameborder="NO" >
	<frame frameborder="NO" name=other2 marginWidth=0 marginheight=0 src="empty3.htm" scrolling=no  noresize>
</frameset>
<frame name="bottom" scrolling="no" noresize="noresize" target="contents" src="bottom.asp">
</frameset>
<script>
	document.getElementById('view').src = "adm/status.asp";
</script>
<noframes>
<body bgcolor="#FFFFFF" style="overflow-x:hidden;">
</body></noframes>
</html>
