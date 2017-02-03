function hsearch(a:MovieClip, b:String, c:String, d:Boolean):MovieClip {
	var curclip:MovieClip 		= a;
	var valuereturn:MovieClip	= new MovieClip();
	if (d) {
		while (curclip != undefined && curclip != _root) {
			if (curclip[b] == c) {
				valuereturn	= curclip;
			}
			curclip = curclip._parent;
		}
	} else {
		while (curclip != undefined && curclip != _root) {
			if (curclip[b] == c) {
				valuereturn	= curclip;
			}
			curclip = curclip._parent;
		}
	}
	return valuereturn;
}

function getdropper(a:MovieClip):MovieClip{
	return eval(a._droptarget);
}

function qload(a:MovieClip, b:String, c:Number, d):Array {
	var arrayclips:Array 	= new Array();
	var i:Number			= 0;
	var t:Number 			= arrayclips.length;
	for (i = 0; i<c; i++) {
		var currn:Number 	= getmaxdepth(a);
		var clip:MovieClip	= a.attachMovie(b, b+currn, currn);
		clip.selfindex 		= currn;
		clip.master 		= a;
		clip.disabled		= false;
		clip.frames			= false;
		clip.selfwidth		= clip._width;
		clip.selfheight		= clip._height;
		clip.onEnterFrame	= function():Void{
			exactfit(this);
		}
		arrayclips.push(clip);
		}
	return arrayclips;
}

function exactfit(a:MovieClip):Void{
	var clip:MovieClip 	= a;
	clip.selfwidth		= int(clip._width);
	clip.selfheight		= int(clip._height);
	clip.onEnterFrame	= null;
}

MovieClip.prototype.xalign = function(a:MovieClip, b:String, c:Number, d:Boolean, e:Function, f:Boolean, g:Boolean):Void{
	xalign(a, this, b, c, d, e, f, g);
}

function xalign(a:MovieClip, b:MovieClip, c:String, d:Number, e:Boolean, f:Function, g:Boolean, h:Boolean ):Void{
	var xmode:Array = xsplit("/", c);
	if(h){
		halign(a, b, xmode[1], d, e, f, g, !h);
		valign(a, b, xmode[0], d, e, f, g, h);
	}else{
		valign(a, b, xmode[0], d, e, f, g, h);
		halign(a, b, xmode[1], d, e, f, g, h);
	}
}

Array.prototype.moreleft = function():MovieClip {
	return moreleft(this);
}

Array.prototype.moreright = function():MovieClip {
	return moreright(this);
}

Array.prototype.moretop = function():MovieClip {
	return moretop(this);
}

Array.prototype.morebottom = function():MovieClip {
	return morebottom(this);
}

function moreleft(clips:Array):MovieClip {
	var more:MovieClip 		= clips[0];
	var blast:Object 		= more.getBounds(_root);
	var i:Number			= 0;
	var t:Number 			= clips.length;
	for (i=1; i<t; i++) {
		var clast:Object 	= clips[i].getBounds(_root);
		if (clast.xMin<blast.xMin) {
			more 			= clips[i];
			blast 			= more.getBounds(_root);
		}
	}
	return more;
}

function moreright(clips:Array):MovieClip{
	var more:MovieClip 		= clips[0];
	var blast:Object 		= more.getBounds(_root);
	var i:Number			= 0;
	var t:Number			= clips.length;
	for (i=1; i<t; i++) {
		var clast:Object 	= clips[i].getBounds(_root);
		if (clast.xMax>blast.xMax) {
			more 			= clips[i];
			blast			= more.getBounds(_root);
		}
	}
	return more;
}

function moretop(clips:Array):MovieClip {
	var more:MovieClip 		= clips[0];
	var blast:Object 		= more.getBounds(_root);
	var i:Number			= 0;
	var t:Number 			= clips.length;
	for (i = 1; i<t; i++) {
		var clast:Object 	= clips[i].getBounds(_root);
		if (clast.yMin<blast.yMin) {
			more 			= clips[i];
			blast 			= more.getBounds(_root);
		}
	}
	return more;
}

