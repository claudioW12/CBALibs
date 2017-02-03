package dload.fx{
	import com.greensock.*;
	import flash.display.*;
	import dload.*;
	
	public class yoyoClip extends MovieClip{
		
		public var permitedYoyo:Boolean				= true;
		public var finYoyo:Function					= null;
		private var startYoyo:Boolean				= true;
		public var fxYoyo:Object					= this;
		public var fps:Number						= 1;
		
		function yoyoClip(a:MovieClip, b:Object=null):void{
			dLoader.attr(this, b);
			thisYoyo(a);
		}
		
		function thisYoyo(a:MovieClip):void{
			var clip:MovieClip 				= a;
			var toAlpha:Number 				= 0;
			clip.alpha==0 ?  toAlpha = 1: toAlpha = 0;
			if(permitedYoyo){
				TweenMax.to(clip, 1, {alpha:toAlpha, onComplete:thisYoyo, onCompleteParams:[clip], ease:dLoader.setEaseGS("none")});
			}
			if(startYoyo){
				startYoyo					= !startYoyo;
			}else{
				if(finYoyo!=null){
					finYoyo(clip, toAlpha, fxYoyo);
				}
			}
		}
	}
}