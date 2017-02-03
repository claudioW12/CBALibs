package dload.fx{
	
	import dload.*;
	import com.greensock.*;
	import flash.display.*;	
	
	public class motionSerial{
		
		public var xClips:Array		= [];
		public var fxSec:Number		= 1;
		public var fxSerial:Object	= {};
		public var fxClip:Object	= {};
		public var fxEnd:Function	= null;
		public var delay:Number 	= 0.2;

		public function motionSerial(obj:Object):void{
			dLoader.setProp(this, obj);
			initSerial();
		}
		
		public function initSerial():void{
			var myTimeline:TimelineMax	= new TimelineMax({onComplete:endSerialize});
			var tmp:Array				= [];
			for each (var clip:MovieClip in xClips){
				if(fxClip!=null){
					dLoader.setProp(fxSerial, fxClip);
					dLoader.setProp(fxSerial, {onCompleteParams:[clip]});
				}
				var t1:TweenMax			= new TweenMax(clip, fxSec, fxSerial);
				tmp.push(t1);
			}
			myTimeline.insertMultiple(tmp, 0, TweenAlign.START, delay);
		}
		
		private function endSerialize():void{
			if(fxEnd!=null){
				fxEnd(xClips);
			}
		}
	}
}