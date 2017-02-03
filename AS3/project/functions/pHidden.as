package project.functions{

	import flash.display.*;
	import flash.display.MovieClip;
	import flash.display.Sprite; 
	import flash.display.Stage;
	
	public class pHidden extends MovieClip{

		public function pHidden():void{ }
		
		public static function isType(a:*, b:*):Boolean{
			return defParent(a) is b ? true: false;
		}
		
		public static function defParent(cClip:*):*{
			var rClip:*									= null;
			while(cClip && cClip is MovieClip){
				cClip 									= cClip.parent;
				rClip									= cClip;
			}
			return rClip;
		}				

		public static function evalProp(clip:*, obj:Object):void{
			if(obj){
				for(var id:String in obj){
					var val:Object 						= obj[id]; 
					if(clip[id] is Function) clip[id](val);
						else clip[id]					= val;
				}
			}	
		}
		
	}
}