<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title></title>
    <link rel="shortcut icon" href="/style/favicon.ico">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/csstyle.css">
    <script src="/js/jquery.min.js"></script>
    <script src="/js/load.js"></script>
    <script src="./js/bootstrap.min.js"></script>
    <script src="./js/mobile.js"></script>
</head>
<body>
    <div class="container-fluid">
        <div class="container" align="center">
            <div class="cs-h-30"></div>
            <img src="img/config.png" class="cs-img" style="width: 30%">
        </div>
        <div class="container col-xs-10 col-xs-offset-1">
            <div align="center">
                <h4><script>dw(MB_Reset)</script></h4>
            </div>
        </div>
        <div class="container col-xs-10 col-xs-offset-1">
            <div class="form-group">
            <div class="cs-h-30"></div>
                <h4><script>dw(MB_Operation)</script></h4>
                <h5><script>dw(MB_Quickly)</script></h5>
            </div>
        </div>
        <div class="container col-xs-10 col-xs-offset-1">
            <div class="form-group">
                <h5><script>dw(MB_DefaultName)</script>: admin</h5>
                <h5><script>dw(MB_DefaultPassword)</script>: admin</h5>
            </div>
            <div class="cs-h-30"></div>
            <div class="row">
                <div class="col-xs-8 col-xs-offset-2">
                    <button type="button" class="btn btn-block btn-default" id="back_btn"><script>dw(MB_Back)</script></button>
                </div>
            </div>
            <div class="cs-h-50"></div>
        </div>
    </div>
    <script>
		$(function() {
			var postVar={"topicurl" : "setting/getLanguageCfg"};
			postVar=JSON.stringify(postVar);
			$.ajax({  
				type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : true, success : function(Data){
					var rJson=JSON.parse(Data);
				}
			}); 
			$('#back_btn').on('click',function() {
				gotoUrl('login.asp');
			});			
		});
    </script>
</body>
</html>