function morebottom(clips:Array):MovieClip {
	var more:MovieClip 		= clips[0];
	var blast:Object 		= more.getBounds(_root);
	var i:Number			= 0;
	var t:Number 			= clips.length;
	for (i = 1; i<t; i++) {
		var clast:Object 	= clips[i].getBounds(_root);
		if (clast.yMax>blast.yMax) {
			more 			= clips[i];
			blast 			= more.getBounds(_root);
		}
	}
	return more;
}

MovieClip.prototype.pixeltop = function():Number {
	return pixeltop(this);
}

MovieClip.prototype.pixelbottom = function():Number {
	return pixelbottom(this);
}

MovieClip.prototype.pixelleft = function():Number {
	return pixelleft(this);
}

MovieClip.prototype.pixelright = function():Number {
	return pixelright(this);
}

function pixeltop(a:MovieClip, b:MovieClip):Number {
	b = defvalun(b, _root);
	return a.getBounds(b).yMin;
}

function pixelbottom(a:MovieClip, b:MovieClip):Number {
	b = defvalun(b, _root);
	return a.getBounds(b).yMax;
}

function pixelleft(a:MovieClip, b:MovieClip):Number {
	b = defvalun(b, _root);
	return a.getBounds(b).xMin;
}

function pixelright(a:MovieClip, b:MovieClip):Number {
	b = defvalun(b, _root);
	return a.getBounds(b).xMax;
}

Array.prototype.aralign = function(a:MovieClip, b:String):Void {
	aralign(a, this, b);
}

function aralign(aclip:MovieClip, xclips:Array, b:String):Void {
	var t:Number 	= xclips.length;
	if (t) {
		var clips:Array 		= xclips.copy();
		var top:MovieClip 		= moretop(clips);
		var bottom:MovieClip 	= morebottom(clips);
		var left:MovieClip 		= moreleft(clips);
		var right:MovieClip 	= moreright(clips);
		var ar_x:Number			= 0;
		var ar_y:Number			= 0;
		var px:Number 			= rcx(aclip);
		var py:Number 			= rcy(aclip);
		var i:Number			= 0;
		var t:Number			= clips.length;
		switch (b) {
			case "tc" :
				ar_x = (rcx(left)+rcx(right))/2;
				ar_y = top.rcy()-(aclip.pixeltop()+(top._height/2));
				for (i = 0; i<t; i++) {
					clips[i]._x += px-ar_x;
					clips[i]._y -= ar_y;
				}
			break;
			case "bc" :
				ar_x = (rcx(left)+rcx(right))/2;
				ar_y = bottom.rcy()-(aclip.pixelbottom()-(bottom._height/2));
				for (i = 0; i<t; i++) {
					clips[i]._x += px-ar_x;
					clips[i]._y -= ar_y;
				}
			break;
			case "cl" :
				ar_x = left.rcx()-(aclip.pixelleft()+(left._width/2));
				ar_y = (rcy(top)+rcy(bottom))/2;
				for (i = 0; i<t; i++) {
					clips[i]._x -= ar_x;
					clips[i]._y += py-ar_y;
				}
			break;
			case "cr" :
				ar_x = right.rcx()-(aclip.pixelright()-(right._width/2));
				ar_y = (rcy(top)+rcy(bottom))/2;
				for (i = 0; i<t; i++) {
					clips[i]._x -= ar_x;
					clips[i]._y += py-ar_y;
				}
			break;
			case "tl" :
				ar_x = left.rcx()-(aclip.pixelleft()+(left._width/2));
				ar_y = top.rcy()-(aclip.pixeltop()+(top._height/2));
				for (i = 0; i<t; i++) {
					clips[i]._x -= ar_x;
					clips[i]._y -= ar_y;
				}
			break;
			case "tr" :
				ar_x = right.rcx()-(aclip.pixelright()-(right._width/2));
				ar_y = top.rcy()-(aclip.pixeltop()+(top._height/2));
				for (i = 0; i<t; i++) {
					clips[i]._x -= ar_x;
					clips[i]._y -= ar_y;
				}
			break;
			case "bl" :
				ar_x = left.rcx()-(aclip.pixelleft()+(left._width/2));
				ar_y = bottom.rcy()-(aclip.pixelbottom()-(bottom._height/2));
				for (i = 0; i<t; i++) {
					clips[i]._x -= ar_x;
					clips[i]._y -= ar_y;
				}
			break;
			case "br" :
				ar_x = right.rcx()-(aclip.pixelright()-(right._width/2));
				ar_y = bottom.rcy()-(aclip.pixelbottom()-(bottom._height/2));
				for (i = 0; i<t; i++) {
					clips[i]._x -= ar_x;
					clips[i]._y -= ar_y;
				}
			break;
			default :
				ar_x = (rcx(left)+rcx(right))/2;
				ar_y = (rcy(top)+rcy(bottom))/2;
				for (i = 0; i<t; i++) {
					clips[i]._x += px-ar_x;
					clips[i]._y += py-ar_y;
				}
			break;	
		}
	}
}

