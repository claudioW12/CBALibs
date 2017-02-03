/*
VERSION: 1.67
DATE: 4/14/2009
ACTIONSCRIPT VERSION: 3.0 (Requires Flash Player 9)
DESCRIPTION: 
	TransformManager makes it easy to add interactive scaling/rotating/moving of DisplayObjects to your Flash application.
	It uses an intuitive interface that's similar to most modern drawing applications. When the user clicks on a managed
	DisplayObject, a selection box will be drawn around it along with 8 handles for scaling/rotating. When the mouse 
	is placed just outside of any of the scaling handles, the cursor will change to indicate that they're in rotation mode. 
	Just like most other applications, the user can hold down the SHIFT key to select multiple items, to constrain
	scaling proportions, or to limit the rotation to 45 degree increments.
	
	Features include: 
		- (NEW!) Select multiple items and scale/rotate/move them all simultaneously. 
		- (NEW!) Optionally control everything (transformations, selections, etc.) through code. 
		- (NEW!) 4 extra handles for a total of 8
		- (NEW!) Depth management which allows you to programmatically push the selected items forward or backward in the stacking order
		- (NEW!) Arrow keys move the selection (optional)
		- (NEW!) Set minScaleX, maxScaleX, minScaleY, and maxScaleY for each TransformItem to limit their scale
		- Define bounds within which the DisplayObjects must stay, and TransformManager will not let the user scale/rotate/move them beyond those bounds
		- Automatically bring the selected item(s) to the front in the stacking order (optional)
		- The DELETE and BACKSPACE keys can be used to delete the selected DisplayObjects (optional)
		- Lock certain kinds of transformations like rotation, scale, and/or movement (optional)
		- Lock the proportions of the DisplayObjects so that users cannot distort them when scaling
		- Scale from the DisplayObject's center or from its corners
		- Listen for Events like scale, move, rotate, select, deselect, click off, delete, depth change, and destroy
		- Set the selection box line color and handle thickness
		- Cursor will automatically change to indicate scale or rotation mode
		- VERY easy to use. In fact, all it takes is one line of code to get it up and running with the default settings.
	
	Notes/Limitations:
		- All DisplayObjects that are managed by a particular TransformManager instance must have the same parent (you can create 
		  multiple TransformManager instances if you want)
		- TextFields cannot be flipped (have negative scales).
		- TextFields cannot be skewed. Therefore, when a TextField is part of a multi-selection, scaling will be disabled because it 
		  could skew the TextField (imagine if a TextField is at a 45 degree angle, and then you selected another item and scaled 
		  vertically - your TextField would end up getting skewed).
		- Due to several bugs in the Flex framework (acknowledged by Adobe), TransformManager doesn't work quite as expected inside 
		  Flex containers, but I created a FlexTransformManager class that helps avoid the limitations. However, you still cannot
		  scale TextFields disproportionately.
		- Due to a limitation in the way Flash reports bounds, items that are extremely close or exactly on top of a boundary
		  (if you define bounds) will be moved about 0.1 pixel away from the boundary when you select them. If an item fills 
		  the width and/or height of the bounds, it will be scaled down very slightly (about 0.2 pixels total) to move it away 
		  from the bounds and allow accurate collision detection.
	
	
	The first (and only) parameter in the constructor should be an object with any number of properties. This makes it easier to
	set only the properties that shouldn't use their default values (you'll probably find that most of the time the default
	values work well for you). It also makes the code easier to read. The properties can be in any order, like so:
	
		var manager:TransformManager = new TransformManager({targetObjects:[clip1_mc, clip2_mc], forceSelectionToFront:true, bounds:new Rectangle(0, 0, 550, 450), allowDelete:true});

EXAMPLES: 
	To make two MovieClips (myClip1 and myClip2) transformable using the default settings:
	
		import gs.transform.TransformManager;
		
		var manager:TransformManager = new TransformManager({targetObjects:[myClip1, myClip2]});
		
	To make the two MovieClips transformable, constrain their scaling to be proportional (even if the user is not holding
	down the shift key), call the onScale function everytime one of the objects is scaled, lock the rotation value of each 
	MovieClip (preventing rotation), and allow the delete key to appear to delete the selected MovieClip from the stage:
	
		import gs.transform.TransformManager;
		import gs.events.TransformEvent;
		
		var manager:TransformManager = new TransformManager({targetObjects:[myClip1, myClip2], constrainScale:true, lockRotation:true, allowDelete:true, autoDeselect:true});
		manager.addEventListener(TransformEvent.SCALE, onScale);
		function onScale($e:TransformEvent):void {
			trace("Scaled " + $e.items.length + " items");
		}
		
	To add myClip1 and myClip2 and myText after a TransformManager has been created, and then listen for when only myClip1 is selected:
		
		import gs.transform.TransformManager;
		import gs.events.TransformEvent;
		
		var manager:TransformManager = new TransformManager();
		
		var clip1Item:TransformItem = manager.addItem(myClip1);
		var clip2Item:TransformItem = manager.addItem(myClip2);
		var myTextItem:TransformItem = manager.addItem(myText, TransformManager.SCALE_WIDTH_AND_HEIGHT, true);
		
		clip1Item.addEventListener(TransformEvent.SELECT, onSelectClip1);
		
		function onSelectClip1($e:TransformEvent):void {
			trace("selected myClip1");
		}
	
		
IMPORTANT PROPERTIES:
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
	- addItems(targetObjects:Array, scaleMode:String, hasSelectableText:Boolean):Array					Same as addItem() but accepts an Array of DisplayObjects (returns an Array of TransformItems)
	- removeItem(item:*):void 																			Removes an item. Calling this on an item will not delete the DisplayObject - it just prevents it from being transformable by this TransformManager anymore.
	- removeAllItems():void																				Removes all items from the TransformManager instance.
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
	- deleteSelection():void
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


CHANGE LOG:
	1.67:
		- Worked around a Flex bug that caused problems with transforming text-related objects immediately after adding them to TransformManager
	1.66:
		- Fixed bug that could cause problems if the targetObject wasn't on the stage when its TransformItem was being instantiated.
	1.65:
		- Fixed some minor issues related to deleting items with hasSelectableText=true.
		- When an item with hasSelectableText=true is part of a multi-selection, it can be deleted. If it is the only item selected, it cannot (this is intuitive because the user would likely want the DELETE key to affect the text, not delete the whole object)
	1.64:	
		- Fixed bug in FlexTransformManager that could cause an ignoredObject to not be ignored.
	1.63:
		- Prevented a situation where in a multi-window AIR app, the cursors could be missing on new windows
	1.6:
		- Added a moveCursor that indicates when selected items are moveable.
	1.56:
		- Added public getUnrotatedSelectionWidth() and getUnrotatedSelectionHeight() methods
	1.55:
		- Added isSelected() method
	1.54:
		- Added arrowKeysMove getter/setter
	1.5:
		- Made the edges draggable (there is a 10-pixel wide area around the border that users can drag). This is particularly helpful with TextFields/TextAreas.
		- Eliminated the need for the TransformItemTF class. TransformItem now handles TextFields too (see the "hasSelectableText" and "scaleMode" additions below).
		- Added "hasSelectableText" property which sets the scaleMode to SCALE_WIDTH_AND_HEIGHT, and prevents dragging of the object unless clicking on the edges/border or center handle, and allows the delete key to be pressed without deleting the object itself.
		- Added "scaleMode" property which can be set to either TransformManager.SCALE_NORMAL (the default), or TransformManager.SCALE_WIDTH_AND_HEIGHT which is useful for text-related objects and/or components. Note: when the scaleMode is set to SCALE_WIDTH_AND_HEIGHT, you cannot flip the object backwards in either direction, nor can you scale it as part of a multi-selection.
		- Added scaleMode and hasSelectableText parameters to the addItem() and addItems() methods of TransformManager
		- Altered FlexTransformManager so that TextAreas, TextInputs, UITextFields, Labels, and RichTextEditors are automatically scaled using width/height instead of scaleX/scaleY in order to retain the size of the text.
		- Altered FlexTransformManager so that the focusThickness of selected components is set to zero (otherwise, it can interfere with the handles slightly)
		- Worked around a bug in the Flex framework that inaccurately reported width/height on some components intermittently, causing the selection box to be drawn incorrectly sometimes.
	1.49:
		- Fixed bug that could cause it to get stuck in multi-select mode if the users holds down SHIFT, then clicks on another window, releases SHIFT, and clicks back on this window.
	1.48:
		- Made changes in order to accommodate a scenario where the targetObject is deleted immediately upon selection (in a TransformEvent.SELECT listener) - previously a 1009 error would be thrown.
	1.47:
		- Fixed bug that could occassionally cause movement of certain components to appear to "jitter" when hitting the bounds
	1.46:
		- Fixed bug that could cause exceptions when selecting an object object that fills the entire width or height of the bounds you defined.
	1.45:
		- Fixed bug that could occassionally cause items to be allowed to scale past the right-most bounds edge.
	1.43:
		- Fixed bug that could occassionally cause incorrect scaling when an item is positioned exactly on top of the bottom right corner of the boundary and scaled with the upper left corner handle
		- Fixed bug that could occassionally cause the stretching handles (on the top, bottom, left and right) to not function if the object was positioned directly on top of a boundary/edge.
	1.42:
		- Added width and height getters/setters to TransformItem and fixed minor bug in TransformItem's scale() method
	1.41:
		- Fixed slight offset that can occur between the handle and the mouse when scaling
		- Fixed SHIFT-DRAG behavior that sometimes didn't honor the origin when skipping from x- to y- movement
		- Fixed boundary constraint behavior when interactively scaling so that it doesn't force the proportions to correlate with the mouse that's beyond the boundaries.
		- Added scaleX, scaleY, rotation, x, y, and alpha getters/setters to TransformItem. scaleX, scaleY, and rotation always use the center of the TransformItem as the registration point.

AUTHOR: Jack Doyle, jack@greensock.com
Copyright 2009, GreenSock. All rights reserved. This work is subject to the terms in http://www.greensock.com/eula.html or for corporate Club GreenSock members ("unlimited" level), the software agreement that was issued with the corporate membership.
*/

