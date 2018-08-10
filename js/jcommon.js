/******************************************
**           js lib for using jquery
**           Date:2014-8-19
******************************************/

/*-----------check value---------------*/
var checkVaildVal={
	IsEmpty : function (str,msg){
		if(str==""){
			alert(msg+JS_msg1);
			return 0;
		}
		return 1;
	},
	
	isNumber : function(str){
		var re=/^[0-9]*$/;
		if(!re.test(str)) return 0;	
		return 1;
	},
	
	IsVaildNumber : function (str,msg){
		if(str==""){
			alert(msg+JS_msg1);	
			return 0;
		} 
		if(!checkVaildVal.isNumber(str)){
			alert(msg+JS_msg9);
			return 0;   
		}  
		return 1;
	},
	
	IsVaildNumberRange : function (str,msg,min,max){
		if(str==""){
			alert(msg+JS_msg1);	
			return 0;
		} 
		if(!checkVaildVal.isNumber(str)){
			alert(msg+JS_msg9);
			return 0;   
		}  
		if((parseInt(str)<min)||(parseInt(str)>max)){
			alert(msg+JS_msg10+min+"-"+max+JS_msg11);
			return 0;   
		} 
		return 1;
	},
	
	isAllChar : function (str){
		if(/[\xB7]/.test(str))	return 0;
		if(/[^\x00-\xff]/.test(str)) return 0;
		return 1;
	},
	
	isHex : function (str){
		var re=/[^A-Fa-f0-9]/;
		if(re.test(str)) return 0;
		return 1;	
	},
	
	isString : function(str){
		var re1=/[^\x20-\x7D]/;
		var re2=/[\x20\x22\x24\x25\x27\x2C\x2F\x3B\x3C\x3E\x5C\x60]/;
		if(re1.test(str)||re2.test(str))return 0;
		return 1;
	},
	
	isString2 : function(str){
		var re1=/[^\x20-\x7D]/;
		var re2=/[\x20\x22\x24\x25\x27\x2C\x2F\x3B\x3C\x3E\x5C\x60]/;
		if(re1.test(str)||re2.test(str)) return 0;
		return 1;
	},
		
	isSSID : function(str){
		var re=/[\x22\x24\x25\x27\x2C\x2F\x3B\x3C\x3E\x5C\x60\x7E]/;
		if(re.test(str)) return 0;
		return 1;
	},
	
	strTrim : function(str){
		str=str.replace(/^[\x20]*/,"");
		str=str.replace(/[\x20]*$/,"");
		str=str.replace(/[\x20]+/g," ");
		return str;
	},
	
	IsVaildString : function (str,msg,flag){
		if(flag==1&&str==""){
			alert(msg+JS_msg1);
			return 0;
		}
		if(flag==3&&str==""){
			alert(msg+JS_msg1);
			return 0;
		}
		if(!checkVaildVal.isAllChar(str)){
			alert(msg+JS_msg2);
			return 0;   
		} 
		if(flag==1 && !checkVaildVal.isString(str)){
			alert(msg+JS_msg6);	  
			if(str.length>32){
				alert(msg+JS_msg3);
				return 0;
			}
			return 0;
		}
		else if(flag==2 && !checkVaildVal.isString(str)){
			alert(msg+JS_msg6);	  
			if(str.length>20){
				alert(msg+JS_msg4);
				return 0;
			}
			return 0;
		}
		else if(flag==3 && !checkVaildVal.isString2(str)){
			alert(msg+JS_msg132);	  
			if(str.length>32){
				alert(msg+JS_msg3);
				return 0;
			}
			return 0;
		}
		return 1;
	},

	IsVaildSSID : function (str,msg){
		var strlen = 0;
		if(str==""){
			alert(msg+JS_msg1);
			return 0;
		}
		for(var i = 0;i < str.length; i++)
		{
			if(str.charCodeAt(i) > 255)
				strlen += 3;
			else 
				strlen++;
		}
		if(strlen>32){
			alert(msg+JS_msg3);
			return 0;
		}	
		if(!checkVaildVal.isSSID(str)){
			alert(msg+JS_msg7);
			return 0;
		}
		if(str.split("")[0]==" "||str.split("")[str.length-1]==" "){
			alert(msg+JS_msg8);
			return 0;
		}
		return 1;
	},

	IsVaildWiFiPass : function (str,msg,flag){
		if(str==""){
			alert(msg+JS_msg1);	
			return 0;
		} 
		if(flag=="ascii"&&!checkVaildVal.isString(str)){
			alert(msg+JS_msg6);
			return 0;  
		}
		if(flag=="hex"&&!checkVaildVal.isHex(str)){
			alert(msg+JS_msg23);
			return 0;
		}  
		return 1;
	},
	
	isPort : function(str){
		if(!checkVaildVal.isNumber(str)) return 0;
		if (parseInt(str)<1||parseInt(str)>65535) return 0;
		return 1;
	},
	
	IsVaildPort : function (str,msg){
		if(str==""){
			alert(msg+JS_msg1);
			return 0;
		}
		if(!checkVaildVal.isPort(str)){
			alert(msg+JS_msg18);
			return 0;
		}
		return 1;
	},
	
	IsPortRange:function(s1,s2){
		if(parseInt(s1)>parseInt(s2)){
			alert(JS_msg87); 
			return 0;
		}
		return 1;
	},
	
	isMAC : function (str){
		var re=/[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}/;
		if(!re.test(str)) return 0;
		return 1;
	},
	
	IsVaildMacAddr : function (str){
		if(str.length!=17){
			alert(JS_msg16);
			return 0;
		}
		if(!checkVaildVal.isMAC(str)){
			alert(JS_msg16);
			return 0;
		}
		if(str=="00:00:00:00:00:00"||str.toUpperCase()=="FF:FF:FF:FF:FF:FF"){
			alert(JS_msg14);
			return 0;
		}
		for(var k=0;k<str.length;k++){
			if((str.charAt(1)&0x01)||(str.charAt(1).toUpperCase()=='B')||(str.charAt(1).toUpperCase()=='D')||(str.charAt(1).toUpperCase()=='F')){
				alert(JS_msg17);
				return 0;
			}
		}
		return 1;
	},
	
	IsVaildIpAddr : function (str, msg){
		var re=/^(?:(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))$/;
		if(str==""){
			alert(msg+JS_msg1);
			return 0;
		}
		var buf=str.split(".");
		if(buf[0]<1 || buf[0]>254){
			alert(msg+JS_msg69);
			return 0;
		}
		if(buf[1]>254||buf[1]==""){
			alert(msg+JS_msg61);
			return 0;	
		}
		if(buf[2]>254||buf[2]==""){
			alert(msg+JS_msg133);
			return 0;	
		}
		if(buf[3]<1||buf[3]>254){		
			alert(msg+JS_msg62);
			return 0;		
		}
		return 1;
	},
	
	isIP : function(str){
		var re=/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
		if(!re.test(str))  	return 0;
		var buf=str.split(".");	
		for(i=0;i<4;i++){
			if(buf[i]<0||buf[i]>255) return 0;
		}
		return 1;
	},
	
	isMask : function (str){	
		if(!checkVaildVal.isIP(str)) return 0;
		var buf=str.split(".");
		if(!(buf[3]==0||buf[3]==128||buf[3]==192||buf[3]==224||buf[3]==240||buf[3]==248||buf[3]==252||buf[3]==254)) return 0;
		if(!(buf[2]==0||buf[2]==128||buf[2]==192||buf[2]==224||buf[2]==240||buf[2]==248||buf[2]==252||buf[2]==254||buf[2]==255)) return 0;
		if(!(buf[1]==0||buf[1]==128||buf[1]==192||buf[1]==224||buf[1]==240||buf[1]==248||buf[1]==252||buf[1]==254||buf[1]==255)) return 0;
		if(!( buf[0]==128||buf[0]==192||buf[0]==224||buf[0]==240||buf[0]==248||buf[0]==252||buf[0]==254||buf[0]==255)) return 0;
		return 1;
	},
	
	IsVaildMaskAddr : function(str,msg){
		if(str==""){
			alert(JS_msg79);
			return 0;
		}
		if(!checkVaildVal.isIP(str)){
			alert(JS_msg79);
			return 0;
		}
		var buf=str.split(".");
		if(buf[0]==255&&buf[1]==255&&buf[2]==255){
			if(!(buf[3]==0||buf[3]==128||buf[3]==192||buf[3]==224||buf[3]==240||buf[3]==248||buf[3]==252||buf[3]==254)){
				alert(JS_msg79);
				return 0;
			}
		}
		if(buf[0]==255&&buf[1]==255&&buf[3]==0){
			if(!(buf[2]==0||buf[2]==128||buf[2]==192||buf[2]==224||buf[2]==240||buf[2]==248||buf[2]==252||buf[2]==254||buf[2]==255)){
				alert(JS_msg79);
				return 0;
			}
		}
		if(buf[0]==255&&buf[2]==0&&buf[3]==0){
			if(!(buf[1]==0||buf[1]==128||buf[1]==192||buf[1]==224||buf[1]==240||buf[1]==248||buf[1]==252||buf[1]==254||buf[1]==255)){
				alert(JS_msg79);
				return 0;
			}
		}
		if(buf[1]==0&&buf[2]==0&&buf[3]==0){
			if(!(buf[0]==128||buf[0]==192||buf[0]==224||buf[0]==240||buf[0]==248||buf[0]==252||buf[0]==254||buf[0]==255)){
				alert(JS_msg79);
				return 0;
			}
		}
		if(!((buf[0]==255&&buf[1]==255&&buf[2]==255)||(buf[0]==255&&buf[1]==255&&buf[3]==0)||(buf[0]==255&&buf[2]==0&&buf[3]==0)||(buf[1]==0&&buf[2]==0&&buf[3]==0))){
			alert(JS_msg79);
			return 0;
		}
		return 1;
	},

	IsIpRange : function (startIP,endIP){
		var ip1=startIP.split(".");
		var ip2=endIP.split(".");
		if(Number(ip1[0])>Number(ip2[0])){
			alert(JS_msg41); 
			return 0;
		}
		if(ip1[0]==ip2[0]){
			if(Number(ip1[1])>Number(ip2[1])){
				alert(JS_msg41); 
				return 0;
			}
		}
		if(ip1[0]==ip2[0]&&ip1[1]==ip2[1]){
			if(Number(ip1[2])>Number(ip2[2])){
				alert(JS_msg41); 
				return 0;
			}
		}		
		if(ip1[0]==ip2[0]&&ip1[1]==ip2[1]&&ip1[2]==ip2[2]){
			if(Number(ip1[3])>Number(ip2[3])){		
				alert(JS_msg41); 
				return 0;
			}
		}		
		return 1;
	},

	IsIpSubnet : function (s1,mn,s2){
		var ip1=s1.split(".");
		var ip2=s2.split(".");
		var ip3=mn.split(".");
		for(var k=0;k<=3;k++){
			if((ip1[k]&ip3[k])!=(ip2[k]&ip3[k])) return 0;
		}
		return 1;
	},
	
	IsSameIp : function (s1, s2){
		ip1=s1.replace(/\.\d{1,3}$/,".");
		ip2=s2.replace(/\.\d{1,3}$/,".");
		if (ip1==ip2) return 0;
		return 1;
	}	
}

