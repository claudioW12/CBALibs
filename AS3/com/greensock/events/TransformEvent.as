/*
VERSION: 1.1
DATE: 3/12/2009
ACTIONSCRIPT VERSION: 3.0 (Requires Flash Player 9)

CODED BY: Jack Doyle, jack@greensock.com
Copyright 2008, GreenSock (This work is subject to the terms at http://www.greensock.com/eula.html.)
*/

package com.greensock.events {
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TransformEvent extends Event {
		public static const MOVE:String = "tmMove";
		public static const SCALE:String = "tmScale";
		public static const ROTATE:String = "tmRotate";
		public static const SELECT:String = "tmSelect";
		public static const MOUSE_DOWN:String = "tmMouseDown";
		public static const SELECT_MOUSE_DOWN:String = "tmSelectMouseDown";
		public static const SELECT_MOUSE_UP:String = "tmSelectMouseUp";
		public static const ROLL_OVER_SELECTED:String = "tmRollOverSelected";
		public static const ROLL_OUT_SELECTED:String = "tmRollOutSelected";
		public static const DELETE:String = "tmDelete";
		public static const SELECTION_CHANGE:String = "tmSelectionChange";
		public static const DESELECT:String = "tmDeselect";
		public static const CLICK_OFF:String = "tmClickOff";
		public static const UPDATE:String = "tmUpdate";
		public static const DEPTH_CHANGE:String = "tmDepthChange";
		public static const DESTROY:String = "tmDestroy";
		
		public var items:Array;
		public var mouseEvent:MouseEvent;
		
		public function TransformEvent($type:String, $items:Array, $mouseEvent:MouseEvent = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			this.items = $items;
			this.mouseEvent = $mouseEvent;
		}
		
		public override function clone():Event{
			return new TransformEvent(this.type, this.items, this.mouseEvent, this.bubbles, this.cancelable);
		}
	
	}
	
}