MovieClip.prototype.valign = function(a:MovieClip, b:String, c:Number, d:Boolean, e:Function, f:Boolean, g:Boolean):Void {
	valign(a, this, b, c, d, e, f, g);
}

function valign(aclip:MovieClip, child:MovieClip, b:String, d:Number, e:Boolean, f:Function, g:Boolean, h:Boolean):Void {
	var pbounds:Object 	= aclip.getBounds(_root);
	var cbounds:Object 	= child.getBounds(_root);
	var origen:Number 	= child._y;
	
	switch (b) {
		case "bottom" :
			runtoaxis(child, child._y, (child._y+(pbounds.yMax-cbounds.yMax)), "_y", d, e, f, g, h)
		break;
		case "bedge" :
			runtoaxis(child, child._y, (child._y+(pbounds.yMax-child.vcenter())), "_y", d, e, f, g, h)
		break;
		case "bout" :
			runtoaxis(child, (child._y + pbounds.yMax-cbounds.yMin), (child._y + pbounds.yMax-cbounds.yMin), "_y", d, e, f, g, h)
		break;
		case "top" :
			runtoaxis(child, child._y, (child._y+(pbounds.yMin-cbounds.yMin)), "_y", d, e, f, g, h)
		break;
		case "tedge" :
			runtoaxis(child, child._y, (child._y+(pbounds.yMin-child.vcenter())), "_y", d, e, f, g, h)
		break;
		case "tout" :
			runtoaxis(child, child._y, (child._y+(pbounds.yMin-cbounds.yMax)), "_y", d, e, f, g, h)
		break;
		default :
			runtoaxis(child, child._y, (child._y+(aclip.rcy()-child.rcy())), "_y", d, e, f, g, h)
		break;	
	}
}

MovieClip.prototype.halign = function(a:MovieClip, b:String, c:Number, d:Boolean, e:Function, f:Boolean, g:Boolean):Void {
	halign(a, this, b, c, d, e, f, g);
}

function halign(aclip:MovieClip, child:MovieClip, b:String, d:Number, e:Boolean, f:Function, g:Boolean, h:Boolean):Void {
	var pbounds:Object = aclip.getBounds(_root);
	var cbounds:Object = child.getBounds(_root);
	switch (b) {
		case "right" :
			runtoaxis(child, child._x, (child._x+(pbounds.xMax-cbounds.xMax)), "_x", d, e, f, g, h)
		break;
		case "redge" :
			runtoaxis(child, child._x, (child._x+(pbounds.xMax-child.hcenter())), "_x", d, e, f, g, h)
		break;
		case "rout" :
			runtoaxis(child, child._x, (child._x+(pbounds.xMax-cbounds.xMax+child._width)), "_x", d, e, f, g, h)
		break;
		case "left" :
			runtoaxis(child, child._x, (child._x+(pbounds.xMin-cbounds.xMin)), "_x", d, e, f, g, h)
		break;
		case "ledge" :
			runtoaxis(child, child._x, (child._x+(pbounds.xMin-child.hcenter())), "_x", d, e, f, g, h)
		break;
		case "lout" :
			runtoaxis(child, child._x, (child._x+(pbounds.xMin-cbounds.xMin-child._width)), "_x", d, e, f, g, h)
		break;
		default :
			runtoaxis(child, child._x, (child._x+(aclip.rcx()-child.rcx())), "_x", d, e, f, g, h)
		break;
	}
}

