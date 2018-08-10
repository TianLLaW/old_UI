<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="/style/normal_ws.css" rel="stylesheet" type="text/css">
<script src="/js/jquery.min.js"></script>
<script src="/js/json2.min.js"></script>
<script src="/js/load.js"></script>
<script src="/js/jcommon.js"></script>
<script>
var rJson,v_wifiOff2,v_ssid2,v_wepkey2,v_wpakey2,v_wifiOff3,v_ssid3,v_wepkey3,v_wpakey3,v_authMode,v_encrypType,v_keyFormat,v_hssid,add_modify_flag=0;//0--->add,1--->modify
function saveChanges(){
	if (!checkVaildVal.IsVaildSSID($("#ssid").val(),MM_Ssid))return false;
	if (add_modify_flag==0){//add ssid
		if(v_wifiOff2==1){
			cur_bssid_num_index=2;
			$("#doAction").val(cur_bssid_num_index);
			$("#wifiOff2").val(0);
			$("#wifiOff3").val(v_wifiOff3);
		}else if(v_wifiOff3==1){
			cur_bssid_num_index=3;
			$("#doAction").val(cur_bssid_num_index);
			$("#wifiOff2").val(v_wifiOff2);
			$("#wifiOff3").val(0);
		}else{
			alert(JS_msg37);
			return false;
		}
	}else{//modify ssid
		cur_bssid_num_index=add_modify_flag;	
		$("#doAction").val(cur_bssid_num_index);
		$("#wifiOff2").val(v_wifiOff2);
		$("#wifiOff3").val(v_wifiOff3);
	}	
	
	if(cur_bssid_num_index==2){
		$("#hssid").val($("#h_ssid").val()+";"+v_hssid[1]);
		$("#ssid2").val($("#ssid").val());
		$("#ssid3").val(v_ssid3);
	}else if(cur_bssid_num_index==3){	
		$("#hssid").val(v_hssid[0]+";"+$("#h_ssid").val());	
		$("#ssid2").val(v_ssid2);
		$("#ssid3").val($("#ssid").val());
	}
	
	var auth_mode_index=$('#auth_mode')[0].selectedIndex;
	var encryp_type_index=$('#encryp_type')[0].selectedIndex;
	var key_format_index=$('#key_format')[0].selectedIndex;
	if (auth_mode_index==1||auth_mode_index==2){
		var checkbox = $('input[id="checkboxPass1"]:checked').val();
		if(checkbox == "on"){
			$("#wepkey").val($("#wepkey2_type").val());
		}else{
			$("#wepkey").val($("#wepkey1_type").val());
		}	
		var wepkey=$("#wepkey").val();
		if (key_format_index==0){//hex
			if (encryp_type_index==0){//10hex
				if (wepkey.length!=10){alert(JS_msg21);return false;}				
			}else{//26hex
				if (wepkey.length!=26){alert(JS_msg22);return false;}				
			}				
			if (!checkVaildVal.IsVaildWiFiPass(wepkey,MM_Password,"hex"))return false;
		}else{
			if (encryp_type_index==0){//10hex
				if (wepkey.length!=5){alert(JS_msg19);return false;}
			}else{
				if (wepkey.length!=13){alert(JS_msg20);return false;}
			}						
			if (!checkVaildVal.IsVaildWiFiPass(wepkey,MM_Password,"ascii"))return false;
		}	
		
		if(cur_bssid_num_index==2){
			$("#authMode").val($("#auth_mode").val()+";"+v_authMode[1]);
			if (encryp_type_index==0){//wep64
				$("#encrypType").val("WEP64;"+v_encrypType[1]);
			}else{
				$("#encrypType").val("WEP128;"+v_encrypType[1]);
			}
			if (key_format_index==0){//hex
				$("#keyFormat").val("1;"+v_keyFormat[1]);
			}else{
				$("#keyFormat").val("0;"+v_keyFormat[1]);
			}
			$("#wepkey2").val($("#wepkey").val());
			$("#wepkey3").val(v_wepkey3);
			$("#wpakey2").val("");	
			$("#wpakey3").val(v_wpakey3);	
		}else if(cur_bssid_num_index==3){
			$("#authMode").val(v_authMode[0]+";"+$("#auth_mode").val());
			if (encryp_type_index==0){//wep64
				$("#encrypType").val(v_encrypType[0]+";WEP64");
			}else{
				$("#encrypType").val(v_encrypType[0]+";WEP128");
			}
			if (key_format_index==0){//hex
				$("#keyFormat").val(v_keyFormat[0]+";1");
			}else{
				$("#keyFormat").val(v_keyFormat[0]+";0");
			}
			$("#wepkey2").val(v_wepkey2);
			$("#wepkey3").val($("#wepkey").val());
			$("#wpakey2").val(v_wpakey2);	
			$("#wpakey3").val("");
		}
	}else if (auth_mode_index>=3){
		var checkbox = $('input[id="checkboxPass2"]:checked').val();
		if(checkbox == "on"){
			$("#wpakey").val($("#wpakey2_type").val());
		}else{
			$("#wpakey").val($("#wpakey1_type").val());
		}
		var wpakey=$("#wpakey").val();
		if (key_format_index==0){//64hex
			if (wpakey.length!=64){alert(JS_msg25);return false;}
			if (!checkVaildVal.IsVaildWiFiPass(wpakey,MM_Password,"hex"))return false;
		}else{
			if (wpakey.length<8||wpakey.length>63){alert(JS_msg24);return false;}
			if (!checkVaildVal.IsVaildWiFiPass(wpakey,MM_Password,"ascii"))return false;
		}	
		
		if(cur_bssid_num_index==2){
			$("#authMode").val($("#auth_mode").val()+";"+v_authMode[1]);
			if (encryp_type_index==0){//tkip
				$("#encrypType").val("TKIP;"+v_encrypType[1]);
			}else if (encryp_type_index==1){//aes
				$("#encrypType").val("AES;"+v_encrypType[1]);
			}else{
				$("#encrypType").val("TKIPAES;"+v_encrypType[1]);
			}
			if (key_format_index==0){//hex
				$("#keyFormat").val("1;"+v_keyFormat[1]);
			}else{
				$("#keyFormat").val("0;"+v_keyFormat[1]);
			}
			$("#wepkey2").val("");
			$("#wepkey3").val(v_wepkey3);
			$("#wpakey2").val($("#wpakey").val());
			$("#wpakey3").val(v_wpakey3);
		}else if(cur_bssid_num_index==3){	
			$("#authMode").val(v_authMode[0]+";"+$("#auth_mode").val());			
			if (encryp_type_index==0){//tkip
				$("#encrypType").val(v_encrypType[0]+";TKIP");
			}else if (encryp_type_index==1){//aes
				$("#encrypType").val(v_encrypType[0]+";AES");
			}else{
				$("#encrypType").val(v_encrypType[0]+";TKIPAES");
			}
			if (key_format_index==0){//hex
				$("#keyFormat").val(v_keyFormat[0]+";1");
			}else{
				$("#keyFormat").val(v_keyFormat[0]+";0");
			}
			$("#wepkey2").val(v_wepkey2);
			$("#wepkey3").val("");
			$("#wpakey2").val(v_wpakey2);
			$("#wpakey3").val($("#wpakey").val());
		}
	}else{
		if(cur_bssid_num_index==2){
			$("#authMode").val("NONE;"+v_authMode[1]);
			$("#encrypType").val("NONE;"+v_encrypType[1]);
			$("#keyFormat").val("0;"+v_keyFormat[1]);
			$("#wepkey2").val("");	
			$("#wepkey3").val(v_wepkey3);	
			$("#wpakey2").val("");	
			$("#wpakey3").val(v_wpakey3);	
		}else if(cur_bssid_num_index==3){
			$("#authMode").val(v_authMode[0]+";NONE");
			$("#encrypType").val(v_encrypType[0]+";NONE");
			$("#keyFormat").val(v_keyFormat[0]+";0");
			$("#wepkey2").val(v_wepkey2);	
			$("#wepkey3").val("");	
			$("#wpakey2").val(v_wpakey2);
			$("#wpakey3").val("");	
		}
	}
	add_modify_flag=0;	
	return true;
}

