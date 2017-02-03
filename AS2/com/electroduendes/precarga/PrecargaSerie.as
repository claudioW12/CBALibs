import com.gskinner.events.GDispatcher;
import mx.utils.Delegate;
class com.electroduendes.precarga.PrecargaSerie {
	private var numCargados:Number 		= 0;
	private var actualProgress:Number 	= 0;
	private var actualTotal:Number 		= 0;
	private var actualPercent:Number 	= 0;
	private var actualTarget:MovieClip 	= null;
	private var urlArray:Array			= new Array();
	private var targetArray:Array		= new Array();
	private var interval:Number 		= 0;
	var dispatchEvent:Function;
	var addEventListener:Function;
	var removeEventListener:Function;
	
	function PrecargaSerie(){
		GDispatcher.initialize(this);
	}

	function loadClips(urlArray:Array, targetArray:Array, type:String) {
 
			this.urlArray = urlArray;
			this.targetArray = targetArray;
			load();
	}

	private function load():Void {
		targetArray[numCargados].loadMovie(urlArray[numCargados]);
		actualTarget = targetArray[numCargados];
		interval = setInterval(Delegate.create(this, loadStart), 50);
	}

	private function loadStart():Void {
		actualProgress = targetArray[numCargados].getBytesLoaded();
		if (actualProgress>=0) {
			clearInterval(interval);
			onLoadActualStart();
			interval = setInterval(Delegate.create(this,onLoadProgress), 50);
		}
	}

	private function onLoadProgress():Void {
		actualProgress 	= actualTarget.getBytesLoaded();
		actualTotal 	= actualTarget.getBytesTotal();
		actualPercent 	= int((actualProgress*100)/actualTotal);
 
		var eventObj:Object = { type:"onLoadProgress", 
					mc:MovieClip, 
					progress:Number, 
					total:Number,
					percent:Number
					};
		eventObj.mc 		= actualTarget;
		eventObj.progress 	= actualProgress;
		eventObj.total 		= actualTotal;
		eventObj.percent 	= actualPercent;
 
	  	dispatchEvent(eventObj);
		if (actualPercent>=100) {
			clearInterval(interval);
			actualProgress = 0;
			numCargados++;
			onLoadActualComplete(actualTarget);
			if (numCargados<targetarray .length) {
				load();
			} else {
				onLoadAllComplete();
			}
		}
	}

	public function onLoadActualStart():Void {
		var eventObj:Object = {type:"onLoadActualStart", mc:MovieClip};
		eventObj.mc 		= actualTarget;
		dispatchEvent(eventObj);
	}

	private function onLoadActualComplete(ref:Object):Void {
		var eventObj:Object = {type:"onLoadActualComplete", mc:Object};
	  	eventObj.mc 		= actualTarget;
	  	dispatchEvent(eventObj);		
	}

	private function onLoadAllComplete():Void {	
		var eventObj:Object = {type:"onLoadAllComplete"};
	  	dispatchEvent(eventObj);
	}

	public function getTargetArray():Array {
		return targetArray.slice();
	}
	
}