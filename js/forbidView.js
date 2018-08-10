var cur_id=0;
var cur_sub_id=0;
var unfold_1 = 0;
var icon_1 = 0;
function Node(id, pid, name, url, unfold, icon){
	this.id=id;
	this.pid=pid;
	this.name=name;
	this.url=url;
	this.unfold = unfold;
	this.icon =icon;
}

function Menu(objName){
	this.obj=objName;
	this.aNodes=[];
}

// Adds a new node to the node array
Menu.prototype.add=function(id, pid, name, url, unfold, icon){   
    this.aNodes[this.aNodes.length]=new Node(id, pid, name,url, unfold, icon);
}

Menu.prototype.toString=function(){
    var str='';
  
    var n=0;
    var id='';
    var pid='';
    var name='';
    var url=''; 
	var unfold='';
	var icon='';
	for (n; n<this.aNodes.length; n++){
        id=this.aNodes[n].id;
        pid=this.aNodes[n].pid;
        name=this.aNodes[n].name;
        url=this.aNodes[n].url;
        unfold = this.aNodes[n].unfold;
		icon = this.aNodes[n].icon;
		
        if(pid==0)
        {
            str += "<A href=";
            str += url;
            str += " target = view";
			str += "><div id =";
            str += id;
			if(unfold == 0)
				str += "  class=left_title onmouseover=My_T_Over(";
			else
				str += "  class=left_title1 onmouseover=My_T_Over(";
            str += id;
			str += ",";
			str += unfold;
			str += ",";
			str += icon;
            str += ")";
            str += " onmouseout=My_T_Out(";
            str += id;
			str += ",";
			str += unfold;
			str += ",";
			str += icon;
            str += ")";
            str += " onclick=My_Open_T(";
            str += id;
			str += ",";
			str += unfold;
			str += ",";
			str += icon;
            str += ")>";
			str += "<ul style='clear:both;'><li style='float:left;height:34px;'>";
			str += "<img id=";
			str += "img"+id;
			str += " src=\"style/"+icon+".png\" border=\"0\">";
			str += "</li>";
			str += "<li>";	
            str += name;
			str += "</li></ul>";
            str += "</div></A><ul id=submenu_";
            str += id;
            str += " class=dis >";
            str += "</ul>";
        }
        else
        {
            str = str.substring(0, str.length-5);
            str += "<li style='clear:left;' id=";
            str += id;
            str += "  class=left_link";
            str += ">";
            str += "<img src='style/submenu.png' algin='absmiddle'>&nbsp;&nbsp;<A href=";
            str += url;
            aid=id+"01";
            str += " id=";
            str += aid;
			str += " onclick='return My_Open_A(";
            str += id;
            str += ",";
            str += aid;	
			str += ")'";
			str += " hidefocus";
            str += " target=view> ";
            str += name;
            str += "</A>";
            str += "</li>";
            str += "</ul>";     
        }
    }
    return str;
}

function My_T_Over(id,unfold,icon)
{
    var x=document.getElementById(id);
	if(unfold==0)
	{
		document.getElementById("img"+id).src="style/"+icon+".png";
		x.className="left_title_over3";
	}
	else
	{
		if(cur_sub_id && (cur_id == id))
			x.className="left_title_over2";
		else
			x.className="left_title_over1";
	}
}

function My_T_Out(id,unfold,icon)
{
    var x=document.getElementById(id);
    if(cur_id==id)
    {
		if(unfold == 0)
		{	
			document.getElementById("img"+id).src="style/"+icon+"_ON.png";
			x.className= "left_title_out3";
		}
		else
		{
			if (0==cur_sub_id && unfold == 1)
				x.className= "left_title1";
			else
				x.className= "left_title_out2";
		}
    }
    else
    {
		if(unfold == 0)
			x.className= "left_title";
		else
			x.className= "left_title1";
    }
}

