package project.autoEnabled{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.*;
	import dload.dLoader;
	
	public class autoEnabled extends MovieClip{
		protected var disabled:Boolean 	= false;
		protected var toggled:Boolean 	= false;
		public var aMin:Number 			= 0.5;
		public var aMax:Number 			= 1;
		var cClip:*						= this;
		
		public function autoenabbled():void{ dLoader.addList(cClip, {activated:initStage}); }
		
		private function initStage(a:Event):void{ }
		
		public function get enab():Boolean{ return this.enabled; }
		
		public function set enab(a:Boolean):void{ dLoader.setProp(this, {enabled:a, alpha:a ? aMax : aMin}); }
		
		public function get tog():Boolean{ return this.toggled; }
		
		public function set tog(a:Boolean):void{ dLoader.setProp(this, {toggled:a}); }
		
		public function get disab():Boolean{ return this.disabled; }
		
		public function set disab(a:Boolean):void{ dLoader.setProp(this, {disabled:a, alpha:!a ? aMax : aMin}); }
		
	}
}