MovieClip.prototype.rcx = function():Number {
	return rcx(this);
}

function rcx(clip:MovieClip):Number {
	var bounds:Object = clip.getBounds(_root);
	return (bounds.xMin+bounds.xMax)/2;
}

MovieClip.prototype.rcy = function():Number {
	return rcy(this);
}

function rcy(clip:MovieClip):Number {
	var bounds:Object = clip.getBounds(_root);
	return (bounds.yMin+bounds.yMax)/2;
}

Array.prototype.arraymoveby = function(a:Number, b:Number, c:Number, d:Boolean, e:Function, f:Boolean, g:Boolean):Void {
	arraymoveby(this, a, b, c, d, e, f, g);
}

function arraymoveby(clips:Array, dx:Number, dy:Number, c:Number, d:Boolean, e:Function, f:Boolean, g:Boolean):Void {
	var i:Number	= 0;
	var t:Number	= clips.length;
	for (i = 0; i<t; i++) {
		if(g){
			runtoaxis(clips[i], clips[i]._x, (clips[i]._x+dx), "_x", c, d, e, f, !g)
			runtoaxis(clips[i], clips[i]._y, (clips[i]._y+dy), "_y", c, d, e, f, g)
		}else{
			runtoaxis(clips[i], clips[i]._x, (clips[i]._x+dx), "_x", c, d, e, f, g)
			runtoaxis(clips[i], clips[i]._y, (clips[i]._y+dy), "_y", c, d, e, f, g)
		}
	}
}

MovieClip.prototype.vcenter = function():Number {
	return vcenter(this);
}

function vcenter(clip:MovieClip):Number {
	return (clip.pixeltop()+clip.pixelbottom())/2;
}

MovieClip.prototype.hcenter = function():Number {
	return hcenter(this);
}

function hcenter(clip:MovieClip):Number {
	return (clip.pixelleft()+clip.pixelright())/2;
}

Array.prototype.concarray = function(a:String, b:String, c:Number, d:Number, e:Number, f:Boolean, g:Function, h:Boolean, i:Boolean):Void{
	concarray(this, a, b, c, d, e, f, g, h, i);
}
function concarray(a:Array, b:String, c:String, d:Number, e:Number, f:Number, g:Boolean, h:Function, i:Boolean, j:Boolean):Void{
	var qx:Number 	= 0;
	var qy:Number 	= 0;
	var z:Number 	= 0;
	var t:Number 	= a.length;
	if (d) {
		qx = d;
	}
	if (e) {
		qy = e;
	}
	for (z=0; z<t-1; z++) {
		if(j){
			halign(a[z], a[z+1], b, f, g, h, i, !j);
			valign(a[z], a[z+1], c, f, g, h, i, j);
		}else{
			halign(a[z], a[z+1], b, f, g, h, i, j);
			valign(a[z], a[z+1], c, f, g, h, i, j);
		}
		a[z+1]._x += qx;
		a[z+1]._y += qy;
	}
}

