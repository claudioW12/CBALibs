import flash.filters.BlurFilter;
import flash.filters.DropShadowFilter;

function blurfilter(a, b:Number, c:Number):Void{
	var filter:BlurFilter = new BlurFilter(0, 0, 3);
	var filterArray:Array = new Array();
	filter.blurX = b;
	filter.blurY = c;
	filterArray.push(filter);
	a.filters = filterArray;
}

function shadowfilter(a, b:Number, c:Number):Void{
	var distance:Number = b;
	var angle:Number 	= c;
	var color:Number 	= 0x0FF000;
	var alpha:Number 	= 80;
	var blurX:Number 	= 2;
	var blurY:Number 	= 2;
	var strength:Number = 5;
	var quality:Number 	= 50;
	var filter:DropShadowFilter = new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality );
	clip.filters = [ filter ]; 
}