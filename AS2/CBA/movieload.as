
function materialize(a:String, b:MovieClip):MovieClip{
	var mm:MovieClip 	= eval(a);
	if(b){
		mm				= eval(b+"."+a);
	}
	return mm;
}

function createemptyclip(a:MovieClip, b:String):Void{
	a.createEmptyMovieClip(b, getmaxdepth(a));
}

function createmovieclip(a:MovieClip, b:String):MovieClip{
	var tmps:Array			= qload(a, b, 1);
	var prop:MovieClip 		= tmps[0];
	return prop;
}	