package com.greensock.transform {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import com.greensock.events.TransformEvent;
	import com.greensock.transform.utils.MatrixTools;
	
	public class TransformManager extends EventDispatcher {
		public static const VERSION:Number = 1.67;
		public static const SCALE_NORMAL:String = "scaleNormal";
		public static const SCALE_WIDTH_AND_HEIGHT:String = "scaleWidthAndHeight";
		private static const _DEG2RAD:Number = Math.PI / 180; //precomputation for speed
		private static const _RAD2DEG:Number = 180 / Math.PI; //precomputation for speed;
		private static var _currentCursor:Shape; //can be scaleCursor or rotationCursor.
        private static var _keysDown:Object; //stores key codes of pressed keys
        private static var _keyListenersInitted:Boolean;
		private static var _keyDispatcher:EventDispatcher = new EventDispatcher();
		private static var _tempDeselectedItem:TransformItem;
		public static var scaleCursor:Shape;
		public static var rotationCursor:Shape;
		public static var moveCursor:Shape;
		
		private var _allowDelete:Boolean; //If true, we'll delete a TransformItem's MovieClip when it's selected and the user hits the Delete key.
		private var _allowMultiSelect:Boolean; 
		private var _multiSelectMode:Boolean; //if true, whenever you select an item, it will be ADDED to the selection instead of replacing it.
		private var _ignoreSelectionEvents:Boolean; //used when selecting/deselecting multiple items, when we want to avoid dispatching an event for every item.
		private var _autoDeselect:Boolean; //If true (and it's true by default), TransformItems will be deselected when the user clicks off of them. Disabling this is sometimes necessary in cases where you want the user to be able to select a MovieClip and then select/edit separate form fields without deselecting the MovieClip. In that case, you'll need to handle things in a custom way through your _eventHandler (look for action_str == "deselect" which will still get fired when the user clicks off of it)
		private var _constrainScale:Boolean; //If true, only proportional scaling is allowed (even if the SHIFT key isn't held down).
		private var _lockScale:Boolean;
		private var _scaleFromCenter:Boolean;
		private var _lockRotation:Boolean;
		private var _lockPosition:Boolean;
		private var _arrowKeysMove:Boolean;
		private var _selConstrainScale:Boolean; //reflects info about the selection. If any selected items have contrainScale set to true, this will be true.
		private var _selLockScale:Boolean; //reflects info about the selection. If any selected items have lockScale set to true, this will be true.
		private var _selLockRotation:Boolean; //reflects info about the selection. If any selected items have loclRotation set to true, this will be true.
		private var _selLockPosition:Boolean; //reflects info about the selection. If any selected items have lockPosition set to true, this will be true.
		private var _selHasTextFields:Boolean; 
		private var _selHasScaleLimits:Boolean; //if any of the items in the selection have scale limits (minScaleX, maxScaleX, minScaleY, maxScaleY), this should be true.
		private var _lineColor:uint;
		private var _handleColor:uint;
		private var _handleSize:Number;
		private var _paddingForRotation:Number;
		private var _selectedItems:Array;
		private var _forceSelectionToFront:Boolean;
		private var _items:Array; //Holds references to all TransformItems that this TransformManager can control (use addItem() to add DisplayObjects)
		private var _ignoredObjects:Array; //ignore clicks on the DisplayObjects in this list (like form elements, etc.)
		private var _enabled:Boolean; //Set this value to false if you want to disable all TransformItems. Setting it to true will enable them all.
		private var _bounds:Rectangle; //Defines an area that the items are restrained to (according to their parent coordinate system)
		private var _selection:Sprite;
		private var _dummyBox:Sprite; //Invisible - mirrors the transformations of the overall selection. We use this to pin the handles in the right spots.
		private var _handles:Array;
		private var _handlesDict:Dictionary; //To make lookups faster on cursor rollovers. 
		private var _parent:DisplayObjectContainer; //the parent of the items (they all must share the same parent!)
		private var _stage:Stage;
		private var _origin:Point; //acts like a registration point for transformations
		private var _trackingInfo:Object; //stores various data about the selection during transformations
		private var _initted:Boolean; //Only true after at least one item is added (which gives us a way to get to the stage and set up listeners)
		private var _isFlex:Boolean;
		private var _edges:Sprite;
		private var _cursorListenersOn:Boolean;
	
		public function TransformManager($vars:Object = null) {
			if (TransformItem.VERSION < 1.62) {
				trace("TransformManager Error: You have an outdated TransformManager-related class file. You may need to clear your ASO files. Please make sure you're using the latest version of TransformManager, TransformItem, and TransformItemTF, available from www.greensock.com.");
			}
			if ($vars == null) {
				$vars = {};
			}
			init($vars);
		}
		
		protected function init($vars:Object):void {
			_allowDelete = setDefault($vars.allowDelete, false);
			_allowMultiSelect = setDefault($vars.allowMultiSelect, true);
			_autoDeselect = setDefault($vars.autoDeselect, true);
			_constrainScale = setDefault($vars.constrainScale, false);
			_lockScale = setDefault($vars.lockScale, false);
			_scaleFromCenter = setDefault($vars.scaleFromCenter, false);
			_lockRotation = setDefault($vars.lockRotation, false);
			_lockPosition = setDefault($vars.lockPosition, false);
			_arrowKeysMove = setDefault($vars.arrowKeysMove, false);
			_forceSelectionToFront = setDefault($vars.forceSelectionToFront, true);
			_lineColor = setDefault($vars.lineColor, 0x5B4059); //Line color (including handles and selection around MovieClip)
			_handleColor = setDefault($vars.handleFillColor, 0x5B4059); //Handle fill color
			_handleSize = setDefault($vars.handleSize, 25); //Number of pixels the handles should be (square)
			_paddingForRotation = setDefault($vars.paddingForRotation, 12); //Number of pixels beyond the handles that should be sensitive for rotating.
			_multiSelectMode = _ignoreSelectionEvents = false;
			_bounds = $vars.bounds;
			_enabled = true;
			_keyDispatcher.addEventListener("pressDelete", onPressDelete, false, 0, true);
			_keyDispatcher.addEventListener("pressArrowKey", onPressArrowKey, false, 0, true);
			_keyDispatcher.addEventListener("pressMultiSelectKey", onPressMultiSelectKey, false, 0, true);
			_keyDispatcher.addEventListener("releaseMultiSelectKey", onReleaseMultiSelectKey, false, 0, true);
			_items = $vars.items || [];
			_selectedItems = [];
			this.ignoredObjects = $vars.ignoredObjects || [];
			_handles = [];
			_handlesDict = new Dictionary();
			if ($vars.targetObjects != undefined) {
				addItems($vars.targetObjects);
			}
		}
		
		protected function initParent($parent:DisplayObjectContainer):void {
			if (!_initted && _parent == null) {
				try {
					_isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager")); // SystemManager is the first display class created within a Flex application
				} catch ($e:Error) {
					_isFlex = false;
				}
				_parent = $parent;
				for (var i:int = _items.length - 1; i > -1; i--) {
					_items[i].targetObject.removeEventListener(Event.ADDED_TO_STAGE, onTargetAddedToStage);
				}
				if (_parent.stage == null) {
					_parent.addEventListener(Event.ADDED_TO_STAGE, initStage, false, 0, true); //Sometimes in Flex, the parent hasn't been added to the stage yet, so we need to wait so that we can access the stage.
				} else {
					initStage();
				}
			}
		}
		
		protected function onTargetAddedToStage($e:Event):void {
			initParent($e.target.parent);
		}
		
		protected function initStage($e:Event=null):void {
			_parent.removeEventListener(Event.ADDED_TO_STAGE, initStage);
			_stage = _parent.stage;
			initKeyListeners(_stage);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, checkForDeselect, false, 0, true);
			_stage.addEventListener(Event.DEACTIVATE, onReleaseMultiSelectKey, false, 0, true); //otherwise, if the user has the SHIFT key down and they click on another window and then release the key and then click back on this window, it could get stuck in multiselect mode.
			initSelection();
			initScaleCursor();
			initMoveCursor();
			initRotationCursor();
			_initted = true;
			
			if (_selectedItems.length != 0) {
				if (_forceSelectionToFront) {
					for (var i:int = _selectedItems.length - 1; i > -1; i--) {
						bringToFront(_selectedItems[i].targetObject);
					}
				}
				calibrateConstraints();
				updateSelection();
			}
		}
		
		public function addItem($targetObject:DisplayObject, $scaleMode:String="scaleNormal", $hasSelectableText:Boolean=false):TransformItem {
			if ($targetObject == _dummyBox || $targetObject == _selection) {
				return null;
			}
			var props:Array = ["constrainScale", "scaleFromCenter", "lockScale", "lockRotation", "lockPosition", "autoDeselect", "allowDelete", "bounds", "enabled", "forceSelectionToFront"];
			var newVars:Object = {manager:this};
			for (var i:uint = 0; i < props.length; i++) {
				newVars[props[i]] = this[props[i]];
			}
			var existingItem:TransformItem = getItem($targetObject); //Just in case it's already in the _items Array
			if (existingItem != null) {
				return existingItem;
			}
			newVars.scaleMode = ($targetObject is TextField) ? SCALE_WIDTH_AND_HEIGHT : $scaleMode;
			newVars.hasSelectableText = ($targetObject is TextField) ? true : $hasSelectableText;
			var newItem:TransformItem = newItem = new TransformItem($targetObject, newVars);
			newItem.addEventListener(TransformEvent.SELECT, onSelectItem);
			newItem.addEventListener(TransformEvent.DESELECT, onDeselectItem);
			newItem.addEventListener(TransformEvent.MOUSE_DOWN, onMouseDownItem);
			newItem.addEventListener(TransformEvent.SELECT_MOUSE_DOWN, onPressMove);
			newItem.addEventListener(TransformEvent.SELECT_MOUSE_UP, onReleaseMove);
			newItem.addEventListener(TransformEvent.UPDATE, onUpdateItem);
			newItem.addEventListener(TransformEvent.SCALE, onUpdateItem);
			newItem.addEventListener(TransformEvent.ROTATE, onUpdateItem);
			newItem.addEventListener(TransformEvent.MOVE, onUpdateItem);
			newItem.addEventListener(TransformEvent.ROLL_OVER_SELECTED, onRollOverSelectedItem);
			newItem.addEventListener(TransformEvent.ROLL_OUT_SELECTED, onRollOutSelectedItem);
			newItem.addEventListener(TransformEvent.DESTROY, onDestroyItem);
			_items.push(newItem);
			if (!_initted) {
				if ($targetObject.parent == null) {
					$targetObject.addEventListener(Event.ADDED_TO_STAGE, onTargetAddedToStage, false, 0, true);
				} else {
					initParent($targetObject.parent);
				}
			}
			return newItem;
		}
		
		public function addItems($targetObjects:Array, $scaleMode:String="scaleNormal", $hasSelectableText:Boolean=false):Array { 
			var a:Array = [];
			for (var i:uint = 0; i < $targetObjects.length; i++) {
				a.push(addItem($targetObjects[i], $scaleMode, $hasSelectableText));
			}
			return a;
		}
		
		public function removeItem($item:*):void {
			var item:TransformItem = findObject($item);
			if (item != null) {
				item.selected = false;
				item.removeEventListener(TransformEvent.SELECT, onSelectItem);
				item.removeEventListener(TransformEvent.DESELECT, onDeselectItem);
				item.removeEventListener(TransformEvent.MOUSE_DOWN, onMouseDownItem);
				item.removeEventListener(TransformEvent.SELECT_MOUSE_DOWN, onPressMove);
				item.removeEventListener(TransformEvent.SELECT_MOUSE_UP, onReleaseMove);
				item.removeEventListener(TransformEvent.UPDATE, onUpdateItem);
				item.removeEventListener(TransformEvent.SCALE, onUpdateItem);
				item.removeEventListener(TransformEvent.ROTATE, onUpdateItem);
				item.removeEventListener(TransformEvent.MOVE, onUpdateItem);
				item.removeEventListener(TransformEvent.ROLL_OVER_SELECTED, onRollOverSelectedItem);
				item.removeEventListener(TransformEvent.ROLL_OUT_SELECTED, onRollOutSelectedItem);
				item.removeEventListener(TransformEvent.DESTROY, onDestroyItem);
				for (var i:int = _items.length - 1; i > -1; i--) {
					if (item == _items[i]) {
						_items.splice(i, 1);
						item.destroy();
						break;
					}
				}
			}
		}
		
		public function removeAllItems():void {
			var item:TransformItem;
			for (var i:int = _items.length - 1; i > -1; i--) {
				item = _items[i];
				item.selected = false;
				item.removeEventListener(TransformEvent.SELECT, onSelectItem);
				item.removeEventListener(TransformEvent.DESELECT, onDeselectItem);
				item.removeEventListener(TransformEvent.MOUSE_DOWN, onMouseDownItem);
				item.removeEventListener(TransformEvent.SELECT_MOUSE_DOWN, onPressMove);
				item.removeEventListener(TransformEvent.SELECT_MOUSE_UP, onReleaseMove);
				item.removeEventListener(TransformEvent.UPDATE, onUpdateItem);
				item.removeEventListener(TransformEvent.SCALE, onUpdateItem);
				item.removeEventListener(TransformEvent.ROTATE, onUpdateItem);
				item.removeEventListener(TransformEvent.MOVE, onUpdateItem);
				item.removeEventListener(TransformEvent.ROLL_OVER_SELECTED, onRollOverSelectedItem);
				item.removeEventListener(TransformEvent.ROLL_OUT_SELECTED, onRollOutSelectedItem);
				item.removeEventListener(TransformEvent.DESTROY, onDestroyItem);
				_items.splice(i, 1);
				item.destroy();
			}
		}
		
		public function addIgnoredObject($object:DisplayObject):void {
			for (var i:uint = 0; i < _ignoredObjects.length; i++) { //first make sure it's not already in the Array
				if (_ignoredObjects[i] == $object) {
					return;
				}
			}
			removeItem($object);
			_ignoredObjects.push($object);
		}
		
		public function removeIgnoredObject($o:DisplayObject):void {
			for (var i:uint = 0; i < _ignoredObjects.length; i++) {
				if (_ignoredObjects[i] == $o) {
					_ignoredObjects.splice(i, 1);
				}
			}
		}
		
		private function onDestroyItem($e:TransformEvent):void {
			removeItem($e.target);
		}
		
		
//---- GENERAL -------------------------------------------------------------------------------------------------------------------------
		
		private function setOrigin($p:Point):void { //Repositions the registration point of the _dummyBox and then calls plotHandles() to redraw the handles
			_origin = $p;
			
			var local:Point = _dummyBox.globalToLocal(_parent.localToGlobal($p));
			var bounds:Rectangle = _dummyBox.getBounds(_dummyBox);
			
			_dummyBox.graphics.clear();
			_dummyBox.graphics.beginFill(0x0066FF, 1);
			_dummyBox.graphics.drawRect(bounds.x - local.x, bounds.y - local.y, bounds.width, bounds.height);
			_dummyBox.graphics.endFill();
			
			_dummyBox.x = _origin.x;
			_dummyBox.y = _origin.y;
			
			enforceSafetyZone();
			
			for (var i:int = _selectedItems.length - 1; i > -1; i--) {
				_selectedItems[i].origin = _origin;
			}
			
			plotHandles();
			renderSelection();
		}
		
		private function enforceSafetyZone():void { //Due to rounding issues in extremely small decimals, a selection can creep slightly over the bounds when the origin and/or selection bounding box is directly on top of one of the edges of the boundaries. This function enforces a 0.1 pixel "safety zone" to avoid that issue.
			if (_bounds != null) {
				if (!_bounds.containsPoint(_origin)) {
					if (_bounds.left > _origin.x) {
						shiftSelection(_bounds.left - _origin.x, 0);
					} else if (_bounds.right < _origin.x) {
						shiftSelection(_bounds.right - _origin.x, 0);
					}
					if (_bounds.top > _origin.y) {
						shiftSelection(0, _origin.y - _bounds.top);
					} else if (_bounds.bottom < _origin.y) {
						shiftSelection(0, _bounds.bottom - _origin.y);
					}
				}
				if (_selectedItems.length != 0) {					
					if (_handles[0].point == null) {
						plotHandles();
					}
					var b:Rectangle = _dummyBox.getBounds(_parent);
					if (_bounds.width - b.width < 0.2) {
						shiftSelectionScale(1 - (0.22 / b.width));
					}
					
					b = _dummyBox.getBounds(_parent);
					if (_bounds.height - b.height < 0.2) {
						shiftSelectionScale(1 - (0.22 / b.height));
					}
					
					if (Math.abs(b.top - _bounds.top) < 0.1) {
						shiftSelection(0, 0.1);
					}
					if (Math.abs(b.bottom - _bounds.bottom) < 0.1) {
						shiftSelection(0, -0.1);
					}
					if (Math.abs(b.left - _bounds.left) < 0.1) {
						shiftSelection(0.1, 0);					
					}
					if (Math.abs(b.right - _bounds.right) < 0.1) {
						shiftSelection(-0.1, 0);
					}
				}
				
			}
			
			function shiftSelection($x:Number, $y:Number):void {
				_dummyBox.x += $x;
				_dummyBox.y += $y
				for (var i:int = _selectedItems.length - 1; i > -1; i--) {
					_selectedItems[i].move($x, $y, false, false);
				}
				_origin.x += $x;
				_origin.y += $y;
			}
			
			function shiftSelectionScale($scale:Number):void {
				var o:Point = _origin.clone();
				_origin.x = _bounds.x + (_bounds.width / 2);
				_origin.y = _bounds.y + (_bounds.height / 2);
				var i:int;
				for (i = _selectedItems.length - 1; i > -1; i--) {
					_selectedItems[i].origin = _origin;
				}
				scaleSelection($scale, $scale);
				_origin.x = o.x;
				_origin.y = o.y;
				for (i = _selectedItems.length - 1; i > -1; i--) {
					_selectedItems[i].origin = _origin;
				}
				updateSelection();
			}
			
		}
		
		protected function onPressDelete($e:Event = null):void {
			if (_enabled && _allowDelete) {
				var deletedItems:Array = [];
				var item:TransformItem;
				var multiple:Boolean = Boolean(_selectedItems.length > 1);
				for (var i:int = _selectedItems.length - 1; i > -1; i--) {
					item = _selectedItems[i];
					if (item.onPressDelete($e, multiple)) {
						deletedItems.push(item);
					}
				}
				if (deletedItems.length != 0) {
					dispatchEvent(new TransformEvent(TransformEvent.DELETE, deletedItems));
				}
			}
		}
		
		public function deleteSelection($e:Event = null):void {
			var deletedItems:Array = [];
			var item:TransformItem;
			for (var i:int = _selectedItems.length - 1; i > -1; i--) {
				item = _selectedItems[i];
				item.deleteObject();
				deletedItems.push(item);
			}
			if (deletedItems.length != 0) {
				dispatchEvent(new TransformEvent(TransformEvent.DELETE, deletedItems));
			}
		}
		
		private function onPressArrowKey($e:KeyboardEvent = null):void {
			if (_arrowKeysMove && _enabled && _selectedItems.length != 0){
				var moveAmount:int = 1;
				// Move faster if the shift key is down.
				if(isKeyDown(Keyboard.SHIFT)){
					moveAmount = 10;
				}
				switch($e.keyCode) {
					case Keyboard.UP:
						moveSelection(0, -moveAmount);
						break;
					case Keyboard.DOWN:
						moveSelection(0, moveAmount);
						break;
					case Keyboard.LEFT:
						moveSelection(-moveAmount, 0);
						break;
					case Keyboard.RIGHT:
						moveSelection(moveAmount, 0);
						break;
				}
			}
		}
		
		public function centerOrigin():void {
			setOrigin(getSelectionCenter());
		}
		
		public function getSelectionCenter():Point {
			var bounds:Rectangle = _dummyBox.getBounds(_dummyBox);
			return _parent.globalToLocal(_dummyBox.localToGlobal(new Point(bounds.x + bounds.width / 2, bounds.y + bounds.height / 2)));
		}
		
		public function getSelectionBounds():Rectangle {
			if (_parent.contains(_dummyBox) && _selectedItems.length != 0) {
				return _dummyBox.getBounds(_parent);
			} else {
				return null;
			}
		}
		
		public function getSelectionBoundsWithHandles():Rectangle {
			if (_parent.contains(_selection) && _selectedItems.length != 0) {
				return _selection.getBounds(_parent);
			} else {
				return null;
			}
		}
		
		public function getUnrotatedSelectionWidth():Number {
			var bounds:Rectangle = _dummyBox.getBounds(_dummyBox);
			return bounds.width * MatrixTools.getScaleX(_dummyBox.transform.matrix);
		}
		
		public function getUnrotatedSelectionHeight():Number {
			var bounds:Rectangle = _dummyBox.getBounds(_dummyBox);
			return bounds.height * MatrixTools.getScaleY(_dummyBox.transform.matrix);
		}
		
		public function getItem($targetObject:DisplayObject):TransformItem {
			for (var i:int = _items.length - 1; i > -1; i--) {
				if (_items[i].targetObject == $targetObject) {
					return _items[i];
				}
			}
			return null;
		}
		
		private function findObject($item:*):TransformItem {
			if ($item is DisplayObject) {
				return getItem($item);
			} else if ($item is TransformItem) {
				return $item;
			} else {
				return null;
			}
		}
		
		private function updateItemProp($prop:String, $value:*):void {
			for (var i:int = _items.length - 1; i > -1; i--) {
				_items[i][$prop] = $value;
			}
		}
		
		private function removeParentListeners():void {
			if (_parent != null && _stage != null) {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseMove);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveMove);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveRotate);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveScale);
			}
		}
		
		public function destroy():void {
			deselectAll();
			_keyDispatcher.removeEventListener("pressDelete", onPressDelete);
			_keyDispatcher.removeEventListener("pressArrowKey", onPressArrowKey);
			_keyDispatcher.removeEventListener("pressMultiSelectKey", onPressMultiSelectKey);
			_keyDispatcher.removeEventListener("releaseMultiSelectKey", onReleaseMultiSelectKey);
			if (_stage != null) {
				_stage.removeEventListener(Event.DEACTIVATE, onReleaseMultiSelectKey);
			}
			removeParentListeners();
			for (var i:int = _items.length - 1; i > -1; i--) {
				_items[i].destroy();
			}
			dispatchEvent(new TransformEvent(TransformEvent.DESTROY, _items.slice()));
		}
		

