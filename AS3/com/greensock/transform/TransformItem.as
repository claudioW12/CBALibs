/*
VERSION: 1.63
DATE: 4/14/2009
ACTIONSCRIPT VERSION: 3.0 (Requires Flash Player 9)
FLASH VERSION
DESCRIPTION: 
	This class works with the TransformManager class to give the user the ability to scale, rotate, and/or move 
	any DisplayObject on the stage using an intuitive interface (similar to most modern drawing applications). 
	Please see the documentation in the TransformManager class for more details.
	
	You can get the TransformItem instance associated with a particular targetObject anytime
	after it is added to the TransformManager instance using the TransformManager's getItem() method, like:
		
		var myItem:TransformItem = myManager.getItem(myObject);


EXAMPLE: 
	To make a Sprite instance named "mySprite" transformable (with default settings):
	
		import gs.transform.TransformItem;
		
		var myItem:TransformItem = new TransformItem(mySprite);
		
	To make the Sprite transformable, constrain its scaling to be proportional (even if the user is not holding
	down the shift key), call the onScale function whenever the Sprite is interactively scaled, and prevent rotation:
	
		import gs.transform.TransformItem;
		import gs.events.TransformEvent;
		
		var myItem:TransformItem = new TransformItem(mySprite, {constrainScale:true, lockRotation:true});
		myItem.addEventListener(TransformEvent.SCALE, onScale);
		function onScale($e:TransformEvent):void {
			trace("Scaled " + $e.items[0].targetObject);
		}
		
IMPORTANT PROPERTIES (* marks properties that can be set exclusively via the constructor):
	- constrainScale : Boolean 			To constrain items to only scaling proportionally, set this to true [default:false]
	- lockScale : Boolean 				Prevents scaling [default:false]
	- lockRotation : Boolean 			Prevents rotating [default:false]
	- lockPosition : Boolean 			Prevents moving [default:false]
	- bounds : Rectangle				Defines the boundaries for movement/scaling/rotation. [default:null]
	- enabled : Boolean 				Allows you to enable or disable the TransformManager [default:true]
	- targetObject : DisplayObject		Returns all of the targetObjects that are controlled by this TransformManager (regardless of whether they're selected or not)
	- selected : Boolean				Controls whether or not the item is selected
	- minScaleX : Number				Imposes a minimum scaleX constraint
	- minScaleY : Number				Imposes a minimum scaleY constraint
	- maxScaleX : Number				Imposes a maximum scaleX constraint
	- maxScaleY : Number				Imposes a maximum scaleY constraint
	- scaleMode : String				Either TransformManager.SCALE_NORMAL (for normal scaleX/scaleY scaling), or if you prefer to have the item resized using its width/height properties, set this to TranfsormManager.SCALE_WIDTH_AND_HEIGHT (this is useful for text-related objects and components when you want the container to resize, but not the text)
	- hasSelectableText : Boolean		If true, this sets the scaleMode to SCALE_WIDTH_AND_HEIGHT, and prevents dragging of the object unless clicking on the edges/border or center handle, and allows the delete key to be pressed without deleting the object itself.
	* forceSelectionToFront : Boolean 	When true, new selections are forced to the front of the display list of the container DisplayObjectContainer [default:false]
	* allowMultiSelect : Boolean		To prevent users from being able to select multiple items, set this to false [default:true]
	* lineColor : Number 				Controls the line color of the selection box and handles [default:0x3399FF]
	* handleSize : Number 				Controls the handle size (in pixels) [default:8]
	* handleFillColor : Number 			Controls the fill color of the handle [default:0xFFFFFF]
	* paddingForRotation : Number 		Sets the amount of space outside each of the four corner scale handles that will trigger rotation mode [default:12]
	* autoDeselect : Boolean 			When the user clicks anywhere OTHER than on one of the TransformItems, all are deselected [default:true]
	* allowDelete : Boolean 			When the user presses the delete (or backspace) key, the selected item(s) will be deleted (except TextFields) [default:false]
	* scaleFromCenter : Boolean 		To force all items to use the center of the selection as the origin for scaling, set this to true [default:false]
	
IMPORTANT METHODS:
	- move(x:Number, y:Number, checkBounds:Boolean, dispatchEvent:Boolean):void
	- scale(sx:Number, sy:Number, angle:Number, checkBounds:Boolean, dispatchEvent:Boolean):void
	- rotate(angle:Number, checkBounds:Boolean, dispatchEvent:Boolean):void
	- update():void
	- destroy():void
	
IMPORTANT EVENTS:
	- TransformEvent.SELECT
	- TransformEvent.DESELECT
	- TransformEvent.MOVE
	- TransformEvent.SCALE
	- TransformEvent.ROTATE
	- TransformEvent.DELETE
	- TransformEvent.DESTROY
	
	All TransformEvents have an "items" property that's an Array populated by the affected TransformItem instances
		
NOTES:
	- Requires Flash Player 9 or later
	- It's highly recommended that you NOT use TransformItems apart from a TransformManager. The recommended method is to
	  first create a TransformManager and then use its addItem() method to make a DisplayObject transformable. This way,
	  you get access to more events and have more control over selections, etc.

CHANGE LOG:
	1.63:
		- Fixed potential drift in registration point if/when move() is called via code and then another transformation is attempted (rotate/scale)
	1.62:
		- Worked around a Flex bug that caused problems with transforming text-related objects immediately after adding them to TransformManager
	1.61:
		- Fixed bug that could cause problems if the targetObject wasn't on the stage when its TransformItem was being instantiated.
	1.6:
		- Added a moveCursor to TransformManager that indicates when selected items are moveable. TransformItem now dispatches ROLL_OVER_SELECTED and ROLL_OUT_SELECTED events.
	1.5:
		- Made the edges draggable (there is a 10-pixel wide area around the border that users can drag). This is particularly helpful with TextFields/TextAreas.
		- Eliminated the need for the TransformItemTF class. TransformItem now handles TextFields too (see the "hasSelectableText" and "scaleMode" additions below).
		- Added "hasSelectableText" property which sets the scaleMode to SCALE_WIDTH_AND_HEIGHT, and prevents dragging of the object unless clicking on the edges/border or center handle, and allows the delete key to be pressed without deleting the object itself.
		- Added "scaleMode" property which can be set to either TransformManager.SCALE_NORMAL (the default), or TransformManager.SCALE_WIDTH_AND_HEIGHT which is useful for text-related objects and/or components. Note: when the scaleMode is set to SCALE_WIDTH_AND_HEIGHT, you cannot flip the object backwards in either direction, nor can you scale it as part of a multi-selection.
		- Added scaleMode and hasSelectableText parameters to the addItem() and addItems() methods of TransformManager
		- Altered FlexTransformManager so that - TextAreas, TextInputs, UITextFields, and RichTextEditors are automatically scaled using width/height instead of scaleX/scaleY in order to retain the size of the text.
		- Altered FlexTransformManager so that the focusThickness of selected components is set to zero (otherwise, it can interfere with the handles slightly)
	1.48:
		- Made changes in order to accommodate a scenario where the targetObject is deleted immediately upon selection (in a TransformEvent.SELECT listener) - previously a 1009 error would be thrown.
	1.47:
		- Fixed bug that could occassionally cause movement of certain components to appear to "jitter" when hitting the bounds
	1.45:
		- Fixed bug that could occassionally cause items to be allowed to scale past the right-most bounds edge.
	1.43:
		- Fixed bug that could occassionally cause incorrect scaling when an item is positioned exactly on top of the bottom right corner of the boundary and scaled with the upper left corner handle
		- Fixed bug that could occassionally cause the stretching handles (on the top, bottom, left and right) to not function if the object was positioned directly on top of a boundary/edge.
	1.42:
		- Added width and height getters/setters to TransformItem and fixed minor bug in TransformItem's scale() method
	1.35:
		- Added scaleX, scaleY, rotation, x, y, and alpha getters/setters to TransformItem. scaleX, scaleY, and rotation always use the center of the TransformItem as the registration point.


AUTHOR: Jack Doyle, jack@greensock.com
Copyright 2009, GreenSock. All rights reserved. This work is subject to the terms in http://www.greensock.com/eula.html or for corporate Club GreenSock members ("unlimited" level), the software agreement that was issued with the corporate membership.
*/

