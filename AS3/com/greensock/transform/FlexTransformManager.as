/*
VERSION: 1.62
DATE: 4/14/2009
ACTIONSCRIPT VERSION: 3.0 (Requires Flash Player 9)
FLEX VERSION
DESCRIPTION: 
	FlexTransformManager makes it easy to add interactive scaling/rotating/moving of DisplayObjects to your Flex application.
	It uses an intuitive interface that's similar to most modern drawing applications. When the user clicks on a managed
	DisplayObject, a selection box will be drawn around it along with 8 handles for scaling/rotating. When the mouse 
	is placed just outside of any of the scaling handles, the cursor will change to indicate that they're in rotation mode. 
	Just like most other applications, the user can hold down the SHIFT key to select multiple items, to constrain
	scaling proportions, or to limit the rotation to 45 degree increments. All the work is done by the TransformManager
	instance which is compatible with Flash, but FlexTransformManager is basically a wrapper that makes it compatible with Flex.
	
	Features include: 
		- Select multiple items and scale/rotate/move them all simultaneously. 
		- Optionally control everything (transformations, selections, etc.) through code. 
		- 4 extra handles for a total of 8
		- Depth management which allows you to programmatically push the selected items forward or backward in the stacking order
		- Arrow keys move the selection (optional)
		- Define bounds within which the DisplayObjects must stay, and FlexTransformManager will not let the user scale/rotate/move them beyond those bounds
		- Automatically bring the selected item(s) to the front in the stacking order (optional)
		- The DELETE and BACKSPACE keys can be used to delete the selected DisplayObjects (optional)
		- Lock certain kinds of transformations like rotation, scale, and/or movement (optional)
		- Lock the proportions of the DisplayObjects so that users cannot distort them when scaling
		- Scale from the DisplayObject's center or from its corners
		- Listen for Events like scale, move, rotate, select, deselect, click off, delete, depth change, and destroy
		- Set the selection box line color and handle thickness
		- Cursor will automatically change to indicate scale or rotation mode
		- You can set the scaleMode of any TransformItem to SCALE_WIDTH_AND_HEIGHT so that the width/height properties are altered instead of scaleX/scaleY. This is helpful for text-related components because altering the width/height changes only the container's dimensions while retaining the text's size.
		- TextAreas, TextInputs, UITextFields, Labels, and RichTextEditors are automatically scaled using width/height instead of scaleX/scaleY in order to retain the size of the text.
		- VERY easy to use. In fact, all it takes is one line of code to get it up and running with the default settings.
	
	
LIMITATIONS:
		- Due to several bugs in the Flex framework, FlexTransformManager cannot accommodate scrollbars.
		- TextFields cannot be scaled disproportionately due to another bug in the Flex framework. Therefore TextFields cannot scale properly in FlexTransformManager.
	
		
IMPORTANT PROPERTIES:
	- width : Number					Width of the Canvas area inside which your TransformItems are contained.
	- height : Number					Height of the Canvas area inside which your TransformItems are contained.
	- constrainScale : Boolean 			To constrain items to only scaling proportionally, set this to true [default:false]
	- scaleFromCenter : Boolean 		To force all items to use the center of the selection as the origin for scaling, set this to true [default:false]
	- lockScale : Boolean 				Prevents scaling [default:false]
	- lockRotation : Boolean 			Prevents rotating [default:false]
	- lockPosition : Boolean 			Prevents moving [default:false]
	- arrowKeysMove : Boolean 			When true, the arrow keys on the keyboard move the selected items when pressed [default: false]
	- autoDeselect : Boolean 			When the user clicks anywhere OTHER than on one of the TransformItems, all are deselected [default:true]
	- allowDelete : Boolean 			When the user presses the delete (or backspace) key, the selected item(s) will be deleted (except TextFields) [default:false]
	- allowMultiSelect:Boolean			To prevent users from being able to select multiple items, set this to false [default:true]
	- bounds : Rectangle				Defines the boundaries for movement/scaling/rotation. [default:null]
	- lineColor : Number 				Controls the line color of the selection box and handles [default:0x3399FF]
	- handleSize : Number 				Controls the handle size (in pixels) [default:8]
	- handleFillColor : Number 			Controls the fill color of the handle [default:0xFFFFFF]
	- paddingForRotation : Number 		Sets the amount of space outside each of the four corner scale handles that will trigger rotation mode [default:12]
	- enabled : Boolean 				Allows you to enable or disable the TransformManager [default:true]
	- forceSelectionToFront : Boolean 	When true, new selections are forced to the front of the display list of the container DisplayObjectContainer [default:false]
	- selectedTargetObjects : Array		An easy way to get an Array of all selected targetObjects 
	- selectedItems : Array 			Similar to selectedTargetObjects, but returns the TransformItem and TransformItemTF instances of the selected items
	- items : Array						All of the TransformItem and TransformItemTF instances that are controlled by this TransformManager (regardless of whether they're selected or not)
	- targetObjects : Array				All of the targetObjects (DisplayObject) that are controlled by this TransformManager (regardless of whether they're selected or not)
	- ignoredObjects : Array			Sometimes you want TransformManager to ignore clicks on certain DisplayObjects, like buttons, color pickers, etc. Those items should populate the ignoreObjects Array. The DisplayObject CANNOT be a child of a targetObject.
	
IMPORTANT METHODS:
	- addItem(targetObject:DisplayObject, scaleMode:String, hasSelectableText:Boolean):TransformItem	To make a DisplayObject controllable by this TransformManager, use this method.
	- addItems(targetObjects:Array, scaleMode:String, hasSelectableText:Boolean):Array																Same as addItem() but accepts an Array of DisplayObjects (returns an Array of TransformItems)
	- removeItem(item:*):void 																			Removes an item. Calling this on an item will not delete the DisplayObject - it just prevents it from being transformable by this TransformManager anymore.
	- selectItem(item:*, addToSelection:Boolean):TransformItem											A quick way to select an item. You may pass in the item's TransformItem or the DisplayObject (targetObject). 
	- selectItems(items:Array, addToSelection:Boolean):Array											Same as selectItem() but accepts an Array of TransformItems (or DisplayObjects)
	- deselectItem(item:*):void 																		Deselects a particular item or DisplayObject
	- deselectAll():void																				Deselects all items
	- getItem(targetObject:DisplayObject):TransformItem													An easy way to find the associated TransformItem from a DisplayObject (if one has been created)
	- scaleSelection(sx:Number, sy:Number):void															Scales the selected items. sx and sy are multipliers in the x and y directions respectively
	- moveSelection(x:Number, y:Number):void 															Moves the selected items. x and y are pixel measurements in the x and y directions respectively
	- rotateSelection(angle:Number):void																Rotates the selected items. Angle is in radians, not degrees.
	- updateSelection():void																			Redraws the selection around the selected items which can be useful if the items changed sizes/positions.
	- moveSelectionDepthDown():void																		Moves each of the selected items down one in z order.
	- moveSelectionDepthUp():void																		Moves each of the selected items up one in z order.
	- getSelectionCenter():Point																		Returns the center point of the current selection
	- getSelectionBounds():Rectangle																	Returns the bounds of the current selection (not including the handles)
	- getSelectionBoundsWithHandles():Rectangle															Returns the bounds of the current selection including the handles
	- addIgnoredObject(object:DisplayObject):void														Allows you to have TransformManager ignore clicks on a particular DisplayObject (handy for buttons, color pickers, etc.). The DisplayObject CANNOT be a child of a targetObject.
	- removeIgnoredObject(object:DisplayObject):void													Remove a DisplayObject from the list of ignoredObjects
	- destroy():void															

IMPORTANT EVENTS:
	- TransformEvent.SELECTION_CHANGE (to determine which items are selected, check the Event's info.items Array. If the Array is empty, it obviously means all items have been deselected)
	- TransformEvent.MOVE
	- TransformEvent.SCALE
	- TransformEvent.ROTATE
	- TransformEvent.CLICK_OFF (only called when autoDeselect is false, otherwise the DESELECT event is called)
	- TransformEvent.DELETE
	- TransformEvent.DEPTH_CHANGE
	- TransformEvent.DESTROY
	
	All TransformEvents have an "items" property which is an Array populated by the affected TransformItem instances. TransformEvents also have a "mouseEvent" property that will be populated if there was an associted MouseEvent (like CLICK_OFF) 



EXAMPLES: 
	To make two Images (myImage1 and myImage2) transformable using the default settings:
	
		<?xml version="1.0" encoding="utf-8"?>
		<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute" xmlns:transform="gs.transform.*">
			<transform:FlexTransformManager id="myManager" width="500" height="500">
				<mx:Image source="../libs/image1.png" id="myImage1" autoLoad="true" x="100" y="100" />
				<mx:Image source="../libs/image2.png" id="myImage2" autoLoad="true" x="0" y="300" />
			</transform:FlexTransformManager>
		</mx:Application>
	
	
	To make the two Images transformable, constrain their scaling to be proportional (even if the user is not holding
	down the shift key), call the onScale function everytime one of the objects is scaled, lock the rotation value of each 
	Image (preventing rotation), and allow the delete key to appear to delete the selected Image from the stage:
	
		<?xml version="1.0" encoding="utf-8"?>
		<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute" xmlns:transform="gs.transform.*" creationComplete="init()">
			<mx:Script>
				<![CDATA[
					import gs.events.TransformEvent;
					private function init():void {
						myManager.addEventListener(TransformEvent.SCALE, onScale, false, 0, true);
					}
					private function onScale($e:TransformEvent):void {
						trace("Scaled " + $e.items.length + " items");
					}
				]]>
			</mx:Script>
			<transform:FlexTransformManager id="myManager" width="500" height="500" allowDelete="true" constrainScale="true" lockRotation="true">
				<mx:Image source="../libs/image1.png" id="image1" autoLoad="true" x="50" y="50" />
				<mx:Image source="../libs/image1.png" id="image2" autoLoad="true" x="100" y="200" />
			</transform:FlexTransformManager>
		</mx:Application>



AUTHOR: Jack Doyle, jack@greensock.com
Copyright 2009, GreenSock. All rights reserved. This work is subject to the terms in http://www.greensock.com/terms_of_use.html or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
*/

