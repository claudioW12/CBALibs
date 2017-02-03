
function standarizerarray(b:Array, c:String):Array{
	var j:Number	= 0;
	var t:Number 	= b.length;
	for(j=0; j<t; j++){
		var fellowship:Array = xsplit(c, b[j]);
		b[j] = trim(fellowship[0]) + c + trim(fellowship[1]);
	}
	return b;
}

function setvaluearray(a:Array, b:Number, c):Array{
	var i:Number	= 0;
	for(i=0; i<b; i++){
		a[i]		= c;
	}
	return a;
}

function resetarray(a:Array, b:Number, c:String):Array{
	var i:Number	= 0;
	for(i=0; i<b; i++){
		a[i]		= c;
	}
	return a;
}

function newarray(a:Array):Array{
	var b:Array	= new Array();
	return b;
}

function shufflearray(a:Number, b:Array):Array{
	b					= newarray(b);
	var c:Number 		= 0;
	var i:Number		= 0;
	var rnum:Number 	= 0;
	var done:Boolean	= false;
	while (c<a) {
		rnum = Math.floor(Math.random()*a);
		for (i = 0; i<=a; i++) {
			if (b[i] == rnum) {
				done	= false;
				break;
			}else{
				done 	= true;
			}
		}
		if (done) {
			var pushed:Number = b.push(rnum);
			c++;
		}
	}
return b;
}

function locking(a:Array, b:Boolean):Void{
	var i:Number 			= 0;
	var t:Number 			= a.length;
	for(i=0; i<t; i++){
		a[i].enabled 		= b;
	}
}

function enabledess(a:Array, b:Boolean):Void{
	var i:Number			= 0;
	var t:Number 			= a.length;
	for(i=0;i<t;i++){
		a[i].enabled		= b;
		if(a[i].disabled){
			//a[i].enabled	= false;
		}
	}
}

function changeavailable(a:Array, b:Boolean):Void{
	var i:Number			= 0;
	var t:Number 			= a.length;
	for(i=0;i<t;i++){
		a[i].disabled 		= b;
	}
}

function noshufflearray(a:Number, b:Array):Array{
	var i:Number 			= 0;
	var t:Number			= a;
	b						= newarray(b);
	for(i=0; i<t; i++){
		b.push(i);
	}
	return b;
}

function gotoxclips(a:Array, b:String, c:Boolean):Void{
	var i:Number 			= 0;
	var t:Number 			= a.length;
	for(i=0; i<t; i++){
		goto(a[i], b, c);
	}
}

function goto(a:MovieClip, b:String, c:Boolean):Void{
	if(c){
		a.gotoAndPlay(b);
	}else{
		a.gotoAndStop(b);
	}
}

function tabindex(a:Array):Void{
	var i:Number	= 0 ;
	var t:Number 	= a.length;
	for(i=0; i<t; i++){
		a[i].tabEnabled		= true;
		a[i].tabIndex		= i;
		a[i].tabChildren	= true
	}
}