function updateKeyFormat(){
	var auth_mode_index=$('#auth_mode')[0].selectedIndex;
	var encryp_type_index=$('#encryp_type')[0].selectedIndex;
	var key_format_index=$('#key_format')[0].selectedIndex;
	if (auth_mode_index==1||auth_mode_index==2){
		if (encryp_type_index==0){//WEP64
			if (key_format_index==0){//hex
				$("#wepkey").attr("maxlength",10);
			}else{
				$("#wepkey").attr("maxlength",5);
			}
		}else{
			if (key_format_index==0){//hex
				$("#wepkey").attr("maxlength",26);
			}else{
				$("#wepkey").attr("maxlength",13);
			}
		}			
	}else{
		if (key_format_index==0){//hex
			$("#wpakey").attr("maxlength",64);
		}else{
			$("#wpakey").attr("maxlength",63);
		}
	}
}

function updateEncrypType(){
	updateKeyFormat();
}

function CreateEncrypType(){
	var new_options,new_values;
	switch($("#auth_mode").val()){
		case "NONE":
			new_values=["NONE"];
			new_options=[MM_Disable];
			break;
		case "OPEN":
		case "SHARED":
			new_values=["WEP64","WEP128"];
			new_options=["WEP64","WEP128"];
			break;
		case "WPAPSK":
			new_values=["TKIP","AES"];
			new_options=["TKIP","AES"];
			break;
		default:
			new_values=["TKIP","AES","TKIPAES"];
			new_options=["TKIP","AES","TKIP/AES"];
			break;
	}
	CreateOptions('encryp_type',new_options,new_values);
}