function qalign(a:MovieClip, b:MovieClip, c:String, d:Number, e:Boolean, f:Function, g:Boolean, h:Boolean):Void {
	var modes:Array 	= xsplit(",", c);
	var i:Number		= 0;
		var pos:Number = dalign(a, b, modes[0]);
		switch (modes[1]) {
			case "top" :
				runtoaxis(b, b._y, (b._y+pos), "_y", d, e, f, g, h)
			break;
			case "bottom" :
				runtoaxis(b, b._y, (b._y+pos), "_y", d, e, f, g, h)
			break;
			case "left" :
				runtoaxis(b, b._x, (b._x+pos), "_x", d, e, f, g, h)
			break;
			case "right" :
				runtoaxis(b, b._x, (b._x+pos), "_x", d, e, f, g, h)
			break;
			case "hcenter" :
				runtoaxis(b, b._x, (b._x+pos), "_x", d, e, f, g, h)
			break;
			case "vcenter" :
				runtoaxis(b, b._y, (b._y+pos), "_y", d, e, f, g, h)
			break;
			case "tout" :
				runtoaxis(b, b._y, (b._y+pos), "_y", d, e, f, g, h)
			break;
			case "tedge" :
				runtoaxis(b, b._y, (b._y+pos), "_y", d, e, f, g, h)
			break;
			case "bout" :
				runtoaxis(b, b._y, (b._y+pos), "_y", d, e, f, g, h)
			break;
			case "bedge" :
				runtoaxis(b, b._y, (b._y+pos), "_y", d, e, f, g, h)
			break;
			case "rout" :
				runtoaxis(b, b._x, (b._x+pos), "_x", d, e, f, g, h)
			break;
			case "redge" :
				runtoaxis(b, b._x, (b._x+pos), "_x", d, e, f, g, h)
			break;
			case "lout" :
				runtoaxis(b, b._x, (b._x+pos), "_x", d, e, f, g, h)
			break;
			case "ledge" :
				runtoaxis(b, b._x, (b._x+pos), "_x", d, e, f, g, h)
			break;
			default :
				trace("Unkown");
			break;
		}
}

function dalign(a:MovieClip, b:MovieClip, c:String):Number{
	switch (c) {
		case "top" :
			return pixeltop(a)-pixeltop(b);
		break;
		case "bottom" :
			return pixelbottom(a)-pixelbottom(b);
		break;
		case "left" :
			return pixelleft(a)-pixelleft(b);
		break;
		case "right" :
			return pixelright(a)-pixelright(b);
		break;
		case "hcenter" :
		return rcx(a)-rcx(b);
		break;
		case "vcenter" :
			return rcy(a)-rcy(b);
		break;
		case "tout" :
			return pixeltop(a)-pixelbottom(b);
		break;
		case "tedge" :
			return pixeltop(a)-rcy(b);
		break;
		case "bout" :
			return pixelbottom(a)-pixeltop(b);
		break;
		case "bedge" :
			return pixelbottom(a)-rcy(b);
		break;
		case "rout" :
			return pixelright(a)-pixelleft(b);
		break;
		case "redge" :
			return pixelright(a)-rcx(b);
		break;
		case "lout" :
			return pixelleft(a)-pixelright(b);
		break;
		case "ledge" :
			return pixelleft(a)-rcx(b);
		break;
		default :
			trace("Unknown");
		break;
	}
}

function aligntostage(clip:MovieClip, alignment:String, ww:Number, hh:Number, c:Number, d:Boolean, e:Function, f:Boolean, g:Boolean):Void {
	var modes:Array 		= xsplit("/", alignment);
	var xheight:Number 		= Stage.height;
	var xwidth:Number		= Stage.width;
	if (ww && hh) {
		xheight = hh;
		xwidth = ww;
	} 
	switch (modes[0]) {
		case "top" :
			runtoaxis(clip, clip._y, (clip._y+(0-clip.pixeltop())), "_y", c, d, e, f, g)
		break;
		case "bottom" :
			runtoaxis(clip, clip._y, (clip._y+(xheight-clip.pixelbottom())), "_y", c, d, e, f, g)
		break;
		default :
			runtoaxis(clip, clip._y, (clip._y+((xheight/2)-rcy(clip))), "_y", c, d, e, f, g)
		break;
	}
	switch (modes[1]) {
		case "left" :
			runtoaxis(clip, clip._x, (clip._x+(0-clip.pixelleft())), "_x", c, d, e, f, g)
		break;
		case "right" :
			runtoaxis(clip, clip._x, (clip._x+(xwidth-clip.pixelright())), "_x", c, d, e, f, g)
		break;
		default :
			runtoaxis(clip, clip._x, (clip._x+((xwidth/2)-clip.rcx())), "_x", c, d, e, f, g)
		break;
	}
}