var lanip='',wtime=0,connectstat=0;
function waitpage(){
	$("#div_body_setting").hide();
	$("#div_wait").show();
}

function waitpage3(){
	$("#div_body_setting").hide();
	$("#connecting").hide();
	if(connectstat==1){
		$("#div_wait_success").show();
	}else{
		$("#div_wait_fail").show();
	}
}

function do_count_down(){
	supplyValue('show_sec',wtime);
	if(wtime==0){
		var curr_url=location.href;
		if(curr_url.indexOf('/wireless/') != -1)
			location.href=addURLTimestamp(location.href);
		else
			parent.location.href='http://'+lanip+'/login.asp'; return false;
	}
	if(wtime > 0){wtime--;setTimeout('do_count_down()',1000);}
}

function do_count_down3(){
	if(connectstat==1)
		supplyValue('show_secs',wtime);
	else
		supplyValue('show_secf',wtime);
	var curr_url=location.href;
	if(wtime==0){
		if(connectstat==1)
			parent.location.href='http://'+lanip+'/home.asp'; 
		else
			location.href=addURLTimestamp(location.href);
	}
	if(wtime > 0){wtime--;setTimeout('do_count_down3()',1000);}
}

function uiPost(postVar){
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);	
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){	
		setTimeout("resetForm();","2000");
	});
}

