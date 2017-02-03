package project.loaderClip{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.*;
	import dload.dLoader;
	import project.autoCenter.autoCenter;
	
	public class loaderClip extends autoCenter{
		var cClip:*						= this;
		var texto:TextField 			= null;
		
		var addClip:String 				= Event.ADDED;
		var remClip:String 				= Event.REMOVED_FROM_STAGE;
		var fpsClip:String 				= Event.ENTER_FRAME;
		
		public function loaderClip(_w:int=300, _h:int=200):void{
			super(_w, _h);
			dLoader.addList(cClip, {addedToStage:initStage});
			trace(this);
		}
		
		private function initStage(a:Event):void{
			//texto						= (centerClip!=null)?centerClip.texto:null;
			dLoader.attr(texto, {embedFonts:true});
			cClip.addEventListener(addClip, added);
			cClip.addEventListener(fpsClip, analizaFrame);
			cClip.addEventListener(remClip, removed);
		}
		
		private function added(a:Event):void{
			cClip.removeEventListener(addClip, added);
		}
		
		private function removed(a:Event):void{
			cClip.removeEventListener(remClip, removed);
			cClip.removeEventListener(fpsClip, analizaFrame);
		}
		
		private function analizaFrame(a:Event):void{
			var clip:MovieClip 		= a.currentTarget as MovieClip;
			var cur:uint			= clip.currentFrame;
			//if(texto != null) dLoader.setProp(texto, {text:cur+"%"});
			//centerClip.gotoAndStop(cur);
		}
	}
}