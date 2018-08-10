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
    <input type="hidden" id="wanMode">
    <input type="hidden" id="lanIp">
    <div class="container-fluid" id="cs_internet">
		<div class="row cs-header">
			<h4><i class="glyphicon glyphicon-asterisk"></i><script>dw(MB_WanSetting)</script></h4>
		</div>
        
		<div class="row" id="cs_tab">
			<div data-cs-index="pppoe" class="col-xs-4 cs-p-0 active">
            	<div class="btn btn-block"><script>dw(MB_Pppoe)</script></div>
            </div>			
			<div data-cs-index="dhcp" class="col-xs-4 cs-p-0">
            	<div class="btn btn-block"><script>dw(MB_Dhcp)</script></div>
            </div>
			<div data-cs-index="static" class="col-xs-4 cs-p-0">
            	<div class="btn btn-block"><script>dw(MB_StaticIp)</script></div>
            </div>
		</div>
        
		<div id="cs_internet">
            <!-- PPPoE -->
            <div id="tab_pppoe" style="display: none;">
                <div class="cs-h-20"></div>
                <div class="container">
                    <p><script>dw(MB_IspInfo)</script></p>
                    <p id="errmsg_ppp" style="display:none;color:#FFFF00" align="center"></p>
                </div>
                <div class="cs-h-20"></div>
                <div class="container">
                    <form class="">
                    <div class="form-group">
                        <label for="pppoeUser"><script>dw(MB_PppoeUser)</script></label>
                        <input type="text" class="form-control input-sm" id="pppoeUser" maxlength="32" onFocus="hideErr(1)">
                    </div>
                    <div class="form-group has-feedback">
                        <label for="pppoePass"><script>dw(MB_PppoePasswd)</script></label>
                        <span id="switch_eye" class="pos-right"><i class="glyphicon glyphicon-eye-open"></i></span>
                        <input type="password" class="form-control form-control2 input-sm" id="pppoePass" maxlength="32" onFocus="hideErr(1)">
                    </div>
                    </form>
                    <div class="cs-h-20"></div>
                    <div class="row">
                        <div class="col-xs-6"><button type="button" class="btn btn-block btn-default" id="pppoe_back_btn"><script>dw(MB_Back)</script></button></div>
                        <div class="col-xs-6"><button type="button" class="btn btn-block btn-cs-black" id="pppoe_next_btn"><script>dw(MB_Next)</script></button></div>
                    </div>
                </div>
            </div>
            <!-- /. PPPoE -->
            
            <!-- Dynamic IP -->
            <div id="tab_dhcp" style="display: none;">
                <div class="cs-h-20"></div>
                <div class="container">
                	<p><script>dw(MB_WanStatus)</script></p>
                    <p id="cs_errmsg_wanip_sc" style="display:none;color:#FFFF00" align="center"><script>dw(MB_DhcpInfo)</script><span id="cs_lanip"></span></p>
                    <p id="cs_errmsg_wanip_en" style="display:none;color:#FFFF00" align="center"><script>dw(MB_DhcpInfo)</script><span id="cs_lanip"></span>&nbsp;automaticalty.</p>  
                </div>
                <div class="cs-h-20"></div>
                <div class="container cs-font-blue cs-input">
                    <form class="">
                    <table class="table">
                        <tr>
                            <td><script>dw(MB_Ip)</script></td>
                            <td><input type="text" class="cs-empty" id="myIp"></td>
                        </tr>
                        <tr>
                            <td><script>dw(MB_Mask)</script></td>
                            <td><input type="text" class="cs-empty" id="myMask"></td>
                        </tr>
                        <tr>
                            <td><script>dw(MB_Gateway)</script></td>
                            <td><input type="text" class="cs-empty" id="myGw"></td>
                        </tr>
                        <tr>
                            <td><script>dw(MB_DnsServer)</script></td>
                            <td><input type="text" class="cs-empty" id="myDns"></td>
                        </tr>
                    </table>
                    </form>
                    <div class="cs-h-20"></div>
                    <div class="row">
                        <div class="col-xs-6"><button type="button" class="btn btn-block btn-default" id="dhcp_back_btn"><script>dw(MB_Back)</script></button></div>
                        <div class="col-xs-6"><button type="button" class="btn btn-block btn-cs-black" id="dhcp_next_btn"><script>dw(MB_Next)</script></button></div>
                    </div>
                </div>
            </div>
            <!-- /. Dynamic IP -->
            
            <!-- Static IP -->
            <div id="tab_static" style="display: none;">
                <div class="cs-h-20"></div>
                <div class="container">
                    <p><script>dw(MB_StaticIpInfo)</script></p>
                    <p id="errmsg" style="display:none;color:#FFFF00" align="center"></p>
                </div>
                <div class="cs-h-20"></div>
                <div class="container cs-font-blue cs-input">
                    <form class="">
                    <table class="table">
                        <tr>
                            <td><script>dw(MB_Ip)</script></td>
                            <td><input type="text" id="staticIp" maxlength="15" onBlur="setMask()" onClick="hideErr(2)"></td>
                        </tr>
                        <tr>
                            <td><script>dw(MB_Mask)</script></td>
                            <td><input type="text" id="staticMask" maxlength="15" onClick="hideErr(2)"></td>
                        </tr>
                        <tr>
                            <td><script>dw(MB_Gateway)</script></td>
                            <td><input type="text" id="staticGw" maxlength="15" onClick="hideErr(2)"></td>
                        </tr>
                        <tr>
                            <td><script>dw(MB_DnsServer)</script></td>
                            <td><input type="text" id="priDns" maxlength="15" onClick="hideErr(2)"></td>
                        </tr>
                    </table>
                    </form>
                    <div class="cs-h-20"></div>
                    <div class="row">
                        <div class="col-xs-6"><button type="button" class="btn btn-block btn-default" id="static_back_btn"><script>dw(MB_Back)</script></button></div>
                        <div class="col-xs-6"><button type="button" class="btn btn-block btn-cs-black" id="static_next_btn"><script>dw(MB_Next)</script></button></div>
                    </div>
                </div>
            </div>
            <!-- /. Static IP -->
            <div class="cs-h-10"></div>
		</div>
	</div>
    
	<div class="container-fluid" id="cs_wifi" style="display:none">
		<div class="row cs-header">
			<h4><i class="glyphicon glyphicon-asterisk"></i><script>dw(MB_WiFiSetting)</script></h4>
		</div>
        <div class="cs-h-10"></div>
        <div class="container">
            <form class="">
                <div class="cs-h-5"></div>
                <div class="form-group">
                    <label class="cs-font-normal" for="ssid"><script>dw(MB_WiFiSsid)</script></label>
                    <input type="text" class="form-control input-sm" id="ssid" maxlength="32">
                </div>
                <div class="form-group has-feedback">
                    <label class="cs-font-normal" for="wpakey"><script>dw(MB_WiFiPasswd)</script></label>
                    <span id="switch_eye2g" class="pos-right"><i class="glyphicon glyphicon-eye-open"></i></span>
                    <input type="password" class="form-control form-control2 input-sm" id="wpakey" maxlength="63">
                </div>
                <span class="form-group" id="cs_pwdmsg">
                    <label class="cs-font-normal"><script>dw(MB_WiFiPasswdLength)</script></label>
                </span>
                <span class="form-group" id="cs_errmsg">
                    <p class="cs-font-normal cs-font-yellow" id="errmsg_wifi"></p>
                </span>
                <div class="cs-h-10"></div>
                <div class="row">
                    <div class="col-xs-6"><button type="button" class="btn btn-block btn-default" id="back_btn"><script>dw(MB_Back)</script></button></div>
                    <div class="col-xs-6"><button type="button" class="btn btn-block btn-cs-black" id="done_btn"><script>dw(MB_Done)</script></button></div>
                </div>
            </form>
		</div>
	</div>
    
    <div id="cs_connect" style="display:none">
        <div class="cs-h-150"></div>
        <div class="container col-xs-10 col-xs-offset-1">
            <div align="center">
                <img src="img/connecting.png" class="img-responsive cs-img-6">
                <div class="cs-h-10"></div>
                <div class="result_bar">
                    <div id="result_bar"></div>
                </div>
                <div class="cs-h-10"></div>
                <h5><script>dw(MB_Apply)</script></h5>
            </div>
        </div>
    </div>
    
    <div class="container-fluid" id="cs_result" style="display: none;">
        <div class="container" align="center">
            <div class="cs-h-30"></div>
            <img src="img/connect_on.png" class="img-responsive cs-img" style="width: 30%">
        </div>
        <div class="cs-h-20"></div>
        <div class="container">
            <div align="center">
                <h4><script>dw(MB_Success)</script></h4>
            </div>
            <div class="cs-h-10"></div>
            <div><script>dw(MB_Changed)</script></div>
        </div>
        <div class="cs-h-30"></div>
        <div class="container">
        <div class="h4" style="border-bottom: 1px solid #fff; padding-bottom: 5px; "><script>dw(MB_WiFi)</script></div>
            <div class="row">
                <div class="col-xs-5"><script>dw(MB_WiFiSsid)</script></div>
                <div class="col-xs-7" id="wifi_ssid"></div>
            </div>
            <div class="row">
                <div class="col-xs-5"><script>dw(MB_WiFiPasswd)</script></div>
                <div class="col-xs-7" id="wifi_wpakey"></div>
            </div>
        </div>
        <div class="cs-h-20"></div>
    </div>
	<script>
		function setMask() {
			var mask="",ip=$('#staticIp').val().split(".")[0];
			if ((ip>=0&&ip<127)&&($('#staticIp').val()!=0)) {
				mask="255.0.0.0";//A type
			} else if (ip>127&&ip<192) {
				mask="255.255.0.0";//B type
			} else if (ip>=192&&ip<224) {
				mask="255.255.255.0";//C type
			} 
			$('#staticMask').val(mask);
		}
		$(function() {
            var postVar={"topicurl" : "setting/getEasyWizardCfg"};
			postVar=JSON.stringify(postVar);
			$.ajax({  
				type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
					var rJson=JSON.parse(Data);
					setJSONValue({
						'lanIp'     	:   rJson['lanIp'],
						'pppoeUser'    	:   rJson['pppoeUser'],
						'pppoePass'    	:   rJson['pppoePass'],
						'ssid'   		:   rJson['ssid'],
						'wpakey'    	:   rJson['wpakey']
					});
					if(rJson['wanMode']==0){
						$('#myIp,#myMask,#myGw,#myDns').val("");
						setJSONValue({
							'staticIp'     	:   rJson['staticIp'],
							'staticMask'   	:   rJson['staticMask'],
							'staticGw'     	:   rJson['staticGw'],
							'priDns'    	:   rJson['priDns']
						});
					}else{
						$('#staticIp,#staticMask,#staticGw,#priDns').val("");
						setJSONValue({
							'myIp'    		:   rJson['wanIp'],
							'myMask'  		:   rJson['wanMask'],
							'myGw'    		:   rJson['wanGw'],
							'myDns'   		:   rJson['priDns']
						});
						if(rJson['wanConnStatus']=="disconnected"){
							$('#myIp,#myMask,#myGw,#myDns').val("");
							if(rJson['wanMode']!=0) supplyValue("priDns","");
						}
					}
					if(rJson['wanIp']=="0.0.0.0") supplyValue("staticIp","");
					if(rJson['wanMask']=="0.0.0.0") supplyValue("staticMask","");
					if(rJson['wanGw']=="0.0.0.0") supplyValue("staticGw","");
					if(rJson['priDns']=="0.0.0.0") supplyValue("priDns","");
					if(rJson['wanMode']==3){
						$($('#cs_tab').find('.btn')[0]).parent().addClass('active').siblings().removeClass('active');
					}else if(rJson['wanMode']==0){
						$($('#cs_tab').find('.btn')[2]).parent().addClass('active').siblings().removeClass('active');
					}else{
						$($('#cs_tab').find('.btn')[1]).parent().addClass('active').siblings().removeClass('active');
					}
				}
			});
			$('#cs_tab').on('click', function(event) {//internet
				event.preventDefault();
				var current=event.target;
				if(current.id=='cs_tab'){
					var type=$(current).children('div.active').data('cs-index');
				}else{
					if ($(current).parent().hasClass('active')) {
						return false;
					}
					var type=$(current).parent().data('cs-index');
				}
				if (type=="pppoe"){
					supplyValue("wanMode","3");
				}else if (type=="static"){
					supplyValue("wanMode","0");
				}else{
					supplyValue("wanMode","1");
				}
				$(current).parent().addClass('active').siblings().removeClass('active');
				$('#tab_'+type).css('display','block').siblings().css('display','none');
			});				
			$('#cs_tab').trigger('click');
			$('#pppoe_back_btn,#dhcp_back_btn,#static_back_btn').on('click',function() {
				gotoUrl('home.asp');
			});			
			$('#back_btn').on('click',function() {
				$("#cs_internet").show();
				$("#cs_wifi").hide();
			});			
			$('#pppoe_next_btn').on('click',function() {
               	if (!IsValidStr($('#pppoeUser'),MB_PppoeUser)) return false;
				if (!IsValidStr($('#pppoePass'),MB_PppoePasswd)) return false;
				$("#cs_internet").hide();
				$("#cs_wifi").show();
            });			
			$('#dhcp_next_btn').on('click',function() {
				$("#cs_internet").hide();
				$("#cs_wifi").show();
            });			
			$('#static_next_btn').on('click',function() {
               	if (!IsValidIp($('#staticIp'),MB_Ip)) return false;
				if (!IsSameIp2($('#staticIp'),$('#lanIp'))) return false;
				if (!IsValidMask($('#staticMask'),MB_Mask)) return false;
				if (!IsValidIp($('#staticGw'),MB_Gateway)) return false;
				if (!IsIpSubnet($('#staticGw'),$('#staticMask'),$('#staticIp'))) return false;
				if (!IsSameIp($('#staticGw'),$('#staticIp'),MB_Gateway)) return false;
				if (!IsValidIp($('#priDns'),MB_DnsServer)) return false;
				if (!IsSameIp($('#priDns'),$('#staticIp'),MB_DnsServer)) return false;
				$("#cs_internet").hide();
				$("#cs_wifi").show();
            });			
            $('#ssid,#wpakey').on('focus',function() {
               	$('#cs_pwdmsg').show();
               	$('#cs_errmsg').hide();
            });
			$('#switch_eye').on('click', function(event) {//pppoe
				var $i_element=$(this).find('i');
				if ($i_element.hasClass('glyphicon-eye-open')) {
					$i_element.removeClass('glyphicon-eye-open').addClass('glyphicon-eye-close');
					$('#pppoePass').attr('type','text');
				} else {					
					$i_element.removeClass('glyphicon-eye-close').addClass('glyphicon-eye-open');
					$('#pppoePass').attr('type','password');
				}
			});	
			$('#switch_eye2g').on('click', function(event) {
				var $i_element=$(this).find('i');
				if ($i_element.hasClass('glyphicon-eye-open')) {
					$i_element.removeClass('glyphicon-eye-open').addClass('glyphicon-eye-close');
					$('#wpakey').attr('type','text');
				} else {
					$i_element.removeClass('glyphicon-eye-close').addClass('glyphicon-eye-open');
					$('#wpakey').attr('type','password');
				}
			});
            $('#done_btn').on('click',function() {//wifi
                if (!IsValidSSID($('#ssid'),MB_WiFiSsid)) return false;
                if (!IsValidKey($('#wpakey'),MB_WiFiPasswd)) return false;               
               	$('#cs_connect').show();
                $("#cs_wifi").hide();
                var postVar={"topicurl" : "setting/setEasyWizardCfg"};
				postVar['wanMode']=$('#wanMode').val();
				if ($("#wanMode").val()=="0"){
					postVar['staticIp']=$('#staticIp').val();
					postVar['staticMask']=$('#staticMask').val();
					postVar['staticGw']=$('#staticGw').val();
					postVar['priDns']=$('#priDns').val();
					postVar['secDns']="0.0.0.0";
				}else if ($("#wanMode").val()=="3"){
					postVar['pppoeUser']=$('#pppoeUser').val();
					postVar['pppoePass']=$('#pppoePass').val();  
				}
				if($('#wanMode').val()=="0"){
					postVar['dnsMode']="1";	
				}else{
					postVar['dnsMode']="0";
				}
				postVar['ssid']=$('#ssid').val();
				postVar['wpakey']=$('#wpakey').val();
				postVar=JSON.stringify(postVar);
				$(":input").attr('disabled',true);	
				$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){	});
                var flag=0;
                var flag_obj=setInterval(function(){
                    if (flag < 16) {
                        flag++;
                        $('#result_bar').css('width',6.25*flag+'%');
                    }else{
                        clearInterval(flag_obj);
                        $('#cs_result').show();
                        $('#cs_connect').hide();
                    }
                },1000);				
                $("#wifi_ssid").html(showSsidFormat($('#ssid').val()));
                $("#wifi_wpakey").html($('#wpakey').val());
            });
            $('#ok_btn').on('click', function(event) {
                if (navigator.userAgent.indexOf("Firefox") != -1 || navigator.userAgent.indexOf("Chrome") !=-1) {
                   location.href="about:blank";
                   close();
                } else {
                   opener=null;
                   open("", "_self");
                   close();
                }
            });
		});
	</script>
</body>
</html>