function uiPost2(postVar){
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		var rJson=JSON.parse(Data);
		lanip=rJson['lan_ip'];
		wtime=rJson['wtime'];
		waitpage();
		do_count_down();
	});
}

function uiPost3(postVar){
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){
		var rJson=JSON.parse(Data);
		lanip=rJson['lan_ip'];
		wtime=rJson['wtime'];
		connectstat=rJson['reserv'];
		waitpage3();
		do_count_down3();
	});
}

function uiPost4(postVar){
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);	
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){	
		var rJson=JSON.parse(Data);
		wtime=rJson['wtime'];
		setTimeout("resetForm();",wtime*1000);
	});
}

function uiPost6(postVar){
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);	
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){	
		setTimeout("resetForm();","10000");
	});
}

function setDisabled(objId,bool){
	$(objId).attr("disabled",bool);
}

///////////jquery///////////////
function supplyValue(Name,Value){
	var node;
	node= $("#"+Name);
	if(node[0]==undefined)
	 	node=$("input[name="+Name+"]");
	 
	var bigType=node[0].tagName || node.get(0).tagName;
	switch(bigType){
		case 'TD' :{}
		case 'DIV' :{}
		case 'SPAN' :{
			node.html(Value);
			break;
		}
		case 'SELECT' :{
			node.val(Value);
			break;
		}
		case 'INPUT' :{
			var smallType=node[0].type;			
			switch(smallType){
				case 'text':
				case 'hidden':
				case 'button':
				case 'password':{
					node.val(Value);
					break;
				}
				case 'radio' :{
					$("input:radio[name="+Name+"][value='"+Value+"']").prop("checked",true);
					break;
				}
				case 'checkbox' :{
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
	var element;
	for(var i in array_json){
		element=$("#"+i) || $("input[name="+i+"]");
		if(element != null){
			supplyValue(i,array_json[i]);
		}
	}
}
function CreateOptions(nodeName,optionValue,valueArray){
	var Node=document.getElementById(nodeName),valueOptions;
	$('#'+nodeName).empty();
	Node.options.length=0;
	if(valueArray==undefined){
		valueOptions=optionValue;
	} else{
		valueOptions=valueArray;
	}
	for(var i=0; i < optionValue.length; i++){
		Node.options[i]=new Option(optionValue[i]);
		Node.options[i].value=valueOptions[i];
	}
}
function HWKeyUp(prefix,idx,event){
	var obj=document.getElementsByName(prefix+idx);
	var nextidx=idx + 1;
	var keynum;

   	if(window.event)
		keynum=event.keyCode;
	else if(event.which) // Netscape/Firefox/Opera
		keynum=event.which;

	if(keynum==9 || keynum==8) return;
	if(obj[0].value.length==2){
		obj=document.getElementsByName(prefix+nextidx);
		if(obj[0]) obj[0].focus();
		return;
	}
}
function CheckHex(keynum){
	if( ( (keynum >= 96) && (keynum <= 105) )||( (keynum >= 48) && (keynum <= 57) )||( (keynum >= 65) && (keynum <= 70) ) ) 		     return true;
	return false;
}
function HWKeyDown(prefix,idx,event){
	var obj=document.getElementsByName(prefix+idx);
	var previdx=idx - 1;

    if(window.event)
		keynum=event.keyCode;
	else if(event.which) // Netscape/Firefox/Opera
		keynum=event.which;

	if((keynum==9)||(keynum==46)||(keynum==8)){
		if(obj[0].value.length==0 && event.keyCode==8){
			obj=document.getElementsByName(prefix+previdx);
			if(obj[0]) obj[0].focus();
		}
		return 1;
	}
	return CheckHex(keynum);
}
//e->input event; o->input object; i->input number
function setFocusFirst(obj){
	if(obj.createTextRange){//IE
		var txt=obj.createTextRange();
		txt.moveStart('character',obj.value.length);
		txt.collapse(true);
		txt.select();
	}
	else
		obj.focus();
}
function setFocusLast(obj){
	if(obj.setSelectionRange){//FF
		obj.setSelectionRange(0,0);
		obj.focus();
	}
	else
		obj.focus();
}
function setFocusAll(obj){
	if(obj.createTextRange){//IE
		var txt=obj.createTextRange();
		txt.moveStart("character", 0);
		txt.moveEnd("character", obj.value.length);
		txt.select();
	}
	else if(obj.setSelectionRange){//FF
		obj.setSelectionRange(0,obj.value.length);
		obj.focus();
	}
}
function ipVali(e, n, i){
	var co=e.keyCode;
	var sh=e.shiftKey;
	
	var inputs=document.getElementsByName(n);
	if(co==8 || co==16 || co==46 || (co>=48 && co<=57) || (co>=96 && co<=105) || co==116){
		if(sh && co >=48 && co <=57)
			return false;
		if(co==8){
			if((inputs[i].value=="") && (inputs[i-1] != null))
				setFocusFirst(inputs[i-1]);//?��
			return true;
		}
		if(co==46){
			if((inputs[i].value=="") && (inputs[i+1] != null))
				setFocusLast(inputs[i+1]);//?
			return true;	
		}
		/*if(inputs[i].value.length>=3){
			if(inputs[i+1] != null)
				setFocusAll(inputs[i+1]);
		}*/
	}
	else if(co==9 || co==37 || co==39 || co==110 || co==190){
		if(co==9) return true;
		if(co==37){
			if(inputs[i].value != "")
				return true;
			else if(inputs[i-1] != null)
				inputs[i-1].focus();
			return false;
		}
		if(co==39){
			if(inputs[i].value != "")
				return true;
			else if(inputs[i+1] != null)
				inputs[i+1].focus();
			return false;
		}
		if(co==110 || co==190){
			if(inputs[i].value.length>0 && inputs[i+1]!=null)
				setFocusAll(inputs[i+1]);
			return false;
		}
	}
	else{
		return false;	
	}
}
function ipVali2(n, i){
	var inputs=document.getElementsByName(n);
	if(inputs[i].value<0 || inputs[i].value>255){		
		alert(JS_msg60);
		setFocusAll(inputs[i]);
		return false;
	}		
}
function checkDate(str){
	var month=["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
	var week=[MM_Week7, MM_Week1, MM_Week2, MM_Week3, MM_Week4, MM_Week5, MM_Week6];
	
	if ((str.substring(4,5))==" ") str=str.replace(" ","");
	else str=str;
	
	var t=str.split(" ");	
	for (var j=0; j<12; j++){
		if (t[0]==month[j]) t[0]=j + 1;
	}	
	return t[2] + "-" + t[0] + "-" + t[1] + "  " + t[3] ;
}
function combinMAC2(m1,m2,m3,m4,m5,m6){
    var mac=m1.toUpperCase()+":"+m2.toUpperCase()+":"+m3.toUpperCase()+":"+m4.toUpperCase()+":"+m5.toUpperCase()+":"+m6.toUpperCase();
    if (mac==":::::") mac="";
    return mac;
}
function decomMAC(ma,macs,nodef){
    var re=/^[0-9a-fA-F]{1,2}:[0-9a-fA-F]{1,2}:[0-9a-fA-F]{1,2}:[0-9a-fA-F]{1,2}:[0-9a-fA-F]{1,2}:[0-9a-fA-F]{1,2}$/;
    if (re.test(macs)||macs==''){
		if (ma.length!=6){
			ma.value=macs;
			return true;
		}
		if (macs!='') var d=macs.split(":");
		else var d=['','','','','',''];
        for (i=0; i < 6; i++){
            ma[i].value=d[i];
			if (!nodef) ma[i].defaultValue=d[i];
		}
        return true;
    }
    return false;
}
function combinIP(d){
	if (d.length!=4) return d.value;
    var ip=d[0].value+"."+d[1].value+"."+d[2].value+"."+d[3].value;
    if (ip=="...") ip="";
    return ip;
}
function decomIP2(ipa,ips,nodef){
	var re=/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
	if (re.test(ips)){
		var d= ips.split(".");
		for (i=0; i < 3; i++){
			ipa[i].value=d[i];
			if (!nodef) ipa[i].defaultValue=d[i];
		}
		return true;
	}
	return false;
}
function decomIP(ipa,ips,nodef){
	var re=/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
	if (re.test(ips)){
		var d= ips.split(".");
		for (i=0; i < 4; i++){
			ipa[i].value=d[i];
			if (!nodef) ipa[i].defaultValue=d[i];
		}
		return true;
	}
	return false;
}
function openWindow(url,windowName,wide,high){
	if (document.all)
		var xMax=screen.width, yMax=screen.height;
	else if (document.layers)
		var xMax=window.outerWidth, yMax=window.outerHeight;
	else
	   	var xMax=640, yMax=500;
	
	var xOffset=(xMax - wide)/2;
	var yOffset=(yMax - high)/3;
	var settings='width='+wide+',height='+high+',screenX='+xOffset+',screenY='+yOffset+',top='+yOffset+',left='+xOffset+',resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes';
	var win=window.open(url, windowName, settings);
	win.opener=window;
}
function getRefToDivNest(divID,oDoc){
  	if( !oDoc ) { oDoc = document; }
  	if( document.layers ) {
		if( oDoc.layers[divID] ) { return oDoc.layers[divID]; } else {
		for( var x = 0, y; !y && x < oDoc.layers.length; x++ ) {
			y = getRefToDivNest(divID,oDoc.layers[x].document); }
		return y; } }
  	if( document.getElementById ) { return document.getElementById(divID); }
  	if( document.all ) { return document.all[divID]; }
  	return document[divID];
}
function progressBar(oBt,oBc,oBg,oBa,oWi,oHi,oDr){
  	MWJ_progBar++; this.id='MWJ_progBar' + MWJ_progBar; this.dir=oDr; this.width=oWi; this.height=oHi; this.amt=0;
  	//write the bar as a layer in an ilayer in two tables giving the border
  	document.write('<span id="progress_div" style="display:none"><table border="0" cellspacing="0" cellpadding="'+oBt+'">'+
	'<tr><td bgcolor="'+oBc+'">'+'<table border="0" cellspacing="0" cellpadding="0"><tr><td height="'+oHi+'" width="'+oWi+'" bgcolor="'+oBg+'">' );
  	if( document.layers ){
		document.write('<ilayer height="'+oHi+'" width="'+oWi+'"><layer bgcolor="'+oBa+'" name="MWJ_progBar'+MWJ_progBar+'"></layer></ilayer>' );
  	}else{
		document.write('<div style="position:relative;top:0px;left:0px;height:'+oHi+'px;width:'+oWi+';">'+'<div style="position:absolute;top:0px;left:0px;height:0px;width:0;font-size:1px;background-color:'+oBa+';" id="MWJ_progBar'+MWJ_progBar+'"></div></div>' );
  	}
  	document.write('</td></tr></table></td></tr></table></span>\n' );
  	this.setBar=resetBar; //doing this inline causes unexpected bugs in early NS4
  	this.setCol=setColour;
}
function resetBar(a,b){
  	//work out the required size and use various methods to enforce it
  	this.amt=( typeof( b )=='undefined' ) ? a : b ? ( this.amt + a ) : ( this.amt - a );
  	if( isNaN( this.amt ) ){ this.amt=0; } if( this.amt > 1 ){ this.amt=1; } if( this.amt < 0 ){ this.amt=0; }
  	var theWidth=Math.round( this.width * ( ( this.dir % 2 ) ? this.amt : 1 ) );
	//alert(theWidth);
  	var theHeight=Math.round( this.height * ( ( this.dir % 2 ) ? 1 : this.amt ) );
  	var theDiv=getRefToDivNest( this.id ); if( !theDiv ){ window.status='Progress: ' + Math.round( 100 * this.amt ) + '%'; return; }
  	if( theDiv.style ){ theDiv=theDiv.style; theDiv.clip='rect(0px '+theWidth+'px '+theHeight+'px 0px)'; }
 	var oPix=document.childNodes ? 'px' : 0;
  	theDiv.width=theWidth + oPix; theDiv.pixelWidth=theWidth; theDiv.height=theHeight + oPix; theDiv.pixelHeight=theHeight;
  	if( theDiv.resizeTo ){ theDiv.resizeTo( theWidth, theHeight ); }
  	theDiv.left=( ( this.dir != 3 ) ? 0 : this.width - theWidth ) + oPix; theDiv.top=( ( this.dir != 4 ) ? 0 : this.height - theHeight ) + oPix;
}
function setColour(a){
  	//change all the different colour styles
  	var theDiv=getRefToDivNest( this.id ); if( theDiv.style ){ theDiv=theDiv.style; }
  	theDiv.bgColor=a; theDiv.backgroundColor=a; theDiv.background=a;
}
function addURLTimestamp(url){
	var _url=url;
	if(_url.indexOf('?')==-1){
		_url += '?timestamp=' + (new Date()).getTime();
	}else{
		if(_url.indexOf('timestamp')==-1)
			_url += "&timestamp=" + (new Date()).getTime();
		else
			_url=_url.replace(/timestamp=.*/ig,"timestamp=" + (new Date()).getTime());
	}
	return _url;
}
function resetForm(){
	//location=location; 
	location.href=addURLTimestamp(location.href);
}
function getRefToDivNest(divID,oDoc){
  	if( !oDoc ){ oDoc=document; }
  	if( document.layers ){
		if( oDoc.layers[divID] ){ return oDoc.layers[divID]; } else{
		for( var x=0, y; !y && x < oDoc.layers.length; x++ ){
			y=getRefToDivNest(divID,oDoc.layers[x].document); }
		return y; } }
  	if( document.getElementById ){ return document.getElementById(divID); }
  	if( document.all ){ return document.all[divID]; }
  	return document[divID];
}
function showLanguageLabel(){

}
function showLanguageLabel2(){

}
function moveLanguagePosition(){
	document.getElementById("languageDiv").style.pixelTop=document.body.scrollTop;
}
function addEventHandler(target, type, func){
	if (target.addEventListener) 
		target.addEventListener(type, func, false);
	else if (target.attachEvent) 
		target.attachEvent("on" + type, func);
	else 
		target["on" + type]=func;
}
addEventHandler(document, "mousemove", function(){	try{top.frames['title'].pageTimeoutDeal();}catch(e){}});
function loadLangMap(flag,type){
	if(type==1){
		$("#div_mainbody,#languageDiv2").hide();
		$("#div_wait_lang").show();
		if(flag==1){
			$("#show_lang_title").html("");
			$("#show_lang_msg").html(MM_ChangeAutoLanguage);
		}else{
			$("#show_lang_title").html(MM_ChangeSetting);
			$("#show_lang_msg").html(MM_ChangeLanguage);
		}
	}else{
		var m="<table width=700><tr><td><table border=0 width=\"100%%\">";
		if(flag==1){
			m+="<tr><td style=\"font-weight:bold; font-size:14px;\"></td></tr>";
		}else{
			m+="<tr><td style=\"font-weight:bold; font-size:14px;\">"+MM_ChangeSetting+"</td></tr>";
		}
		m+="<tr><td height=1 class=line></td></tr>\
		</table><table border=0 width=\"100%%\">\
		<tr><td rowspan=2 width=100 align=center><img src=\"/style/load.gif\"></td>\
		<td class=msg_title></td></tr>";
		if(flag==1){
			m+="<tr><td>"+MM_ChangeAutoLanguage+"</td></tr>";
		}else{
			m+="<tr><td>"+MM_ChangeLanguage+"</td></tr>";
		}
		m+="<tr><td colspan=2 height=1 class=line></td></tr>\
		</table></td></tr></table>";
		top['view'].document.body.innerHTML=m;
	}
}
function CreateLangOption(){
	new_options=[MM_English,MM_SChinese];
	new_values=['en','cn'];	
	CreateOptions("langType",new_options,new_values);
}
function CreateLanguageOption(val){
	new_options=[MM_AutoLanguage,MM_English,MM_SChinese,MM_TChinese,MM_Vietnam,MM_Russian,MM_Japanese];
	new_values=['auto','en','cn','ct','vn','ru','jp'];	
	CreateOptions("langType",new_options,new_values);
	if (val.indexOf(",")==-1){$("#langType option[value='auto']").remove();}
	if (val.indexOf("en")==-1){$("#langType option[value='en']").remove();}
	if (val.indexOf("cn")==-1){$("#langType option[value='cn']").remove();}
	if (val.indexOf("ct")==-1){$("#langType option[value='ct']").remove();}
	if (val.indexOf("vn")==-1){$("#langType option[value='vn']").remove();}
	if (val.indexOf("ru")==-1){$("#langType option[value='ru']").remove();}
	if (val.indexOf("jp")==-1){$("#langType option[value='jp']").remove();}
}
function setLanguage(type,val){
	var language;
	if(localStorage.language=="vi"||localStorage.language=="vn"){
		language="vn";
	}else if(localStorage.language=="ru"){
		language="ru";	
	}else if(localStorage.language=="ja"||localStorage.language=="jp"){
		language="jp";	
	}else if(localStorage.language=="zh-tw"||localStorage.language=="zh-hk"||localStorage.language=="ct"){
		language="ct";	
	}else if(localStorage.language=="zh-cn"||localStorage.language=="cn"){
		language="cn";
	}else{
		language="en";
	}
	loadLangMap(0,type);
	var postVar={"topicurl" : "setting/setLanguageCfg"};
	postVar['langType']=val;
    postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);	
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){	
		setTimeout("top.location.reload();","3000");
	});
}
function autoLanguage(type){
	loadLangMap(1,type);
	var postVar={"topicurl" : "setting/setLanguageCfg"};
	var applang=(navigator.language||navigator.browserLanguage).toLowerCase();
	if(applang=="vi"){
		postVar['langType']="vn";
	}else if(applang=="ru"){
		postVar['langType']="ru";
	}else if(applang=="ja"){
		postVar['langType']="jp";
	}else if(applang=="zh-tw"){
		postVar['langType']="ct";
	}else if(applang=="zh-cn"){
		postVar['langType']="cn";
	}else{
		postVar['langType']="en";
	}
	postVar['langFlag']="0";
    postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);	
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){	
		setTimeout("top.location.reload();","5000");
	});
}
function dispalyFromHourOption(){
	var strTmp;
	for(var i=0; i<24; i++){
		if(i<10)
			strTmp="<option value="+i+">0"+i+"</option>";
		else
			strTmp="<option value="+i+">"+i+"</option>";
		document.write(strTmp);
	}	
}
function dispalyFromMinOption(){
	var strTmp;
	for(var i=0; i<60; i++){
		if(i<10)
			strTmp="<option value="+i+">0"+i+"</option>";
		else
			strTmp="<option value="+i+">"+i+"</option>";
		document.write(strTmp);
	}	
}
function getLeapYearState(year){
	if ( (year % 4==0 && year % 100 != 0) || (year % 400==0) )
		return 1;
	else
		return 0;
}
function getMonthLength(mm, leap){
	if (mm==1 || mm==3 || mm==5 || mm==7 || mm==8 || mm==10 || mm==12)
		return 31;
	else if (mm==4 || mm==6 || mm==9 || mm==11)
		return 30;
	else{
		if (leap==1)
			return 29;
		else
			return 28;	
	}
}
function showTimeFormat(time){
	var tmp=time[0];
	if (time[0]>1)
		tmp+=" "+MM_days+", ";
	else
		tmp+=" "+MM_day+", ";
		
	tmp+=time[1];
	if (time[1]>1)
		tmp+=" "+MM_hours+", ";
	else
		tmp+=" "+MM_hour+", ";
	
	tmp+=time[2];
	if (time[2]>1)
		tmp+=" "+MM_mins+", ";
	else
		tmp+=" "+MM_min+", ";
		
	tmp+=time[3];
	if (time[3]>1)
		tmp+=" "+MM_secs;
	else
		tmp+=" "+MM_sec;
		
	return tmp;
}
function showOpMode(mode){
	if (mode==0)
		return MM_GatewayMode;
	else if (mode==1)
		return MM_BridgeMode;
	else if (mode==2)
		return MM_RepeaterMode;
	else if (mode==3)
		return MM_WispMode;
}
function showSsidFormat(ssid){
	return ssid.replace(eval("/&/gi"),'&amp;').replace(eval("/ /gi"),'&nbsp;');	
}
function setWirelessMode(objId,mode){
	switch(mode){
		case 0:	supplyValue(objId, "2.4GHz (B+G)");		break;
		case 1:	supplyValue(objId, "2.4GHz (B)");		break;
		case 4:	supplyValue(objId, "2.4GHz (G)");		break;
		case 6:	supplyValue(objId, "2.4GHz (N)");		break;
		case 9:	supplyValue(objId, "2.4GHz (B+G+N)");	break;
		case 2:	supplyValue(objId, "802.11A");			break;
		case 8:	supplyValue(objId, "802.11A/ N");		break;
		case 14: supplyValue(objId, "802.11A/ N/ AC");		break;
		case 75: supplyValue(objId, "2.4GHz (B+G+N+AC)");	break;
		default: supplyValue(objId, "2.4GHz (B+G+N)");	break;
	}
}
function setAuthMode(objId,authmode,encryptype){
	if (authmode=="NONE")	              
		supplyValue(objId,MM_Disable);
	else if (authmode=="OPEN"||authmode=="SHARED"){ 	
		if (authmode=="OPEN") 
			 supplyValue(objId,"WEP-"+MM_OpenSystem);
		else
			 supplyValue(objId,"WEP-"+MM_SharedKey);
	}
	else if (authmode=="WPAPSK") supplyValue(objId,"WPA-PSK");
	else if (authmode=="WPA2PSK") supplyValue(objId,"WPA2-PSK");
	else if (authmode=="WPAPSKWPA2PSK") supplyValue(objId,"WPA/WPA2-PSK");
	else supplyValue(objId,MM_Disable);
}
function myBrowser(){
   	var userAgent = navigator.userAgent;
    if (userAgent.indexOf("Opera") > -1) return "Opera";
    if (userAgent.indexOf("Firefox") > -1) return "FF";
    if (userAgent.indexOf("Chrome") > -1) return "Chrome";
    if (userAgent.indexOf("Safari") > -1) return "Safari";
    if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !(userAgent.indexOf("Opera") > -1)) return "IE";
	if (userAgent.toLowerCase().indexOf("trident") > -1 && userAgent.indexOf("rv") > -1) return "IE11";
}
function cs_hex_string(val){
	var strInput = val;
	if(strInput.substr(0,2).toLowerCase() === "0x"){
		var s = strInput.substr(2);
	}else{
		return strInput;
	}
	if(s.length % 2 !== 0) {
		alert("Illegal Format ASCII Code!");
		return "";
	}else{
		var nInputLength = strInput.length;
		if(nInputLength%2 == 0){                 
			var StrHex = "";
			for (var i=0; i < nInputLength; i = i + 2 ){
				var str = strInput.substr(i, 2);
				//StrHex = StrHex + .toString(16);
				var n = parseInt(str, 16);
				StrHex = StrHex + String.fromCharCode(n);
			}
			return StrHex;
		}
	}
}
