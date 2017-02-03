package com.hdi.loaders{
 
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
 
	public class SimpleLoader{
 
		public var url:String;								//url string
		public var callback:Function = null;				//callback function or loading monitor - returns @percent (int 0 - 100), @tag (String from SimpleLoader)
		public var tag:String = "";							//tag string of loading item
		public var objName:String;							//object name for final loaded object
		public var objParent:Object;						//parent for final loaded object
		public var percent:int;								//percentage of loaded content
		private var ldr:Loader;								//loader class
 
		/**
		 * init
		 * @param parentObj: parent for loaded item
		 * @param contentURL: url path of content to load
		 * @param objectName: the target name of the final loaded object
		 * @param monFunction: function to callback with loader progress
		 * @param tagString: description or label of currently loading item
		 **/
		public function SimpleLoader(parentObj:Object, contentURL:String, objectName:String = "", monFunction:Function = null, tagString:String = ""){
 
			callback = monFunction;
			url = contentURL;
			objName = objectName;
			objParent = parentObj;
			tag = tagString;
 
			//load items and setup event listener
			ldr = new Loader();
			ldr.load(new URLRequest(contentURL));
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, loadingComplete);
			ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadingProgress);
		}
 
		/**
		 * on loading complete
		 * @param event: Event
		 **/
		private function loadingComplete(ev:Event):void{
 
			//add item to parent and add object name
			if(objParent != null){
				var obj:Object = ev.target.content;
				objParent.addChild(obj);
				if(objName.length > 0){
					objParent[objName] = obj;
				}
				ldr.unload();
			}
 
			//set percent to 100 and callback
			percent = 100;
			if(callback != null){
				callback(100, tag);
			}
 
			//remove event listeners
			if(ev.target.hasEventListener(Event.COMPLETE)){
				ev.target.removeEventListener(Event.COMPLETE, loadingComplete);
			}
			if(ev.target.hasEventListener(ProgressEvent.PROGRESS)){
				ev.target.removeEventListener(ProgressEvent.PROGRESS, loadingProgress);
			}
		}
 
		/**
		 * on loading progress
		 * @param event: ProgressEvent
		 **/
		private function loadingProgress(ev:ProgressEvent):void{
 
			//update percent
			percent = Math.floor((ev.bytesLoaded / ev.bytesTotal)*100);
			if(callback != null){
 
				//callback updated percentage
				if(percent < 100){
					callback(percent, tag);
				}
			}
		}
	}
}