function alignxclips(a:MovieClip, b:MovieClip, c:Number, d:Boolean, e:Function, f:Boolean, g:Boolean):Void{
	if(g){
		alignxclipy(a, b, c, d, e, f, g);
		alignxclipx(a, b, c, d, e, f, !g);
	}else{
		alignxclipy(a, b, c, d, e, f, g);
		alignxclipx(a, b, c, d, e, f, g);
	}
}

function alignxclipx(a:MovieClip, b:MovieClip, frames:Number, unit:Boolean, type:Function, d:Boolean, e:Boolean):Void{
	a.enabled			= false;
	TweenMax.fromTo(a, frames,{_x:a._x}, {_x:b._x, ease:type.easeInOut, onComplete:onmotionfinished, onCompleteParams:[a,d,e], onUpdate:onmotionchanged, onUpdateParams:[a]});
}

function alignxclipy(a:MovieClip, b:MovieClip, frames:Number, unit:Boolean, type:Function, d:Boolean, e:Boolean):Void{
	a.enabled			= false;
	TweenMax.fromTo(a, frames,{_y:a._y}, {_y:b._y, ease:type.easeInOut, onComplete:onmotionfinished, onCompleteParams:[a,d,e], onUpdate:onmotionchanged, onUpdateParams:[a]});
}

function runtoaxis(a:MovieClip, b:Number, c:Number, d:String, e:Number, f:Boolean, g:Function, h:Boolean, i:Boolean):Void{
	var tmpfps:Boolean	= false;
	if(!f){
		tmpfps			= !f; 
	}
	a.enabled			= false;
	if(d=="_x"){
		TweenMax.fromTo(a, e,{_x:b}, {_x:c, ease:g.easeInOut, onComplete:onmotionfinished, onCompleteParams:[a,h,i], onUpdate:onmotionchanged, onUpdateParams:[a], useFrames:tmpfps});
	}else{
		TweenMax.fromTo(a, e,{_y:b}, {_y:c, ease:g.easeInOut, onComplete:onmotionfinished, onCompleteParams:[a,h,i], onUpdate:onmotionchanged, onUpdateParams:[a], useFrames:tmpfps});
	}
}

function changecolor(a:MovieClip, b:Object, c:Number, d:Function):Void{
	TweenMax.to(a, c, {tint:b, ease:d.easeInOut});
}

function removexclips(a:Array):Array{
	var i:Number 	= 0;
	var t:Number	= a.length;
	for(i=0;i<t;i++){
		if(a[i]){
			removeclip(a[i]);
		}
	}
	return newarray(a);
}		

function removeclip(a:MovieClip):Void{
	a.removeMovieClip();
}

function desalphaxclips(a:Array, b:Number):Void{
	var i:Number	= 0;
	var t:Number 	= a.length;
	for(i=0;i<t;i++){
		desalpha(a[i], b);
	}
}

function desalpha(a:MovieClip, b:Number):Void{
	a._alpha		= b;
}

function dispelxclips(a:Array, b:Number, c:Number, d:Number, e:Boolean):Void{
	var tmpfps:Boolean	= false;
	if(!e){
		tmpfps			= !e; 
	}
	var i:Number 		= 0; 
	var t:Number 		= a.length;
	for(i=0; i<t; i++){
		dispel(a[i], b, c, d, e);			
	}
}		

function dispel(a:MovieClip, b:Number, c:Number, d:Number, e:Boolean):Void{
	var tmpfps:Boolean	= false;
	if(!e){
		tmpfps			= !e; 
	}
	TweenMax.fromTo(a, d, {_alpha:b}, {_alpha:c, ease:None.easeInOut, useFrames:tmpfps});
}		

