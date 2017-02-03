/*
VERSION: 0.99
DATE: 11/6/2008
ACTIONSCRIPT VERSION: 3.0 (Requires Flash Player 9)

CODED BY: Jack Doyle, jack@greensock.com
Copyright 2008, GreenSock (This work is subject to the terms at http://www.greensock.com/terms_of_use.html.)
*/


package com.greensock.transform.utils {
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	
	public class MatrixTools {
		private static const VERSION:Number = 0.99;
		//private static const _DEG2RAD:Number = Math.PI / 180; //precomputation for speed
		//private static const _RAD2DEG:Number = 180 / Math.PI; //precomputation for speed;
		
		public static function getDirectionX($m:Matrix):Number {
			var sx:Number = Math.sqrt($m.a * $m.a + $m.b * $m.b);
			if ($m.a < 0) { 
				return -sx;
			} else {
				return sx;
			}
		}
		
		public static function getDirectionY($m:Matrix):Number {
			var sy:Number = Math.sqrt($m.c * $m.c + $m.d * $m.d);
			if ($m.d < 0) {
				return -sy;
			} else {
				return sy;
			}
		}
		
		public static function getScaleX($m:Matrix):Number {
			var sx:Number = Math.sqrt($m.a * $m.a + $m.b * $m.b);
			if ($m.a < 0 && $m.d > 0) {
				return -sx;
			} else {
				return sx;
			}
		}
		
		public static function getScaleY($m:Matrix):Number {
			var sy:Number = Math.sqrt($m.c * $m.c + $m.d * $m.d);
			if ($m.d < 0 && $m.a > 0) {
				return -sy;
			} else {
				return sy;
			}
		}
		
		public static function getAngle($m:Matrix):Number { //If a DisplayObject is flipped (negative scaleX or scaleY), you cannot simply do Math.atan2($m.b, $m.a)!
			var a:Number = Math.atan2($m.b, $m.a);
			var s:Number = Math.atan2(-$m.c, $m.d);
			if (s * a < 0) {
				if (a <= 0) {
					return a + Math.PI;
				} else {
					return a - Math.PI;
				}
			} else {
				return a;
			}
		}
		
		public static function scaleMatrix($m:Matrix, $sx:Number, $sy:Number, $angle:Number, $skew:Number):void {
			if (Math.abs($sx) < 0.01) {
				$sx = 1;
			}
			if (Math.abs($sy) < 0.01) {
				$sy = 1;
			}
			if ($angle == -$skew || Math.abs(($angle + $skew) % (Math.PI - 0.01)) < 0.01) { //protects against rounding errors in tiny decimals
				var tx:Number = $m.tx;
				var ty:Number = $m.ty;
				$m.tx = $m.ty = 0;
				$m.rotate(-$angle);
				$m.scale($sx, $sy);
				$m.rotate($angle);
				$m.tx = tx;
				$m.ty = ty;
				if ($angle != -$skew) {
					$m.c = -Math.tan($angle) * $m.d; //can protect against rounding errors in extremely small decimals that make the skew and angle get slightly off-base so that it appears as though there is a skew when there shouldn't be. Commented out because we do it elsewhere in TransformItem, so it's redundant here.
				}
			} else {
				var cosAngle:Number = Math.cos($angle);
				var sinAngle:Number = Math.sin($angle);
				var cosSkew:Number = Math.cos($skew);
				var sinSkew:Number = Math.sin($skew);
				
				var a:Number = cosAngle * $m.a + sinAngle * $m.b;
				var b:Number = cosAngle * $m.b - sinAngle * $m.a;
				var c:Number = cosSkew * $m.c - sinSkew * $m.d;
				var d:Number = cosSkew * $m.d + sinSkew * $m.c;
				
				var ha:Number = (a * $sx) - a;
				var hb:Number = (b * $sy) - b;
				var hc:Number = (c * $sx) - c;
				var hd:Number = (d * $sy) - d;
				
				$m.a += cosAngle * ha - sinSkew * hb;
				$m.b += sinAngle * ha + cosSkew * hb;
				$m.c += sinSkew * hd + cosAngle * hc;
				$m.d += cosSkew * hd - sinAngle * hc;
			}			
		}
		
		public static function getSkew($m:Matrix):Number {
			return Math.atan2($m.c, $m.d);
		}
		
		public static function setSkewX($m:Matrix, $skewX:Number):void {
			var sy:Number = Math.sqrt($m.c * $m.c + $m.d * $m.d);
			$m.c = -sy * Math.sin($skewX);
			$m.d =  sy * Math.cos($skewX);
		}
		
		public static function setSkewY($m:Matrix, $skewY:Number):void {
			var sx:Number = Math.sqrt($m.a * $m.a + $m.b * $m.b);
			$m.a = sx * Math.cos($skewY);
			$m.b = sx * Math.sin($skewY);
		}
	
	}
}