function My_Open_T(id,unfold,icon){  
    localStorage.languageDiv_flag=1;
    var subnode;
    if(cur_id != id){
        if(cur_id != 0)
        {			
			if (cur_sub_id != 0)
            {
				try{subnode=document.getElementById(cur_sub_id + "01");
					subnode.style.color = "";
					subnode.style.fontWeight = "";
				}catch(e){};
            }
			
          	try{document.getElementById("submenu_"+cur_id).className="dis";}catch(e){};
		  	
			if(unfold_1 == 0)
			{
				try{document.getElementById(cur_id).className="left_title";}catch(e){};
		  	}
			else
			{
				try{document.getElementById(cur_id).className="left_title1";}catch(e){};
			}
        }
        
        try{document.getElementById("submenu_"+id).className="block";}catch(e){};
		
		if(unfold == 0)
		{   
			if(cur_id != 0)
			{
				try{document.getElementById("img"+cur_id).src="style/"+icon_1+".png";}catch(e){};
			}
			try{document.getElementById("img"+id).src="style/"+icon+"_ON.png";}catch(e){};
			try{document.getElementById(id).className ="left_title_out3";}catch(e){};
		}
		else 
		{
			if(cur_id != 0)
			{
				try{document.getElementById("img"+cur_id).src="style/"+icon_1+".png";}catch(e){};
			}
			try{document.getElementById("img"+id).src="style/"+icon+"_ON.png";}catch(e){};
			try{document.getElementById(id).className ="left_title_over2";}catch(e){};
		}
		
        cur_id =id;
        cur_sub_id =cur_id+"01";
		unfold_1 =unfold;
		icon_1 =icon;
        try{subnode=document.getElementById(cur_sub_id + "01");
			if (subnode != null)
			{
				subnode.style.color = "#0095c5";
				subnode.style.fontWeight = "700";
			}
			else
			{
				cur_sub_id=0;
			}
		}catch(e){};
    }
	else
	{
		var x=document.getElementById(id);
		if(unfold == 0)
		{
			if(x.className = "left_title")
				x.className = "left_title_out3";
			try{document.getElementById("img"+id).src="style/"+icon+"_ON.png";}catch(e){};
		}
		else
		{
			if(cur_id != 0)
			{
				if(cur_id==id && 0==cur_sub_id)
				{
					try{document.getElementById("submenu_"+id).className="block";}catch(e){};
					
					if(unfold == 0)
					{
						;
					}
					else
					{
						try{document.getElementById(id).className ="left_title_over2";}catch(e){};
						try{document.getElementById("img"+id).src="style/"+icon+"_ON.png";}catch(e){};
					}
					
					cur_id =id;
					cur_sub_id =cur_id+"01";
					unfold_1 =unfold;
					icon_1 =icon;
					try{subnode=document.getElementById(cur_sub_id + "01");
						if (subnode != null)
						{
							subnode.style.color = "#0095c5";
							subnode.style.fontWeight = "700";
						}
						else
						{
							cur_sub_id=0;
						}
					}catch(e){};
				}
				else
				{
					if (cur_sub_id != 0)
					{
						try{subnode=document.getElementById(cur_sub_id + "01");
						subnode.style.color = "";
						subnode.style.fontWeight = "";}catch(e){};
						
						if(cur_id != 0)
						{
							try{document.getElementById("img"+cur_id).src="style/"+icon_1+".png";}catch(e){};
						}
						
					}
					
					try{document.getElementById("submenu_"+cur_id).className="dis";}catch(e){};
					try{document.getElementById(cur_id).className="left_title1";}catch(e){};
					cur_sub_id=0;
				}
			}
		}
	}
	var x=document.getElementById(id);
	x.parentNode.href=addTimestamp(x.parentNode.href);
}

function addTimestamp(url){
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

function My_Open_A(id,aid){  
    localStorage.languageDiv_flag=1;
    var x=document.getElementById(aid);
	if('999' == id){
		if(confirm(JS_logout)){
			clearCookie(document.cookie.split("=")[0]);
			//top.location.href='/login.asp';
			parent.location.href='/formLogoutAll.htm';
		}
		return false;
	}
    if(cur_sub_id!=0){
        var old=document.getElementById(cur_sub_id + "01");
        old.style.color="";
        old.style.fontWeight="";
		old.style.textDecoration="none";
    }
	if(id=='90301') counts=0;
    x.style.color="#0095c5";
    x.style.fontWeight="700";
	x.style.textDecoration="underline";
	x.href=addTimestamp(x.href);
    cur_sub_id=id;
}

///////////////////////////////////////
function addEventHandler(target, type, func){
	if (target.addEventListener) 
		target.addEventListener(type, func, false);
	else if (target.attachEvent) 
		target.attachEvent("on" + type, func);
	else 
		target["on" + type]=func;
}

var stopEvent=function(e){
    e=e || window.event;
    if(e.preventDefault){
      	e.preventDefault();
      	e.stopPropagation();
    }else{
      	e.returnValue=false;
      	e.cancelBubble=true;
    }
}
  
function clearCookie(name){    
 	setCookie(name, "", -1);    
}    
   
function setCookie(name, value, seconds){    
	seconds=seconds || 0;      
	var expires="";    
	if (seconds != 0 ){   
		var date=new Date();    
		date.setTime(date.getTime()+(seconds*1000));    
		expires="; expires="+date.toGMTString();    
	}    
 	document.cookie=name+"="+escape(value)+expires+"; path=/";  
} 
