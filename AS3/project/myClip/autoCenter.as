package project.myClip{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.*;
	import dload.dLoader;
	
	public class autoCenter extends MovieClip{
		protected var w:Number			= 300;
		protected var h:Number			= 200;
		protected var myAlpha:Number	= 1;
		var cClip:*						= this;
		
		public function autoCenter():void{ dLoader.addList(cClip, {activated:initStage}); }
		
		private function initStage(a:Event):void{  }
		
		public function get _w():Number{ return this.w; }
		
		public function get _h():Number{ return this.h; }
		
		public function get _trans():Number{ return this.myAlpha; }
		
		public function set _w(a:Number):void{
			this.w						= a;
			dLoader.attr(this.backClip, {width:this.w});
		}
		
		public function set _h(a:Number):void{
			this.h						= a;
			dLoader.attr(this.backClip, {height:this.h});
		}
		
		public function set _trans(a:Number):void{
			this.myAlpha				= a;
			dLoader.attr(this.backClip, {alpha:this.myAlpha});
		}
	}
}