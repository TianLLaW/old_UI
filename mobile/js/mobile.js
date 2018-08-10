/*------------start--------------*/
function isAllStr(str) {
	if(/[^\x20-\x7D]/.test(str)) return 0;
	if(/[\x20\x22\x24\x25\x27\x2C\x2F\x3B\x3C\x3E\x5C\x60]/.test(str)) return false;
	return true;
}
function IsValidStr(id,msg) {
	if (id.val()=="") {
		$('#errmsg_ppp').show().html(msg+MB_msg1);
		return false;
	}
	if (!isAllStr(id.val())){
		$('#errmsg_ppp').show().html(msg+MB_msg5);
		return false;
	}
	return true;
}
function isSSID(str) {
	if(/[\x22\x24\x25\x27\x2C\x2F\x3B\x3C\x3E\x5C\x60\x7E]/.test(str)) return false;
    var len = 0;
    for (var i = 0; i < str.length; i++) {
        var a = str.charAt(i);
        if (a.match(/[^\x00-\xff]/ig) != null){
            len += 3;//中文字符 3字节
        }else{
            len += 1;
        }
    }
  	if(len > 32) return false;
  	return true;
}
function IsValidSSID(id,msg) {
	var aid="#cs_pwdmsg",bid="#cs_errmsg",cid="#errmsg_wifi";
	if (id.val()=="") {
		$(aid).hide();
		$(bid).show();
		$(cid).html(msg+MB_msg1);
		return false;
	}
	if (!isSSID(id.val())){
		$(aid).hide();
		$(bid).show();
		$(cid).html(msg+MB_msg4);
		return false;
	}
	return true;
}
function IsValidKey(id,msg) {
	var aid="#cs_pwdmsg",bid="#cs_errmsg",cid="#errmsg_wifi";
	if (id.val()=="") {
		$(aid).hide();
		$(bid).show();
		$(cid).html(msg+MB_msg1);
		return false;
	}
	if (!isAllStr(id.val())){
		$(aid).hide();
		$(bid).show();
		$(cid).html(msg+MB_msg5);
		return false;
	}
	if (id.val().length<8) {
		$(aid).hide();
		$(bid).show();
		$(cid).html(MB_WiFiPasswdLength);
		return false;
	}
	return true;
}
function isIP(str) {
	var re=/^(?:(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))$/;
	if(!re.test(str)) return false;
	var buf=str.split(".");
	if(buf[3]<1||buf[3]>254) return false;
	return true;
}
function IsValidIp(id,msg) {
	if (id.val()=="") {
		$('#errmsg').show().html(msg+MB_msg1);
		id.focus();
		return false;
	}
	if (id.val().split(".")[0]<1||id.val().split(".")[0]==127||id.val().split(".")[0]>223) {
		$('#errmsg').show().html(msg+MB_msg2);
		id.focus();
		return false;
	}
	if (!isIP(id.val())){
		$('#errmsg').show().html(msg+MB_msg2);
		id.focus();
		return false;
	}
	return true;
}
function IsSameIp(aid,bid,msg) {
	if (aid.val()==bid.val()) {
		$('#errmsg').show().html(msg+MB_msg3);
		aid.focus();
		return false;
	}
	return true;
}
function IsSameIp2(aid,bid) {
	if (aid.val()==bid.val()) {
		$('#errmsg').show().html(JS_msg44);
		aid.focus();
		return false;
	}
	return true;
}
function isIPMask(str) {
	var re=/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
	if(!re.test(str)) return false;
	var buf=str.split(".");	
	for(i=0;i<4;i++){
		if(buf[i]<0||buf[i]>255) return false;
	}
	return true;
}
function isMask(str) {
	if(!isIPMask(str)) return 0;
	var buf=str.split(".");
	var m0=buf[0],m1=buf[1],m2=buf[2],m3=buf[3];
	if(!(m3==0||m3==128||m3==192||m3==224||m3==240||m3==248||m3==252||m3==254))	 return false;
	if(!(m2==0||m2==128||m2==192||m2==224||m2==240||m2==248||m2==252||m2==254||m2==255)) return false;
	if(!(m1==0||m1==128||m1==192||m1==224||m1==240||m1==248||m1==252||m1==254||m1==255)) return false;
	if(!(m0==128||m0==192||m0==224||m0==240||m0==248||m0==252||m0==254||m0==255)) return false;
	return true;
}
function IsValidMask(id,msg) {
	if (id.val()=="") {
		$('#errmsg').show().html(msg+MB_msg1);
		id.focus();
		return false;
	}
	if (!isMask(id.val())){
		$('#errmsg').show().html(msg+MB_msg2);
		id.focus();
		return false;
	}
	return true;
}
function IsIpSubnet(s1,mn,s2){
	var ip1=s1.val().split(".");
	var ip2=s2.val().split(".");
	var ip3=mn.val().split(".");
	for(var k=0;k<=3;k++){
		if((ip1[k]&ip3[k])!=(ip2[k]&ip3[k])){		
			$('#errmsg').html(JS_msg44);
			return false;
		}
	}
	return true;
}
/*------------end--------------*/

function supplyValue(Name,Value){
	var node;
	node= $("#"+Name);
	if(node[0]==undefined)
	 	node=$("input[name="+Name+"]");
	 
	var bigType = node[0].tagName || node.get(0).tagName;
	switch(bigType){
		case 'TD' : {}
		case 'DIV' : {}
		case 'SPAN' : {
			node.html(Value);
			break;
		}
		case 'SELECT' : {
			node.val(Value);
			break;
		}
		case 'INPUT' : {
			var smallType = node[0].type;			
			switch(smallType){
				case 'text':
				case 'hidden':
				case 'password':{
					node.val(Value);
					break;
				}
				case 'radio' : {
					$("input:radio[name="+Name+"][value='"+Value+"']").prop("checked",true);
					break;
				}
				case 'checkbox' : {
					if(Value==1)
					 	node.attr("checked",true); 
					else
					  	node.attr("checked",false); 
					break;
				}
			}
		}
	}
}
function setJSONValue(array_json){
	if(typeof array_json != 'object'){ return false;}
	for(var i in array_json){
		var element = $("#"+i) || $("input[name="+i+"]");
		if(element != null){
			supplyValue(i,array_json[i]);
		}
	}
}
function gotoUrl(url){
	window.location.href=url;
}
function hideErr(val){
	if(1==val){
		$("#errmsg_ppp").html("");
	}else{
		$("#errmsg").html("");
	}
}
function getAppleBrowser(){
	var u = navigator.userAgent;
	if (u.indexOf('iPhone') > -1 || u.indexOf('iPod') > -1 || u.indexOf('iPad') > -1) return 1;	
	else return 0;
}
function showSsidFormat(ssid){
	return ssid.replace(eval("/&/gi"),'&amp;').replace(eval("/ /gi"),'&nbsp;');	
}
