package project.myClip{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.*;
	import dload.dLoader;
	
	public class loaderClip extends MovieClip{
		protected var w:Number			= 300;
		protected var h:Number			= 200;
		protected var myAlpha:Number	= 1;
		var cClip:*						= this;
		var texto:TextField 			= null;
		
		var addClip:String 				= Event.ADDED;
		var remClip:String 				= Event.REMOVED_FROM_STAGE;
		var fpsClip:String 				= Event.ENTER_FRAME;
		
		public function loaderClip():void{ dLoader.addList(cClip, {addedToStage:initStage}); }
		
		private function initStage(a:Event):void{
			texto						= centerClip.texto;
			dLoader.setProp(texto, {embedFonts:true});
			cClip.addEventListener(addClip, added);
			cClip.addEventListener(fpsClip, analizaFrame);
			cClip.addEventListener(remClip, removed);
		}
		
		public function get _w():Number{ return this.w; }
		
		public function get _h():Number{ return this.h; }
		
		public function get _trans():Number{ return this.myAlpha; }
		
		public function set _w(a:Number):void{
			this.w						= a;
			dLoader.setProp(this.backClip, {width:this.w});
		}
		
		public function set _h(a:Number):void{
			this.h						= a;
			dLoader.setProp(this.backClip, {height:this.h});
		}
		
		public function set _trans(a:Number):void{
			this.myAlpha				= a;
			dLoader.setProp(this.backClip, {alpha:this.myAlpha});
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
			dLoader.setProp(texto, {text:cur+"%"});
			centerClip.gotoAndStop(cur);
		}
	}
}