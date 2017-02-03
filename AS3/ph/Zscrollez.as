package ph{
	//
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import ph.graphic.RectScuare;
	//-----------------------------------------------
	public class Zscrollez extends Sprite {
		//
		private var holder       :MovieClip;
		private var clip         :MovieClip;
		private var clipMask     :RectScuare;
		private var dragger      :RectScuare;
		private var slider       :RectScuare;
		private var bGround      :RectScuare;
		private var bgAlpha      :Number;
		private var bgColor      :uint;
		private var hg           :uint;
		private var wd           :uint;
		private var scrolled     :uint;
		private var friction     :uint;
		private var currentY     :int;
		private var draggerHg    :uint;
		private var draggerColor :uint;
		private var sliderColor  :uint;
		private var fade         :Tween;
		private var fadeAmount   :Number;
		private var wheel        :Boolean;
		private var activate	 :Boolean;
		//------------------------------------------------------------------------
		public function Zscrollez(_clip:MovieClip, _hg:uint, _wd:uint, deactivated:Boolean, _friction:uint = 5, _wheel:Boolean = false):void {
			//
			clip       	= _clip;
			hg         	= _hg;
			wd			= _wd;	
			friction  	= _friction;
			wheel      	= _wheel;
			if(!deactivated){
				activate	= true;
			}
			activate	= deactivated;
			//
			if (clip.height > hg) {
				//
				createHolder();
				createMask();
				createSrollBar();
				addListeners();
			}
		}
		//---------------------------------------------------------------------------
		public function set scrollWheel(b:Boolean):void {
			//
			wheel = b;
			addListeners();
		}
		//
		public function set handCursor(h:Boolean):void {
			//
			dragger.buttonMode = h;
		}
		//---------------------------------------------------------------------------
		public function scrollBarProperties(_draggerHg:uint, _draggerC:uint, _sliderC:uint):void {
			//
			draggerHg    = _draggerHg;
			draggerColor = _draggerC;
			sliderColor  = _sliderC;
			//
			createSrollBar(draggerHg, draggerColor, sliderColor);
			addListeners();
		}
		//---------------------------------------------------------------------------
		public function backGround(_bgColor:uint = 0xFFFFFF, _bgAlpha:Number = 1):void {
			//
			bgColor 		= _bgColor;
			bgAlpha 		= _bgAlpha;
			//
			bGround 		= new RectScuare(wd, hg, bgColor);
			bGround.x 		= bGround.y = 0;
			bGround.alpha 	= bgAlpha;
			holder.addChild(bGround);
			holder.swapChildren(bGround, clip);
		}
		//---------------------------------------------------------------------------
		private function createHolder():void {
			//
			holder = new MovieClip();
			holder.x = clip.x;
			holder.y = clip.y;
			clip.x = clip.y = 0;
			holder.addChild(clip);
			addChild(holder);
		}
		//---------------------------------------------------------------------------
		private function createMask():void {
			//
			clipMask 	= new RectScuare(wd, hg, 0x000000);
			clip.mask 	= clipMask;
			holder.addChild(clipMask);
		}
		//---------------------------------------------------------------------------
		private function createSrollBar(dH:uint = 30, dC:uint = 0x000000, sC:uint = 0xCCCCCC):void {
			//
			draggerHg    = dH;
			draggerColor = dC;
			sliderColor  = sC;
			//
			slider = new RectScuare(10, hg, sliderColor);
			dragger = new RectScuare(6, dH, draggerColor);
			slider.x = wd;
			dragger.x = wd+2;
			if(activate){
				holder.addChild(slider);
				holder.addChild(dragger);
			}
		}
		//--------------------------------------------------------------------------
		private function dragOn(e:Event):void {
			//
			dragger.startDrag(false, new Rectangle(dragger.x, 0, 0, slider.height - dragger.height));
			dragOnOutSide();
		}
		private function dragOff(e:Event):void {
			//
			dragger.stage.removeEventListener(MouseEvent.MOUSE_UP, dragOff);
			dragger.stopDrag();
		}
		private function dragOnOutSide():void {
			//
			dragger.stage.addEventListener(MouseEvent.MOUSE_UP, dragOff);
		}
		//---------------------------------------------------------------------------
		private function fadeIn(e:Event):void {
			//
			e.type == "rollOver" ? fadeAmount = 0.7 : fadeAmount = 1;
			fade = new Tween(e.target, "alpha", Strong.easeOut, e.target.alpha, fadeAmount, 0.7, true);
		}
		//---------------------------------------------------------------------------
		private function easeIn(e:Event):void {
			//
			friction > 5 ? friction = 5 : null;
			//
			scrolled = dragger.y / (hg - dragger.height) * 100;
			currentY = -(clip.height - hg) * scrolled / 100;
			clip.y += (currentY - clip.y) / friction;
		}
		//---------------------------------------------------------------------------
		private function aplyScrollWheel(e:MouseEvent):void {
			//
			dragger.y += e.delta * -10;
			//
			if (dragger.y < 0) {
				//
				dragger.y = 0;

			} else if (dragger.y > (slider.height - dragger.height)) {
				//
				
				dragger.y = slider.height - dragger.height;
			}
		}
		//--------------------------------------------------------------------------
		private function addListeners():void {
			//
			if(activate){
				dragger.addEventListener(MouseEvent.ROLL_OVER, fadeIn);
				dragger.addEventListener(MouseEvent.ROLL_OUT, fadeIn);
				dragger.addEventListener(MouseEvent.MOUSE_DOWN, dragOn);
				dragger.addEventListener(MouseEvent.MOUSE_UP, dragOff);
				dragger.addEventListener(Event.ENTER_FRAME, easeIn);
			}
			//
			if (wheel == true) {
				clip.addEventListener(MouseEvent.MOUSE_WHEEL, aplyScrollWheel);
			}
		}
		//-------------------------------------------------------------------------
	}// class
}// package