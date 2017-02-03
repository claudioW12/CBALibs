package dload{
	import flash.events.EventDispatcher;
	public class EventHandler extends EventDispatcher{
		public var eventList:Array				= [];
		private var myClip:*					= null;

		public function EventHandler(dispatcher:*){
			super();
			myClip								= dispatcher;
			if(myClip.myEvents) eventList = myClip.myEvents.eventList;
			else{
				eventList						= [];
				myClip.myEvents					= this;
			}
		}
	
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void{
			eventList.push({type:type, listener:listener});
			if(myClip.hasEventListener(type)){
				myClip.removeEventListener(type, listener);
			}
			myClip.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function removeEvent(type:*):void{
			if(type is Array){
				for each(var ss:String in type){
					removeEvent(ss);
				}
			}else{
				if(myClip.myEvents!=null){
					for each(var nObject:Object in eventList){
						if(nObject.type == type){
							myClip.removeEventListener(nObject.type, nObject.listener);
							eventList.splice(nObject, 1);
						}
					}
				}
			}
		}

		public function RemoveAll():void{
			for each(var obj:Object in eventList){
				myClip.removeEventListener(obj.type, obj.listener);
			}
			myClip.myEvents						= null;
			eventList = [];
		}
	}
}
