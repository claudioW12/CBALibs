package ph.graphic{
	//
	import flash.display.Sprite;
	import flash.display.Graphics;
	//
	public class RectScuare extends Sprite {
		//
		private var _clip    :Sprite;
		private var _wd      :uint;
		private var _hg      :uint;
		private var _bgColor :uint;
		//
		public function RectScuare(wd:uint, hg:uint, bgColor:uint):void {
			//
			_wd      = wd;
			_hg      = hg;
			_bgColor = bgColor;
			//
			drawRectScuare();
		}
		//
		private function drawRectScuare():void {
			//
			_clip = new Sprite();
			_clip.graphics.beginFill(_bgColor);
			_clip.graphics.drawRect(0, 0, _wd, _hg);
			addChild(_clip);
		}
	}
}