//---- DEPTH MANAGEMENT ------------------------------------------------------------------------------------------------------------

		public function moveSelectionDepthDown():void{
			moveSelectionDepth(-1);
		}
		
		public function moveSelectionDepthUp():void{
			moveSelectionDepth(1);
		}
		
		private function moveSelectionDepth(direction:int = 1):void{
			if (_enabled && _selectedItems.length != 0 && _parent != null && _parent.contains(_dummyBox) && _parent.contains(_selection)) {
				var curDepths:Array = [];
				var i:int;
				for (i = _items.length - 1; i > -1; i--) {
					if (_items[i].targetObject.parent == _parent) {
						curDepths.push({depth:_parent.getChildIndex(_items[i].targetObject), item:_items[i]});
					}
				}
				curDepths.sortOn("depth");
				var newDepths:Array = [];
				var hitGap:Boolean = false;
				if (direction == -1) {
					newDepths.push(curDepths[0].item.targetObject);
					if (!curDepths[0].item.selected) {
						hitGap = true;
					}
					for (i = 1; i < curDepths.length; i++) {
						if (curDepths[i].item.selected && hitGap) { // prevent the bottom two items from swapping depths when they're both selected
							newDepths.splice(-1, 0, curDepths[i].item.targetObject);
						} else {
							newDepths.push(curDepths[i].item.targetObject);
							if (!curDepths[i].item.selected && !hitGap) {
								hitGap = true;
							}
						}
					}
				} else {
					newDepths.push(curDepths[curDepths.length - 1].item.targetObject);
					if (!curDepths[curDepths.length - 1].item.selected) {
						hitGap = true;
					}
					for (i = curDepths.length - 2; i > -1; i--) {
						if (curDepths[i].item.selected && hitGap) {
							newDepths.splice(1, 0, curDepths[i].item.targetObject);
						} else {
							newDepths.unshift(curDepths[i].item.targetObject);
							if (!curDepths[i].item.selected && !hitGap) {
								hitGap = true;
							}
						}
					}
				}
				for (i = 0; i < newDepths.length; i++) {
					_parent.setChildIndex(newDepths[i], curDepths[i].depth);
				}
				dispatchEvent(new TransformEvent(TransformEvent.DEPTH_CHANGE, _items.slice()));
			}
		}
		
		
