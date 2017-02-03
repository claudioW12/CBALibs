
function playback(a:String, b:Function):Void{
	stopAllSounds();
	/*
	var s:Sound 		= new Sound();
	var current:Number 	= 0;
	s.loadSound(a, c);
	
	s.onLoad=function(a:Boolean):Void{
		if(a && !c){
			s.start(1, 1);
		}
	}	
	
	s.onSoundComplete=function():Void{
		b();
	}
	*/
	currentsound = new Sound(this);
	currentsound.loadSound(a, true);
	currentsound.onSoundComplete=function(){
		b();
	}	
}

function loadsounds(a:String, b:MovieClip, c:MovieClip, d:String, e:Array):Void{
	stopAllSounds();
	stopingclipsound(c, true, e);
	currentsound = new Sound(this);
	currentsound.loadSound(a, true);
	currentsound.onSoundComplete=function(){
		b.gotoAndStop(d);
	}
}

function stopingclipsound(a:MovieClip, b:Boolean, c:Array):Void{
	var i:Number	= 0;
	var t:Number 	= c.length;
	for(i=0; i<t; i++){
		if(c[i]!=a){
			c[i].signal.gotoAndStop(1);
			c[i].player.gotoAndStop(1);
			c[i].player.enabled=b;
		}else{
			c[i].signal.gotoAndPlay(1);
		}
	}
}