function updateAuthMode(){
	$("#div_encryp_type,#div_key_format,#div_wepkey,#div_wpakey").hide();
	$("#wepkey,#wpakey").attr("disabled",true);
	CreateEncrypType();
	var auth_mode_str=$("#auth_mode").val();
	switch(auth_mode_str){
		case "NONE":
			supplyValue("encryp_type","NONE");
			break;
		case "OPEN":
		case "SHARED":
			$("#div_encryp_type,#div_key_format,#div_wepkey").show();
			$("#wepkey").val("").attr("disabled",false);	
			supplyValue("encryp_type","WEP64");
			supplyValue("key_format","1");	
			updateEncrypType();
			break;
		default:
			$("#div_encryp_type,#div_key_format,#div_wpakey").show();
			$("#wpakey").val("").attr("disabled",false);
			supplyValue("encryp_type","AES");
			supplyValue("key_format","0");
			updateEncrypType();
			break;
	}
}

function deleteClick(){
	if ($("#DR1").get(0) && $("#DR1").get(0).checked==true && $("#DR2").get(0) && $("#DR2").get(0).checked==true){
		$("#doAction").val(1);
		$("#wifiOff2").val(1);
		$("#wifiOff3").val(1);
	}else if ($("#DR2").get(0)&&$("#DR2").get(0).checked==true){
		$("#doAction").val(3);
		$("#wifiOff2").val(v_wifiOff2);
		$("#wifiOff3").val(1);
	}else if ($("#DR1").get(0)&&$("#DR1").get(0).checked==true){
		$("#doAction").val(2);
		$("#wifiOff2").val(1);
		$("#wifiOff3").val(v_wifiOff3);
	}else{
		alert(JS_msg36);
		return false;
	}
	
	if( !confirm(JS_msg130) ) return false;
	$("#ssid2").val(v_ssid2);
	$("#wepkey2").val(v_wepkey2);
	$("#wpakey2").val(v_wpakey2);
	$("#ssid3").val(v_ssid3);
	$("#wepkey3").val(v_wepkey3);
	$("#wpakey3").val(v_wpakey3);
	$("#hssid").val(v_hssid[0]+";"+v_hssid[1]);
	$("#authMode").val(v_authMode[0]+";"+v_authMode[1]);
	$("#encrypType").val(v_encrypType[0]+";"+v_encrypType[1]);
	$("#keyFormat").val(v_keyFormat[0]+";"+v_keyFormat[1]);
	return true;
}

