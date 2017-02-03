package dload.utils{
	
	import flash.display.*;
	import flash.text.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;	
	import flash.events.*;
	import dload.dLoader;
	
	public class Chrono{
		
		private var chronoSec:Number 			= 1000;
		public var turboTimer:Timer;
		private var endChrono:Function 			= null;
		private var stepByStep:Function			= null;
		private var autoStart:Boolean			= false;
		private var args:Array					= null;
		
		public function Chrono(obj:Object):void{
			setPropClip(this, obj);
			turboTimer							=  new Timer(1000, chronoSec);
			turboTimer.addEventListener(TimerEvent.TIMER, timerListener);
			turboTimer.addEventListener(TimerEvent.TIMER_COMPLETE, finTimer);
			if(autoStart) turboTimer.start();
		}
		
		public function startTimer():void{
			if(turboTimer!=null) turboTimer.start();
		}
		
		public function stopTimer():void{
			if(turboTimer!=null){
				turboTimer.stop();
				turboTimer							= null;
			}
		}
		
		public function pauseTimer():void{
			if(turboTimer!=null) turboTimer.stop();
		}
		
		public function currentTime():*{
			return turboTimer.currentCount;
		}
	
		private function setPropClip(clip:*, obj:Object):void{
			if(obj) for(var id:String in obj) clip[id] = obj[id];
		}		
		
		private function timerListener(a:TimerEvent):void{
			if(stepByStep!=null) stepByStep(a);
		}
		
		private function finTimer(a:TimerEvent):void{
			if(endChrono!=null) args ? dLoader.addMeth(endChrono, args) : endChrono(a);
		}
	}
}
