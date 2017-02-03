
function getrealpath(a:MovieClip):String{
	var path:String			= unescape(getabsoluteurl(a));
	var pathurl:Array      	= xsplit(".swf", path);
	var backstring:String	= pathurl[0];
	var tmp:Array			= xsplit("/", backstring);
	var returnchain:String	= tmp[tmp.length-1];
	return returnchain;			
}

function getabsoluteurl(a:MovieClip):String {			
	return (a._url);
}

