
if(!rootclip){
	var rootclip:MovieClip = _root;
}

var menu:ContextMenu 		= new ContextMenu();
menu.hideBuiltInItems();

var arreglolinks:Array 		= linksgoto.split(":_:");
var totallinks:Number  		= arreglolinks.length;
var vinculo:Array			= new Array();

init();

function init():Void{
	var i:Number = 0;
	for(i=0;i<totallinks;i++){
		var tmp:Array					= arreglolinks[i].split("::");
		var elemento:ContextMenuItem 	= new ContextMenuItem(tmp[1], gotandget, true, true)
		elemento.separatorBefore		= false;
		elemento.onSelect = function(obj:Object, item:ContextMenuItem):Void{
			var caption:String	= item.caption;
			gotandget(caption);
		}
		menu.customItems.push(elemento);
	}
	rootclip.menu = menu;
}

function gotandget(a:String):Void{
	var i:Number = 0;
	for(i=0;i<totallinks;i++){
		var tmp:Array	= arreglolinks[i].split("::");
		if(a==tmp[1]){
			if(tmp[0]){
				getURL(tmp[0],"_blank");
			}
		}
	}
}
