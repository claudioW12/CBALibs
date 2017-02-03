
function isnotcero(a:Number):Boolean{
	var r:Boolean	= false
	if(a!=0){
		r=true;
	}
	return r;
}

function absolute(a:Number):Number{
	var dis:Number = a
	if(a<0){
		dis = invertsigned(a);
	}
	return dis;	
}

function invertsigned(a:Number):Number{
	var dis:Number = a
	dis	= a * -1;
	return dis;	
}
