package com.hdi.loaders{
 
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.MovieClip
 
	public class LoaderCollection extends MovieClip {
 
		public var loaderList:Array = [];								//array of added loaders
		private var callbackFunc:Function = null;						//function to callback on loader updates - returns @percent (int 0 - 100), @tag (String from SimpleLoader)
		public var percent:int;											//@percent (int 0 - 100)
		public var tag:String = "";										//@tag (String from SimpleLoader) currently loading item tag
		var index:int;													//index of loading items in loaderList;
		/**
		 * init
		 * @param callback: funciton to call on loader updates
		 **/
		public function LoaderCollection(callback:Function):void{
			callbackFunc = callback;
			this.addEventListener(Event.ENTER_FRAME, loaderHandler);
		}
 
		/**
		 * add SimpleLoader instance to LoaderCollection
		 * @param loader: SimpleLoader
		 **/
		public function addSimpleLoader(loader:SimpleLoader):void{
			loaderList.push(loader);
		}
 
		/**
		 * add Loader instance to LoaderCollection
		 * @param loader: Loader
		 **/
		public function addLoader(loader:Loader):void{
			loaderList.push(loader);
		}
 
		/**
		 * stop loader updates and cleanup eventlisteners
		 **/
		public function cleanup():void{
			if(this.hasEventListener(Event.ENTER_FRAME)){
				this.removeEventListener(Event.ENTER_FRAME, loaderHandler);
			}
			loaderList = [];						//reset loaderList
		}
 
		/**
		 * figure out average percent of all loading items
		 * @param event: Event
		 **/
		private function loaderHandler(ev:Event):void{
			//trace(this.name);
 
			var perc:int = 0;						//average percent of loaded items
			var ldrs:int = loaderList.length;		//number of currently loading items
			var inc:int;							//percent loaded of loader
 
			//has loading items
			if(loaderList.length > 0){
 
				var ldr:* = loaderList[index];			//loading item
 
				// update tag if SimpleLoader
				if(ldr is SimpleLoader){
					tag = ldr.tag;
				}
 
				for(var p:String in loaderList){
					ldr = loaderList[p];			//loading item
					inc = 0;
 
					//update percent increment
					if(ldr is SimpleLoader){
						inc = ldr.percent;
					}
					else{
						if(ldr.contentLoaderInfo != null){
							inc = Math.floor((ldr.contentLoaderInfo.bytesLoaded/ldr.contentLoaderInfo.bytesTotal)*100);
						}
					}
 
					if(inc > percent && inc < 100){
						index = int(p);
					}
 
					//update percentage
					perc += inc;
 
					//clear fully loaded items
					if(inc == 100){
						//loaderList.splice(int(p),1);
					}
				}
 
				//update percentage and callback updated loading info
				percent = Math.floor(perc/ldrs);
				callbackFunc(percent, tag);
 
				//cleanup Collection once all items are loaded
				if(percent == 100){
					cleanup();
				}
			}
		}
	}
}