//---- SELECTION ---------------------------------------------------------------------------------------------------------------------
		
		private function checkForDeselect($e:MouseEvent = null):void {
			if (_selectedItems.length != 0) {
				var deselectedItem:TransformItem = _tempDeselectedItem; //if an item was JUST deselected on this click, it'll be stored here (because it's now deselected, but we need to still sense whether or not the user CTRL-clicked on it to deselect it, in which case we shouldn't deselectAll())
				_tempDeselectedItem = null;
				if (_selection.hitTestPoint($e.stageX, $e.stageY, true)) {
					return;
				} else if (deselectedItem != null) {
					if (deselectedItem.targetObject.hitTestPoint($e.stageX, $e.stageY, true)) {
						return;
					}
				}
				for (var i:int = _selectedItems.length - 1; i > -1; i--) {
					 if (_selectedItems[i].targetObject.hitTestPoint($e.stageX, $e.stageY, true)) {
						return;
					}
				}
				for (i = _ignoredObjects.length - 1; i > -1; i--) {
					if (_ignoredObjects[i].hitTestPoint($e.stageX, $e.stageY, true)) {
						return;
					}
				}
				if (_autoDeselect) {
					deselectAll();
				} else if (!_selection.hitTestPoint($e.stageX, $e.stageY, true)) {
					dispatchEvent(new TransformEvent(TransformEvent.CLICK_OFF, _selectedItems.slice(), $e));
				}
			}
		}
		
		private function onMouseDownItem($e:TransformEvent):void {
			if (isKeyDown(Keyboard.CONTROL)) {
				$e.target.selected = !$e.target.selected;
				if (!$e.target.selected) {
					_tempDeselectedItem = $e.target as TransformItem; //we need to keep track of this just until the checkForDeselect() runs, otherwise it'll always deselectAll() when we CTRL-CLICK an item to deselect it.
				}
			} else {
				$e.target.selected = true;
			}
		}
		
		private function onMouseDownSelection($e:MouseEvent):void {
			_stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseMove, false, 0, true);
			onPressMove($e);
		}
		
		public function selectItem($item:*, $addToSelection:Boolean = false):TransformItem { //You can pass in a reference to the DisplayObject or its associated TransformItem.
			var item:TransformItem = findObject($item); //makes it possible to pass in DisplayObjects or TransformItems
			if (item == null) {
				trace("TransformManager Error: selectItem() and selectItems() only work with objects that have a TransformItem associated with them. Make sure you create one by calling TransformManager.addItem() before attempting to select it.");
			} else if (!item.selected) {
				var previousMode:Boolean = _multiSelectMode;
				_multiSelectMode = $addToSelection; //otherwise when the item dispatches a SELECT event, it'll wipe out the other selected items.
				_ignoreSelectionEvents = true;
				item.selected = true;
				_ignoreSelectionEvents = false;
				_multiSelectMode = previousMode;
				dispatchEvent(new TransformEvent(TransformEvent.SELECTION_CHANGE, [item]));
			}
			return item;
		}
		
		public function deselectItem($item:*):TransformItem {
			var item:TransformItem = findObject($item);
			if (item != null) {
				item.selected = false;
			}
			return item;
		}
		
		public function selectItems($items:Array, $addToSelection:Boolean = false):Array {
			var i:uint, j:uint, item:TransformItem, selectedItem:TransformItem, found:Boolean;
			var validItems:Array = [];
			_ignoreSelectionEvents = true;
			for (i = 0; i < $items.length; i++) {
				item = findObject($items[i]);
				if (item != null) {
					validItems.push(item);	
				}
			}
			if (!$addToSelection) {
				for (i = 0; i < _selectedItems.length; i++) {
					selectedItem = _selectedItems[i];
					found = false;
					for (j = 0; j < validItems.length; j++) {
						if (validItems[j] == selectedItem) {
							found = true;
							break;
						}
					}
					if (!found) {
						selectedItem.selected = false;
					}
				}
			}
			var previousMode:Boolean = _multiSelectMode;
			_multiSelectMode = true;
			for (i = 0; i < validItems.length; i++) {
				validItems[i].selected = true;
			}
			_multiSelectMode = previousMode;
			_ignoreSelectionEvents = false;
			dispatchEvent(new TransformEvent(TransformEvent.SELECTION_CHANGE, validItems));
			return validItems;
		}
		
		public function deselectAll():void {
			var oldItems:Array = _selectedItems.slice();
			_ignoreSelectionEvents = true;
			for (var i:int = _selectedItems.length - 1; i > -1; i--) {
				_selectedItems[i].selected = false;
			}
			_ignoreSelectionEvents = false;
			dispatchEvent(new TransformEvent(TransformEvent.SELECTION_CHANGE, oldItems));
		}
		
		public function isSelected($item:*):Boolean {
			var item:TransformItem = findObject($item);
			if (item != null) {
				return item.selected;
			} else {
				return false;
			}
		}
		
		private function onSelectItem($e:TransformEvent):void {
			var i:int;
			var previousIgnore:Boolean = _ignoreSelectionEvents;
			_ignoreSelectionEvents = true;
			var changed:Array = [$e.target as TransformItem];
			if (!_multiSelectMode) {
				for (i = _selectedItems.length - 1; i > -1; i--) {
					changed.push(_selectedItems[i]);
					_selectedItems[i].selected = false;
					_selectedItems.splice(i, 1);
				}
			}
			_selectedItems.push($e.target);
			if (_initted) {
				if (_forceSelectionToFront) {
					for (i = _selectedItems.length - 1; i > -1; i--) {
						bringToFront(_selectedItems[i].targetObject);
					}
				}
				calibrateConstraints();
				updateSelection();
			}
			_ignoreSelectionEvents = previousIgnore;
			if (!_ignoreSelectionEvents) {
				dispatchEvent(new TransformEvent(TransformEvent.SELECTION_CHANGE, changed));
			}
		}
		
		private function calibrateConstraints():void {
			_selConstrainScale = _constrainScale;
			_selLockScale = _lockScale;
			_selLockRotation = _lockRotation;
			_selLockPosition = _lockPosition;
			_selHasTextFields = _selHasScaleLimits = false;
			for (var i:int = _selectedItems.length - 1; i > -1; i--) {
				if (_selectedItems[i].constrainScale) {
					_selConstrainScale = true;
				}
				if (_selectedItems[i].lockScale) {
					_selLockScale = true;
				}
				if (_selectedItems[i].lockRotation) {
					_selLockRotation = true;
				}
				if (_selectedItems[i].lockPosition) {
					_selLockPosition = true;
				}
				if (_selectedItems[i].scaleMode != SCALE_NORMAL) {
					_selHasTextFields = true;
				}
				if (_selectedItems[i].hasScaleLimits) {
					_selHasScaleLimits = true;
				}
			}
		}
		
		private function onDeselectItem($e:TransformEvent):void {
			for (var i:int = _selectedItems.length - 1; i > -1; i--) {
				if (_selectedItems[i] == $e.target) {
					_selectedItems.splice(i, 1);
					updateSelection();
					if (!_ignoreSelectionEvents) {
						dispatchEvent(new TransformEvent(TransformEvent.SELECTION_CHANGE, [$e.target as TransformItem]));
					}
					if (!mouseIsOverSelection(true)) {
						swapCursorOut();
					}
					return;
				}
			}
		}
		
		private function onUpdateItem($e:TransformEvent):void {
			if ($e.target.selected) {
				updateSelection();
				dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [$e.target]));
			}
		}
		
		public function updateSelection():void { //Includes resizing the _dummyBox.
			if (_selectedItems.length != 0) {
				if (_dummyBox.parent != _parent) { //in case the user accidentally removed it
					_parent.addChild(_dummyBox);
				}
				var r:Rectangle;
				_dummyBox.transform.matrix = new Matrix(); //Clears any transformations.
				_dummyBox.graphics.clear();
				_dummyBox.graphics.beginFill(0x0066FF, 1);
				if (_selectedItems.length == 1) {
					var ti:TransformItem = _selectedItems[0];
					var t:DisplayObject = ti.targetObject;
					if (!t.hasOwnProperty("content") && t.width != 0) { //in Flex, SWFLoaders/Images and some other components don't accurately report width/height
						var m:Matrix = t.transform.matrix;
						t.transform.matrix = new Matrix(); //gets rid of all transformations. Bugs in the Flex framework prevented getBounds() from accurately reporting the width/height, so I had to remove all transformations and check it directly with object.width and object.height.
						r = t.getBounds(t);
						_dummyBox.graphics.drawRect(r.x, r.y, t.width, t.height);
						_dummyBox.transform.matrix = t.transform.matrix = m;
					} else {
						r = t.getBounds(t);
						_dummyBox.graphics.drawRect(r.x, r.y, r.width, r.height);
						_dummyBox.transform.matrix = t.transform.matrix;
					}
				} else {
					r = _selectedItems[0].targetObject.getBounds(_parent);
					for (var i:int = _selectedItems.length - 1; i > 0; i--) {
						r = r.union(_selectedItems[i].targetObject.getBounds(_parent));
					}
					_dummyBox.graphics.drawRect(r.x, r.y, r.width, r.height);
				}
				_dummyBox.graphics.endFill();
				centerOrigin();
				if (_selection.parent != _parent) {
					_parent.addChild(_selection);
				}
				renderSelection();
				bringToFront(_selection);
			} else if (_parent != null) {
				if (_selection.parent == _parent) {
					_parent.removeChild(_selection);
				}
				if (_dummyBox.parent == _parent) {
					_parent.removeChild(_dummyBox);
				}
			}
		}
		
		private function renderSelection():void { //Only makes the selection handles and edges match where the _dummyBox is
			if (_initted) {
				var m:Matrix = _dummyBox.transform.matrix;
				_selection.graphics.clear();
				_selection.graphics.lineStyle(1, _lineColor, 1, false, "none");
				
				_edges.graphics.clear();
				_edges.graphics.lineStyle(10, 0xFF0000, 0, false, "none");
				
				var rotation:Number = _dummyBox.rotation;
				var flip:Boolean = false;
				if (MatrixTools.getDirectionX(m) * MatrixTools.getDirectionY(m) < 0) {
					flip = true;
				}
				var p:Point, finishPoint:Point, i:int;
				for (i = _handles.length - 1; i > -1; i--) {
					p = m.transformPoint(_handles[i].point);
					_handles[i].handle.x = p.x;
					_handles[i].handle.y = p.y;
					_handles[i].handle.rotation = rotation;
					if (flip) {
						_handles[i].handle.rotation += _handles[i].flipRotation;
					}
					if (i == 8) { 
						_selection.graphics.moveTo(p.x, p.y);
						_edges.graphics.moveTo(p.x, p.y);
						finishPoint = p;
					} else if (i > 4) {
						_selection.graphics.lineTo(p.x, p.y);
						_edges.graphics.lineTo(p.x, p.y);
					}
				}
				_selection.graphics.lineTo(finishPoint.x, finishPoint.y);
				_edges.graphics.lineTo(finishPoint.x, finishPoint.y);
				
			}
		}
		
		private function initSelection():void {
			_selection = _isFlex ? new (getDefinitionByName("mx.core.UIComponent"))() : new Sprite();
			_selection.name = "__selection_mc";
			_edges = new Sprite();
			_edges.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownSelection, false, 0, true);
			_selection.addChild(_edges);
			_dummyBox = _isFlex ? new (getDefinitionByName("mx.core.UIComponent"))() : new Sprite();
			_dummyBox.name = "__dummyBox_mc";
			_dummyBox.visible = false;
			_handles = [];
			createHandle("c", "center", 0, 0, null);
			createHandle("t", "stretchV", 90, 0, "b");
			createHandle("r", "stretchH", 0, 0, "l");
			createHandle("b", "stretchV", -90, 0, "t");
			createHandle("l", "stretchH", 180, 0, "r");
			createHandle("tl", "corner", -135, -90, "br");
			createHandle("tr", "corner", -45, 90, "bl");
			createHandle("br", "corner", 45, -90, "tl");
			createHandle("bl", "corner", 135, 90, "tr");
			redrawHandles();
			setCursorListeners(true);
		}
		
		private function createHandle($name:String, $type:String, $cursorRotation:Number, $flipRotation:Number = 0, $oppositeName:String = null):Object {
			var h:Sprite = new Sprite(); //container handle
			h.name = $name;
			var s:Sprite = new Sprite(); //Scale handle
			s.name = "scaleHandle";
			
			var handle:Object = {handle:h, scaleHandle:s, type:$type, name:$name, oppositeName:$oppositeName, flipRotation:$flipRotation, cursorRotation:$cursorRotation};
			_handlesDict[s] = handle; //To make lookups faster on cursor rollovers
			
			if ($type != "center") {
				var onPress:Function;
				if ($type == "stretchH") {
					onPress = onPressStretchH;
				} else if ($type == "stretchV") {
					onPress = onPressStretchV;
				} else {
					onPress = onPressScale;
					var r:Sprite = new Sprite(); //rotation hit area
					r.name = "rotationHandle"
					r.addEventListener(MouseEvent.MOUSE_DOWN, onPressRotate, false, 0, true);
					h.addChild(r);
					_handlesDict[r] = handle;
					handle.rotationHandle = r;
				}
				s.addEventListener(MouseEvent.MOUSE_DOWN, onPress, false, 0, true);
			} else {
				s.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownSelection, false, 0, true);
			}
			h.addChild(s);
			_selection.addChild(h);
			_handles.push(handle);
			return handle;
		}
		
		private function redrawHandles():void {
			var i:uint, s:Sprite, r:Sprite, handleName:String, rx:Number, ry:Number;
			var halfH:Number = _handleSize / 2;
			for (i = 0; i < _handles.length; i++) {
				s = _handles[i].scaleHandle;
				handleName = _handles[i].name;
				s.graphics.clear();
				s.graphics.lineStyle(1, _lineColor, 1, false, "none");
				s.graphics.beginFill(_handleColor, 1);
				s.graphics.drawRect(0 - (_handleSize / 2), 0 - (_handleSize / 2), _handleSize, _handleSize);
				s.graphics.endFill();
				if (_handles[i].type == "corner") {
					r = _handles[i].rotationHandle;
					if (handleName == "tl") {
						rx = ry = -halfH - _paddingForRotation;
					} else if (handleName == "tr") {
						rx = -halfH;
						ry = -halfH - _paddingForRotation;
					} else if (handleName == "br") {
						rx = ry = -halfH;
					} else {
						rx = -halfH - _paddingForRotation;
						ry = -halfH;
					}
					r.graphics.clear();
					r.graphics.lineStyle(0, _lineColor, 0);
					r.graphics.beginFill(0xFF0000, 0);
					r.graphics.drawRect(rx, ry, _handleSize + _paddingForRotation, _handleSize + _paddingForRotation);
					r.graphics.endFill();
				}
			}
		}
		
		private function plotHandles():void {
			var r:Rectangle = _dummyBox.getBounds(_dummyBox);
			_handles[0].point = new Point(r.x + r.width / 2, r.y + r.height / 2); //center
			_handles[1].point = new Point(r.x + r.width / 2, r.y); 				  //top
			_handles[2].point = new Point(r.x + r.width, r.y + r.height / 2);	  //right
			_handles[3].point = new Point(r.x + r.width / 2, r.y + r.height);	  //bottom
			_handles[4].point = new Point(r.x, r.y + r.height / 2); 			  //left
			_handles[5].point = new Point(r.x, r.y);							  //topLeft
			_handles[6].point = new Point(r.x + r.width, r.y); 					  //topRight
			_handles[7].point = new Point(r.x + r.width, r.y + r.height); 		  //bottomRight
			_handles[8].point = new Point(r.x, r.y + r.height);					  //bottomLeft
		}
		

