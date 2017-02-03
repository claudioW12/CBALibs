import	com.greensock.*;
import	com.greensock.easing.*;
#include "fload.as"
#include "dload.as"
#include "arrload.as"
#include "pathload.as"
#include "nload.as"
#include "mload.as"
#include "mathload.as"
#include "movieload.as"
#include "sload.as"
#include "kload.as"
#include "cload.as"
#include "scload.as"
#include "filter.as"

if(xml){
	XML.prototype.ignoreWhite 	= true;	
}else{
	XML.prototype.ignoreWhite 	= false;	
}

if(txt){
	System.useCodepage	= true;
}else{
	System.useCodepage	= false;
}

if(!roota){
	var roota:String	= "";
}

var thispath:String		= roota+getrealpath(this);

this.stop();

var back				= background;
if(back){
	back.enabled		= false;
}

var abc:Array 			= new Array("a","b","c","d","e","f","g","h","i","j","k","l","m","n","ñ","o","p","q","r","s","t","u","v","w","x","y","z");


var colourhex:Array		= new Array();
colourhex				= createcolour(colorlist);

