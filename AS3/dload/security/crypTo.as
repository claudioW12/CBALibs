package dload.security{
	
	import com.meychi.ascrypt3.TEA;
	
	public class crypTo{
		
		internal static const CRYPTO_KEY:String = "pedro";
		
		public static function encrypTo(a:String):String{
			var tea:TEA					= new TEA();
			return tea.encrypt(a, CRYPTO_KEY);
		}
		
		public static function decrypTo(a:String):String{
			var tea:TEA 				= new TEA();
			return tea.decrypt(a, CRYPTO_KEY);
		}
	}
}