//---- MOVE ------------------------------------------------------------------------------------------------------------------------

		private function onPressMove($e:Event):void {
			if (!_selLockPosition) {
				_trackingInfo = {offsetX:_parent.mouseX - _dummyBox.x, offsetY:_parent.mouseY - _dummyBox.y, x:_dummyBox.x, y:_dummyBox.y, mouseX:_parent.mouseX, mouseY:_parent.mouseY};
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveMove, false, 0, true);
				swapCursorIn(moveCursor, null);
				setCursorListeners(false);
				onMouseMoveMove();
			}
		}
		
		private function onMouseMoveMove($e:MouseEvent = null):void {
			var x:Number = int(_parent.mouseX - (_dummyBox.x + _trackingInfo.offsetX));
			var y:Number = int(_parent.mouseY - (_dummyBox.y + _trackingInfo.offsetY));
			var totalX:Number = _parent.mouseX - _trackingInfo.mouseX;
			var totalY:Number = _parent.mouseY - _trackingInfo.mouseY;
			if (!isKeyDown(Keyboard.SHIFT)) {
				moveSelection(x, y);
			} else if (Math.abs(totalX) > Math.abs(totalY)) {
				moveSelection(x, _trackingInfo.y - _dummyBox.y);
			} else {
				moveSelection(_trackingInfo.x - _dummyBox.x, y);
			}
		}
		
		public function moveSelection($x:Number, $y:Number):void {
			if (!_selLockPosition) {
				var safe:Object = {x:$x, y:$y};
				var m:Matrix = _dummyBox.transform.matrix;
				_dummyBox.x += $x;
				_dummyBox.y += $y;
				var i:int;
				if (_bounds != null && !_bounds.containsRect(_dummyBox.getBounds(_parent))) {
					for (i = _selectedItems.length - 1; i > -1; i--) {
						_selectedItems[i].moveCheck($x, $y, safe);
					}
					m.translate(safe.x, safe.y);
					_dummyBox.transform.matrix = m;
				}
				for (i = _selectedItems.length - 1; i > -1; i--) {
					_selectedItems[i].move(safe.x, safe.y, false, false);
				}
				_origin.x = _dummyBox.x;
				_origin.y = _dummyBox.y;
				renderSelection();
			}
		}
		
		private function onReleaseMove($e:Event):void {
			if (!_selLockPosition) {
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveMove);
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseMove);
				if (!mouseIsOverSelection(true)) {
					swapCursorOut();
				}
				setCursorListeners(true);
				if (_trackingInfo.x != _dummyBox.x || _trackingInfo.y != _dummyBox.y) {
					dispatchEvent(new TransformEvent(TransformEvent.MOVE, _selectedItems.slice()));
					for (var i:int = _selectedItems.length - 1; i > -1; i--) {
						_selectedItems[i].forceEventDispatch(TransformEvent.MOVE);
					}
				}
			}
		}


