
function xsplit(sep:String, xstring:String):Array{
	var a:Array	= xstring.split(sep);
	return a;
}

Array.prototype.isthere = function(str:String):Boolean {
	return isthere(this, str);
}

function isthere(b:Array, a:String):Boolean{
	var is_here:Boolean	= false;
	var i:Number		= 0;
	for(i=0;i<b.length;i++){
		if(uppercase(a)==uppercase(b[i])){
			is_here=true;
			break;
		}
	}
	return is_here;
}

function trim(a:String):String {
	var i:Number	= 0;
	var j:Number	= 0;
	for(i=0; a.charCodeAt(i)<33; i++);
		for(j=a.length-1; a.charCodeAt(j)<33; j--);
			return a.substring(i, j+1);
}

function uppercase(a:String):String{
	a.toUpperCase();
	return a;
}

function defvalun(a:MovieClip, b:MovieClip):MovieClip{
	return (!a) ? b : a;
}

Array.prototype.copy = function(a:Number, b:Number):Array{
	return arraycopy(this, a, b);
}

function arraycopy(xarray:Array, a:Number, b:Number):Array {
	var arnew:Array = new Array();
	var pis:Number 	= 0;
	var pos:Number	= 0;
	var i:Number	= 0; 
	if ((a) && (b)) {
		pis = a;
		pos = b+1;
	} else {
		if ((a == undefined) && (b == undefined)) {
			pis = 0;
			pos = xarray.length;
		} else {
			if (a) {
				pis = a;
				pos = xarray.length;
			} else {
				pis = 0;
				pos = b+1;
			}
		}
	}
	for (i=pis;i<pos;i++) {
		arnew.push(xarray[i]);
	}
	return arnew;
}

function replacetext(a:String,b:String,c:String,d:String):String {
	var tag:Array			= d.split(",");
	var index:Number 		= c.lastIndexOf(b);
	var sidea:String 		= c.substr(0, index);
	var begin:Number		= index+b.length;
	var ending:Number		= c.length-begin;
	var sideb:String 		= c.substr(begin, ending);
	var i:Number			= 0;
	var j:Number			= 0;
	var begintag:String		= "";
	var endingtag:String	= "";
	if(d){
		for(i=0,j=(tag.length-1);i<tag.length;i++,j--){
			begintag+="<"+tag[i]+">";
			endingtag+="</"+tag[j]+">";
		}
	}
	var devuelto:String	= sidea+begintag+a+endingtag+sideb;
	return devuelto;
}

function firstuppercase(a:String):String{
	var counter:Number 		= a.length;
	var firstchar:String 	= a.charAt(0);
	var sideb:String 		= a.substr(1, counter);
	var newstring:String 	= firstchar.toUpperCase()+sideb;
	return newstring;
}

/*a ACTIONSCRIPT3*/
function changetxt(a:TextField, b:Boolean, c:Function):Void{
	var listenerch:Object 	= new Object();
	listenerch.onChanged = function(a:TextField){
		var sm:String		= trim(a.text);
		if(sm){
			b				= true;
		}else{
			b				= false;
		}
		c(b);
	}
	a.addListener(listenerch);
}