function lighting(a:MovieClip, b:Array, c:Number, d:Number, e:Number, f:Boolean):Void{
	var i:Number		= 0;
	var t:Number 		= b.length;
	var current:Number 	= 0;
	for(i=0;i<t;i++){
		current			= b[i]._alpha;
		TweenMax.fromTo(b[i], e, {_alpha:current}, {_alpha:c, ease:None.easeInOut});
	}
	current	= a._alpha;
	TweenMax.fromTo(a, e,{_alpha:current}, {_alpha:d, ease:None.easeInOut});
}

function getmaxdepth(a:MovieClip):Number{
	var depth:Number = a.getNextHighestDepth();
	return depth;
}

function bringtofrontxclips(a:Array):Void{
	var i:Number 		= 0;
	var t:Number 		= a.length;
	for(i=0; i<t; i++){
		bringtofront(a[i]);
	}
}	

function bringtofront(a:MovieClip):Void{
	var pt:MovieClip	= a._parent;
	changedepth(a, getmaxdepth(pt))
}

function changedepth(a:MovieClip, b:Number):Void{
	a.swapDepths(b);
}

function thisvisible(a:MovieClip, b:Boolean):Void{
	a._visible	= b;
}

function createcolour(a:Array):Array{
	var tmp:Array		= new Array();
	var i:Number		= 0;
	var t:Number 		= a.length;
	for(i=0; i<t; i++){
		if(i%2==0){
			var	obj:Object	= new Object(); 
			obj.ncolor	= a[i];
			obj.hcolor	= a[i+1];
			tmp.push(obj);
		}
	}
	return tmp;
}

function alinea(a:Array, b:Number, c:Number, d:Number, e:Array, f:Number, g:Boolean, h:Function, ii:Boolean):Void{
	var i:Number	= 0;
	var t:Number	= a.length;
	var pos:Number	= 0;
	var posx:Array	= new Array();
	for(i=0; i<t; i++){
		posx.push(pos);
		var n:Number= a[i]._width+d;
		pos+=n;
	}
	var max:Number 	= posx[posx.length-1];
	var dif:Number 	= (b-max)/2;
	for(i=0; i<t; i++){
		var randomn:Number 	= e[i];
		var addy:Number 	= c;
		var addx:Number 	= dif+posx[randomn];
		runtoaxis(a[i], a[i]._y, addy, "_y", f, g, h, ii, false);
		runtoaxis(a[i], a[i]._x, addx, "_x", f, g, h, ii, false);
		var obj:MovieClip	= new MovieClip();
		obj._x				= addx;
		obj._y				= addy;
		a[i].initposition	= obj;
		obj.removeMovieClip();
	}
}

function desalinea(a:Array, b:Number, c:Number, d:Number, e:Array, f:Number, g:Number, h:Boolean, ii:Function, jj:Boolean, kk:Boolean):Void{
	var i:Number		= 0;
	var t:Number		= a.length;
	var pos:Number		= 0;
	var per:Number 		= f;
	var coun:Number 	= 0;
	var tmp:Array		= new Array();
	var j:Number 		= 0;
	for(i=0; i<t; i++){
		var n:Number= int(a[i]._width+d);
		pos+=n;
		a[i].fill		= abc[coun];
		if(pos<per){
			a[i].fill	= abc[coun];
		}else{
			coun++;
			a[i].fill	= abc[coun];
			pos			= 0;
		}
	}
	coun				= 0;
	for(j=0; j<t; j++){
		var tmp2:Array		= new Array();
		for(i=0; i<t; i++){
			if(a[i].fill==abc[j]){
				tmp2.push(a[i]);
			}
		}
		if(tmp2.length>0){
			tmp[coun]= tmp2;
			coun++
		}
	}
	for(i=0; i<tmp.length; i++){
		var cantidad:Number		= tmp[i].length;
		if(jj){
			var alter:Array			= shufflearray(cantidad, alter);
		}else{
			var alter:Array			= noshufflearray(cantidad, alter);
		}
			alinea(tmp[i], b, e[i], d, alter, g, h, ii, kk);
	}
}		

function onmotionfinished(a:MovieClip, b:Boolean, c:Boolean):Void{
	motionfinished(a, b, c);
}

function onmotionchanged(a:MovieClip):Void{
	motionchanged(a);
}

