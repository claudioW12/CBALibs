package project.myClip{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.*;
	import dload.dLoader;
	
	public class loaderClip extends MovieClip{
		protected var widther:Number	= 300;
		protected var higher:Number		= 200;
		protected var myAlpha:Number	= 1;
		var cClip:*						= this;
		var texto:TextField 			= null;
		
		var addClip:String 				= Event.ADDED;
		var remClip:String 				= Event.REMOVED_FROM_STAGE;
		var fpsClip:String 				= Event.ENTER_FRAME;
		
		public function loaderClip():void{ dLoader.addList(cClip, {addedToStage:initStage}); }
		
		private function initStage(a:Event):void{
			texto						= centerClip.texto;
			dLoader.attr(texto, {embedFonts:true});
			cClip.addEventListener(addClip, added);
			cClip.addEventListener(fpsClip, analizaFrame);
			cClip.addEventListener(remClip, removed);
		}
		
		public function get _w():Number{ return this.widther; }
		
		public function get _h():Number{ return this.higher; }
		
		public function get _trans():Number{ return this.myAlpha; }
		
		public function w(a:Number):*{
			this.widther				= a;
			dLoader.attr(this.backClip, {width:this.widther});
			return this;
		}
		
		public function h(a:Number):*{
			this.higher					= a;
			dLoader.attr(this.backClip, {height:this.higher});
			return this;
		}
		
		public function full(anc:int, alt:int):*{
			return w(anc).h(alt);
		}
	
		public function set _w(a:Number):*{
			this.widther				= a;
			dLoader.attr(this.backClip, {width:this.widther});
			return this;
		}
		
		public function set _h(a:Number):*{
			this.higher						= a;
			dLoader.attr(this.backClip, {height:this.higher});
			return this;
		}
		
		public function set _trans(a:Number):void{
			this.myAlpha				= a;
			dLoader.attr(this.backClip, {alpha:this.myAlpha});
		}
		
		private function added(a:Event):void{
			cClip.removeEventListener(addClip, added);
		}
		
		private function removed(a:Event):void{
			cClip.removeEventListener(remClip, removed);
			cClip.removeEventListener(fpsClip, analizaFrame);
			delete this;
		}
		
		private function analizaFrame(a:Event):void{
			var clip:MovieClip 		= a.currentTarget as MovieClip;
			var cur:uint			= clip.currentFrame;
			dLoader.attr(texto, {text:cur+"%"});
			centerClip.gotoAndStop(cur);
		}
	}
}