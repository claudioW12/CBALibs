package dload{
	import dload.dLoader;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.text.*;
	
	public class dload extends MovieClip{
		
		public var motionFinished:Function		= null;
		public var motionChanged:Function		= null; 
		
		public var abc:Array 					= dLoader.abc;
		public var cList:Array					= dLoader.cList;
		
		public var debugger:Boolean				= false;
		public var rootMovie:MovieClip 			= null;
		public var fps:uint 					= 0;
		
		public var thisContainer:*;
		public var _stage:*;
		public var mBg:MovieClip				= null;
		public var scaleMode:String				= "";
		
		public function dload(a:*, b:Object=null):void{
			
			attr(this, b);
			attr(dLoader, b);
			
			this.addEventListener(Event.ACTIVATE, addedToStage);
			
			thisContainer						= a;
			
			thisContainer.stop();
			
			if(mBg)	attr(mBg, {enabled:false, alpha:0});
			
			thisContainer.thisPath				= getRealPath(thisContainer);
			
			if(thisContainer.loaderInfo.parameters.roota) thisContainer.thisPath = thisContainer.loaderInfo.parameters.roota+thisContainer.thisPath;
			
			if(thisContainer.roota) thisContainer.thisPath = thisContainer.roota+thisContainer.thisPath;

			_stage								= thisContainer.stage;
			_stage.showDefaultContextMenu 		= false;
			if(scaleMode) setScale(scaleMode);
			if(fps) setFps(fps);
		}
		
		private function addedToStage(a:Event):void{
			if(debugger){
				trace("dload Activated")
			}
		}
		
		public function setScale(a:String="showAll"):void{
			if(a!="") _stage.scaleMode 			= a;
		}
		
		public function setFps(a:uint=30):void{
			var min:uint						= 12;
			var max:uint						= 120;
			a									= isMin(a, min) ? min : a;
			a									= isMay(a, max) ? max : a;
			_stage.frameRate					= a;
		}
		
		public function toURL(url:String, target:String="_blank"):Boolean{
			return dLoader.toURL(url, target);
		}

		public function addList(a:Object, b:Object=null, c:Object=null):*{
			return dLoader.addList(a, b, c);
		}
		
		public function addListenerButton(a:*, b:Object=null, c:Object=null):void{
			dLoader.addListenerButton(a, b, c);
		}
		
		public function newList(clip:*, obj:Object):void{
			dLoader.newList(clip, obj);
		}
		
		public static function killTweens(arr:Object):*{
			return dLoader.killTweens(arr);
		}		
		
		public function attr(clip:*, obj:Object):*{
			return dLoader.attr(clip, obj);
		}
		
		public function setMeth(arr:Object, obj:Object=null):*{
			return dLoader.setMeth(arr, obj);
		}
		
		public function addMeth(func:Object, b:Object):void{
			dLoader.addMeth(func, b);
		}
		
		public function crProp(a:Array, b:Object=null, Arr:Array=null):void{
			dLoader.crProp(a, b, Arr);
		}
		
		public function isClass(val:Object, Arr:Array):Boolean{
			return dLoader.isClass(val, Arr);
		}
		
		public function isVal(a:*):Boolean{
			return dLoader.isVal(a);
		}
		
		public function isType(a:*, b:*):Boolean{
			return dLoader.isType(a, b);
		}
		
		public function defineParent(cClip:*):*{
			return dLoader.defineParent(cClip);
		}				
	
		public function toBool(a:String):Boolean{
			return dLoader.toBool(a);
		}
		
		public function rClass(a:String):Class{
			return dLoader.rClass(a);
		}
		
		public function getClass(obj:Object):Class{
		  return dLoader.getClass(obj);
		}	
		
		public function getSuperClass(a:Object):Object{
			return dLoader.getSuperClass(a);
		}		
		
		public function getClassName(a:*):String{
			return dLoader.getClassName(a);
		}		
		
		public function getDropper(a:*):*{
			return dLoader.getDropper(a);
		}

		public function push(arr:Array, obj:Object):Array{
			return dLoader.push(arr, obj);
		}

		public function qLoad(a:*, b:*, c:Number, d:Object=null):Array{
			return dLoader.qLoad(a, b, c, d);
		}
		
		public function setEaseGS(a:String, b:String="InOut"):*{
			return dLoader.setEaseGS(a, b);
		}		
		
		public function setEaseBT(a:String, b:String="InOut"):*{
			return dLoader.setEaseBT(a, b);
		}		
		
		public function centerXY(a:*, b:Object=null):void{
			dLoader.centerXY(a, b);
		}
		
		public function centerX(a:*, b:int=0):void{
			dLoader.centerX(a, b);
		}
		
		public function centerY(a:*, b:int=0):void{
			dLoader.centerY(a, b);
		}
		
		public function chColor(a:Object, c:Number, b:Object):*{
			return dLoader.chColor(a, c, b);
		}

		public function killAllGS():*{
			return dLoader.killAllGS();
		}

		public function tMaxTo(a:Object, c:Number,  b:Object):*{
			return dLoader.tMaxTo(a, c, b);
		}
		
		public function tMaxFromTo(a:Object, c:Number,  b:Object, d:Object):*{
			return dLoader.tMaxFromTo(a, c, b, d);
		}
		
		public function tLiteTo(a:Object, c:Number,  b:Object):*{
			return dLoader.tLiteTo(a, c, b);
		}
		
		public function serialLite(arr:Array, sec:Number, prop:Object):*{
			return dLoader.serialLite(arr, sec, prop);
		}
		
		public function outSide(a:*, b:Function, c:Object=null, d:Object=null):*{
			return dLoader.outSide(a, b, c, d);
		}
		
		public function txtColor(a:TextField, b:Object, c:Number=0, d:Number=0):*{
			return dLoader.txtColor(a, b, c, d);
		}
								
		public function addClip(parent:*, child:*):*{
			return dLoader.addClip(parent, child);
		}

		public function removClip(par:*, chi:*):void{
			dLoader.removClip(par, chi);
		}
		
		public function removeClip(a:*):*{
			return dLoader.removeClip(a);
		}

		public function removeAllChild(a:*):*{
			return dLoader.removeAllChild(a);
		}

		public function toPlay(arr:Object, sce:Object):*{
			return dLoader.toPlay(arr, sce);
		}
		
		public function toStop(arr:Object, sce:Object):*{
			return dLoader.toStop(arr, sce);
		}		
				
		public function dispelClip(a:*, b:Number, c:Object=null):void{
			dLoader.dispelClip(a, b, c);
		}
										
		public function lightClip(a:Array, b:Array, c:Number, d:Object=null):void{
			dLoader.lightClip(a, b, c, d);
		}				
		public function getMaxDepth(a:*):Number{
			return dLoader.getMaxDepth(a);
		}		
		
		public function toFront(a:*):*{
			return dLoader.toFront(a);
		}
		
		public function byNameFrom(a:MovieClip, b:String, list:Object=null, prop:Object=null):Array{
			return dLoader.byNameFrom(a, b, list, prop);
		}
		
		public function byClassFrom(a:MovieClip, b:Class):Array{
			return dLoader.byClassFrom(a, b);
		}
		
		public function dynClass(cad:String, clip:MovieClip, b:uint):Array{
			return dLoader.dynClass(cad, clip, b);
		}
		
		public function dynClip(a:String, b:MovieClip):MovieClip{
			return dLoader.dynClip(a, b);
		}
		
		public function changeDepth(a:*, b:Number):void{
			dLoader.changeDepth(a, b);
		}		
		
		public function shadowFilter(a:*, b:Number, c:Number):void{
			dLoader.shadowFilter(a, b, c);
		}
		
		public function blurFilter(a:*, b:Number, c:Number):void{
			dLoader.blurFilter(a, b, c);
		}

		public function encode(a:String):String{
			return dLoader.encode(a);
		}
		
		public function decode(a:String):String{
			return dLoader.decode(a);
		}
		
		public function encrypTo(a:String):String{
			return dLoader.encrypTo(a);
		}
		
		public function decrypTo(a:String):String{
			return dLoader.decrypTo(a);
		}

		public function xSplit(sep:String, xstring:String):Array{
			return dLoader.xSplit(sep, xstring); 
		}

		public function isThere(b:Array, a:String):Boolean{
			return dLoader.isThere(b, a);
		}
		
		public function colByName(a:String):Object{
			return dLoader.colByName(a);
		}		
		
		public function hexByName(a:String):Object{
			return dLoader.hexByName(a);
		}		
		
		public function colByIndex(a:uint):Object{
			return dLoader.colByIndex(a);
		}
		
		public function hexByIndex(a:uint):Object{
			return dLoader.hexByIndex(a);
		}
		
		public function replace(a:String, b:String, c:String):String{
			return dLoader.replace(a, b, c);
		}
		
		public function join(a:Array, b:String=""):String{
			return dLoader.join(a, b);
		}
		
		public function uCase(a:String):String{
			return dLoader.uCase(a);
		}
		
		public function lCase(a:String):String{
			return dLoader.lCase(a);
		}				
		
		public function defValun(a:*, b:*):*{
			return dLoader.defValun(a, b);
		}
		
		public function insFirst(a:Array, b:*):Array{
			return dLoader.insFirst(a, b);
		}
		
		public function arrayCopy(xarray:Array, a:Number, b:Number):Array{
			return dLoader.arrayCopy(xarray, a, b);
		}
		
		public function firstUCase(a:String):String{
			return dLoader.firstUCase(a);
		}
		
		public function revStr(a:String):String{
			return dLoader.revStr(a);
		}		

		public function formaText(a:*, c:*, d:String="left", e:Number=12, f:Number=0, g:Number=0):void{
			dLoader.formaText(a, c, d, e, f, g);
		}
		
		public function trim(str:String, lim:String=" "):String{
			return dLoader.trim(str, lim);
		}
		
		public function trimFront(str:String, char:String):String{
			return dLoader.trimFront(str, char);
		}
		
		public function trimBack(str:String, char:String):String{
			return dLoader.trimBack(str, char);
		}
		
		public function stringToCharacter(str:String):String{
			return dLoader.stringToCharacter(str);
		}		
		
		public function delStr(a:String, b:String):String{
			return dLoader.delStr(a, b);
		}
		
		public function standarizerArray(b:Array, c:String):Array{
			return dLoader.standarizerArray(b, c);
		}
		
		public function setArray(a:Array, b:Number, c:String):Array{
			return dLoader.setArray(a, b, c);
		}
		
		public function resetArray(a:Array, b:Number, c:String):Array{
			return dLoader.resetArray(a, b, c);
		}
		
		public function newArray(a:Array):Array{
			return dLoader.newArray(a);
		}

		public function max(array:Array):Number{
			return dLoader.max(array);
		}	

		public function min(array:Array):Number{
			return dLoader.min(array);
		}	
		
		public function shuffleArray(a:Number, b:Array):Array{
			return dLoader.shuffleArray(a, b);
		}
		
		public function noOrder(a:Array):Array{
			return dLoader.noOrder(a);
		}
		
		public function revArray(a:Array):Array{
			return dLoader.revArray(a);
		}
		
		public function cloneObj(re0:Object):*{
			return dLoader.cloneObj(re0);
		}
		
		public function last(arr:Array):*{
			return dLoader.last(arr);
		}
		
		public function concatArray(a:Array, b:Array):Array{
			return dLoader.concatArray(a, b);
		}
		
		public function expolarArray(moreArray:Array, smallArr:Array):Array{
			return dLoader.expolarArray(moreArray, smallArr);
		}
		
		public function uniqueKey(a:Array):Array{
			return dLoader.uniqueKey(a);
		}		
		
		public function changeAvailable(a:Array, b:Boolean):void{
			dLoader.changeAvailable(a, b);
		}
		
		public function noShuffleArray(a:Number, b:Array):Array{
			return dLoader.noShuffleArray(a, b);
		}

		public function isNotCero(a:Number):Boolean{
			return dLoader.isNotCero(a);
		}		
		
		public function absNumber(a:Number):Number{
			return dLoader.absNumber(a);
		}		
		
		public function isMin(a:Number, b:Number):Boolean{
			return dLoader.isMin(a, b);
		}		
		
		public function equal(a:*, b:*):Boolean{
			return dLoader.equal(a, b);
		}				
		
		public function eqStrict(a:*, b:*):Boolean{
			return dLoader.eqStrict(a, b);
		}
		
		public function parented(clip:*):*{
			return dLoader.parented(clip);
		}		
		
		public function firstIsClassSecond(a:*, b:*):Boolean{
			return dLoader.firstIsClassSecond(a, b);
		}		
		
		public function invertSigned(a:Number):Number{
			return dLoader.invertSigned(a);
		}
		
		public function randomNumber(a:Number, b:Number):Number{
			return dLoader.randomNumber(a, b);
		}
				
		public function randomInt(a:Number, b:Number):Number{
			return dLoader.randomInt(a, b);
		}
		
		public function calcularAngulo(a:MovieClip, b:MovieClip):Number{
			return dLoader.calcularAngulo(a, b);
		}		
		
		public function calcAprobated(a:Array, b:int=51):Boolean{
			return dLoader.calcAprobated(a, b);
		}		
		
		public function isMay(a:Number, b:Number):Boolean{
			return dLoader.isMay(a, b);
		}				
		
		public function isPar(a:Number):Boolean{
			return dLoader.isPar(a);
		}
		
		public function setVolumen(vol:Number, chan:SoundChannel):void{ 
			dLoader.setVolumen(vol, chan);
		}
		
		public function stopSounds():Boolean{
			return dLoader.stopSounds();
		}
			
		public function setAllVolumen(val:Number):void{
			dLoader.setAllVolumen(val);
		}
		
		public function isClip(a:String, b:*):*{
			return dLoader.isClip(a, b);
		}
		
		public function crClip(a:*, b:*, c:Object=null):*{
			return dLoader.crClip(a, b, c);
		}

		public function crBack(a:*, b:Number=954, c:Number=475, d:Object=0x000000, e:Object=0xCC0066, alphas:Array=null):void{
			dLoader.crBack(a, b, c, d, e, alphas);
		}		

		public function getBoundAbs(a:*, b:*):Object{
			return dLoader.getBoundAbs(a, b);
		}		
		
		public function getAbsoluteUrl(a:*):String{	
			return dLoader.getAbsoluteUrl(a);
		}
		
		public function getRealPath(a:*):String{
			return dLoader.getRealPath(a);
		}		
		
		public function ftpURL(clip:*, ret:String=""):String{
			return dLoader.ftpURL(clip, ret);
		}		

		public function getRealUrl(url:String, _stage:*=null):String{
			return dLoader.getRealUrl(url, _stage);
		}
		
		public function playBack(a:String, b:Object=null):SoundChannel{
			return dLoader.playBack(a, b);
		}

		public function existFileMp3(a:String, b:*):void{
			dLoader.existFileMp3(a, b);
		}
		
		public function moreLeft(clips:Array, relParent:*):*{
			return dLoader.moreLeft(clips, relParent);
		}
		
		public function moreRight(clips:Array, relParent:*):*{
			return dLoader.moreRight(clips, relParent);
		}
		
		public function moreTop(clips:Array, relParent:*):*{
			return dLoader.moreTop(clips, relParent);
		}
		
		public function moreBottom(clips:Array, relParent:*):*{
			return dLoader.moreBottom(clips, relParent);
		}				
						
		public function pixelTop(a:*, relParent:*):Number{
			return dLoader.pixelTop(a, relParent);
		}
		
		public function pixelBottom(a:*, relParent:*):Number{
			return dLoader.pixelBottom(a, relParent);
		}
		
		public function pixelLeft(a:*, relParent:*):Number{
			return dLoader.pixelLeft(a, relParent);
		}
		
		public function pixelRight(a:*, relParent:*):Number{
			return dLoader.pixelRight(a, relParent);
		}

		public function hSearch(a:*, b:String, c:String, _stage:*, d:*):*{
			return dLoader.hSearch(a, b, c, _stage, d);
		}			
		
		public function rCx(clip:*, relParent:*):Number{
			return dLoader.rCx(clip, relParent);
		}		
		
		public function rCy(clip:*, relParent:*):Number{
			return dLoader.rCy(clip, relParent);
		}
		
		public function vCenter(clip:*, relParent:*):Number{
			return dLoader.vCenter(clip, relParent);
		}
		
		public function hCenter(clip:*, relParent:*):Number{
			return dLoader.hCenter(clip, relParent);
		}			
		
		public function arAlign(aclip:*, xclips:Array, b:String, relParent:*):void{
			dLoader.arAlign(aclip, xclips, b, relParent);
		}
		
		public function dAlign(a:MovieClip, b:MovieClip, c:String, relParent:*):Number{
			return dLoader.dAlign(a, b, c, relParent);
		}						

		public function xAlign(a:*, b:*, c:String, d:Number, e:Boolean, f:*, g:Boolean, h:Boolean, relParent:*):void{
			dLoader.xAlign(a, b, c, d, e, f, g, h, relParent);
		}
				
		public function vAlign(aclip:*, child:*, b:String, d:Number, e:Boolean, f:*, g:Boolean, h:Boolean, relParent:*):void{
			dLoader.vAlign(aclip, child, b, d, e, f, g, h, relParent);
		}		

		public function hAlign(aclip:MovieClip, child:MovieClip, b:String, d:Number, e:Boolean, f:*, g:Boolean, h:Boolean, relParent:*):void{
			dLoader.hAlign(aclip, child, b, d, e, f, g, h, relParent);
		}				
		
		public function concArray(a:Array, b:String, c:String, d:Number, e:Number, f:Number, g:Boolean, h:*, i:Boolean, j:Boolean, relParent:*):Array{
			return dLoader.concArray(a, b, c, d, e, f, g, h, i, j, relParent);
		}		
						
		public function qAlign(a:MovieClip, b:MovieClip, c:String, d:Number, e:Boolean, f:*, g:Boolean, h:Boolean, relParent:*):void{
			dLoader.qAlign(a, b, c, d, e, f, g, h, relParent);
		}						
						
		public function alignToStage(clip:MovieClip, alignment:String, ww:Number, hh:Number, c:Number, d:Boolean, e:Function, f:Boolean, g:Boolean, h:Function, ii:Number, jj:Number, relParent:*):void{
			dLoader.alignToStage(clip, alignment, ww, hh, c, d, e, f, g, h, ii, jj, relParent);
		}		

		public function alignClip(a:MovieClip, b:MovieClip, c:Number, d:Boolean, e:*, f:Boolean, g:Boolean):void{
			dLoader.alignClip(a, b, c, d, e, f, g);
		}

		public function alignXClipX(a:*, b:*, frames:Number, unit:Boolean, type:*, d:Boolean, e:Boolean):void{
			dLoader.alignXClipX(a, b, frames, unit, type, d, e);
		}
		
		public function alignXClipY(a:*, b:*, frames:Number, unit:Boolean, type:*, d:Boolean, e:Boolean):void{
			dLoader.alignXClipY(a, b, frames, unit, type, d, e);
		}		
				
		public function runToAxis(a:*, b:Number, c:Number, d:String, e:Number, f:Boolean, g:*, h:Boolean, i:Boolean):void{
			dLoader.runToAxis(a, b, c, d, e, f, g, h, i);
		}
										
		public function arrayMoveBy(clips:Array, dx:Number, dy:Number, c:Number, d:Boolean, e:*, f:Boolean, g:Boolean):void{
			dLoader.arrayMoveBy(clips, dx, dy, c, d, e, f, g);
		}				
		
		public function alignHClip(xClips:Array, osdH:Number, posY:Number, sepX:Number, sec:Number, isSec:Boolean, fxEase:Function, isActivated:Boolean):void{
			dLoader.alignHClip(xClips, osdH, posY, sepX, sec, isSec, fxEase, isActivated);
		}
		
		public function alignHClips(xClips:Array, osdH:Number, c:Number, sepX:Number, posY:Array, maxH:Number, sec:Number, isSec:Boolean, fxEase:Function, isRandom:Boolean, activated:Boolean):void{
			dLoader.alignHClips(xClips, osdH, c, sepX, posY, maxH, sec, isSec, fxEase, isRandom, activated);
		}
		
		public function alignToLeft(xClips:Array, posX:Number, posY:Number, sepX:Number, sec:Number, isSec:Boolean, fxEase:Function, rToLeft:Boolean=false):void{
			dLoader.alignToLeft(xClips, posX, posY, sepX, sec, isSec, fxEase, rToLeft);
		}
		
		public function onMotionFinished(a:*, b:Boolean, c:Boolean):void{
			if(motionFinished!=null) dLoader.motionFinished(a, b, c);
		}
		
		public function onMotionChanged(a:*):void{
			if(motionChanged!=null) dLoader.motionChanged(a);
		}
	}
}