function modifyClick(index){
	var f=document.wirelessMultipleAdd;
	$("#add").val(BT_Modify);
	$("#div_encryp_type,#div_key_format,#div_wepkey,#div_wpakey").hide();
	$("#wepkey,#wpakey").attr("disabled",true);	
	var auth_mode_index,encryp_type_index,key_format_index,hssid_index;
	if (index==1){
		add_modify_flag=2;//modify
		$("#ssid").val(v_ssid2);		
		if (v_hssid[0]==1){
			hssid_index=0;
		}else{
			hssid_index=1;
		}	
		if (v_authMode[0]=="NONE"){
			f.encryp_type.options[0]=new Option(MM_Disable,"NONE");
			f.encryp_type.options[1]=null;
			auth_mode_index=0;
			encryp_type_index=0;
		}else if (v_authMode[0]=="OPEN"||v_authMode[0]=="SHARED"){
			f.encryp_type.options[0]=new Option("WEP64","WEP64");
			f.encryp_type.options[1]=new Option("WEP128","WEP128");	
			f.encryp_type.options[2]=null;			
			$("#div_encryp_type,#div_key_format,#div_wepkey").show();
			$("#wepkey").attr("disabled",false).val(v_wepkey2);	
			$("#wepkey1_type").attr("disabled",false).val(v_wepkey2);	
			if (v_authMode[0]=="OPEN"){
				auth_mode_index=1;
			}else{
				auth_mode_index=2;
			}	
			if (v_wepkey2.length==5||v_wepkey2.length==10){
				encryp_type_index=0;
			}else{
				encryp_type_index=1;
			}				
			if (v_keyFormat[0]==1){//hex
				key_format_index=0;
			}else{
				key_format_index=1;
			}
		}else{
			if (v_authMode[0]=="WPA2PSK"||v_authMode[0]=="WPAPSKWPA2PSK"){
				f.encryp_type.options[0]=new Option("TKIP","TKIP");
				f.encryp_type.options[1]=new Option("AES","AES");
				f.encryp_type.options[2]=new Option("TKIP/AES","TKIPAES");
				f.encryp_type.options[3]=null;
			}else{
				f.encryp_type.options[0]=new Option("TKIP","TKIP");
				f.encryp_type.options[1]=new Option("AES","AES");
				f.encryp_type.options[2]=null;
			}
			$("#div_encryp_type,#div_key_format,#div_wpakey").show();
			$("#wpakey").attr("disabled",false).val(v_wpakey2);	
			$("#wpakey1_type").attr("disabled",false).val(v_wpakey2);			
			if (v_authMode[0]=="WPAPSK"){
				auth_mode_index=3;
			}else if (v_authMode[0]=="WPA2PSK"){
				auth_mode_index=4;
			}else{
				auth_mode_index=5;
			}			
			if (v_encrypType[0]=="TKIP"){	
				encryp_type_index=0;
			}else if (v_encrypType[0]=="AES"){
				encryp_type_index=1;
			}else{
				encryp_type_index=2;
			}	
			if (v_keyFormat[0]==1){//hex
				key_format_index=0;
			}else{
				key_format_index=1;
			}
		}
	}else if (index==2){
		add_modify_flag=3;//modify
		$("#ssid").val(v_ssid3);		
		if (v_hssid[1]==1){
			hssid_index=0;
		}else{
			hssid_index=1;
		}	
		if (v_authMode[1]=="NONE"){
			f.encryp_type.options[0]=new Option(MM_Disable,"NONE");
			f.encryp_type.options[1]=null;
			auth_mode_index=0;
			encryp_type_index=0;
		}else if (v_authMode[1]=="OPEN"||v_authMode[1]=="SHARED"){
			f.encryp_type.options[0]=new Option("WEP64","WEP64");
			f.encryp_type.options[1]=new Option("WEP128","WEP128");
			f.encryp_type.options[2]=null;
			$("#div_encryp_type,#div_key_format,#div_wepkey").show();
			$("#wepkey").attr("disabled",false).val(v_wepkey3);	
			$("#wepkey1_type").attr("disabled",false).val(v_wepkey3);
			if (v_authMode[1]=="OPEN"){
				auth_mode_index=1;
			}else{
				auth_mode_index=2;
			}
			if (v_wepkey3.length==5||v_wepkey3.length==10){
				encryp_type_index=0;
			}else{
				encryp_type_index=1;
			}	
			if (v_keyFormat[1]==1){//hex
				key_format_index=0;
			}else{
				key_format_index=1;
			}
		}else{
			if (v_authMode[1]=="WPA2PSK"||v_authMode[1]=="WPAPSKWPA2PSK"){
				f.encryp_type.options[0]=new Option("TKIP","TKIP");
				f.encryp_type.options[1]=new Option("AES","AES");
				f.encryp_type.options[2]=new Option("TKIP/AES","TKIPAES");
				f.encryp_type.options[3]=null;
			}else{
				f.encryp_type.options[0]=new Option("TKIP","TKIP");
				f.encryp_type.options[1]=new Option("AES","AES");
				f.encryp_type.options[2]=null;
			}
			$("#div_encryp_type,#div_key_format,#div_wpakey").show();
			$("#wpakey").attr("disabled",false).val(v_wpakey3);	
			$("#wpakey1_type").attr("disabled",false).val(v_wpakey3);			
			if (v_authMode[1]=="WPAPSK"){
				auth_mode_index=3;
			}else if (v_authMode[1]=="WPA2PSK"){
				auth_mode_index=4;
			}else{
				auth_mode_index=5;
			}						
			if (v_encrypType[1]=="TKIP"){	
				encryp_type_index=0;
			}else if (v_encrypType[1]=="AES"){
				encryp_type_index=1;
			}else{
				encryp_type_index=2;
			}	
			if (v_keyFormat[1]==1){//hex
				key_format_index=0;
			}else{
				key_format_index=1;
			}
		}
	}
	$('#h_ssid')[0].selectedIndex=hssid_index;
	$('#encryp_type')[0].selectedIndex=encryp_type_index;
	$('#auth_mode')[0].selectedIndex=auth_mode_index;
	$('#key_format')[0].selectedIndex=key_format_index;
	updateEncrypType();
}

