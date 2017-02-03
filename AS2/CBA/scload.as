
if(!scalestage){
	var scalestage:String 	= "Scale";
}

if(alignstage){
	var alignstage:String 	= "TL";
}


Stage.scaleMode 		= scalestage;
Stage.align 			= alignstage;

var scalelistener:Object 	= new Object();

scalelistener.onResize	= function():Void{
	var a:Number 		= Stage.width;
	var b:Number 		= Stage.height;
	reescale(a, b);
}

if(detectionscale){
	Stage.addListener(scalelistener);
}