package com.greensock.transform {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.getDefinitionByName;
	
	import com.greensock.events.TransformEvent;
	import com.greensock.transform.utils.MatrixTools;
	
	public class TransformItem extends EventDispatcher {
		public static const VERSION:Number = 1.63;
		protected static const _DEG2RAD:Number = Math.PI / 180; //precomputation for speed
		protected static const _RAD2DEG:Number = 180 / Math.PI; //precomputation for speed;
		protected static var _proxyCount:uint = 0;
		
		protected var _hasSelectableText:Boolean;
		
		protected var _stage:Stage;
		protected var _scaleMode:String;
		protected var _target:DisplayObject; //if scaleMode is normal. this will point to the _targetObject. Otherwise, we create a proxy that we scale normally and then use it to scale the width/height or setSize() the targetObject.
		protected var _proxy:InteractiveObject;
		protected var _offset:Point; //used for TextFields - for some odd reason, TextFields created in the IDE must be offset 2 pixels left and up in order to line up properly with their scaled counterparts. 
		protected var _origin:Point;
		protected var _localOrigin:Point;
		protected var _baseRect:Rectangle;
		protected var _bounds:Rectangle;
		protected var _targetObject:DisplayObject;
		protected var _allowDelete:Boolean; //If true, we'll delete a TransformItem's MovieClip when it's selected and the user hits the Delete key.
		protected var _constrainScale:Boolean; //If true, only proportional scaling is allowed (even if the SHIFT key isn't held down).
		protected var _lockScale:Boolean;
		protected var _lockRotation:Boolean;
		protected var _lockPosition:Boolean;
		protected var _enabled:Boolean; //Set this value to false if you want to disable all TransformItems. Setting it to true will enable them all.
		protected var _selected:Boolean;
		protected var _minScaleX:Number;
		protected var _minScaleY:Number;
		protected var _maxScaleX:Number;
		protected var _maxScaleY:Number;
		protected var _cornerAngleTL:Number;
		protected var _cornerAngleTR:Number;
		protected var _cornerAngleBR:Number;
		protected var _cornerAngleBL:Number;
		protected var _createdManager:TransformManager;
		protected var _isFlex:Boolean;
		protected var _frameCount:uint = 0;
		
		public function TransformItem($targetObject:DisplayObject, $vars:Object) {
			if (TransformManager.VERSION < 1.6) {
				trace("TransformManager Error: You have an outdated TransformManager-related class file. You may need to clear your ASO files. Please make sure you're using the latest version of TransformManager, TransformItem, and TransformItemTF, available from www.greensock.com.");
			}
			init($targetObject, $vars);
		}
		
		protected function init($targetObject:DisplayObject, $vars:Object):void {
			try {
				_isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager")); // SystemManager is the first display class created within a Flex application
			} catch ($e:Error) {
				_isFlex = false;
			}
			_targetObject = $targetObject;
			_baseRect = _targetObject.getBounds(_targetObject);
			_allowDelete = setDefault($vars.allowDelete, false);
			_constrainScale = setDefault($vars.constrainScale, false);
			_lockScale = setDefault($vars.lockScale, false);
			_lockRotation = setDefault($vars.lockRotation, false);
			_lockPosition = setDefault($vars.lockPosition, false);
			_hasSelectableText = setDefault($vars.hasSelectableText, (_targetObject is TextField) ? true : false);
			this.scaleMode = setDefault($vars.scaleMode, (_hasSelectableText) ? TransformManager.SCALE_WIDTH_AND_HEIGHT : TransformManager.SCALE_NORMAL);
			this.minScaleX = setDefault($vars.minScaleX, -Infinity);
			this.minScaleY = setDefault($vars.minScaleY, -Infinity);
			this.maxScaleX = setDefault($vars.maxScaleX, Infinity);
			this.maxScaleY = setDefault($vars.maxScaleY, Infinity);
			_bounds = $vars.bounds;
			this.origin = new Point(_targetObject.x, _targetObject.y);
			if ($vars.manager == undefined) {
				$vars.items = [this];
				_createdManager = new TransformManager($vars);
			}
			if (_targetObject.stage != null) {
				_stage = _targetObject.stage;
			} else {
				_targetObject.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			}
			_selected = false;
			_enabled = !Boolean($vars.enabled);
			this.enabled = !_enabled;
		}
		
		protected function onAddedToStage($e:Event):void { //needed to keep track of _stage primarily for the MOUSE_UP listening and for the scenario when a _targetObject is removed from the stage immediately when selected (very rare and somewhat unintuitive scenario, but a user did want to do it)
			_stage = _targetObject.stage;
			try {
				_isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager")); // SystemManager is the first display class created within a Flex application
			} catch ($e:Error) {
				_isFlex = false;
			}
			if (_proxy != null) {
				_targetObject.parent.addChild(_proxy);
			}
			_targetObject.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
//---- SELECTION ---------------------------------------------------------------------------------------
		
		protected function onMouseDown($e:MouseEvent):void {
			if (_hasSelectableText) {
				dispatchEvent(new TransformEvent(TransformEvent.MOUSE_DOWN, [this]));
			} else {
				_targetObject.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				dispatchEvent(new TransformEvent(TransformEvent.MOUSE_DOWN, [this], $e));
				if (_selected) {
					dispatchEvent(new TransformEvent(TransformEvent.SELECT_MOUSE_DOWN, [this], $e));
				}
			}
		}
		
		protected function onMouseUp($e:MouseEvent):void {
			_targetObject.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if (!_hasSelectableText && _selected) {
				dispatchEvent(new TransformEvent(TransformEvent.SELECT_MOUSE_UP, [this], $e));
			}
		}
		
		protected function onRollOverItem($e:MouseEvent):void {
			if (_selected) {
				dispatchEvent(new TransformEvent(TransformEvent.ROLL_OVER_SELECTED, [this], $e));
			}
		}
		
		protected function onRollOutItem($e:MouseEvent):void {
			if (_selected) {
				dispatchEvent(new TransformEvent(TransformEvent.ROLL_OUT_SELECTED, [this], $e));
			}
		}
		
		
//---- GENERAL -----------------------------------------------------------------------------------------
		
		public function update($e:Event = null):void {
			_baseRect = _targetObject.getBounds(_targetObject);
			setCornerAngles();
			if (_proxy != null) {
				calibrateProxy();
			}
			dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
		}
		
		//in Flex, we cannot addChild() immediately because the container needs time to instantiate or it will throw errors, so we wait 3 frames...
		protected function autoCalibrateProxy($e:Event=null):void {
			if (_frameCount >= 3) {
				_targetObject.removeEventListener(Event.ENTER_FRAME, autoCalibrateProxy);
				_targetObject.parent.addChild(_proxy);
				_target = _proxy;
				calibrateProxy();
				_frameCount = 0;
			} else {
				_frameCount++;
			}
		}
		
		protected function createProxy():void {
			removeProxy();
			
			if (_hasSelectableText) {
				_proxy = (_isFlex) ? new (getDefinitionByName("mx.core.UITextField"))() : new TextField();
			} else {
				_proxy = (_isFlex) ? new (getDefinitionByName("mx.core.UIComponent"))() : new Sprite();
			}
			_proxyCount++;
			_proxy.name = "__tmProxy" + _proxyCount;  //important: FlexTransformManager looks for this name in order to avoid infinite loop problems with addChild()
			_proxy.visible = false;
			
			try {
				_target = _proxy;
				_targetObject.parent.addChild(_proxy);
			} catch ($e:Error) {
				_target = _targetObject;
				_targetObject.addEventListener(Event.ENTER_FRAME, autoCalibrateProxy); //In Flex, sometimes the parent can need a few frames to instantiate properly
			}
			_offset = new Point(0, 0);
			
			//TextFields created in the IDE have a different gutter than ones created via ActionScript (2 pixels), so we must attempt to discern between the 2 using the line metrics...
			if (_targetObject is TextField) {
				var tf:TextField = (_targetObject as TextField);
				var isEmpty:Boolean = false;
				if (tf.text == "") {
					tf.text = "Y"; //temporarily dump a character in for measurement.
					isEmpty = true;
				}
				var format:TextFormat = tf.getTextFormat(0, 1);
				var altFormat:TextFormat = tf.getTextFormat(0, 1);
				altFormat.align = "left";
				tf.setTextFormat(altFormat, 0, 1);
				var metrics:TextLineMetrics = tf.getLineMetrics(0);
				if (metrics.x == 0) {
					_offset = new Point(-2, -2);
				}
				tf.setTextFormat(format, 0, 1);
				if (isEmpty) {
					tf.text = "";
				}
				
			}
			calibrateProxy();
		}
		
		protected function removeProxy():void {
			if (_proxy != null) {
				if (_proxy.parent != null) {
					_proxy.parent.removeChild(_proxy);
				}
				_proxy = null;
			}
			_target = _targetObject;
		}
		
		protected function calibrateProxy():void {
			var m:Matrix = _targetObject.transform.matrix;
			_targetObject.transform.matrix = new Matrix(); //to clear all transformations
			
			if (!_hasSelectableText) {
				var r:Rectangle = _targetObject.getBounds(_targetObject);
				var g:Graphics = (_proxy as Sprite).graphics;
				g.clear();
				g.beginFill(0xFF0000, 0);
				g.drawRect(r.x, r.y, _targetObject.width, _targetObject.height); //don't use r.width and r.height because often times Flex components report those inaccurately with getBounds()!
				g.endFill();
			}
			
			_proxy.width = _baseRect.width = _targetObject.width;
			_proxy.height = _baseRect.height = _targetObject.height;
			_proxy.transform.matrix = _targetObject.transform.matrix = m;
		}
		
		protected function setCornerAngles():void { //figures out the angles from the origin to each of the corners of the _bounds rectangle.
			if (_bounds != null) {
				_cornerAngleTL = TransformManager.positiveAngle(Math.atan2(_bounds.y - _origin.y, _bounds.x - _origin.x));
				_cornerAngleTR = TransformManager.positiveAngle(Math.atan2(_bounds.y - _origin.y, _bounds.right - _origin.x));
				_cornerAngleBR = TransformManager.positiveAngle(Math.atan2(_bounds.bottom - _origin.y, _bounds.right - _origin.x));
				_cornerAngleBL = TransformManager.positiveAngle(Math.atan2(_bounds.bottom - _origin.y, _bounds.x - _origin.x));
			}
		}
		
		protected function reposition():void { //Ensures that the _origin lines up with the _localOrigin.
			var p:Point = _target.parent.globalToLocal(_target.localToGlobal(_localOrigin)); 
			_target.x += _origin.x - p.x;
			_target.y += _origin.y - p.y;
		}
		
		public function onPressDelete($e:Event = null, $allowSelectableTextDelete:Boolean = false):Boolean {
			if (_enabled && _allowDelete && (_hasSelectableText == false || $allowSelectableTextDelete)) { //_hasSelectableText typically means it's a TextField in which case users should be able to hit the DELETE key without deleting the whole TextField.
				deleteObject();
				return true;
			}
			return false;
		}
		
		public function deleteObject():void {
			this.selected = false;
			_targetObject.parent.removeChild(_targetObject);
			removeProxy();
			dispatchEvent(new TransformEvent(TransformEvent.DELETE, [this]));
		}
		
		public function forceEventDispatch($type:String):void {
			dispatchEvent(new TransformEvent($type, [this]));
		}
		
		public function destroy():void {
			this.enabled = false; //kills listeners too
			this.selected = false; //kills listeners too
			dispatchEvent(new TransformEvent(TransformEvent.DESTROY, [this]));
		}


//---- MOVE --------------------------------------------------------------------------------------------

		public function move($x:Number, $y:Number, $checkBounds:Boolean = true, $dispatchEvent:Boolean = true):void {
			if (!_lockPosition) {
				if ($checkBounds && _bounds != null) {
					var safe:Object = {x:$x, y:$y};
					moveCheck($x, $y, safe);
					$x = safe.x;
					$y = safe.y;
				}
				_target.x += $x;
				_target.y += $y;
				_origin.x += $x;
				_origin.y += $y;
				if (_target != _targetObject) {
					_targetObject.x += $x;
					_targetObject.y += $y;
				}
				
				if ($dispatchEvent && ($x != 0 || $y != 0)) {
					dispatchEvent(new TransformEvent(TransformEvent.MOVE, [this]));
				}
			}
		}
		
		public function moveCheck($x:Number, $y:Number, $safe:Object):void { //Just checks to see if the translation will hit the bounds and edits the $safe object properties to make sure it doesn't
			if (_lockPosition) {
				$safe.x = $safe.y = 0;
			} else if (_bounds != null) {
				var r:Rectangle = _targetObject.getBounds(_targetObject.parent);
				r.offset($x, $y);
				if (!_bounds.containsRect(r)) {
					if (_bounds.right < r.right) {
						$x += _bounds.right - r.right;
						$safe.x = int(Math.min($safe.x, $x));
					} else if (_bounds.left > r.left) {
						$x += _bounds.left - r.left;
						$safe.x = int(Math.max($safe.x, $x));
					}
					if (_bounds.top > r.top) {
						$y += _bounds.top - r.top;
						$safe.y = int(Math.max($safe.y, $y));
					} else if (_bounds.bottom < r.bottom) {
						$y += _bounds.bottom - r.bottom;
						$safe.y = int(Math.min($safe.y, $y));
					}
				}
			}
		}
		

//---- SCALE -------------------------------------------------------------------------------------------

		public function scale($sx:Number, $sy:Number, $angle:Number = 0, $checkBounds:Boolean = true, $dispatchEvent:Boolean = true):void {
			if (!_lockScale) {
				scaleRotated($sx, $sy, $angle, -$angle, $checkBounds, $dispatchEvent);
			}
		}
		
		public function scaleRotated($sx:Number, $sy:Number, $angle:Number, $skew:Number, $checkBounds:Boolean = true, $dispatchEvent:Boolean = true):void {
			if (!_lockScale) {
				var m:Matrix = _target.transform.matrix;
				
				if ($angle != -$skew && Math.abs(($angle + $skew) % (Math.PI - 0.01)) < 0.01) { //protects against rounding errors in tiny decimals
					$skew = -$angle;
				}
				
				if ($checkBounds && _bounds != null) {
					var safe:Object = {sx:$sx, sy:$sy};
					scaleCheck(safe, $angle, $skew);
					$sx = safe.sx;
					$sy = safe.sy;
				}
				
				MatrixTools.scaleMatrix(m, $sx, $sy, $angle, $skew);
				
				if (_scaleMode == "scaleNormal") {
					_targetObject.transform.matrix = m;
					reposition();
				} else {
					_proxy.transform.matrix = m;
					reposition();
					
					var w:Number = Math.sqrt(m.a * m.a + m.b * m.b) * _baseRect.width;
					var h:Number = Math.sqrt(m.d * m.d + m.c * m.c) * _baseRect.height;
					var p:Point = _targetObject.parent.globalToLocal(_proxy.localToGlobal(_offset)); //had to use _targetObject.parent instead of _proxy.parent because of another bug in Flex that prevented _proxy items from accurately reporting their parent for a few frames after being added to the display list! Since they both have the same parent, this shouldn't matter though.
					//if (_scaleMode == "scaleWidthAndHeight") {
						_targetObject.width = w;
						_targetObject.height = h;
					//} else {
					//	(_targetObject as Object).setSize((w % 1 > 0.5) ? int(w) + 1 : int(w), (h % 1 > 0.5) ? int(h) + 1 : int(h));
					//}
					_targetObject.rotation = _proxy.rotation;
					_targetObject.x = p.x;
					_targetObject.y = p.y;
					
				}
				
				if ($dispatchEvent && ($sx != 1 || $sy != 1)) {
					dispatchEvent(new TransformEvent(TransformEvent.SCALE, [this]));
				}
			}
		}
		
		public function scaleCheck($safe:Object, $angle:Number, $skew:Number):void { //Just checks to see if the scale will hit the bounds and edits the $safe object properties to make sure it doesn't
			if (_lockScale) {
				$safe.sx = $safe.sy = 1;
			} else if (_bounds != null) {
				var sx:Number, sy:Number;
				var original:Matrix = _target.transform.matrix;
				var originalScaleX:Number = MatrixTools.getDirectionX(original);
				var originalScaleY:Number = MatrixTools.getDirectionY(original);
				var m:Matrix = original.clone();
								
				MatrixTools.scaleMatrix(m, $safe.sx, $safe.sy, $angle, $skew);
				
				if (this.hasScaleLimits) {
					
					var angleDif:Number = $angle - MatrixTools.getAngle(original);
					var skewDif:Number = $skew - MatrixTools.getSkew(original);
					
					if (angleDif == 0 && Math.abs(skewDif) < 0.0001) {
						
						sx = MatrixTools.getScaleX(original);
						sy = MatrixTools.getScaleY(original);
						
						$safe.sx = Math.min((_maxScaleX / sx), Math.max((_minScaleX / sx), $safe.sx));
						$safe.sy = Math.min((_maxScaleY / sy), Math.max((_minScaleY / sy), $safe.sy));
						
						m = original.clone();
						MatrixTools.scaleMatrix(m, $safe.sx, $safe.sy, $angle, $skew);
						
					} else {
						sx = MatrixTools.getDirectionX(m);
						sy = MatrixTools.getDirectionY(m);
						if (sx > _maxScaleX || sx < _minScaleX || sy > _maxScaleY || sy < _minScaleY) {
							$safe.sx = $safe.sy = 1;
							return;
						}
					}
				}
				
				_target.transform.matrix = m;
				reposition();
				if (!_bounds.containsRect(_target.getBounds(_target.parent))) {
					if ($safe.sy == 1) {
						_target.transform.matrix = original;
						iterateStretchX($safe, $angle, $skew);
					} else if ($safe.sx == 1) {
						_target.transform.matrix = original;
						iterateStretchY($safe, $angle, $skew);
					} else {
						/* potential future replacement technique - needs refinement for when there are skewed items near the edge
						var scaledBounds:Rectangle = _target.getBounds(_target.parent);
						sx = sy = 1;
						
						if (scaledBounds.right > _bounds.right && Math.abs(_bounds.right - _origin.x) > 0.5) {
							sx = (_bounds.right - _origin.x) / (scaledBounds.right - _origin.x);
						}
						if (scaledBounds.left < _bounds.left && Math.abs(_origin.x - _bounds.left) > 0.5) {
							sx = Math.min(sx, (_origin.x - _bounds.left) / (_origin.x - scaledBounds.left));
						}
						if (scaledBounds.bottom > _bounds.bottom && Math.abs(_bounds.bottom - _origin.y) > 0.5) {
							sy = (_bounds.bottom - _origin.y) / (scaledBounds.bottom - _origin.y);
						} 
						if (scaledBounds.top < _bounds.top && Math.abs(_origin.y - _bounds.top) > 0.5) {
							sy = Math.min(sy, (_origin.y - _bounds.top) / (_origin.y - scaledBounds.top));
						}
						var s:Number = Math.min(sx, sy);
						
						$safe.sx *= s;
						$safe.sy *= s;
						*/
						
						var i:int, corner:Point, cornerAngle:Number, oldLength:Number, newLength:Number, dx:Number, dy:Number;
						var minScale:Number = 1;
						var r:Rectangle = _target.getBounds(_target);
						var corners:Array = [new Point(r.x, r.y), new Point(r.right, r.y), new Point(r.right, r.bottom), new Point(r.x, r.bottom)]; //top left, top right, bottom right, bottom left
						for (i = corners.length - 1; i > -1; i--) {
							corner = _target.parent.globalToLocal(_target.localToGlobal(corners[i]));
							
							if (!(Math.abs(corner.x - _origin.x) < 1 && Math.abs(corner.y - _origin.y) < 1)) { //If the origin is on top of the corner (same coordinates), no need to factor it in.
								cornerAngle = TransformManager.positiveAngle(Math.atan2(corner.y - _origin.y, corner.x - _origin.x));
								dx = _origin.x - corner.x;
								dy = _origin.y - corner.y;
								oldLength = Math.sqrt(dx * dx + dy * dy);
								
								if (cornerAngle < _cornerAngleBR || (cornerAngle > _cornerAngleTR && _cornerAngleTR != 0)) { //Extends RIGHT
									dx = _bounds.right - _origin.x;
									newLength = (dx < 1 && ((_cornerAngleBR - cornerAngle < 0.01) || (cornerAngle - _cornerAngleTR < 0.01))) ? 0 : dx / Math.cos(cornerAngle); //Flash was occassionally reporting the angle slightly off when you put the object in the very bottom right corner and then scale inwards/upwards, and since the Math.sin() was so small, there were rounding errors in the decimals. This prevents the odd behavior.
								} else if (cornerAngle <= _cornerAngleBL) { //Extends DOWN
									dy = _bounds.bottom - _origin.y;
									newLength = (_cornerAngleBL - cornerAngle < 0.01) ? 0 : dy / Math.sin(cornerAngle); //Flash was occassionally reporting the angle slightly off when you put the object in the very bottom right corner and then scale inwards/upwards, and since the Math.sin() was so small, there were rounding errors in the decimals. This prevents the odd behavior.
								} else if (cornerAngle < _cornerAngleTL) { //Extends LEFT
									dx = _origin.x - _bounds.x;
									newLength = dx / Math.cos(cornerAngle);
								} else { //Extends UP
									dy = _origin.y - _bounds.y;
									newLength = dy / Math.sin(cornerAngle);
								}
								if (newLength != 0) {
									minScale = Math.min(minScale, Math.abs(newLength) / oldLength);
								}
							}
						}
						m = _target.transform.matrix;
						
						if (($safe.sx < 0 && (_origin.x == _bounds.x || _origin.x == _bounds.right)) || ($safe.sy < 0 && (_origin.y == _bounds.y || _origin.y == _bounds.bottom))) {  //Otherwise if the origin was sitting directly on top of the bounds edge, you could scale right past it in a negative direction (flip)
							$safe.sx = 1;
							$safe.sy = 1;
						} else {
							$safe.sx = (MatrixTools.getDirectionX(m) * minScale) / originalScaleX;
							$safe.sy = (MatrixTools.getDirectionY(m) * minScale) / originalScaleY;
						}
						
					}
					
				}
				_target.transform.matrix = original;
			}
		}
		
		protected function iterateStretchX($safe:Object, $angle:Number, $skew:Number):void {
			if (_lockScale) {
				$safe.sx = $safe.sy = 1;
			} else if (_bounds != null && $safe.sx != 1) {
				var original:Matrix = _target.transform.matrix;
				var i:uint, loops:uint, base:uint, m:Matrix = new Matrix();
				var inc:Number = 0.01;
				if ($safe.sx < 1) {
					inc = -0.01;
				}
				
				if ($safe.sx > 0) {
					loops = Math.abs(($safe.sx - 1) / inc) + 1;
					base = 1;
				} else {
					base = 0;
					loops = ($safe.sx / inc) + 1;
				}
				
				for (i = 1; i <= loops; i++) {
					m.a = original.a; //faster than m.clone();
					m.b = original.b;
					m.c = original.c;
					m.d = original.d;
					
					MatrixTools.scaleMatrix(m, base + (i * inc), 1, $angle, $skew);
					_target.transform.matrix = m;
					reposition();
					if (!_bounds.containsRect(_target.getBounds(_target.parent))) {
						if (!($safe.sx < 1 && $safe.sx > 0)) {
							$safe.sx = base + ((i - 1) * inc);
						}
						break;
					}
				}
			}
		}
		
		
		protected function iterateStretchY($safe:Object, $angle:Number, $skew:Number):void {
			if (_lockScale) {
				$safe.sx = $safe.sy = 1;
			} else if (_bounds != null && $safe.sy != 1) {
				var original:Matrix = _target.transform.matrix;
				var i:uint, loops:uint, base:uint, m:Matrix = new Matrix();
				var inc:Number = 0.01;
				if ($safe.sy < 1) {
					inc = -0.01;
				}
				
				if ($safe.sx > 0) {
					loops = Math.abs(($safe.sy - 1) / inc) + 1;
					base = 1;
				} else {
					base = 0;
					loops = ($safe.sy / inc) + 1;
				}
				
				for (i = 1; i <= loops; i++) {
					m.a = original.a; //faster than m.clone();
					m.b = original.b;
					m.c = original.c;
					m.d = original.d;
					
					MatrixTools.scaleMatrix(m, 1, base + (i * inc), $angle, $skew);
					_target.transform.matrix = m;
					reposition();
					if (!_bounds.containsRect(_target.getBounds(_target.parent))) {
						if (!($safe.sy < 1 && $safe.sy > 0)) {
							$safe.sy = base + ((i - 1) * inc);
						}
						break;
					}
				}
			}
		}		
		
		public function setScaleConstraints($minScaleX:Number, $maxScaleX:Number, $minScaleY:Number, $maxScaleY:Number):void {
			this.minScaleX = $minScaleX;
			this.maxScaleX = $maxScaleX;
			this.minScaleY = $minScaleY;
			this.maxScaleY = $maxScaleY;
		}


//---- ROTATE ------------------------------------------------------------------------------------------

		public function rotate($angle:Number, $checkBounds:Boolean = true, $dispatchEvent:Boolean = true):void {
			if (!_lockRotation) {
				if ($checkBounds && _bounds != null) {
					var safe:Object = {angle:$angle};
					rotateCheck(safe);
					$angle = safe.angle;
				}
				
				var m:Matrix = _targetObject.transform.matrix;
				m.rotate($angle);
				_targetObject.transform.matrix = m;
				if (_proxy != null) {
					m = _proxy.transform.matrix;
					m.rotate($angle);
					_proxy.transform.matrix = m;
				}
				reposition();
				
				if (_target == _proxy) {
					var p:Point = _proxy.parent.globalToLocal(_proxy.localToGlobal(_offset));
					_targetObject.x = p.x;
					_targetObject.y = p.y;
				}
				
				if ($dispatchEvent && $angle != 0) {
					dispatchEvent(new TransformEvent(TransformEvent.ROTATE, [this]));
				}
			}
		}
		
		public function rotateCheck($safe:Object):void { //Just checks to see if the rotation will hit the bounds and edits the $safe.angle property to make sure it doesn't
			if (_lockRotation) {
				$safe.angle = 0;
			} else if (_bounds != null && $safe.angle != 0) {
				var originalAngle:Number = _target.rotation * _DEG2RAD;
				var original:Matrix = _target.transform.matrix;
				var m:Matrix = original.clone();
				m.rotate($safe.angle);
				_target.transform.matrix = m;
				reposition();
				if (!_bounds.containsRect(_target.getBounds(_target.parent))) {
					m = original.clone();
					var inc:Number = _DEG2RAD; //1 degree increments
					if (TransformManager.acuteAngle($safe.angle) < 0) {
						inc *= -1;
					}
					for (var i:uint = 1; i < 360; i++) {
						m.rotate(inc);
						_target.transform.matrix = m;
						reposition();
						if (!_bounds.containsRect(_target.getBounds(_target.parent))) {
							$safe.angle = (i - 1) * inc;
							break;
						}
					}
				}
				_target.transform.matrix = original;
			}
		}
		
		
//---- STATIC FUNCTIONS --------------------------------------------------------------------------------
		
		protected static function setDefault($value:*, $default:*):* {
			if ($value == undefined) {
				return $default;
			} else {
				return $value;
			}
		}
		
		
//---- GETTERS / SETTERS --------------------------------------------------------------------------------
		
		public function get enabled():Boolean {
			return _enabled;
		}
		public function set enabled($b:Boolean):void { //Gives us a way to enable/disable all TransformItems
			if ($b != _enabled) {
				_enabled = $b;
				this.selected = false;
				if ($b) {
					_targetObject.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown); //note: if weak reference was used here, it occasionally wouldn't work at all.
					_targetObject.addEventListener(MouseEvent.ROLL_OVER, onRollOverItem);
					_targetObject.addEventListener(MouseEvent.ROLL_OUT, onRollOutItem);
				} else {
					_targetObject.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					_targetObject.removeEventListener(MouseEvent.ROLL_OVER, onRollOverItem);
					_targetObject.removeEventListener(MouseEvent.ROLL_OUT, onRollOutItem);
					if (_stage != null) {
						_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					}
				}
			}
		}
		public function get x():Number {
			return _targetObject.x;
		}
		public function set x($n:Number):void {
			move($n - _targetObject.x, 0, true, true);
		}
		public function get y():Number {
			return _targetObject.y;
		}
		public function set y($n:Number):void {
			move(0, $n - _targetObject.y, true, true);
		}
		public function get targetObject():DisplayObject {
			return _targetObject;
		}
		public function get scaleX():Number {
			return MatrixTools.getScaleX(_targetObject.transform.matrix); //_targetObject.scaleX doesn't report properly in Flex, so this is the only way to get reliable results.
		}
		public function set scaleX($n:Number):void {
			var o:Point = this.origin;
			this.origin = this.center;
			var m:Matrix = _targetObject.transform.matrix;
			scaleRotated($n / MatrixTools.getScaleX(m), 1, _targetObject.rotation * _DEG2RAD, Math.atan2(m.c, m.d), true, true);
			this.origin = o;
		}
		public function get scaleY():Number {
			return MatrixTools.getScaleY(_targetObject.transform.matrix); //_targetObject.scaleY doesn't report properly in Flex, so this is the only way to get reliable results.
		}
		public function set scaleY($n:Number):void {
			var o:Point = this.origin;
			this.origin = this.center;
			var m:Matrix = _targetObject.transform.matrix;
			scaleRotated(1, $n / MatrixTools.getScaleY(m), _targetObject.rotation * _DEG2RAD, Math.atan2(m.c, m.d), true, true); 
			this.origin = o;
		}
		public function get width():Number {
			if (_targetObject.parent != null) {
				return _targetObject.getBounds(_targetObject.parent).width;
			} else {
				var s:Sprite = new Sprite();
				s.addChild(_targetObject);
				var w:Number = _targetObject.getBounds(s).width;
				s.removeChild(_targetObject);
				return w;
			}
		}
		public function set width($n:Number):void {
			var o:Point = this.origin;
			this.origin = this.center;
			scale($n / this.width, 1, 0, true, true);
			this.origin = o;
		}
		public function get height():Number {
			if (_targetObject.parent != null) {
				return _targetObject.getBounds(_targetObject.parent).height;
			} else {
				var s:Sprite = new Sprite();
				s.addChild(_targetObject);
				var h:Number = _targetObject.getBounds(s).height;
				s.removeChild(_targetObject);
				return h;
			}
		}
		public function set height($n:Number):void {
			var o:Point = this.origin;
			this.origin = this.center;
			scale(1, $n / this.height, 0, true, true);
			this.origin = o;
		}
		public function get rotation():Number {
			return MatrixTools.getAngle(_targetObject.transform.matrix) * _RAD2DEG; //_targetObject.rotation doesn't report properly in Flex, so this is the only way to get reliable results.
		}
		public function set rotation($n:Number):void {
			var o:Point = this.origin;
			this.origin = this.center;
			rotate(($n * _DEG2RAD) - MatrixTools.getAngle(_targetObject.transform.matrix), true, true);
			this.origin = o;
		}
		public function get alpha():Number {
			return _targetObject.alpha;
		}
		public function set alpha($n:Number):void {
			_targetObject.alpha = $n;
		}
		public function get center():Point {
			if (_targetObject.parent != null) { //Check to make sure it wasn't removed from the DisplayList. If it was, just return the innerCenter.
				return _targetObject.parent.globalToLocal(_targetObject.localToGlobal(this.innerCenter));
			} else {
				return this.innerCenter;
			}
		}
		public function get innerCenter():Point {
			var r:Rectangle = _targetObject.getBounds(_targetObject);
			return new Point(r.x + r.width / 2, r.y + r.height / 2);
		}
		public function set constrainScale($b:Boolean):void {
			_constrainScale = $b;
		}
		public function get constrainScale():Boolean {
			return _constrainScale;
		}
		public function set lockScale($b:Boolean):void {
			_lockScale = $b;
		}
		public function get lockScale():Boolean {
			return _lockScale;
		}
		public function set lockRotation($b:Boolean):void {
			_lockRotation = $b;
		}
		public function get lockRotation():Boolean {
			return _lockRotation;
		}
		public function set lockPosition($b:Boolean):void {
			_lockPosition = $b;
		}
		public function get lockPosition():Boolean {
			return _lockPosition;
		}
		public function set allowDelete($b:Boolean):void {
			if ($b != _allowDelete) {
				_allowDelete = $b;
				if (_createdManager != null) {
					_createdManager.allowDelete = $b;
				}
			}
		}
		public function get allowDelete():Boolean {
			return _allowDelete;
		}
		public function set selected($b:Boolean):void {
			if ($b != _selected) {
				_selected = $b;
				if ($b) {
					if (_targetObject.parent == null) {
						return;
					}
					if (_targetObject.hasOwnProperty("setStyle")) { //focus borders get in the way of the selection box/handles.
						(_targetObject as Object).setStyle("focusThickness", 0);
					}
					dispatchEvent(new TransformEvent(TransformEvent.SELECT, [this]));
				} else {
					dispatchEvent(new TransformEvent(TransformEvent.DESELECT, [this]));
				}
			}
		}
		public function get selected():Boolean {
			return _selected;
		}
		public function set bounds($r:Rectangle):void {
			_bounds = $r;
			setCornerAngles();
		}
		public function get bounds():Rectangle {
			return _bounds;
		}
		public function set origin($p:Point):void {
			_origin = $p;
			if (_proxy != null && _proxy.parent != null) {
				_localOrigin = _proxy.globalToLocal(_proxy.parent.localToGlobal($p));
			} else if (_targetObject.parent != null) {
				_localOrigin = _targetObject.globalToLocal(_targetObject.parent.localToGlobal($p));
			}
			setCornerAngles();
		}
		public function get origin():Point {
			return _origin;
		}
		public function get minScaleX():Number {
			return _minScaleX;
		}
		public function set minScaleX($n:Number):void {
			if ($n == 0) {
				$n = _targetObject.getBounds(_targetObject).width || 500;
				_minScaleX = 1 / $n; //don't let it scale smaller than 1 pixel.
			} else {
				_minScaleX = $n;
			}
			if (_targetObject.scaleX < _minScaleX) {
				_targetObject.scaleX = _minScaleX;
			}
		}
		public function get minScaleY():Number {
			return _minScaleY;
		}
		public function set minScaleY($n:Number):void {
			if ($n == 0) {
				$n = _targetObject.getBounds(_targetObject).height || 500;
				_minScaleY = 1 / $n; //don't let it scale smaller than 1 pixel.
			} else {
				_minScaleY = $n;
			}
			if (_targetObject.scaleY < _minScaleY) {
				_targetObject.scaleY = _minScaleY;
			}
		}
		public function get maxScaleX():Number {
			return _maxScaleX;
		}
		public function set maxScaleX($n:Number):void {
			if ($n == 0) {
				$n = _targetObject.getBounds(_targetObject).width || 0.005;
				_maxScaleX = 0 - (1 / $n); //don't let it scale smaller than 1 pixel.
			} else {
				_maxScaleX = $n;
			}
			if (_targetObject.scaleX > _maxScaleX) {
				_targetObject.scaleX = _maxScaleX;
			}
		}
		public function get maxScaleY():Number {
			return _maxScaleY;
		}
		public function set maxScaleY($n:Number):void {
			if ($n == 0) {
				$n = _targetObject.getBounds(_targetObject).height || 0.005;
				_maxScaleY = 0 - (1 / $n); //don't let it scale smaller than 1 pixel.
			} else {
				_maxScaleY = $n;
			}
			if (_targetObject.scaleY > _maxScaleY) {
				_targetObject.scaleY = _maxScaleY;
			}
		}
		public function set maxScale($n:Number):void {
			this.maxScaleX = this.maxScaleY = $n;
		}
		public function set minScale($n:Number):void {
			this.minScaleX = this.minScaleY = $n;
		}
		public function get hasScaleLimits():Boolean {
			return (_minScaleX != -Infinity || _minScaleY != -Infinity || _maxScaleX != Infinity || _maxScaleY != Infinity);
		}
		
		public function get scaleMode():String {
			return _scaleMode;
		}
		public function set scaleMode($s:String):void {
			if ($s != TransformManager.SCALE_NORMAL) {
				createProxy();
			} else {
				removeProxy();
			}
			_scaleMode = $s;
		}
		public function get hasSelectableText():Boolean {
			return _hasSelectableText;
		}
		public function set hasSelectableText($b:Boolean):void {
			if ($b) {
				this.scaleMode = TransformManager.SCALE_WIDTH_AND_HEIGHT;
				this.allowDelete = false;
			}
			_hasSelectableText = $b;
		}
		
	}
	
}