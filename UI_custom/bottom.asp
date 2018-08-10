<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
<link href="style/style.css" rel="stylesheet" type="text/css">
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
			if (rJson['copyRight']!=""){
				var curDate = new Date();
				$("#copyRight").html("Copyright &copy; "+curDate.getFullYear()+" "+rJson['copyRight']);
			}
		}
    });
})
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="bottom_left">&nbsp;</td>
<td class="bottom_center"><span id="copyRight"></span></td>
<td class="bottom_right">&nbsp;</td>
</tr>
</table>
</body>
</html>