//---- SCALE ------------------------------------------------------------------------------------------------------------------------

		private function onPressScale($e:MouseEvent):void {
			if (!_selLockScale && (!_selHasTextFields || _selectedItems.length == 1)) {
				setScaleOrigin($e.target as Sprite);
				captureScaleTrackingInfo($e.target as Sprite);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveScale, false, 0, true);
				_stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseScale, false, 0, true);
				setCursorListeners(false);
				onMouseMoveScale();
			}
		}
		
		private function setScaleOrigin($pressedHandle:Sprite):void {
			bringToFront($pressedHandle.parent);
			if (_scaleFromCenter) {
				centerOrigin();
			} else {
				var h:DisplayObject = _selection.getChildByName(_handlesDict[$pressedHandle].oppositeName);
				setOrigin(new Point(h.x, h.y));
			}
		}
		
		private function onMouseMoveScale($e:MouseEvent = null):void {
			updateScale(true, true);
		}
		
		private function updateScale($x:Boolean = true, $y:Boolean = true):void {
			var ti:Object = _trackingInfo; //to speed things up
			var mx:Number = _parent.mouseX - ti.mouseOffsetX, my:Number = _parent.mouseY - ti.mouseOffsetY;
			
			if (_bounds != null) {
				if (mx > _bounds.right) {
					mx = _bounds.right;
				} else if (mx < _bounds.left) {
					mx = _bounds.left;
				}
				if (my > _bounds.bottom) {
					my = _bounds.bottom;
				} else if (my < _bounds.top) {
					my = _bounds.top;
				}
			}
			
			var dx:Number = mx - _origin.x; //Distance from mouse to origin (x)
			var dy:Number = _origin.y - my; //Distance from mouse to origin (y)
			var d:Number = Math.sqrt(dx * dx + dy * dy); //Distance from mouse to origin (total).
			var angleToMouse:Number = Math.atan2(dy, dx);
			
			var constrain:Boolean = (_selConstrainScale || isKeyDown(Keyboard.SHIFT));
			
			var newScaleX:Number, newScaleY:Number, oldScaleX:Number, oldScaleY:Number;
			if (constrain) {
				var angleDif:Number = (angleToMouse - ti.angleToMouse + Math.PI * 3.5) % (Math.PI * 2);
				if (angleDif < Math.PI) {
					d *= -1; //flip it when necessary to make the scaleX & scaleY negative.
				}
				newScaleX = d * ti.scaleRatioXConst;
				newScaleY = d * ti.scaleRatioYConst;
			} else {
				angleToMouse += ti.angle;
				newScaleX = ti.scaleRatioX * Math.cos(angleToMouse) * d;
				newScaleY = ti.scaleRatioY * Math.sin(angleToMouse) * d;
			}
			
			var m:Matrix = _dummyBox.transform.matrix;
			oldScaleX = Math.sqrt(m.a * m.a + m.b * m.b);
			oldScaleY = Math.sqrt(m.c * m.c + m.d * m.d);
			if (m.a < 0) {
				oldScaleX = -oldScaleX;
			}
			if (m.d < 0) {
				oldScaleY = -oldScaleY;
			}
			
			if (($x || constrain) && newScaleX != 0) {
				newScaleX /= oldScaleX;
			} else {
				newScaleX = 1;
			}
			if (($y || constrain) && newScaleY != 0) {
				newScaleY /= oldScaleY;
			} else {
				newScaleY = 1;
			}
			scaleSelection(newScaleX, newScaleY);
		}
		
		public function scaleSelection($sx:Number, $sy:Number):void {
			if (!_selLockScale && (!_selHasTextFields || (_selectedItems.length == 1 && $sx > 0 && $sy > 0))) {
				var i:int;
				var m:Matrix = _dummyBox.transform.matrix;
				var m2:Matrix = m.clone(); //keep a fresh backup copy in case the bounds are violated and we need to re-apply the transformations after figuring out what's safe.
				
				var angle:Number = MatrixTools.getAngle(m); //like _dummyBox.rotation * _DEG2RAD;
				var skew:Number = MatrixTools.getSkew(m);
				if (angle != -skew && Math.abs((angle + skew) % (Math.PI - 0.01)) < 0.01) { //protects against rounding errors in tiny decimals
					skew = -angle;
				}
				
				MatrixTools.scaleMatrix(m, $sx, $sy, angle, skew);
				
				_dummyBox.transform.matrix = m;
				
				var safe:Object = {sx:$sx, sy:$sy};
				if (_selHasScaleLimits || (_bounds != null && !_bounds.containsRect(_dummyBox.getBounds(_parent)))) {
					for (i = _selectedItems.length - 1; i > -1; i--) {
						_selectedItems[i].scaleCheck(safe, angle, skew);
					}
					MatrixTools.scaleMatrix(m2, safe.sx, safe.sy, angle, skew);
					_dummyBox.transform.matrix = m2;
				}
				for (i = _selectedItems.length - 1; i > -1; i--) {
					_selectedItems[i].scaleRotated(safe.sx, safe.sy, angle, skew, false, false);
				}
				renderSelection();
			}
		}
		
		public function flipSelectionHorizontal():void {
			if (_enabled && _selectedItems.length != 0) {
				scaleSelection(-1, 1);
			}
		}
		
		public function flipSelectionVertical():void {
			if (_enabled && _selectedItems.length != 0) {
				scaleSelection(1, -1);
			}
		}
		
		private function onReleaseScale($e:MouseEvent):void {
			if (!_selLockScale) {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseScale);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveScale);
				if (!_trackingInfo.handle.hitTestPoint($e.stageX, $e.stageY, true)) {
					swapCursorOut();
				}
				setCursorListeners(true);
				centerOrigin();
				var m:Matrix = _dummyBox.transform.matrix;
				if (_trackingInfo.scaleX != MatrixTools.getDirectionX(m) || _trackingInfo.scaleY != MatrixTools.getDirectionY(m)) {
					dispatchEvent(new TransformEvent(TransformEvent.SCALE, _selectedItems.slice()));
					for (var i:int = _selectedItems.length - 1; i > -1; i--) {
						_selectedItems[i].forceEventDispatch(TransformEvent.SCALE);
					}
				}
			}
		}
		
		private function captureScaleTrackingInfo($handle:Sprite):void {
			var handlePoint:Point = _parent.globalToLocal($handle.localToGlobal(new Point(0, 0)));
			
			var mdx:Number = handlePoint.x - _origin.x; //Distance to mouse along the x-axis
			var mdy:Number = _origin.y - handlePoint.y; //Distance to mouse along the y-axis
			var distanceToMouse:Number = Math.sqrt(mdx * mdx + mdy * mdy);
			var angleToMouse:Number = Math.atan2(mdy, mdx);
			
			var m:Matrix = _dummyBox.transform.matrix;
			
			var angle:Number = MatrixTools.getAngle(m); //like _dummyBox.rotation * _DEG2RAD;
			var skew:Number = MatrixTools.getSkew(m);
			var correctedAngle:Number = angleToMouse + angle; //Rotated (corrected) angle to mouse (as though we tilted everything including the mouse position so that the _dummyBox is at a 0 degree angle)
			
			var scaleX:Number = MatrixTools.getDirectionX(m);
			var scaleY:Number = MatrixTools.getDirectionY(m);
			
			_trackingInfo = {scaleRatioX:scaleX / (Math.cos(correctedAngle) * distanceToMouse),
							 scaleRatioY:scaleY / (Math.sin(correctedAngle) * distanceToMouse),
							 scaleRatioXConst:scaleX / distanceToMouse,
							 scaleRatioYConst:scaleY / distanceToMouse,
							 angleToMouse:positiveAngle(angleToMouse),
							 angle:angle,
							 skew:skew,
							 mouseX:_parent.mouseX,
							 mouseY:_parent.mouseY,
							 scaleX:scaleX,
							 scaleY:scaleY,
							 mouseOffsetX:_parent.mouseX - handlePoint.x,
							 mouseOffsetY:_parent.mouseY - handlePoint.y,
							 handle:$handle};
		}
		

//---- STRETCH HORIZONTAL ------------------------------------------------------------------------------------------------------------
		
		private function onPressStretchH($e:MouseEvent):void {
			if (!_selLockScale) {
				setScaleOrigin($e.target as Sprite);
				captureScaleTrackingInfo($e.target as Sprite);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveStretchH, false, 0, true);
				_stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseStretchH, false, 0, true);
				setCursorListeners(false);
				onMouseMoveStretchH();
			}
		}
		
		private function onMouseMoveStretchH($e:MouseEvent = null):void {
			updateScale(true, false);
		}
		
		private function onReleaseStretchH($e:MouseEvent):void {
			if (!_selLockScale) {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseStretchH);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveStretchH);
				if (!_trackingInfo.handle.hitTestPoint($e.stageX, $e.stageY, true)) {
					swapCursorOut();
				}
				setCursorListeners(true);
				centerOrigin();
				var m:Matrix = _dummyBox.transform.matrix;
				if (_trackingInfo.scaleX != MatrixTools.getDirectionX(m) || _trackingInfo.scaleY != MatrixTools.getDirectionY(m)) {
					dispatchEvent(new TransformEvent(TransformEvent.SCALE, _selectedItems.slice()));
					for (var i:int = _selectedItems.length - 1; i > -1; i--) {
						_selectedItems[i].forceEventDispatch(TransformEvent.SCALE);
					}
				}
			}
		}
		
		
//---- STRETCH VERTICAL ------------------------------------------------------------------------------------------------------------
	
		private function onPressStretchV($e:MouseEvent):void {
			if (!_selLockScale) {
				setScaleOrigin($e.target as Sprite);
				captureScaleTrackingInfo($e.target as Sprite);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveStretchV, false, 0, true);
				_stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseStretchV, false, 0, true);
				setCursorListeners(false);
				onMouseMoveStretchV();
			}
		}
		
		private function onMouseMoveStretchV($e:MouseEvent = null):void {
			updateScale(false, true);
		}
		
		private function onReleaseStretchV($e:MouseEvent):void {
			if (!_selLockScale) {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseStretchV);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveStretchV);
				if (!_trackingInfo.handle.hitTestPoint($e.stageX, $e.stageY, true)) {
					swapCursorOut();
				}
				setCursorListeners(true);
				centerOrigin();
				var m:Matrix = _dummyBox.transform.matrix;
				if (_trackingInfo.scaleX != MatrixTools.getDirectionX(m) || _trackingInfo.scaleY != MatrixTools.getDirectionY(m)) {
					dispatchEvent(new TransformEvent(TransformEvent.SCALE, _selectedItems.slice()));
					for (var i:int = _selectedItems.length - 1; i > -1; i--) {
						_selectedItems[i].forceEventDispatch(TransformEvent.SCALE);
					}
				}
			}
		}
		
		

