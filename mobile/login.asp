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
<script>
if(window.top != window.self){
	top.location.href = location.href;
}
</script>
</head>
<body>
	<div class="container-fluid">
		<div class="container" align="center">
        	<div class="cs-h-40"></div>
			<img src="/style/logo.png" class="img-responsive cs-logo">
		</div>
        
		<div id="cs_login">
            <div class="cs-h-30"></div>
            <div class="container col-xs-10 col-xs-offset-1">
                <div align="center">
                	<span class="cs-font-24"><script>dw(MB_Welcome)</script></span>
                </div>
                <div class="cs-h-30"></div>
                <form method="post" id="login_frm" action="/cgi-bin/cstecgi.cgi?action=login&flag=1">
				<input type="hidden" id="loginUser">
				<input type="hidden" id="loginPass">
                <div class="form-group has-feedback">
                    <label for="username"><script>dw(MB_User)</script></label>
                    <span class="form-control-feedback"><i class="glyphicon glyphicon-user"></i></span>
                    <input type="text" class="form-control input-sm" id="username" name="username" maxlength="32" onFocus="cleanErr()">
                </div>
                <div class="form-group has-feedback">
                    <label for="password"><script>dw(MB_Passwd)</script></label>
                    <span class="form-control-feedback"><i class="glyphicon glyphicon-lock"></i></span>
                    <input type="password" class="form-control input-sm" id="password" name="password" maxlength="32" onFocus="cleanErr()" onChange="$('#login_btn').click();">
                </div>
				<p class="cs-font-normal cs-font-yellow" id="errmsg"></p>
				<div class="form-group" align="right">
					<a class="cs-font-white cs-a-link" id="forgot_btn"><script>dw(MB_Forgot)</script></a>
				</div>				
                <div class="cs-h-10"></div>
                <div class="row">
                    <div class="col-xs-8 col-xs-offset-2">
                    	<button type="submit" class="btn btn-block btn-cs-black" id="login_btn"><script>dw(MB_Login)</script></button>
                    </div>
                </div>				
                </form>
                <div class="cs-h-20"></div>
            </div>
		</div>
	</div>
	<script>
        function cleanErr(){
            $("#errmsg").html("");
        }
		$(function() {
            var postVar={"topicurl" : "setting/getLanguageCfg"};
			postVar=JSON.stringify(postVar);
			$.ajax({  
				type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : true, success : function(Data){
					var rJson=JSON.parse(Data);
					setJSONValue({
						'loginUser'   :   rJson['loginUser'],
						'loginPass'   :   rJson['loginPass']
					});
				}
			}); 
            cleanErr();
			$('#login_btn').on('click', function(event) {
				if($("#username").val()==""||$("#password").val()==""){
					$('#errmsg').html(JS_msg51);
					return false;
				}
				if($("#username").val()!=$("#loginUser").val()||$("#password").val()!=$("#loginPass").val()){
					$('#errmsg').html(JS_msg52);
					return false;
				}
                $("#login_frm").submit();
				return true;
			});
			$('#forgot_btn').on('click', function(event) {
				window.location.href='forgot.asp';
			});
		});
	</script>
</body>
</html>