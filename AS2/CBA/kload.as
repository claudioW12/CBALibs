
function setkey(a:Object, b:Function):Object{
	var keypressed:Object	= new Object();
	Key.removeListener(keypressed);
	keypressed.onKeyDown = function() {
		var pressed:Number	= Key.getCode();
		b(Key);
	} 
	Key.addListener(keypressed);
	return keypressed;
}