function creatMultiAPlist(){
	var strTmp="";
	if (v_wifiOff2==0&&v_wifiOff3==0){
		strTmp="<tr align=center>\n";
		strTmp+="<td class=item_center2>1</td>\n";
		strTmp+="<td class=item_center2><a href='javascript:modifyClick(1)'>"+showSsidFormat(v_ssid2)+"</a></td>\n";
		if (v_authMode[0]=="NONE"){
			strTmp+="<td class=item_center2>"+MM_Disable+"</td>\n";
		}else if (v_authMode[0]=="OPEN"||v_authMode[0]=="SHARED"){
			if (v_authMode[0]=="OPEN"){
				strTmp+="<td class=item_center2>WEP-"+MM_OpenSystem+"</td>\n";
			}else{
				strTmp+="<td class=item_center2>WEP-"+MM_SharedKey+"</td>\n";
			}
		}else{
			if (v_authMode[0]=="WPAPSK"){
				strTmp+="<td class=item_center2>WPA-PSK</td>\n";
			}else if (v_authMode[0]=="WPA2PSK"){
				strTmp+="<td class=item_center2>WPA2-PSK</td>\n";
			}else{
				strTmp+="<td class=item_center2>WPA/WPA2-PSK</td>\n";
			}
		}		
		strTmp+="<td class=item_center2><input type=checkbox id=DR1 name=DR1></td>\n";
		strTmp+="</tr>\n";

		strTmp+="<tr align=center>\n";
		strTmp+="<td class=item_center2>2</td>\n";
		strTmp+="<td class=item_center2><a href='javascript:modifyClick(2)'>"+showSsidFormat(v_ssid3)+"</a></td>\n";
		if (v_encrypType[1]=="NONE"){
			strTmp+="<td class=item_center2>"+MM_Disable+"</td>\n";
		}else if (v_authMode[1]=="OPEN"||v_authMode[1]=="SHARED"){
			if (v_authMode[1]=="OPEN"){
				strTmp+="<td class=item_center2>WEP-"+MM_OpenSystem+"</td>\n";
			}else{
				strTmp+="<td class=item_center2>WEP-"+MM_SharedKey+"</td>\n";
			}
		}else{
			if (v_authMode[1]=="WPAPSK"){
				strTmp+="<td class=item_center2>WPA-PSK</td>\n";
			}else if (v_authMode[1]=="WPA2PSK"){
				strTmp+="<td class=item_center2>WPA2-PSK</td>\n";
			}else{
				strTmp+="<td class=item_center2>WPA/WPA2-PSK</td>\n";
			}
		}		
		strTmp+="<td class=item_center2><input type=checkbox id=DR2 name=DR2></td>\n";
		strTmp+="</tr>\n";
	}else if (v_wifiOff2==0){
		strTmp="<tr align=center>\n";
		strTmp+="<td class=item_center2>1</td>\n";
		strTmp+="<td class=item_center2><a href='javascript:modifyClick(1)'>"+showSsidFormat(v_ssid2)+"</a></td>\n";
		if (v_encrypType[0]=="NONE"){
			strTmp+="<td class=item_center2>"+MM_Disable+"</td>\n";
		}else if (v_authMode[0]=="OPEN"||v_authMode[0]=="SHARED"){
			if (v_authMode[0]=="OPEN"){
				strTmp+="<td class=item_center2>WEP-"+MM_OpenSystem+"</td>\n";
			}else{
				strTmp+="<td class=item_center2>WEP-"+MM_SharedKey+"</td>\n";
			}
		}else{
			if (v_authMode[0]=="WPAPSK"){
				strTmp+="<td class=item_center2>WPA-PSK</td>\n";
			}else if (v_authMode[0]=="WPA2PSK"){
				strTmp+="<td class=item_center2>WPA2-PSK</td>\n";
			}else{
				strTmp+="<td class=item_center2>WPA/WPA2-PSK</td>\n";
			}
		}		
		strTmp+="<td class=item_center2><input type=checkbox id=DR1 name=DR1></td>\n";
		strTmp+="</tr>\n";
	}else if (v_wifiOff3==0){
		strTmp="<tr align=center>\n";
		strTmp+="<td class=item_center2>1</td>\n";
		strTmp+="<td class=item_center2><a href='javascript:modifyClick(2)'>"+showSsidFormat(v_ssid3)+"</a></td>\n";
		if (v_encrypType[1]=="NONE"){
			strTmp+="<td class=item_center2>"+MM_Disable+"</td>\n";
		}else if (v_authMode[1]=="OPEN"||v_authMode[1]=="SHARED"){
			if (v_authMode[1]=="OPEN"){
				strTmp+="<td class=item_center2>WEP-"+MM_OpenSystem+"</td>\n";
			}else{
				strTmp+="<td class=item_center2>WEP-"+MM_SharedKey+"</td>\n";
			}
		}else{
			if (v_authMode[1]=="WPAPSK"){
				strTmp+="<td class=item_center2>WPA-PSK</td>\n";
			}else if (v_authMode[1]=="WPA2PSK"){
				strTmp+="<td class=item_center2>WPA2-PSK</td>\n";
			}else{
				strTmp+="<td class=item_center2>WPA/WPA2-PSK</td>\n";
			}
		}		
		strTmp+="<td class=item_center2><input type=checkbox id=DR2 name=DR2></td>\n";
		strTmp+="</tr>\n";
	}
	$("#div_multiaplist").append(strTmp);
}

