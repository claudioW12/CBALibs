package dload{
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import dload.MouseEvents;
	import flash.display.*;
	
	public class dragOut{
		private var releaseOutSide:Function = null;
		
		public function dragOut(obj:*, list:Function=null){
			releaseOutSide					= list;
//			var oros:MouseEvents			= new MouseEvents(obj);
			if(obj!=null) obj.addEventListener(MouseEvents.RELEASE_OUTSIDE, releaseOut);
		}
		
		private function releaseOut(a:*){
			if(releaseOutSide!=null) if(a.target.enabled) releaseOutSide(a);
		}
	}
}