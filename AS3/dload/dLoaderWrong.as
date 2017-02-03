package dload{
	/*
	dLoader es una clase que agrupa funcionalidades de otras clases.
	Una ventaja es que evita importar N Librerías solo debo importar dLoader y utilizo sus métodos.
	Utiliza interpolación de movimiento de greensock TweenLite y su hermando mayor TweenMax.
	Maneja eventos complejos como evaluación de Listener en los clips.
	Método que simplifica ampliamente la manera en que pueden ser agregados los listener
		permite realizarlo solo en un par de líneas.
		permite quitar todos los listener.
		permite quitar solo uno.
		recolectar todos los clips con nombre en común.
	Version 1.3
	add new features:
		[args is Array or MovieClip]
		addList 
		setProp
		changeColor
		outSide
		removeClip
		dispelClip
		toFront
	Version 1.4
	optimized trim[bucles]
	*/
	
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;	
	import com.greensock.plugins.*;
	TweenPlugin.activate([MotionBlurPlugin]);
	
	import dload.EventHandler;
	import dload.dLoader;
	import dload.fx.*;
	import dload.utils.libColor;
	import dload.security.crypTo;
	import dload.security.base64;
	
	import dload.easing.EasingGS;
	import dload.easing.EasingBT;
	import dload.dragOut;
	
	import flash.display.*;
	import flash.display.InterpolationMethod;
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite; 
	import flash.display.Stage;
	
	import flash.events.*;
	import flash.events.Event;

	import flash.filters.DropShadowFilter; 
	import flash.filters.BitmapFilterQuality; 
	import flash.filters.BlurFilter; 

	import flash.geom.Matrix;

	import flash.media.Video;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import flash.net.*;
	import flash.net.sendToURL;	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import flash.system.Capabilities;
	
	import flash.text.*;
	import flash.text.TextField;
	
	import flash.ui.*;
	import flash.utils.*;
	
	public class dLoader extends MovieClip{
		
		public static var motionFinished:Function	= null;
		public static var motionChanged:Function	= null;
		public static var cList:Array				= libColor.colorList;
		
		public static var abc:Array 				= ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
		
		public static var debugger:Boolean			= false;
		public static var rootMovie:MovieClip		= null;
		
		public function dLoader():void{
			this.addEventListener(Event.ACTIVATE, addedToStage);
		}
		
		private function addedToStage(a:Event):void{
			if(debugger) trace("Dloader Activated")
		}
		
		public static function addList(arr:*, list:Object=null, prop:Object=null):void{
			if(arr is Array) for each (var clip:* in arr) addList(clip, list, prop);
			else{
				var cClip:*							= arr;
				setProp(cClip, prop);
				if(list) newList(new EventHandler(cClip), list);
			}
		}
		
		public static function addListenerButton(a:MovieClip, b:Object=null, c:Object=null):void{
			newList(a, b);
			setProp(a, c);
		}
		
		public static function newList(clip:*, obj:Object):void{
			if(obj) for(var id:String in obj) clip.addEventListener(id, obj[id]);
		}
		
		public static function setProp(arr:Object, obj:Object):void{
			if(arr is Array) for each (var clip:* in arr) setProp(clip, obj);
				else if(obj) for(var id:String in obj) arr[id] = obj[id];
		}
		
		public static function setMeth(arr:Object, obj:Object=null):void{
			if(arr is Array) for each (var clip:* in arr) setMeth(clip, obj);
				else if(obj) for(var id:String in obj) arr[id].apply(null, obj[id]);
		}
		
		public static function addMeth(func:Object, b:Object):void{
			func.apply(null, b);
		}
		
		public static function crProp(a:Array, b:Object=null, Arr:Array=null):void{
			for each (var clip:MovieClip in a){
				for(var id:String in b){
					var val:Object 						= b[id];
					clip[id]							= val;
					if(Arr!=null){
						if(isClass(val, Arr)){
							var clas:*					= getClass(val);
							var ss:*					= new clas();
							clip[id]					= ss;
						}
					}
				}		
			}
		}
		
		public static function isClass(val:Object, Arr:Array):Boolean{
			var cl:Class								= getClass(val);
			var done:Boolean							= false;
			var classes:Array 							= Arr;
			for each (var cla:* in classes){
				if(cla==cl){
					done								= true;
					break;
				}
			}
			return done;
		}
		
		public static function isType(a:*, b:*):Boolean{
			return defineParent(a) is b? true: false;
		}
		
		public static function defineParent(cClip:*):*{
			var rClip:*							= null;
			while(cClip && cClip is MovieClip){
				cClip 									= cClip.parent;
				rClip									= cClip;
			}
			return rClip;
		}				
		
		public static function getProp(a:Object, b:String="accessor"):void{
			var mainxml:XML						= describeType(a);
			var lista:XMLList					= mainxml.child(b);
			var total:uint						= lista.length();
			var i:uint							= 0;
			
			for(i=0; i<total; i++){
				var atributo:String 			= lista[i].attribute("name");
				var prop:*						= a[atributo];
				if(prop) if(prop!="") trace(atributo, "\t\n\t", a[atributo]);
			}
		}
		
		public static function returnClass(a:String):Class{
			return Class(getDefinitionByName(a));
		}		
		
		public static function getClass(a:Object):Class{
		  return Class(getDefinitionByName(getQualifiedClassName(a)) as Class);
		}		
		
		public static function getSuperClass(a:Object):Object{
			var n:String						= getQualifiedSuperclassName(a);
			if(n==null) return(null);
			return getDefinitionByName(n);
		}
		
		public static function getClassName(a:*):String{
			return getQualifiedClassName(a);
		}		
		
		public static function getDropper(a:*):*{
			var drop:*							= a.dropTarget;
			return drop;
		}		
		
		public static function qLoad(a:*, b:*, c:Number):Array{
			var arrayClips:Array 				= newArray(arrayClips);
			var i:uint							= 0;
			var nameClass:String 				= getClassName(b);
			for(i = 0; i<c; i++){
				var clip:*						= new b();
				addList(clip, {added:clipAdded, removed:clipRemoved, addedToStage:clipAddedStage, removedFromStage:clipRemovedStage},
								{events:null, master:a, name:nameClass+i, disabled:false, selfIndex:getMaxDepth(a)-1, selfWidth:clip.width, selfHeight:clip.height});
				addClip(a, clip);
				arrayClips.push(clip);
			}
			return arrayClips;
		}		
		
		public static function setEaseGS(a:String, b:String="InOut"):*{
			return EasingGS.setEase(a, b);
		}
		
		public static function setEaseBT(a:String, b:String="InOut"):*{
			return EasingBT.setEase(a, b);
		}
				
		public static function clipAdded(a:Event):void{
			var clip:MovieClip					= a.currentTarget as MovieClip;
		}
		
		public static function clipRemoved(a:Event):void{
			var clip:MovieClip					= a.currentTarget as MovieClip;
		}
		
		public static function clipAddedStage(a:Event):void{
			var clip:MovieClip					= a.currentTarget as MovieClip;
		}
		
		public static function clipRemovedStage(a:Event):void{
			var clip:MovieClip					= a.currentTarget as MovieClip;
		}

		public static function centerXY(a:*, b:Object=null):void{
			if(b) setProp(a, b);
		}		
		
		public static function centerX(a:*, b:int=0):void{
			setProp(a, {x:0-a.width/2});
			setProp(a, {x:a.x+b});
		}
		
		public static function centerY(a:*, b:int=0):void{
			setProp(a, {y:0-a.height/2});
			setProp(a, {y:a.y+b});
		}		
		
		public static function changeColor(arr:Object, sec:Number,  prop:Object):void{
			if(arr is Array) for each (var clip:MovieClip in arr) changeColor(clip, sec,  prop);
				else tMaxTo(arr, sec,  prop);
		}
		
		public static function tMaxTo(a:Object, c:Number,  b:Object):void{
			TweenMax.to(a, c, b);
		}
		
		public static function tMaxFromTo(arr:Object, sec:Number,  from:Object, to:Object):void{
			if(arr is Array) for each (var clip:* in arr) tMaxFromTo(clip, sec, from, to);
				else TweenMax.fromTo(arr, sec, from, to);
		}
		
		public static function tLiteTo(arr:Object, sec:Number,  prop:Object):void{
			if(arr is Array) for each (var clip:* in arr) tLiteTo(clip, sec, prop);
				else TweenLite.to(arr, sec, prop);
		}
		
		public static function serialLite(arr:Array, sec:Number, prop:Object):void{
			var timeline:TimelineLite = new TimelineLite();
			for each(var clip:MovieClip in arr) timeline.append(new TweenLite(clip, sec, prop));
		}
		
		public static function outSide(arr:Object, b:Function, c:Object=null, d:Object=null):void{
			if(arr is Array) for each (var clip:MovieClip in arr) outSide(clip, b, c, d)
			else{
				new dragOut(arr, b);
				addList(arr, c, d);
			}
		}
		
		public static function txtColor(a:TextField, b:Object, c:Number=0, d:Number=0):void{
			var fmt:TextFormat					= new TextFormat();
			fmt.color							= b;
			if((c==0)&&(d==0)) a.setTextFormat(fmt);
				else a.setTextFormat(fmt, c, d);
		}
		
		public static function addClip(par:*, chi:*):void{
			if(par && chi) par.addChild(chi);
		}
		
		public static function removClip(par:*, chi:*):void{
			if(par && chi) par.addChild(chi);
		}		
		
		public static function removeClip(arr:Object):void{
			if(arr is Array) for each (var clip:* in arr) removeClip(clip);
				else if(arr && arr.parent) arr.parent.removeChild(arr);
		}
								
		public static function goToAndPlay(arr:Object, sce:Object="off"):void{
			if(arr is Array) for each(var clip:MovieClip in arr) goToAndPlay(clip, sce);
				else arr.gotoAndPlay(sce);
		}
		
		public static function goToAndStop(arr:Object, sce:Object="off"):void{
			if(arr is Array) for each(var clip:MovieClip in arr) goToAndStop(clip, sce);
				else arr.gotoAndStop(sce);
		}
		
		public static function dispelClip(arr:*, b:Number, c:Object=null):void{
			if(arr is Array) for each (var clip:* in arr) dispelClip(clip, b, c);
				else tMaxTo(arr, b,  c);
		}
		
		public static function lightClip(a:Array, b:Array, c:Number, d:Object=null):void{
			dispelClip(expolarArray(b, a), c, d);
		}
		
		public static function getMaxDepth(a:*):Number{
			return  a.numChildren;
		}
		
		public static function toFront(arr:Object):void{
			if(arr is Array) for each (var clip:* in arr) toFront(clip);
				else addClip(arr.parent, arr as MovieClip);
		}
		
		public static function byNameFrom(a:MovieClip, b:String):Array{
			var i:uint 							= 0;
			var t:uint							= a.numChildren;
			var tmp:Array						= [];
			for(i=0; i<t; i++){
				var clip:MovieClip 				= isClip(b+i, a);
				if(clip){
					setProp(clip, {indexed:i});
					tmp.push(clip);
				}
			}
			return tmp;
		}		
				
		public static function dynamicClip(a:String, b:MovieClip):MovieClip{
			var clase:Class					= returnClass(a);
			var clipClase:MovieClip			= new clase();
			addClip(b, clipClase);
			return clipClase;
		}
				
		public static function changeDepth(a:*, b:Number):void{
			var pt:MovieClip					= a.parent as MovieClip;
			pt.setChildIndex(a, b);
		}		
		
		public static function shadowFilter(a:*, b:Number, c:Number):void{
			var shadowfx:DropShadowFilter 		= new DropShadowFilter(); 
			setProp(shadowfx, {distance:b, shadowfx:c});
			setProp(a, {filters:[shadowfx]});
		}
		
		public static function blurFilter(a:*, b:Number, c:Number):void{
			var blur:BlurFilter 				= new BlurFilter(); 
			setProp(blur, {blurX:b, blurY:c, quality:BitmapFilterQuality.HIGH});
			setProp(a, {filters:[blur]});
		}

		public static function encode(a:String):String{
			return base64.encode(a);
		}
		
		public static function decode(a:String):String{
			return base64.decode(a);
		}
		
		public static function encrypTo(a:String):String{
			return crypTo.encrypTo(a);
		}
		
		public static function decrypTo(a:String):String{
			return crypTo.decrypTo(a);
		}
			
		public static function xSplit(sep:String, xstring:String):Array{
			return xstring.split(sep);
		}

		public static function isThere(b:Array, a:String):Boolean{
			var done:Boolean					= false;
			for each (var str:* in b){ 
				if(uCase(a)==uCase(str)){
					done						= true;
					break;
				}
			} 							
			return done;
		}
		
		public static function colByName(a:String):Object{
			return libColor.colByName(a);
		}
		
		public static function hexByName(a:String):Object{
			return libColor.hexByName(a);
		}
		
		public static function colByIndex(a:uint):Object{
			return libColor.colByIndex(a);
		}
		
		public static function hexByIndex(a:uint):Object{
			return libColor.hexByIndex(a);
		}
		
		public static function replace(a:String, b:String, c:String):String{
			return a.split(b).join(c);
		}		
		
		public static function uCase(a:String):String{
			return a.toUpperCase();
		}
		
		public static function lCase(a:String):String{
			return a.toLowerCase();
		}		
		
		public static function defValun(a:*, b:*):*{
			return (!a)? b: a;
		}
		
		public static function insFirst(a:Array, b:*):Array{
			var done:Array						= [];
			done.push(b);
			for each(var obj:* in a) done.push(obj);
			return done;
		}		
		
		public static function arrayCopy(xarray:Array, a:Number=0, b:Number=0):Array{
			var arnew:Array 					= newArray(arnew);
			var pis:uint 						= 0;
			var pos:uint						= 0;
			var i:uint							= 0; 
			if((a)&&(b)){
				pis 							= a;
				pos 							= b+1;
			}else{
				if(!a && !b){
					pis 						= 0;
					pos 						= xarray.length;
				}else{
					if(a){
						pis 					= a;
						pos 					= xarray.length;
					}else{
						pis 					= 0;
						pos 					= b+1;
					}
				}
			}
			for(i=pis; i<pos; i++) arnew.push(xarray[i]);
			return arnew;
		}
		
		public static function firstUCase(a:String):String{
			var counter:Number 					= a.length;
			var firstchar:String 				= a.charAt(0);
			var sideb:String 					= a.substr(1, counter);
			return uCase(firstchar)+sideb;
		}

		public static function formaText(a:*, c:*, d:String="left", e:Number=12, f:Number=0, g:Number=0):void{
			var fuente:*						= new c();
			var formato:TextFormat 				= new TextFormat();
			var txt:* 							= a;
			setProp(formato, {font:fuente.fontName, size:e});
			setProp(txt, {autoSize:d, defaultTextFormat:formato, embedFonts:true, selectable:false, wordWrap:false, antiAliasType:"advanced", border:false, mouseEnabled:false, sharpness:f, thickness:g});
		}
		
		public static function trim(str:String, cad:String=" "):String{
			var char:String 					= cad;
			return trimBack(trimFront(str, char), char);
		}
		
		public static function trimFront(str:String, char:String):String{
			char 								= stringToCharacter(char);
			if(str.charAt(0)== char) str		= trimFront(str.substring(1), char);
			return str;
		}
		
		public static function trimBack(str:String, char:String):String{
			char 								= stringToCharacter(char);
			if(str.charAt(str.length - 1)== char) str = trimBack(str.substring(0, str.length - 1), char);
			return str;
		}
		
		public static function stringToCharacter(str:String):String{
			if(str.length == 1) return str;
			return str.slice(0, 1);
		}		
		
		public static function delStr(a:String, b:String):String{
			var i:uint							= 0;
			var arr:Array						= xSplit(b, a);
			var t:uint							= arr.length;
			var cad:String 						= "";
			for(i=0; i<t; i++) cad				+= arr[i];
			return cad;
		}		
		
		public static function toBool(a:*):Boolean{
			return (a == "1" || a == 1);
		}		
		
		public static function standarizerArray(b:Array, c:String):Array{
			var tmpArr:Array					= newArray(tmpArr);
			for each (var str:* in b){ 
				var tmp:Array 					= xSplit(c, str);
				tmpArr.push(tmp[0]+c+tmp[1]);
			} 
			return tmpArr;
		}
		
		public static function setArray(a:Array, b:Number, c:String):Array{
			var tmpArr:Array					= newArray(tmpArr);
			for each(var str:* in a) tmpArr.push(c);
			return tmpArr;
		}
		
		public static function resetArray(a:Array, b:Number, c:String):Array{
			var tmpArr:Array					= newArray(tmpArr);
			for each(var str:* in a) tmpArr.push(c);
			return tmpArr;
		}
		
		public static function newArray(a:Array):Array{
			return [];
		}
		
		public static function shuffleArray(a:Number, b:Array):Array{
			b									= newArray(b);
			var c:Number 						= 0;
			var i:Number						= 0;
			var rnum:Number 					= 0;
			var done:Boolean					= false;
			while(c<a){
				rnum 							= int(Math.random()*a);
				for(i = 0; i<=a; i++){
					if(b[i] == rnum){
						done					= false;
						break;
					}else done 					= true;
				}
				if(done){
					var pushed:Number			= b.push(rnum);
					++c;
				}
			}
			return b;
		}
		
		public static function noOrder(a:Array):Array{
			var i:uint							= 0;
			var t:uint							= a.length;
			var tmp:Array						= shuffleArray(t, tmp);
			var ret:Array						= newArray(ret);
			for(i=0; i<t; i++) ret.push(a[tmp[i]]);	
			return ret;
		}
		
		public static function revArray(a:Array):Array{
			return dLoader.arrayCopy(a, 0, 0).reverse();
		}
		
		public static function cloneObj(re0:Object):*{
			var newObj:ByteArray	= new ByteArray();
			newObj.writeObject(re0);
			newObj.position		= 0;
			return(newObj.readObject());
		}		
		
		public static function concatArray(a:Array, b:Array):Array{
			for each(var i:* in b) a.push(i);
			return a;
		}
		
		public static function expolarArray(moreArray:Array, smallArr:Array):Array{
			var retorn:Array					= newArray(retorn);
			var i:uint							= 0;
			var t:uint							= moreArray.length;
			smallArr							= uniqueKey(smallArr);
			if(isMay(t, smallArr.length)) for (i=0; i<t; i++) if(smallArr.indexOf(moreArray[i])==-1) retorn.push(moreArray[i]);
			return retorn;
		}
		
		public static function uniqueKey(arr:Array):Array{
			var n:uint				= 0;
			arr.sort();
			while(n<arr.length) (arr[n+1] == arr[n]) ? arr.splice(n, 1) : n++;
			return arr;
		}
		
		public static function changeAvailable(a:Array, b:Boolean):void{
			setProp(a, {enabled:b, disabled:!b});
		}
		
		public static function noShuffleArray(a:Number, b:Array):Array{
			var i:uint 							= 0;
			var t:uint							= a;
			b									= newArray(b);
			for(i=0; i<t; i++) b.push(i);
			return b;
		}
		
		public static function isNotCero(a:Number):Boolean{
			return a != 0;
		}				
		
		public static function absNumber(a:Number):Number{
			return a < 0 ? a * -1: a;
		}		
		
		public static function isMin(a:Number, b:Number):Boolean{
			return a < b;
		}		
		
		public static function equal(a:*, b:*):Boolean{
			return a == b;
		}

		public static function eqStrict(a:*, b:*):Boolean{
			return a === b;
		}
		
		public static function firstIsClassSecond(a:*, b:*):Boolean{
			return a is getClass(b);
		}
		
		public static function invertSigned(a:Number):Number{
			return a*-1;
		}
		
		public static function randomNumber(a:Number, b:Number):Number{
			return (Math.random()*(b-a)+a); 
		}
				
		public static function randomInt(a:Number, b:Number):int{
			return int((Math.random()*(b-a+1))+a);
		}
		
		public static function calcularAngulo(a:MovieClip, b:MovieClip):int{
			var angulo:Number 					= Math.atan2(a.y-b.y, a.x-b.x);
			return int(angulo*180/Math.PI);
		}
		
		public static function calcAprobated(a:Array, b:int=51):Boolean{
			var t:uint								= a.length;
			var bad:uint							= 0;
			var good:uint							= 0;
			var done:Boolean						= false;
			for each (var element:* in a){
				if(element) ++good;
					else ++bad;
			} 		
			var calculate:int						= (good*100)/t;
			return isMay(calculate, b);
		}		
		
		public static function isMay(a:Number, b:Number):Boolean{
			return a > b;
		}		
		
		public static function isPar(a:Number):Boolean{
		   return !(a%2);
		}
		
		public static function setVolumen(vol:Number, chan:SoundChannel):void{ 
			var transform:SoundTransform 			= chan.soundTransform; 
			transform.volume 						= vol ; 
			chan.soundTransform 					= transform; 
		} 		
		
		public static function setAllVolumen(val:Number):void{
			var transform:SoundTransform			= new SoundTransform();
			transform.volume						= val;
			flash.media.SoundMixer.soundTransform 	= transform;
		}		
		
		public static function isClip(a:String, b:*):*{
			return b.getChildByName(a) as MovieClip;
		}
		
		public static function crClip(a:*, b:*):*{
			var newm:*								= new a();
			var clip:MovieClip 						= newm as MovieClip;
			clip.name								= getClassName(a)+getMaxDepth(b);
			addClip(b, clip);
			return clip;
		}

		public static function crBack(a:*, width:Number=954, height:Number=475, colorOrig:Object=0x000000, colorFinal:Object=0xCC0066, alpha:Array=null):void{
			var osdw:Number 						= width;
			var osdh:Number							= height;
			var gradient:MovieClip 					= new MovieClip();
			var typeGradient:String 				= GradientType.LINEAR;
			var colors:Array 						= [colorOrig, colorFinal];
			var radial:Array 						= [0x00, 0xFF];
			var mtr:Matrix 							= new Matrix();
			var sm:String 							= SpreadMethod.PAD;
			if(!alpha) alpha						= [1, 1];
			mtr.createGradientBox(osdh, osdw, 0, 0, 0);
			mtr.rotate(Math.PI / 2);
			gradient.graphics.beginGradientFill(typeGradient, colors, alpha, radial, mtr, sm);
			gradient.graphics.drawRect(0, 0, osdw, osdh);
			gradient.graphics.endFill();
			addClip(a, gradient);
		}		
		
		public static function getBoundAbs(a:*, b:*):Object{
			var obj:Object 							= a.getBounds(b); 
//			var objr:Object							= new Object();
//			setProp(objr, {xMin:obj.x, xMax:obj.x+obj.width, yMin:obj.y, yMax:obj.y+obj.height});
//			return objr;
			return {xMin:obj.x, xMax:obj.x+obj.width, yMin:obj.y, yMax:obj.y+obj.height};
		}		
		
		public static function getAbsoluteUrl(a:*):String{			
			return (a.loaderInfo.url);
		}
		
		public static function getRealPath(a:*):String{
			var path:String						= unescape(getAbsoluteUrl(a));
			var pathurl:Array					= xSplit(".swf", path);
			var backstring:String				= pathurl[pathurl.length-2];
			var tmp:Array						= xSplit("/", backstring);
			var returnchain:String				= tmp[tmp.length-1];
			return returnchain;			
		}		
		
		public static function getRealUrl(url:String, _stage:*=null):String{
			if(_stage){
				if(!(url.indexOf(":")> -1 || url.indexOf("/")== 0 || url.indexOf("\\")== 0)){
					var rootURL:String;
					if(MovieClip(rootMovie)as MovieClip){
						rootURL					= getAbsoluteUrl(_stage);
						if(rootURL){
							var lastIndex: int	= Math.max(rootURL.lastIndexOf("\\"), rootURL.lastIndexOf("/"));
							if(lastIndex!=-1) url = rootURL.substr(0, lastIndex + 1)+ url;
						}
					}
				}
			}
			return url;
		}
		
		public static function playBack(a:String, b:Object=null):void{
			var prop:Object					= {endPlay:null, args:null, mute:true};
			setProp(prop, b);
			if(prop.mute) SoundMixer.stopAll();
			var soundClip:Sound				= new Sound();
			soundClip.load(new URLRequest(a));
			var sndChannel:SoundChannel		= soundClip.play();
			if(prop.endPlay!=null) sndChannel.addEventListener(Event.SOUND_COMPLETE, function(){dLoader.addMeth(prop.endPlay, prop.args);});
		}		

		public static function existFileMp3(a:String, b:*):void{
			var queue:LoaderMax 				= new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});

			queue.append(new MP3Loader(a, {name:"audio", repeat:0, autoPlay:false}));
			
			queue.load(); 
			
			function progressHandler(a:LoaderEvent):void{}
			
			function completeHandler(a:LoaderEvent):void{
				var music:*						= LoaderMax.getContent("audio");
			}
			
			function errorHandler(a:LoaderEvent):void{
				if(b) removeClip(b);
			}
		}
		
		public static function moreLeft(clips:Array, relParent:*):*{
			var more:* 							= clips[0];
			var blast:Object 					= getBoundAbs(more, relParent);
			var i:uint							= 0;
			var t:uint 							= clips.length;
			for(i=1; i<t; i++){
				var clast:Object 				= getBoundAbs(clips[i], relParent);
				if(clast.xMin<blast.xMin){
					more 						= clips[i];
					blast	 					= getBoundAbs(more, relParent);
				}
			}
			return more;
		}
		
		public static function moreRight(clips:Array, relParent:*):*{
			var more:* 							= clips[0];
			var blast:Object 					= getBoundAbs(more, relParent);
			var i:uint							= 0;
			var t:uint							= clips.length;
			for(i=1; i<t; i++){
				var clast:Object 				= getBoundAbs(clips[i], relParent);
				if(clast.xMax>blast.xMax){
					more 						= clips[i];
					blast						= getBoundAbs(more, relParent);
				}
			}
			return more;
		}
		
		public static function moreTop(clips:Array, relParent:*):*{
			var more:MovieClip 					= clips[0];
			var blast:Object 					= getBoundAbs(more, relParent);
			var i:uint							= 0;
			var t:uint 							= clips.length;
			for(i = 1; i<t; i++){
				var clast:Object 				= getBoundAbs(clips[i], relParent);
				if(clast.yMin<blast.yMin){
					more 						= clips[i];
					blast						= getBoundAbs(more, relParent);
				}
			}
			return more;
		}
		
		public static function moreBottom(clips:Array, relParent:*):*{
			var more:MovieClip 					= clips[0];
			var blast:Object 					= getBoundAbs(more, relParent);
			var i:uint							= 0;
			var t:uint 							= clips.length;
			for(i = 1; i<t; i++){
				var clast:Object 				= getBoundAbs(clips[i], relParent);
				if(clast.yMax>blast.yMax){
					more 						= clips[i];
					blast						= getBoundAbs(more, relParent);
				}
			}
			return more;
		}				
						
		public static function pixelTop(a:*, relParent:*):Number{
			return getBoundAbs(a, relParent).yMin;
		}
		
		public static function pixelBottom(a:*, relParent:*):Number{
			return getBoundAbs(a, relParent).yMax;
		}
		
		public static function pixelLeft(a:*, relParent:*):Number{
			return getBoundAbs(a, relParent).xMin;
		}
		
		public static function pixelRight(a:*, relParent:*):Number{
			return getBoundAbs(a, relParent).xMax;
		}

		public static function hSearch(a:*, b:String, c:String, _stage:*, d:Boolean=false):*{
			var cclip:* 						= a;
			var rclip:*							= null;
			if(d){
				while(cclip && cclip!=_stage && (cclip is MovieClip)){
					if(cclip[b]==c) rclip		= cclip;
					cclip 						= cclip.parent;
				}
			}else{
				while(cclip && cclip!=_stage && (cclip is MovieClip)){
					if(cclip[b]==c) rclip		= cclip;
					cclip 						= cclip.parent;
				}
			}
			return rclip;
		}				
				
		public static function rCx(clip:*, relParent:*):Number{
			var bounds:Object 					= getBoundAbs(clip, relParent);
			return (bounds.xMin+(bounds.xMax))/2;
		}		
		
		public static function rCy(clip:*, relParent:*):Number{
			var bounds:Object 					= getBoundAbs(clip, relParent);
			return (bounds.yMin+bounds.yMax)/2;
		}
		
		public static function vCenter(clip:*, relParent:*):Number{
			return (pixelTop(clip, relParent)+pixelBottom(clip, relParent))/2;
		}
		
		public static function hCenter(clip:*, relParent:*):Number{
			return (pixelLeft(clip, relParent)+pixelRight(clip, relParent))/2;
		}			
				
		public static function arAlign(aclip:*, xclips:Array, b:String, relParent:*):void{
			var t:uint 							= xclips.length;
			if(t){
				var clips:Array 				= arrayCopy(xclips, 0, 0);
				var top:* 						= moreTop(clips, relParent);
				var bottom:* 					= moreBottom(clips, relParent);
				var left:* 						= moreLeft(clips, relParent);
				var right:* 					= moreRight(clips, relParent);
				var arx:Number					= 0;
				var ary:Number					= 0;
				var px:Number 					= rCx(aclip, relParent);
				var py:Number 					= rCy(aclip, relParent);
				var i:uint						= 0;
				switch(b){
					case "tc":
						arx 					= (rCx(left, relParent)+rCx(right, relParent))/2;
						ary 					= rCy(top, relParent)-(pixelTop(aclip, relParent)+(top.height/2));
						for(i = 0; i<t; i++){
							clips[i].x 			+= px-arx;
							clips[i].y 			-= ary;
						}
					break;
					case "bc":
						arx 					= (rCx(left, relParent)+rCx(right, relParent))/2;
						ary 					= rCy(bottom, relParent)-(pixelBottom(aclip, relParent)-(bottom.height/2));
						for(i = 0; i<t; i++){
							clips[i].x 			+= px-arx;
							clips[i].y 			-= ary;
						}
					break;
					case "cl":
						arx 					= rCx(left, relParent)-(pixelLeft(aclip, relParent)+(left.width/2));
						ary 					= (rCy(top, relParent)+rCy(bottom, relParent))/2;
						for(i = 0; i<t; i++){
							clips[i].x 			-= arx;
							clips[i].y 			+= py-ary;
						}
					break;
					case "cr":
						arx 					= rCx(right, relParent)-(pixelRight(aclip, relParent)-(right.width/2));
						ary 					= (rCy(top, relParent)+rCy(bottom, relParent))/2;
						for(i = 0; i<t; i++){
							clips[i].x 			-= arx;
							clips[i].y 			+= py-ary;
						}
					break;
					case "tl":
						arx 					= rCx(left, relParent)-(pixelLeft(aclip, relParent)+(left.width/2));
						ary 					= rCy(top, relParent)-(pixelTop(aclip, relParent)+(top.height/2));
						for(i = 0; i<t; i++){
							clips[i].x 			-= arx;
							clips[i].y 			-= ary;
						}
					break;
					case "tr":
						arx 					= rCx(right, relParent)-(pixelRight(aclip, relParent)-(right.width/2));
						ary 					= rCy(top, relParent)-(pixelTop(aclip, relParent)+(top.height/2));
						for(i = 0; i<t; i++){
							clips[i].x 			-= arx;
							clips[i].y 			-= ary;
						}
					break;
					case "bl":
						arx 					= rCx(left, relParent)-(pixelLeft(aclip, relParent)+(left.width/2));
						ary 					= rCy(bottom, relParent)-(pixelBottom(aclip, relParent)-(bottom.height/2));
						for(i = 0; i<t; i++){
							clips[i].x 			-= arx;
							clips[i].y 			-= ary;
						}
					break;
					case "br":
						arx 					= rCx(right, relParent)-(pixelRight(aclip, relParent)-(right.width/2));
						ary 					= rCy(bottom, relParent)-(pixelBottom(aclip, relParent)-(bottom.height/2));
						for(i = 0; i<t; i++){
							clips[i].x 			-= arx;
							clips[i].y 			-= ary;
						}
					break;
					default:
						arx 					= (rCx(left, relParent)+rCx(right, relParent))/2;
						ary 					= (rCy(top, relParent)+rCy(bottom, relParent))/2;
						for(i = 0; i<t; i++){
							clips[i].x 			+= px-arx;
							clips[i].y 			+= py-ary;
						}
					break;	
				}
			}
		}
		
		public static function dAlign(a:MovieClip, b:MovieClip, c:String, relParent:*):Number{
			var devol:Number 					= 0;
			switch(c){
				case "top":
					devol 						= pixelTop(a, relParent)-pixelTop(b, relParent); 
					return devol;
				break;
				case "bottom":
					devol						= pixelBottom(a, relParent)-pixelBottom(b, relParent); 
					return devol;
				break;
				case "left":
					devol						= pixelLeft(a, relParent)-pixelLeft(b, relParent);
					return devol;
				break;
				case "right":
					devol 						= pixelRight(a, relParent)-pixelRight(b, relParent);
					return devol;
				break;
				case "hcenter":
					devol 						= rCx(a, relParent)-rCx(b, relParent);
					return devol;
				break;
				case "vCenter":
					devol 						= rCy(a, relParent)-rCy(b, relParent);
					return devol;
				break;
				case "tout":
					devol 						= pixelTop(a, relParent)-pixelBottom(b, relParent);
					return devol;
				break;
				case "tedge":
					devol 						= pixelTop(a, relParent)-rCy(b, relParent)
					return devol;
				break;
				case "bout":
					devol 						= pixelBottom(a, relParent)-pixelTop(b, relParent); 
					return devol;
				break;
				case "bedge":
					devol 						= pixelBottom(a, relParent)-rCy(b, relParent);
					return devol;
				break;
				case "rout":
					devol 						= pixelRight(a, relParent)-pixelLeft(b, relParent);
					return devol;
				break;
				case "redge":
					devol						= pixelRight(a, relParent)-rCx(b, relParent);
					return devol;
				break;
				case "lout":
					devol						= pixelLeft(a, relParent)-pixelRight(b, relParent)
					return devol;
				break;
				case "ledge":
					devol 						= pixelLeft(a, relParent)-rCx(b, relParent);
					return devol;
				break;
				default :
				break;
			}
			return devol;
		}						
		
		public static function xAlign(a:*, b:*, c:String, d:Number, e:Boolean, f:*, g:Boolean, h:Boolean, relParent:*):void{
			var xmode:Array 					= xSplit("/", c);
			if(h){
				hAlign(a, b, xmode[1], d, e, f, g, !h, relParent);
				vAlign(a, b, xmode[0], d, e, f, g, h, relParent);
			}else{
				hAlign(a, b, xmode[1], d, e, f, g, h, relParent);
				vAlign(a, b, xmode[0], d, e, f, g, h, relParent);
			}
		}		
				
		public static function vAlign(aclip:*, child:*, b:String, d:Number, e:Boolean, f:*, g:Boolean, h:Boolean, relParent:*):void{
			var pbounds:Object 					= getBoundAbs(aclip, relParent);
			var cbounds:Object 					= getBoundAbs(child, relParent);
			var origen:Number 					= child.y;
			switch(b){
				case "bottom":
					runToAxis(child, child.y, (child.y+(pbounds.yMax-cbounds.yMax)), "y", d, e, f, g, h)
				break;
				case "bedge":
					runToAxis(child, child.y, (child.y+(pbounds.yMax-vCenter(child, relParent))), "y", d, e, f, g, h)
				break;
				case "bout":
					runToAxis(child, (child.y + pbounds.yMax-cbounds.yMin), (child.y + pbounds.yMax-cbounds.yMin), "y", d, e, f, g, h)
				break;
				case "top":
					runToAxis(child, child.y, (child.y+(pbounds.yMin-cbounds.yMin)), "y", d, e, f, g, h)
				break;
				case "tedge":
					runToAxis(child, child.y, (child.y+(pbounds.yMin-vCenter(child, relParent))), "y", d, e, f, g, h)
				break;
				case "tout":
					runToAxis(child, child.y, (child.y+(pbounds.yMin-cbounds.yMax)), "y", d, e, f, g, h)
				break;
				default:
					runToAxis(child, child.y, (child.y+(rCy(aclip, relParent)-rCy(child, relParent))), "y", d, e, f, g, h)
				break;	
			}
		}		

		public static function hAlign(aclip:MovieClip, child:MovieClip, b:String, d:Number, e:Boolean, f:*, g:Boolean, h:Boolean, relParent:*):void{
			var pbounds:Object 					= getBoundAbs(aclip, relParent);
			var cbounds:Object 					= getBoundAbs(child, relParent);
			switch(b){
				case "right":
					runToAxis(child, child.x, (child.x+(pbounds.xMax-cbounds.xMax)), "x", d, e, f, g, h)
				break;
				case "redge":
					runToAxis(child, child.x, (child.x+(pbounds.xMax-hCenter(child, relParent))), "x", d, e, f, g, h)
				break;
				case "rout":
					runToAxis(child, child.x, (child.x+(pbounds.xMax-cbounds.xMax+child.width)), "x", d, e, f, g, h)
				break;
				case "left":
					runToAxis(child, child.x, (child.x+(pbounds.xMin-cbounds.xMin)), "x", d, e, f, g, h)
				break;
				case "ledge":
					runToAxis(child, child.x, (child.x+(pbounds.xMin-hCenter(child,relParent))), "x", d, e, f, g, h)
				break;
				case "lout":
					runToAxis(child, child.x, (child.x+(pbounds.xMin-cbounds.xMin-child.width)), "x", d, e, f, g, h)
				break;
				default:
					runToAxis(child, child.x, (child.x+(rCx(aclip, relParent)-rCx(child, relParent))), "x", d, e, f, g, h)
				break;
			}
		}				
		
		public static function concArray(a:Array, b:String, c:String, d:Number, e:Number, f:Number, g:Boolean, h:*, i:Boolean, j:Boolean, relParent:*):void{
			var qx:Number 						= 0;
			var qy:Number 						= 0;
			var z:uint 							= 0;
			var t:uint 							= a.length;
			
			if(d) qx 							= d;
			
			if(e) qy 							= e;
			
			for(z=0; z<t-1; z++){
				if(j){
					hAlign(a[z], a[z+1], b, f, g, h, i, !j, relParent);
					vAlign(a[z], a[z+1], c, f, g, h, i, j, relParent);
				}else{
					hAlign(a[z], a[z+1], b, f, g, h, i, j, relParent);
					vAlign(a[z], a[z+1], c, f, g, h, i, j, relParent);
				}
				a[z+1].x 						+= qx;
				a[z+1].y 						+= qy;
			}
		}		
						
		public static function qAlign(a:MovieClip, b:MovieClip, c:String, d:Number, e:Boolean, f:*, g:Boolean, h:Boolean, relParent:*):void{
			var modes:Array 					= xSplit(",", c);
			var i:Number						= 0;
				var pos:Number 					= dAlign(a, b, modes[0], relParent);
				switch(modes[1]){
					case "top":
						runToAxis(b, b.y, (b.y+pos), "y", d, e, f, g, h)
					break;
					case "bottom":
						runToAxis(b, b.y, (b.y+pos), "y", d, e, f, g, h)
					break;
					case "left":
						runToAxis(b, b.x, (b.x+pos), "x", d, e, f, g, h)
					break;
					case "right":
						runToAxis(b, b.x, (b.x+pos), "x", d, e, f, g, h)
					break;
					case "hcenter":
						runToAxis(b, b.x, (b.x+pos), "x", d, e, f, g, h)
					break;
					case "vcenter":
						runToAxis(b, b.y, (b.y+pos), "y", d, e, f, g, h)
					break;
					case "tout":
						runToAxis(b, b.y, (b.y+pos), "y", d, e, f, g, h)
					break;
					case "tedge":
						runToAxis(b, b.y, (b.y+pos), "y", d, e, f, g, h)
					break;
					case "bout":
						runToAxis(b, b.y, (b.y+pos), "y", d, e, f, g, h)
					break;
					case "bedge":
						runToAxis(b, b.y, (b.y+pos), "y", d, e, f, g, h)
					break;
					case "rout":
						runToAxis(b, b.x, (b.x+pos), "x", d, e, f, g, h)
					break;
					case "redge":
						runToAxis(b, b.x, (b.x+pos), "x", d, e, f, g, h)
					break;
					case "lout":
						runToAxis(b, b.x, (b.x+pos), "x", d, e, f, g, h)
					break;
					case "ledge":
						runToAxis(b, b.x, (b.x+pos), "x", d, e, f, g, h)
					break;
					default:
					break;
				}
		}						
						
		public static function alignToStage(clip:MovieClip, alignment:String, ww:Number, hh:Number, c:Number, d:Boolean, e:Function, f:Boolean, g:Boolean, h:Function, ii:Number, jj:Number, relParent:*):void{
			var modes:Array 					= xSplit("/", alignment);
			var xheight:Number 					= ii;
			var xwidth:Number					= jj;
			if(ww && hh){
				xheight 						= hh;
				xwidth 							= ww;
			} 
			switch(modes[0]){
				case "top":
					runToAxis(clip, clip.y, (clip.y+(0-pixelTop(clip, relParent))), "y", c, d, e, f, g)
				break;
				case "bottom":
					runToAxis(clip, clip.y, (clip.y+(xheight-pixelBottom(clip, relParent))), "y", c, d, e, f, g)
				break;
				default:
					runToAxis(clip, clip.y, (clip.y+((xheight/2)-rCy(clip, relParent))), "y", c, d, e, f, g)
				break;
			}
			switch(modes[1]){
				case "left":
					runToAxis(clip, clip.x, (clip.x+(0-pixelLeft(clip, relParent))), "x", c, d, e, f, g)
				break;
				case "right":
					runToAxis(clip, clip.x, (clip.x+(xwidth-pixelRight(clip, relParent))), "x", c, d, e, f, g)
				break;
				default:
					runToAxis(clip, clip.x, (clip.x+((xwidth/2)-rCx(clip, relParent))), "x", c, d, e, f, g)
				break;
			}
		}		

		public static function alignClip(a:MovieClip, b:MovieClip, c:Number, d:Boolean, e:*, f:Boolean, g:Boolean):void{
			if(g){
				alignXClipY(a, b, c, d, e, f, g);
				alignXClipX(a, b, c, d, e, f, !g);
			}else{
				alignXClipY(a, b, c, d, e, f, g);
				alignXClipX(a, b, c, d, e, f, g);
			}
		}

		public static function alignXClipX(a:*, b:*, frames:Number, unit:Boolean, type:*, d:Boolean, e:Boolean):void{
			a.enabled							= false;
			tMaxFromTo(a, frames,  {x:a.x},{x:b.x, ease:type, onComplete:onMotionFinished, onCompleteParams:[a,d,e]});
		}
		
		public static function alignXClipY(a:*, b:*, frames:Number, unit:Boolean, type:*, d:Boolean, e:Boolean):void{
			a.enabled							= false;
			tMaxFromTo(a, frames, {y:a.y},{y:b.y, ease:type, onComplete:onMotionFinished, onCompleteParams:[a,d,e]});
		}		
				
		public static function goToAxis(a:*, e:Number, b:Object, c:Object):void{
			tMaxFromTo(a, e, b, c);
		}				
				
		public static function runToAxis(a:*, b:Number, c:Number, d:String, e:Number, f:Boolean, g:*, h:Boolean, i:Boolean):void{
			if(d=="x"){
				tMaxFromTo(a, e, {x:b}, {x:c, ease:g, onComplete:onMotionFinished, onCompleteParams:[a,h,i], onUpdate:onMotionChanged, onUpdateParams:[a], useFrames:!f});
			}else{
				tMaxFromTo(a, e, {y:b}, {y:c, ease:g, onComplete:onMotionFinished, onCompleteParams:[a,h,i], onUpdate:onMotionChanged, onUpdateParams:[a], useFrames:!f});
			}
		}
										
		public static function arrayMoveBy(clips:Array, dx:Number, dy:Number, c:Number, d:Boolean, e:*, f:Boolean, g:Boolean):void{
			for each (var clip:* in clips) goToAxis(clip, {x:clip.x, y:clip.y}, {x:(clip.x+dx), y:(clip.y+dy)});
		}				
		
		public static function alignHClip(xClips:Array, osdH:Number, posY:Number, sepX:Number, sec:Number, isSec:Boolean, fxEase:Function, isActivated:Boolean):void{
			var i:Number						= 0;
			var t:Number						= xClips.length;
			var pos:Number						= 0;
			var posx:Array						= newArray(posx);
			for(i=0; i<t; i++){
				posx.push(pos);
				var n:Number					= xClips[i].width+sepX;
				pos								+= n;
			}
			var max:Number 						= posx[posx.length-1];
			var dif:Number 						= (osdH-max)/2;
			for(i=0; i<t; i++){
				var addy:Number 				= posY;
				var addx:Number 				= dif+posx[i];
				var initPosition:MovieClip 		= new MovieClip();
				setProp(initPosition, {x:addx, y:addy});
				setProp(xClips[i], {initPosition:initPosition});
				dLoader.runToAxis(xClips[i], xClips[i].y, addy, "y", sec, isSec, fxEase, isActivated, false);
				dLoader.runToAxis(xClips[i], xClips[i].x, addx, "x", sec, isSec, fxEase, isActivated, false);
			}
		}
		
		public static function alignHClips(xClips:Array, osdH:Number, c:Number, sepX:Number, posY:Array, maxH:Number, sec:Number, isSec:Boolean, fxEase:Function, isRandom:Boolean, isActivated:Boolean):void{
			isRandom ? xClips = noOrder(xClips): xClips;
			var i:uint							= 0;
			var t:uint							= xClips.length;
			var pos:Number						= 0;
			var per:Number 						= maxH;
			var coun:Number 					= 0;
			var tmp:Array						= newArray(tmp);
			var j:uint							= 0;
			var clip:MovieClip 					= null;
			var column:uint						= 0;
			
			for each (clip	in xClips){
				var n:Number					= clip.width+sepX;
				pos								+= n;
				clip.row						= abc[coun];
				clip.column						= column;
				++column;
				if(!(pos<per)){
					++coun;
					column						= 0;
					pos							= 0;
				}
			}	
			
			coun								= 0;
			
			for(j=0; j<t; j++){
				var tmp2:Array					= newArray(tmp2);
				for(i=0; i<t; i++){
					clip						= xClips[i];
					if(clip.row==abc[j]) tmp2.push(clip);
				}
				if(tmp2.length>0){
					tmp[coun]					= tmp2;
					++coun;
				}
			}
			
			for(i=0; i<tmp.length; i++)	alignHClip(tmp[i], osdH, posY[i], sepX, sec, isSec, fxEase, isActivated);
		}

		public static function onMotionFinished(a:*, b:Boolean, c:Boolean):void{
			if(motionFinished!=null) motionFinished(a, b, c);
		}
		
		public static function onMotionChanged(a:*):void{
			if(motionChanged!=null)	motionChanged(a);
		}
	}
}