var wifiIdx="0";
$(function(){
	var postVar={topicurl:"setting/getWiFiMultipleConfig"};
	postVar["wifiIdx"]=wifiIdx;
    postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", url : " /cgi-bin/cstecgi.cgi", data : postVar, async : false, success : function(Data){
			rJson=JSON.parse(Data);	
			v_wifiOff2=rJson['wifiOff2'];
			v_ssid2=rJson['ssid2'];
			v_wepkey2=rJson['wepkey2'];//wep
			v_wpakey2=rJson['wpakey2'];//wpa
			v_wifiOff3=rJson['wifiOff3'];
			v_ssid3=rJson['ssid3'];
			v_wepkey3=rJson['wepkey3'];//wep
			v_wpakey3=rJson['wpakey3'];//wpa
			v_hssid=rJson['hssid'].split(";");
			v_authMode=rJson['authMode'].split(";");
			v_encrypType=rJson['encrypType'].split(";");
			v_keyFormat=rJson['keyFormat'].split(";");
			creatMultiAPlist();
			if (v_wifiOff2==1 && v_wifiOff3==1){
				$("#delsel,#delreset").attr("disabled",true);
			}
		}
    });
	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
});

function updatePassType(index){
	
	if(index == 1){
		var checkbox = $('input[id="checkboxPass1"]:checked').val();
		if(checkbox == "on"){
			$("#wepkey2_type").val($("#wepkey1_type").val()); 
			$("#wepkey").val($("#wepkey1_type").val());
			$("#div_wepkey1").hide();
			$("#div_wepkey2").show();
		}else{
			$("#wepkey1_type").val($("#wepkey2_type").val());
			$("#wepkey").val($("#wepkey2_type").val());
			$("#div_wepkey1").show();//p
			$("#div_wepkey2").hide();//t
		}
	}else if(index == 2){
		var checkbox = $('input[id="checkboxPass2"]:checked').val();
		if(checkbox == "on"){
			$("#wpakey2_type").val($("#wpakey1_type").val()); 
			$("#wpakey").val($("#wpakey1_type").val());
			$("#div_wpakey1").hide();
			$("#div_wpakey2").show();
		}else{
			$("#wpakey1_type").val($("#wpakey2_type").val());
			$("#wpakey").val($("#wpakey2_type").val());
			$("#div_wpakey1").show();//p
			$("#div_wpakey2").hide();//t
		}
	}
}

