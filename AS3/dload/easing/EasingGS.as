package dload.easing{
	import com.greensock.easing.*;
	import fl.transitions.easing.None;
	import fl.transitions.easing.Regular;
	
	import flash.events.*;
	
	public class EasingGS{
		
		public function EasingGS():void{
		}
		
		public static function setEase(effect:String, acceleration:String="InOut"):*{
			switch(acceleration.toLowerCase()){
				case "in":
					acceleration							= "In";
				break;
				case "out":
					acceleration							= "Out";
				break;
				default:
					acceleration							= "InOut";
				break;
			}

			switch(effect.toLowerCase()){
				case "back":
					return Back["ease"+acceleration];
				break;
				
				case "bounce":
					return Bounce["ease"+acceleration];
				break;
		
				case "circ":
					return Circ["ease"+acceleration];
				break;
				
				case "cubic":
					return Cubic["ease"+acceleration];
				break;
				
				case "easelookup":
					return EaseLookup["ease"+acceleration];
				break;
		
				case "elastic":
					return Elastic["ease"+acceleration];
				break;
				
				case "expo":
					return Expo["ease"+acceleration];
				break;
		
				case "fastease":
					return FastEase["ease"+acceleration];
				break;
		
				case "linear":
					return Linear["ease"+acceleration];
				break;
		
				case "quad":
					return Quad["ease"+acceleration];
				break;
				
				case "quart":
					return Quart["ease"+acceleration];
				break;
				
				case "quint":
					return Quint["ease"+acceleration];
				break;
				
				case "regular":
					return Regular["ease"+acceleration];
				break;
				
				case "roughease":
					return RoughEase["ease"+acceleration];
				break;
		
				case "sine":
					return Sine["ease"+acceleration];
				break;
				
				case "strong":
					return Strong["ease"+acceleration];
				break;
				
				default:
					return None["ease"+acceleration];
				break;
			}
			return null;
		}
	}
}