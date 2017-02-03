package TextoMatrix {
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	public class TextoMatrix {
		var abecedario:Array;
		var frase:String;
		var fraseArray:Array;
		var arraycapsuled:Array = new Array();
		var arraysNum:Number	= 0;
		var printtext:String	= "";
		var aleatorio:Number;
		var aleatoriofrase:String;
		var textscene:*;
		var tiempo:Timer;
		var detectar:MovieClip;
		var velocidadTexto:Number;
		var funcionmain:Function;
		var autocenter:Boolean	= false;
		
		public function TextoMatrix(a:*, b:String, c:Number, d:Function, e:Array, f:Boolean) {
			velocidadTexto 	= c;
			textscene		= a;
			frase			= b;
			funcionmain 	= d;
			abecedario		= e;
			autocenter		= f;
			fraseArray		= frase.split("");
			for each (var valor:* in fraseArray) {
				arraycapsuled.push({letra:valor, activada:false, letraRand:""});
			}
			detectar	= new MovieClip();
			tiempo		= new Timer(velocidadTexto, frase.length);
			tiempo.addEventListener(TimerEvent.TIMER, tiempoRecorre);
			tiempo.start();
			detectar.addEventListener(Event.ENTER_FRAME,verArray);
		}
		
		public function tiempoRecorre(e:TimerEvent):void {
			arraycapsuled[arraysNum].activada	= true;
			arraysNum++;
		}
		
		public function verArray(e:Event) {
			printtext	= "";
			var valor:*;
			for each (valor in arraycapsuled) {
				if(!valor.activada){
					aleatorio		= int(Math.random() * (abecedario.length-1));
					aleatoriofrase	= String(abecedario[aleatorio].toLowerCase());
					printtext		+= String(aleatoriofrase);
				}else{
					printtext		+= String(valor.letra);
				}
			}
			var ending:Boolean = true;
			for each (valor in arraycapsuled) {
				if (!valor.activada) {
					ending		= false;
					funcionmain(false, MovieClip(textscene.parent));
				}
			}
			if(ending){
				detectar.removeEventListener(Event.ENTER_FRAME,verArray);
				funcionmain(true,MovieClip(textscene.parent));
			}
			textscene.htmlText	=	printtext;
		}
	}
}