//---- ROTATE -------------------------------------------------------------------------------------------------------------------------

		private function onPressRotate($e:MouseEvent):void {
			if (!_selLockRotation) {
				centerOrigin();
				
				var mdx:Number = _parent.mouseX - _origin.x; //Distance to mouse along the x-axis
				var mdy:Number = _origin.y - _parent.mouseY; //Distance to mouse along the y-axis
				var angleToMouse:Number = Math.atan2(mdy, mdx);
				var angle:Number = _dummyBox.rotation * _DEG2RAD;
				
				_trackingInfo = {angleToMouse:positiveAngle(angleToMouse),
								 angle:angle,
								 mouseX:_parent.mouseX,
								 mouseY:_parent.mouseY,
								 rotation:_dummyBox.rotation,
								 handle:$e.target};
				
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveRotate, false, 0, true);
				_stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseRotate, false, 0, true);
				setCursorListeners(false);
				onMouseMoveRotate();
			}
		}
		
		private function onMouseMoveRotate($e:MouseEvent = null):void {
			var ti:Object = _trackingInfo; //to speed things up
			
			var dx:Number = _parent.mouseX - _origin.x; //Distance from mouse to origin (x)
			var dy:Number = _origin.y - _parent.mouseY; //Distance from mouse to origin (y)
			var angleToMouse:Number = Math.atan2(dy, dx);
			
			var angleDifference:Number = ti.angleToMouse - Math.atan2(dy, dx);
			var newAngle:Number = angleDifference + ti.angle;
			
			if (isKeyDown(Keyboard.SHIFT)) {
				var angleIncrement:Number = Math.PI * 0.25; //45 degrees
				newAngle = Math.round(newAngle / angleIncrement) * angleIncrement;
			}
			newAngle -= _dummyBox.rotation * _DEG2RAD;
			if (Math.abs(newAngle) > 0.25 * _DEG2RAD) {
				rotateSelection(newAngle);
			}
		}
		
		public function rotateSelection($angle:Number):void {
			if (!_selLockRotation) {
				var i:int;
				var angle:Number = _dummyBox.rotation * _DEG2RAD;
				var m:Matrix = _dummyBox.transform.matrix;
				var m2:Matrix = m.clone(); //keep a fresh backup copy in case the bounds are violated and we need to re-apply the transformations after figuring out what's safe.
				m.tx = m.ty = 0;
				m.rotate($angle);
				m.tx = _origin.x, 
				m.ty = _origin.y;
				_dummyBox.transform.matrix = m;
				
				var safe:Object = {angle:$angle};
				if (_bounds != null && !_bounds.containsRect(_dummyBox.getBounds(_parent))) {
					for (i = _selectedItems.length - 1; i > -1; i--) {
						_selectedItems[i].rotateCheck(safe);
					}
					m2.tx = m2.ty = 0;
					m2.rotate(safe.angle);
					m2.tx = _origin.x, 
					m2.ty = _origin.y;
					_dummyBox.transform.matrix = m2;
				}
				for (i = _selectedItems.length - 1; i > -1; i--) {
					_selectedItems[i].rotate(safe.angle, false, false);
				}
				renderSelection();
			}
		}
		
		private function onReleaseRotate($e:MouseEvent):void {
			if (!_selLockRotation) {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseRotate);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveRotate);
				if (!_trackingInfo.handle.hitTestPoint($e.stageX, $e.stageY, true)) {
					swapCursorOut();
				}
				setCursorListeners(true);
				if (_trackingInfo.rotation != _dummyBox.rotation) {
					dispatchEvent(new TransformEvent(TransformEvent.ROTATE, _selectedItems.slice()));
					for (var i:int = _selectedItems.length - 1; i > -1; i--) {
						_selectedItems[i].forceEventDispatch(TransformEvent.ROTATE);
					}
				}
			}
		}
	
		
//---- CURSOR FUNCTIONS ----------------------------------------------------------------------------------------------------------
		
		private function swapCursorIn($cursor:Shape, $handle:Object):void {
			if (_currentCursor != $cursor) {
				_currentCursor = $cursor;
				Mouse.hide();
				_stage.addChild(_currentCursor); //required because in some AIR applications that spawn multiple windows, there can be different stages.
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, snapCursor);
				if ($handle != null) {
					_currentCursor.rotation = $handle.handle.rotation + $handle.cursorRotation;
				}
				_currentCursor.visible = true;
				bringToFront(_currentCursor);
				snapCursor();
			}
		}
		
		private function swapCursorOut($e:Event = null):void {
			if (_currentCursor != null) {
				Mouse.show();
				_currentCursor.visible = false;
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, snapCursor);
				_currentCursor = null;
			}
		}
		
		private function snapCursor($e:MouseEvent = null):void {
			_currentCursor.x = _currentCursor.stage.mouseX;
			_currentCursor.y = _currentCursor.stage.mouseY;
		}
		
		private function onRollOverScale($e:MouseEvent):void {
			if (!_selLockScale && (!_selHasTextFields || _selectedItems.length == 1)) {
				swapCursorIn(scaleCursor, _handlesDict[$e.target]);
			}
		}
		
		private function onRollOverRotate($e:MouseEvent):void {
			if (!_selLockRotation) {
				swapCursorIn(rotationCursor, _handlesDict[$e.target]);
			}
		}
		
		private function onRollOverMove($e:Event=null):void {
			if (!_selLockPosition && _cursorListenersOn) {
				swapCursorIn(moveCursor, null);
			}
		}
		
		private function onRollOverSelectedItem($e:TransformEvent):void {
			if (!_selLockPosition && _cursorListenersOn && !$e.items[0].hasSelectableText) {
				swapCursorIn(moveCursor, null);
			}
		}
		
		private function onRollOutSelectedItem($e:TransformEvent):void {
			if (_cursorListenersOn) {
				swapCursorOut(null);
			}
		}
		
		private function setCursorListeners($on:Boolean = true):void {
			var s:Sprite, r:Sprite, i:int;
			for (i = _handles.length - 1; i > -1; i--) {
				s = _handles[i].handle.getChildByName("scaleHandle");
				r = _handles[i].handle.getChildByName("rotationHandle");
				if (_handles[i].handle.name != "c") {
					if ($on) {
						s.addEventListener(MouseEvent.MOUSE_OVER, onRollOverScale, false, 0, true);
						s.addEventListener(MouseEvent.MOUSE_OUT, swapCursorOut, false, 0, true);
						if (r != null) {
							r.addEventListener(MouseEvent.MOUSE_OVER, onRollOverRotate, false, 0, true);
							r.addEventListener(MouseEvent.MOUSE_OUT, swapCursorOut, false, 0, true);
						}
					} else {
						s.removeEventListener(MouseEvent.MOUSE_OVER, onRollOverScale);
						s.removeEventListener(MouseEvent.MOUSE_OUT, swapCursorOut);
						if (r != null) {
							r.removeEventListener(MouseEvent.MOUSE_OVER, onRollOverRotate);
							r.removeEventListener(MouseEvent.MOUSE_OUT, swapCursorOut);
						}
					}
				} else {
					if ($on) {
						s.addEventListener(MouseEvent.MOUSE_OVER, onRollOverMove, false, 0, true);
						s.addEventListener(MouseEvent.MOUSE_OUT, swapCursorOut, false, 0, true);
					} else {
						s.removeEventListener(MouseEvent.MOUSE_OVER, onRollOverMove);
						s.removeEventListener(MouseEvent.MOUSE_OUT, swapCursorOut);
					}
				}
			}
			
			if ($on) {
				_edges.addEventListener(MouseEvent.ROLL_OVER, onRollOverMove, false, 0, true);
				_edges.addEventListener(MouseEvent.ROLL_OUT, swapCursorOut, false, 0, true);
			} else {
				_edges.removeEventListener(MouseEvent.ROLL_OVER, onRollOverMove);
				_edges.removeEventListener(MouseEvent.ROLL_OUT, swapCursorOut);
			}
			
			_cursorListenersOn = $on;
			
		}
		
		protected function mouseIsOverSelection($ignoreSelectableTextItems:Boolean=false):Boolean {
			if (_selectedItems.length == 0 || _stage == null) {
				return false;
			} else if (_selection.hitTestPoint(_stage.mouseX, _stage.mouseY, true)) {
				return true;
			} else {
				for (var i:int = _selectedItems.length - 1; i > -1; i--) {
					 if (_selectedItems[i].targetObject.hitTestPoint(_stage.mouseX, _stage.mouseY, true) && !(_selectedItems[i].hasSelectableText && $ignoreSelectableTextItems)) {
						return true;
					}
				}
			}
			return false;
		}
		
		private function initScaleCursor():void {
			if (scaleCursor == null) {
				var ln:Number = 9; //length
				scaleCursor = new Shape();
				var s:Graphics = scaleCursor.graphics;
				var clr:uint, lw:uint;
				for (var i:uint = 0; i < 2; i++) {
					if (i == 0) {
						clr = 0xFFFFFF;
						lw = 5;
					} else {
						clr = 0x000000;
						lw = 2;
					}
					s.lineStyle(lw, clr, 1, false, null, "square", "miter", 3);
					
					s.beginFill(clr, 1);
					s.moveTo(-ln, 0);
					s.lineTo(2 - ln, -1.5);
					s.lineTo(2 - ln, 1.5);
					s.lineTo(-ln, 0);
					s.endFill();
					s.moveTo(2 - ln, 0);
					s.lineTo(-3, 0);
					s.moveTo(-ln, 0);
					
					s.beginFill(clr, 1);
					s.moveTo(ln, 0);
					s.lineTo(ln - 2, -1.5);
					s.lineTo(ln - 2, 1.5);
					s.lineTo(ln, 0);
					s.endFill();
					s.moveTo(3, 0);
					s.lineTo(ln - 2, 0);
					s.moveTo(3, 0);
				}
				_stage.addChild(scaleCursor);
				scaleCursor.visible = false;
			}
		}
		
		private function initRotationCursor():void {
			if (rotationCursor == null) {
				var aw:Number = 2; //arrow width
				var sb:Number = 6; //space between arrows
				rotationCursor = new Shape();
				var r:Graphics = rotationCursor.graphics;
				var clr:uint, lw:uint;
				for (var i:uint = 0; i < 2; i++) {
					if (i == 0) {
						clr = 0xFFFFFF;
						lw = 5;
					} else {
						clr = 0x000000;
						lw = 2;
					}
					r.lineStyle(lw, clr, 1, false, null, "square", "miter", 3);
					
					r.beginFill(clr, 1);
					r.moveTo(0, -sb);
					r.lineTo(0, -sb - aw);
					r.lineTo(aw, -sb - aw);
					r.lineTo(0, -sb);
					r.endFill();
					
					r.beginFill(clr, 1);
					r.moveTo(0, sb);
					r.lineTo(0, sb + aw);
					r.lineTo(aw, sb + aw);
					r.lineTo(0, sb);
					r.endFill();
					
					r.lineStyle(lw, clr, 1, false, null, "none", "miter", 3);
					r.moveTo(aw / 2, -sb - aw / 2);
					r.curveTo(aw * 4.5, 0, aw / 2, sb + aw / 2);
					r.moveTo(0, 0);
				}
				_stage.addChild(rotationCursor);
				rotationCursor.visible = false;
			}
		}
		
		private function initMoveCursor():void {
			if (moveCursor == null) {
				var ln:Number = 10; //length
				moveCursor = new Shape();
				var s:Graphics = moveCursor.graphics;
				var clr:uint, lw:uint, i:uint;
				for (i = 0; i < 2; i++) {
					if (i == 0) {
						clr = 0xFFFFFF;
						lw = 5;
					} else {
						clr = 0x000000;
						lw = 2;
					}
					s.lineStyle(lw, clr, 1, false, null, "square", "miter", 3);
					
					s.beginFill(clr, 1);
					s.moveTo(-ln, 0);
					s.lineTo(2 - ln, -1.5);
					s.lineTo(2 - ln, 1.5);
					s.lineTo(-ln, 0);
					s.endFill();
					s.beginFill(clr, 1);
					s.moveTo(2 - ln, 0);
					s.lineTo(ln, 0);
					s.moveTo(ln, 0);
					s.lineTo(ln - 2, -1.5);
					s.lineTo(ln - 2, 1.5);
					s.lineTo(ln, 0);
					s.endFill();
					
					s.beginFill(clr, 1);
					s.moveTo(0, -ln);
					s.lineTo(-1.5, 2 - ln);
					s.lineTo(1.5,  2 - ln);
					s.lineTo(0, -ln);
					s.endFill();
					s.beginFill(clr, 1);
					s.moveTo(0, 2 - ln);
					s.lineTo(0, ln);
					s.moveTo(0, ln);
					s.lineTo(-1.5, ln - 2);
					s.lineTo(1.5,  ln - 2);
					s.lineTo(0, ln);
					s.endFill();
				}
				_stage.addChild(moveCursor);
				moveCursor.visible = false;
			}
		}
		
		
