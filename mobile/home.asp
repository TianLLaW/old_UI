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
	<div id="cs_menu" class="container-fluid">
        <div class="row cs-header" align="center">
			<h4><span id="cs_title"></span></h4>
		</div>

		<div>
            <div class="cs-h-50"></div>
            <div class="container col-xs-12">
            	<div class="row" align="center">
                    <h4><script>dw(MB_Model)</script>: <span id="productModel"></span></h4>
                    <h5><script>dw(MB_Version)</script>: <span id="fmVersion"></span></h5>
                </div>
                <div class="cs-h-50"></div>
                <div class="row cs_img_center" align="center">
                    <div class="col-xs-6">
                        <img src="img/quick.png" id="quick_btn" class="img-responsive" style="border-radius:10px;margin-right:5px;">
                        <div class="cs-h-10"></div>
                        <div class="col-xs-12"><p style="margin-right:5px;"><script>dw(MB_QuickSetup)</script></p></div>
                    </div>
                    <div class="col-xs-6"> 
                        <img src="img/advanced.png" id="adv_btn" class="img-responsive" style="margin-left:5px;border-radius:10px;">
                        <div class="cs-h-10"></div>
                        <div class="col-xs-12"><p style="margin-left:5px;"><script>dw(MB_AdvancedSetup)</script></p></div>
                    </div>
                </div>
            </div>
		</div>
	</div>
	<script>
		$(function(){
			var postVar={"topicurl" : "setting/getLanguageCfg"};
			postVar=JSON.stringify(postVar);
			$.ajax({  
				type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : true, success : function(Data){
					var rJson=JSON.parse(Data);
					document.title=rJson['webTitle'];
					setJSONValue({
						'productModel' 	:   rJson['productName'],
						'fmVersion'  	:   rJson['fmVersion']
					});
					if (rJson['webTitle']!="TOTOLINK"){
						$('#cs_title').html(rJson['webTitle']+" "+MB_RouterSetting2);
					}else{
						$('#cs_title').html(MB_RouterSetting);
					}
				}
			});
            $('#quick_btn').on('click', function(event) {
               	window.location.href='mobile.asp';
            });
            $('#adv_btn').on('click', function(event) {
                gotoUrl('../home.asp');
            });
        });
	</script>
</body>
</html>