package com.greensock.transform {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	import com.greensock.events.TransformEvent;
	
	import mx.containers.Canvas;
	import mx.core.UITextField;
	
	[Event(name="move", type="gs.events.TransformEvent")]
	[Event(name="scale", type="gs.events.TransformEvent")]
	[Event(name="rotate", type="gs.events.TransformEvent")]
	[Event(name="select", type="gs.events.TransformEvent")]
	[Event(name="mouseDown", type="gs.events.TransformEvent")]
	[Event(name="selectMouseDown", type="gs.events.TransformEvent")]
	[Event(name="selectMouseUp", type="gs.events.TransformEvent")]
	[Event(name="delete", type="gs.events.TransformEvent")]
	[Event(name="selectionChange", type="gs.events.TransformEvent")]
	[Event(name="deselect", type="gs.events.TransformEvent")]
	[Event(name="clickOff", type="gs.events.TransformEvent")]
	[Event(name="update", type="gs.events.TransformEvent")]
	[Event(name="depthChange", type="gs.events.TransformEvent")]
	[Event(name="destroy", type="gs.events.TransformEvent")]
	
	public class FlexTransformManager extends Canvas {
		public static const VERSION:Number = 1.62;
		protected static var _flexTF:UITextField; //Just ensures that the UITextField class is embedded for use in TransformItem.
		protected static var _initted:Boolean;
		protected static var _nonStandardScalingClasses:Array; //Classes that will be treated like TextFields where their width and height is scaled instead of scaleX/scaleY
		
		protected var _manager:TransformManager;
		
		public function FlexTransformManager($vars:Object = null) {
			super();
			if (!_initted) {
				if (TransformManager.VERSION < 1.67) {
					trace("TransformManager Error: You have an outdated TransformManager-related class file. You may need to clear your ASO files. Please make sure you're using the latest version of TransformManager, FlexTransformItem, and FlexTransformItemTF, available from www.greensock.com.");
				}
				_nonStandardScalingClasses = [];
				
				//these classes will be scaled by changing their width/height instead of scaleX/scaleY (this is preferred for certain text-related components so that only the container resizes instead of the text.
				addNonStandardScalingClass("mx.controls.TextArea", TransformManager.SCALE_WIDTH_AND_HEIGHT, true);
				addNonStandardScalingClass("mx.controls.TextInput", TransformManager.SCALE_WIDTH_AND_HEIGHT, true);
				addNonStandardScalingClass("mx.core.UITextField", TransformManager.SCALE_WIDTH_AND_HEIGHT, true);
				addNonStandardScalingClass("mx.controls.RichTextEditor", TransformManager.SCALE_WIDTH_AND_HEIGHT, true);
				addNonStandardScalingClass("mx.controls.Label", TransformManager.SCALE_WIDTH_AND_HEIGHT, false);
				
				_initted = true;
			}
			_manager = new TransformManager($vars);
			super.verticalScrollPolicy = "off";
			super.horizontalScrollPolicy = "off";
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 1, true);
		}
		
		protected static function addNonStandardScalingClass($classPath:String, $scaleMode:String, $hasSelectableText:Boolean):void {
			var type:Object;
			try {
				type = getDefinitionByName($classPath);
			} catch ($e:Error) {
				
			}
			if (type != null) {
				_nonStandardScalingClasses[_nonStandardScalingClasses.length] = {type:type, scaleMode:$scaleMode, hasSelectableText:$hasSelectableText};
			}
		}
		
		protected function onAddToStage($e:Event):void {
			for (var i:int = this.numChildren - 1; i > -1; i--) {
				autoAddChild(this.getChildAt(i));
			}
			_manager.bounds = new Rectangle(0, 0, this.width, this.height);
		}
		
		public function addItem($targetObject:DisplayObject, $scaleMode:String="scaleNormal", $hasSelectableText:Boolean=false):TransformItem {
			if ($targetObject.parent != this) {
				super.addChildAt($targetObject, Math.max(0, this.numChildren - 1));
			}
			return _manager.addItem($targetObject, $scaleMode, $hasSelectableText);
		}
		
		public function addItems($targetObjects:Array, $scaleMode:String="scaleNormal", $hasSelectableText:Boolean=false):Array	{
			for (var i:int = 0; i < $targetObjects.length; i++) {
				if ($targetObjects[i].parent != this) {
					super.addChild($targetObjects[i]);
				}
			}
			return _manager.addItems($targetObjects, $scaleMode, $hasSelectableText);
		}
		
		override public function addChild($child:DisplayObject):DisplayObject {
			var mc:DisplayObject = super.addChild($child);
			autoAddChild($child);
			return mc;
		}
		
		protected function autoAddChild($child:DisplayObject):void {
			var i:int, ignored:Array = _manager.ignoredObjects;
			for (i = 0; i < ignored.length; i++) {
				if (ignored[i] == $child) {
					return;
				}
			}
			if (_manager != null && $child.name != "__dummyBox_mc" && $child.name != "__selection_mc" && $child.name.substr(0, 9) != "__tmProxy") {
				var scaleMode:String = TransformManager.SCALE_NORMAL, hasSelectableText:Boolean = false;
				for (i = _nonStandardScalingClasses.length - 1; i > -1; i--) {
					if ($child is _nonStandardScalingClasses[i].type) {
						scaleMode = _nonStandardScalingClasses[i].scaleMode;
						hasSelectableText = _nonStandardScalingClasses[i].hasSelectableText;
					}
				}
				addItem($child, scaleMode, hasSelectableText);
			}
		}
		
		override public function addChildAt($child:DisplayObject, $index:int):DisplayObject {
			var mc:DisplayObject = super.addChildAt($child, $index);
			autoAddChild($child);
			return mc;
		}
		
		public function removeItem($item:*):void {
			_manager.removeItem($item);
		}
		
		override public function removeChild($child:DisplayObject):DisplayObject {
			_manager.removeItem($child);
			return super.removeChild($child);
		}
		
		override public function removeChildAt($index:int):DisplayObject {
			_manager.removeItem(this.getChildAt($index));
			return super.removeChildAt($index);
		}
		
		public function addIgnoredObject($object:DisplayObject):void {
			_manager.addIgnoredObject($object);
		}
		
		public function removeIgnoredObject($object:DisplayObject):void {
			_manager.removeIgnoredObject($object);
		}
		
		override public function addEventListener($type:String, $listener:Function, $useCapture:Boolean=false, $priority:int=0, $useWeakReference:Boolean=false):void {
			var isTransform:Boolean = false;
			switch ($type) {
				case TransformEvent.CLICK_OFF:
				case TransformEvent.DELETE:
				case TransformEvent.DEPTH_CHANGE:
				case TransformEvent.DESELECT:
				case TransformEvent.DESTROY:
				case TransformEvent.MOUSE_DOWN:
				case TransformEvent.MOVE:
				case TransformEvent.ROTATE:
				case TransformEvent.SCALE:
				case TransformEvent.SELECT:
				case TransformEvent.SELECTION_CHANGE:
				case TransformEvent.UPDATE:
					_manager.addEventListener($type, $listener, $useCapture, $priority, $useWeakReference);
					isTransform = true;
					break;
			}
			if (!isTransform) {
				super.addEventListener($type, $listener, $useCapture, $priority, $useWeakReference);
			}
		}
		
		override public function removeEventListener($type:String, $listener:Function, $useCapture:Boolean=false):void {
			var isTransform:Boolean = false;
			switch ($type) {
				case TransformEvent.CLICK_OFF:
				case TransformEvent.DELETE:
				case TransformEvent.DEPTH_CHANGE:
				case TransformEvent.DESELECT:
				case TransformEvent.DESTROY:
				case TransformEvent.MOUSE_DOWN:
				case TransformEvent.MOVE:
				case TransformEvent.ROTATE:
				case TransformEvent.SCALE:
				case TransformEvent.SELECT:
				case TransformEvent.SELECTION_CHANGE:
				case TransformEvent.UPDATE:
					_manager.removeEventListener($type, $listener, $useCapture);
					isTransform = true;
					break;
			}
			if (!isTransform) {
				super.removeEventListener($type, $listener, $useCapture);
			}
		}
		
		override public function removeAllChildren():void {
			_manager.removeAllItems();
			super.removeAllChildren();
		}
		
		public function selectItem($item:*, $addToSelection:Boolean=false):void {
			_manager.selectItem($item, $addToSelection);
		}
		
		public function selectItems($items:Array, $addToSelection:Boolean=false):void {
			_manager.selectItems($items, $addToSelection);
		}
		
		public function deselectItem($item:*):void {
			_manager.deselectItem($item);
		}
		
		public function deselectAll():void {
			_manager.deselectAll();
		}
		
		public function isSelected($item:*):Boolean {
			return _manager.isSelected($item);
		}
		
		public function updateSelection():void {
			_manager.updateSelection();
		}
		
		public function getItem($targetObject:DisplayObject):TransformItem {
			return _manager.getItem($targetObject);
		}
		
		public function moveSelectionDepthDown():void {
			_manager.moveSelectionDepthDown();
		}
		
		public function moveSelectionDepthUp():void {
			_manager.moveSelectionDepthUp();
		}
		
		public function getSelectionCenter():Point {
			return _manager.getSelectionCenter();
		}
		
		public function getSelectionBounds():Rectangle {
			return _manager.getSelectionBounds();
		}
		
		public function getSelectionBoundsWithHandles():Rectangle {
			return _manager.getSelectionBoundsWithHandles();
		}
		
		public function getUnrotatedSelectionWidth():Number {
			return _manager.getUnrotatedSelectionWidth();
		}
		
		public function getUnrotatedSelectionHeight():Number {
			return _manager.getUnrotatedSelectionHeight();
		}
		
		public function moveSelection($x:Number, $y:Number):void {
			_manager.moveSelection($x, $y);
		}
		
		public function scaleSelection($sx:Number, $sy:Number):void {
			_manager.scaleSelection($sx, $sy);
		}
		
		public function rotateSelection($angle:Number):void {
			_manager.rotateSelection($angle);
		}
		
		public function destroy():void {
			_manager.destroy();
			_manager = null;
			if (this.parent != null) {
				this.parent.removeChild(this);
			}
		}
		
//---- GETTERS / SETTERS -----------------------------------------------------------------------------------------------------
		
		override public function get enabled():Boolean {
			return _manager.enabled;
		}
		override public function set enabled($b:Boolean):void { //Gives us a way to enable/disable all FlexTransformItems
			if (_manager != null) {
				_manager.enabled = $b;
			}
			super.enabled = $b;
		}
		override public function set width($n:Number):void {
			if (this.height != 0) {
				_manager.bounds = new Rectangle(0, 0, $n, this.height);
			} else if (this.parent != null) {
				_manager.bounds = new Rectangle(0, 0, $n, this.parent.height);
			}
			super.width = $n;
		}
		override public function set height($n:Number):void {
			if (this.width != 0) {
				_manager.bounds = new Rectangle(0, 0, this.width, $n);
			} else if (this.parent != null) {
				_manager.bounds = new Rectangle(0, 0, this.parent.width, $n);
			}
			super.height = $n;
		}
		override public function set verticalScrollPolicy($value:String):void {
			trace("FlexTransformManager must have verticalScrollPolicy set to 'off'.");
		}
		override public function set horizontalScrollPolicy($value:String):void {
			trace("FlexTransformManager must have horizontalScrollPolicy set to 'off'.");
		}
		public function get selectionScaleX():Number {
			return _manager.selectionScaleX;
		}
		public function set selectionScaleX($n:Number):void {
			_manager.selectionScaleX = $n;
		}
		public function get selectionScaleY():Number {
			return _manager.selectionScaleY;
		}
		public function set selectionScaleY($n:Number):void {
			_manager.selectionScaleY = $n;
		}
		public function get selectionRotation():Number {
			return _manager.selectionRotation;
		}
		public function set selectionRotation($n:Number):void {
			_manager.selectionRotation = $n;
		}
		public function get selectionX():Number {
			return _manager.selectionX;
		}
		public function set selectionX($n:Number):void {
			_manager.selectionX = $n;
		}
		public function get selectionY():Number {
			return _manager.selectionY;
		}
		public function set selectionY($n:Number):void {
			_manager.selectionY = $n;
		}
		public function get items():Array {
			return _manager.items;
		}
		public function get targetObjects():Array {
			return _manager.targetObjects;
		}
		public function set selectedTargetObjects($a:Array):void {
			_manager.selectedTargetObjects = $a;
		}
		public function get selectedTargetObjects():Array {
			return _manager.selectedTargetObjects;
		}
		public function set selectedItems($a:Array):void {
			_manager.selectedItems = $a;
		}
		public function get selectedItems():Array {
			return _manager.selectedItems;
		}
		public function set constrainScale($b:Boolean):void {
			_manager.constrainScale = $b;
		}
		public function get constrainScale():Boolean {
			return _manager.constrainScale;
		}
		public function set lockScale($b:Boolean):void {
			_manager.lockScale = $b;
		}
		public function get lockScale():Boolean {
			return _manager.lockScale;
		}
		public function set scaleFromCenter($b:Boolean):void {
			_manager.scaleFromCenter = $b;
		}
		public function get scaleFromCenter():Boolean {
			return _manager.scaleFromCenter;
		}
		public function set lockRotation($b:Boolean):void {
			_manager.lockRotation = $b;
		}
		public function get lockRotation():Boolean {
			return _manager.lockRotation;
		}
		public function set lockPosition($b:Boolean):void {
			_manager.lockPosition = $b;
		}
		public function get lockPosition():Boolean {
			return _manager.lockPosition;
		}
		public function set allowMultiSelect($b:Boolean):void {
			_manager.allowMultiSelect = $b
		}
		public function get allowMultiSelect():Boolean {
			return _manager.allowMultiSelect;
		}
		public function set allowDelete($b:Boolean):void {
			_manager.allowDelete = $b;
		}
		public function get allowDelete():Boolean {
			return _manager.allowDelete;
		}
		public function set autoDeselect($b:Boolean):void {
			_manager.autoDeselect = $b;
		}
		public function get autoDeselect():Boolean {
			return _manager.autoDeselect;
		}
		public function set lineColor($n:uint):void {
			_manager.lineColor = $n;
		}
		public function get lineColor():uint {
			return _manager.lineColor;
		}
		public function set handleFillColor($n:uint):void {
			_manager.handleFillColor = $n;
		}
		public function get handleFillColor():uint {
			return _manager.handleFillColor;
		}
		public function set handleSize($n:Number):void {
			_manager.handleSize = $n;
		}
		public function get handleSize():Number {
			return _manager.handleSize;
		}
		public function set paddingForRotation($n:Number):void {
			_manager.paddingForRotation = $n;
		}
		public function get paddingForRotation():Number {
			return _manager.paddingForRotation;
		}
		public function set bounds($r:Rectangle):void {
			_manager.bounds = $r;
		}
		public function get bounds():Rectangle {
			return _manager.bounds;
		}
		public function get forceSelectionToFront():Boolean {
			return _manager.forceSelectionToFront;
		}
		public function set forceSelectionToFront($b:Boolean):void {
			_manager.forceSelectionToFront = $b;
		}
		public function set arrowKeysMove($b:Boolean):void {
			_manager.arrowKeysMove = $b;
		}
		public function get arrowKeysMove():Boolean {
			return _manager.arrowKeysMove;
		}
		public function get transformManager():TransformManager {
			return _manager;
		}
		public function get ignoredObjects():Array {
			return _manager.ignoredObjects;
		}
		public function set ignoredObjects($a:Array):void {
			_manager.ignoredObjects = $a;
		}
	
	}
	
}