//---- KEYBOARD HANDLING ------------------------------------------------------------------------------------------------------
	
		private static function initKeyListeners($stage:DisplayObjectContainer):void {
			if (!_keyListenersInitted) {
				_keysDown = {};
				$stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
            	$stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
            	$stage.addEventListener(Event.DEACTIVATE, clearKeys);
            	_keyListenersInitted = true;
            }
		}
		
		public static function isKeyDown($keyCode:uint):Boolean {
            if (!_keyListenersInitted) {
                throw new Error("Key class has yet been initialized.");
            }
            return Boolean($keyCode in _keysDown);
        }
        
        private static function onKeyPress($e:KeyboardEvent):void {
            _keysDown[$e.keyCode] = true;
            if ($e.keyCode == Keyboard.DELETE || $e.keyCode == Keyboard.BACKSPACE) {
            	_keyDispatcher.dispatchEvent(new KeyboardEvent("pressDelete"));
            } else if ($e.keyCode == Keyboard.SHIFT || $e.keyCode == Keyboard.CONTROL) {
            	_keyDispatcher.dispatchEvent(new KeyboardEvent("pressMultiSelectKey"));
            } else if($e.keyCode == Keyboard.UP || $e.keyCode == Keyboard.DOWN || $e.keyCode == Keyboard.LEFT || $e.keyCode == Keyboard.RIGHT) {
        		var kbe:KeyboardEvent = new KeyboardEvent("pressArrowKey", true, false, $e.charCode, $e.keyCode, $e.keyLocation, $e.ctrlKey, $e.altKey, $e.shiftKey);
        		_keyDispatcher.dispatchEvent(kbe);
            }
        }
        
        private static function onKeyRelease($e:KeyboardEvent):void {
        	if ($e.keyCode == Keyboard.SHIFT || $e.keyCode == Keyboard.CONTROL) {
        		_keyDispatcher.dispatchEvent(new KeyboardEvent("releaseMultiSelectKey"));
        	}
        	delete _keysDown[$e.keyCode];
        }
        
        private static function clearKeys($e:Event):void {
        	_keysDown = {};
        }
        
        private function onPressMultiSelectKey($e:Event=null):void {
        	if (_allowMultiSelect && !_multiSelectMode) {
        		_multiSelectMode = true;
        	}
        }
        
        private function onReleaseMultiSelectKey($e:Event=null):void {
        	if (_multiSelectMode && _allowMultiSelect) {
        		_multiSelectMode = false;
        	}
        }
        
		
//---- STATIC FUNCTIONS -------------------------------------------------------------------------------------------------
		
		private static function setDefault($value:*, $default:*):* {
			if ($value == undefined) {
				return $default;
			} else {
				return $value;
			}
		}
		
		private static function bringToFront($o:DisplayObject):void {
			if ($o.parent != null) {
				$o.parent.setChildIndex($o, $o.parent.numChildren - 1);
			}
		}
		
		public static function positiveAngle($a:Number):Number {
			var revolution:Number = Math.PI * 2;
			return ((($a % revolution) + revolution) % revolution);
		}
		
		public static function acuteAngle($a:Number):Number {
			if ($a != $a % Math.PI) {
				$a = $a % (Math.PI * 2);
				if ($a < -Math.PI) {
					return Math.PI + ($a % Math.PI);
				} else if ($a > Math.PI) {
					return -Math.PI + ($a % Math.PI);
				}
			}
			return $a;
		}
		
		
//---- GETTERS / SETTERS -----------------------------------------------------------------------------------------------------
		
		public function get enabled():Boolean {
			return _enabled;
		}
		public function set enabled($b:Boolean):void { //Gives us a way to enable/disable all TransformItems
			_enabled = $b;
			updateItemProp("enabled", $b);
			if (!$b) {
				swapCursorOut();
				removeParentListeners();
			}
		}
		public function get selectionScaleX():Number {
			return MatrixTools.getScaleX(_dummyBox.transform.matrix);
		}
		public function set selectionScaleX($n:Number):void {
			scaleSelection($n / this.selectionScaleX, 1);
		}
		public function get selectionScaleY():Number {
			return MatrixTools.getScaleY(_dummyBox.transform.matrix);
		}
		public function set selectionScaleY($n:Number):void {
			scaleSelection(1, $n / this.selectionScaleY);
		}
		public function get selectionRotation():Number {
			return _dummyBox.rotation;
		}
		public function set selectionRotation($n:Number):void {
			rotateSelection(($n - this.selectionRotation) * _DEG2RAD);
		}
		public function get selectionX():Number {
			return _dummyBox.x;
		}
		public function set selectionX($n:Number):void {
			_dummyBox.x = $n;
		}
		public function get selectionY():Number {
			return _dummyBox.y;
		}
		public function set selectionY($n:Number):void {
			_dummyBox.y = $n;
		}
		public function get items():Array {
			return _items;
		}
		public function get targetObjects():Array {
			var a:Array = [];
			for (var i:uint = 0; i < _items.length; i++) {
				a.push(_items[i].targetObject);
			}
			return a;
		}
		public function set selectedTargetObjects($a:Array):void {
			selectItems($a, false);
		}
		public function get selectedTargetObjects():Array {
			var a:Array = [];
			for (var i:uint = 0; i < _selectedItems.length; i++) {
				a.push(_selectedItems[i].targetObject);
			}
			return a;
		}
		public function set selectedItems($a:Array):void {
			selectItems($a, false);
		}
		public function get selectedItems():Array {
			return _selectedItems;
		}
		public function set constrainScale($b:Boolean):void {
			_constrainScale = $b;
			updateItemProp("constrainScale", $b);
			calibrateConstraints();
		}
		public function get constrainScale():Boolean {
			return _constrainScale;
		}
		public function set lockScale($b:Boolean):void {
			_lockScale = $b;
			updateItemProp("lockScale", $b);
			calibrateConstraints();
		}
		public function get lockScale():Boolean {
			return _lockScale;
		}
		public function set scaleFromCenter($b:Boolean):void {
			_scaleFromCenter = $b;
		}
		public function get scaleFromCenter():Boolean {
			return _scaleFromCenter;
		}
		public function set lockRotation($b:Boolean):void {
			_lockRotation = $b;
			updateItemProp("lockRotation", $b);
			calibrateConstraints();
		}
		public function get lockRotation():Boolean {
			return _lockRotation;
		}
		public function set lockPosition($b:Boolean):void {
			_lockPosition = $b;
			updateItemProp("lockPosition", $b);
			calibrateConstraints();
		}
		public function get lockPosition():Boolean {
			return _lockPosition;
		}
		public function set allowMultiSelect($b:Boolean):void {
			_allowMultiSelect = $b
			if (!$b) {
				_multiSelectMode = false;
			}
		}
		public function get allowMultiSelect():Boolean {
			return _allowMultiSelect;
		}
		public function set allowDelete($b:Boolean):void {
			_allowDelete = $b;
			updateItemProp("allowDelete", $b);
		}
		public function get allowDelete():Boolean {
			return _allowDelete;
		}
		public function set autoDeselect($b:Boolean):void {
			_autoDeselect = $b;
		}
		public function get autoDeselect():Boolean {
			return _autoDeselect;
		}
		public function set lineColor($n:uint):void {
			_lineColor = $n;
			redrawHandles();
			updateSelection();
		}
		public function get lineColor():uint {
			return _lineColor;
		}
		public function set handleFillColor($n:uint):void {
			_handleColor = $n;
			redrawHandles();
		}
		public function get handleFillColor():uint {
			return _handleColor;
		}
		public function set handleSize($n:Number):void {
			_handleSize = $n;
			redrawHandles();
		}
		public function get handleSize():Number {
			return _handleSize;
		}
		public function set paddingForRotation($n:Number):void {
			_paddingForRotation = $n;
			redrawHandles();
		}
		public function get paddingForRotation():Number {
			return _paddingForRotation;
		}
		public function set bounds($r:Rectangle):void {
			_bounds = $r;
			updateItemProp("bounds", $r);
		}
		public function get bounds():Rectangle {
			return _bounds;
		}
		public function get forceSelectionToFront():Boolean {
			return _forceSelectionToFront;
		}
		public function set forceSelectionToFront($b:Boolean):void {
			_forceSelectionToFront = $b;
		}
		public function set arrowKeysMove($b:Boolean):void {
			_arrowKeysMove = $b;
		}
		public function get arrowKeysMove():Boolean {
			return _arrowKeysMove;
		}
		public function get ignoredObjects():Array {
			return _ignoredObjects.slice();
		}
		public function set ignoredObjects($a:Array):void {
			_ignoredObjects = [];
			for (var i:uint = 0; i < $a.length; i++) {
				if ($a[i] is DisplayObject) {
					_ignoredObjects.push($a[i]);
				} else {
					trace("TRANSFORMMANAGER WARNING: An attempt was made to add " + $a[i] + " to the ignoredObjects Array but it is NOT a DisplayObject, so it was not added.");
				}
			}
		}
	
	}
	
}