package dload.security{
	
	import com.meychi.ascrypt3.Base64;
	
	public class base64{
		
		internal static const CRYPTO_KEY:String = "pedro";
		
		public static function encode(a:String):String{
			var base:Base64				= new Base64();
			return base.encode(a);
		}
		
		public static function decode(a:String):String{
			var base:Base64				= new Base64();
			return base.decode(a);
		}
	}
}