function waitpage_mult(){
	$("#div_setting").hide();
	$("#div_wait").show();
}
var lanip="",wtime=70;
function do_count_down_mult(){
	supplyValue('show_sec',wtime);
	if(wtime==0){parent.location.href='http://'+lanip+'/login.asp'; return false;}
	if(wtime > 0){wtime--;setTimeout('do_count_down_mult()',1000);}
}

function uiPost_ff(postVar){
	postVar=JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	waitpage_mult();
	do_count_down_mult();
	$.post(" /cgi-bin/cstecgi.cgi",postVar,function(Data){});
	setTimeout(function(){
		lanip=location.host;
	},15000);
}

function doSubmit(flag){
	if (flag==1){//add & edit
		if (saveChanges()==false)return false;
	}else{//del
		if (deleteClick()==false)return false;
	}
	$(".select").css('backgroundColor','#ebebe4');
	var postVar={"topicurl":"setting/setWiFiMultipleConfig"};
	postVar['doAction']=$('#doAction').val();
	postVar['wifiOff2']=$('#wifiOff2').val();
	postVar['ssid2']=$('#ssid2').val();
	postVar['wepkey2']=$('#wepkey2').val();
	postVar['wpakey2']=$('#wpakey2').val();
	postVar['wifiOff3']=$('#wifiOff3').val();
	postVar['ssid3']=$('#ssid3').val();
	postVar['wepkey3']=$('#wepkey3').val();
	postVar['wpakey3']=$('#wpakey3').val();
	postVar['hssid']=$('#hssid').val();
	postVar['authMode']=$('#authMode').val();
	postVar['encrypType']=$('#encrypType').val();
	postVar['keyFormat']=$('#keyFormat').val();
	postVar['wifiIdx']=wifiIdx;
	uiPost_ff(postVar);

}
</script>
</head>
<body class="mainbody">
<div id="div_setting">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<form name="wirelessMultipleAdd">
<input type="hidden" id="doAction">
<input type="hidden" id="wifiOff2">
<input type="hidden" id="ssid2">
<input type="hidden" id="wepkey2">
<input type="hidden" id="wpakey2">
<input type="hidden" id="wifiOff3">
<input type="hidden" id="ssid3">
<input type="hidden" id="wepkey3">
<input type="hidden" id="wpakey3">
<input type="hidden" id="hssid">
<input type="hidden" id="authMode">
<input type="hidden" id="encrypType">
<input type="hidden" id="keyFormat">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_MultiAp)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_MultiAp)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_Ssid)</script></td>
<td><input type="text" class="text" id="ssid" maxlength=32></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_BSsid)</script></td>
<td><select class="select" id="h_ssid">
<option value="1"><script>dw(MM_Disable)</script></option>
<option value="0" selected><script>dw(MM_Enable)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_SecurityMode)</script></td>
<td><select class="select" id="auth_mode" onChange="updateAuthMode()"> 
<option value="NONE"><script>dw(MM_Disable)</script></option>
<option value="OPEN">WEP-<script>dw(MM_OpenSystem)</script></option>
<option value="SHARED">WEP-<script>dw(MM_SharedKey)</script></option>
<option value="WPAPSK">WPA-PSK</option>
<option value="WPA2PSK">WPA2-PSK</option>
<option value="WPAPSKWPA2PSK">WPA/WPA2-PSK</option>
</select></td>
</tr>
<tr id="div_encryp_type" style="display:none"> 
<td class="item_left"><script>dw(MM_EncrypType)</script></td>
<td><select class="select" name="encryp_type" id="encryp_type" onChange="updateEncrypType()"></select></td>
</tr>
<tr id="div_key_format" style="display:none"> 
<td class="item_left"><script>dw(MM_KeyFormat)</script></td>
<td><select class="select" id="key_format" onChange="updateKeyFormat()">
<option value="1">Hex</option>
<option value="0">ASCII</option>
</select></td>
</tr>
<tr id="div_wepkey" style="display:none"> 
<td class="item_left"><script>dw(MM_Password)</script></td>
<td><input type="hidden" id="wepkey" maxlength="26"><span id="div_wepkey1"><input type="password" class="text" id="wepkey1_type" maxlength="26"></span><span id="div_wepkey2" style="display:none"><input type="text" class="text" id="wepkey2_type" maxlength="26"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="checkboxPass1" onChange="updatePassType(1)"></td>
</tr> 
<tr id="div_wpakey" style="display:none">
<td class="item_left"><script>dw(MM_Password)</script></td>
<td><input type="hidden" id="wpakey" maxlength="64"><span id="div_wpakey1"><input type="password" class="text" id="wpakey1_type" maxlength="64"></span><span id="div_wpakey2" style="display:none"><input type="text" class="text" id="wpakey2_type" maxlength="64"></span>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="checkboxPass2" onChange="updatePassType(2)"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Add+'" id="add" onClick="doSubmit(1)">')</script></td></tr>
</table>
</form>

<table border=0 width="100%" id="div_multiaplist">
<tr><td colspan="4"><b><script>dw(MM_MultiApTbl)</script>&nbsp;<script>dw(JS_msg89)</script></b></td></tr>
<tr><td colspan="4" height="1" class="line"></td></tr>
<tr><td colspan="4" height="2"></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_Ssid)</script></b></td>
<td class="item_center"><b><script>dw(MM_SecurityMode)</script></b></td>
<td class="item_center"><b><script>dw(MM_Select)</script></b></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_Delete+'" id="delsel" onClick="doSubmit(0)">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="button" value="'+BT_Reset+'" id="delreset" onClick="resetForm()">')</script></td></tr>
</table> 
</td></tr></table>
</div>

<div id="div_wait" style="display:none">
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_ChangeSetting)</script></td></tr>
<tr><td height="1" class="line"></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><script>dw(JS_msg75)</script></td></tr>
<tr><td><script>dw(MM_PleaseWait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
</table></td></tr></table>
</div>
</body></html>