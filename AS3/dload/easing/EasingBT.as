package dload.easing{
	import org.libspark.betweenas3.easing.*;
	
	import flash.events.*;
	
	public class EasingBT{
		
		public function EasingBT():void{
		}
		
		public static function setEase(effect:String, acceleration:String="InOut"):*{

			switch(acceleration.toLowerCase()){
				case "in":
					acceleration				= "In";
				break;
				case "out":
					acceleration				= "Out";
				break;
				default:
					acceleration				= "InOut";
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
				
				case "circular":
					return Circular["ease"+acceleration];
				break;
				
				case "cubic":
					return Cubic["ease"+acceleration];
				break;
				
				case "custom":
					return Custom["ease"+acceleration];
				break;
		
				case "elastic":
					return Elastic["ease"+acceleration];
				break;
				
				case "expo":
					return Expo["ease"+acceleration];
				break;
				
				case "exponential":
					return Exponential["ease"+acceleration];
				break;
		
				case "linear":
					return Linear["ease"+acceleration];
				break;
		
				case "physical":
					return Physical["ease"+acceleration];
				break;
				
				case "quad":
					return Quad["ease"+acceleration];
				break;
				
				case "quadratic":
					return Quadratic["ease"+acceleration];
				break;
				
				case "quart":
					return Quart["ease"+acceleration];
				break;
				
				case "quartic":
					return Quartic["ease"+acceleration];
				break;
				
				case "quint":
					return Quint["ease"+acceleration];
				break;
				
				case "quintic":
					return Quintic["ease"+acceleration];
				break;
				
				case "sine":
					return Sine["ease"+acceleration];
				break;
				
				default:
					return Linear["ease"+acceleration];
				break;
			}
			return null;
		}
	}
}