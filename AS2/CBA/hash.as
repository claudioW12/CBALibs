
function mkhash(initvals) {
	return new Hash(initvals);
}

function Hash(initvals, size) {
	this.xlist = [];
	this.size = size;
	this.finite = 1;
	this.requestedIndex = null;
	if (size == undefined) {
		this.finite = 0;
		this.size = 1;
	}
	var len=initvals.length;
	for (var i = 0; i<len; i += 2) {
		this.ap(initvals[i], initvals[i+1]);
	}
}

Hash.prototype.ap = function(kk, vv) {
	if (this.exists(kk)) {
		this.xlist[this.existsIndex][1] = vv;
	} else {
		this.xlist.push([kk, vv]);
	}
	if (this.xlist.length*this.finite>this.size) {
		return this.xlist.shift();
	}
};

Hash.prototype.del = function(xkey) {
	if (this.exists(xkey)) {
		this.xlist.splice(this.existsIndex, 1);
		return true;
	}
	return null;
};

Hash.prototype.keys = function() {
	var xkeys = [];
	for (var i = 0; i<this.xlist.length; i++) {
		xkeys.push(this.xlist[i][0]);
	}
	return xkeys;
};

Hash.prototype.values = function() {
	var values = [];
	for (var i = 0; i<this.xlist.length; i++) {
		values.push(this.xlist[i][1]);
	}
	return values;
};

Hash.prototype.exists = function(xkey) {
	this.existsIndex = undefined;
	for (var i = 0; i<this.xlist.length; i++) {
		if (this.xlist[i][0] == xkey) {
			this.existsIndex = i;
			return true;
		}
	}
	return false;
};

Hash.prototype.getIt = function() {
	return this.xlist[this.existsIndex][1];
};

Hash.prototype.getThekey = function() {
	return this.xlist[this.existsIndex][0];
};

Hash.prototype.getTheval = function() {
	return this.xlist[this.existsIndex][1];
};

Hash.prototype.exists_bs = function(xkey, insensi) {
	this.existsIndex = undefined;
	if (insensi) {
		for (var i = 0; i<this.xlist.length; i++) {
			if (lc(this.xlist[i][0]) eq lc(xkey)) {
				this.existsIndex = i;
				return true;
			}
		}
	} else {
		for (var i = 0; i<this.xlist.length; i++) {
			if (this.xlist[i][0] eq xkey) {
				this.existsIndex = i;
				return true;
			}
		}
	}
	return false;
};

Hash.prototype.value = function(xkey) {
	for (var i = 0; i<this.xlist.length; i++) {
		if (this.xlist[i][0] == xkey) {
			this.requestedIndex = i;
			return this.xlist[i][1];
		}
	}
	return undefined;
};

Hash.prototype.value_bs = function(xkey, insensi) {
	if (insensi) {
		for (var i = 0; i<this.xlist.length; i++) {
			if (lc(this.xlist[i][0]) eq lc(xkey)) {
				this.requestedIndex = i;
				return this.xlist[i][1];
			}
		}
	} else {
		for (var i = 0; i<this.xlist.length; i++) {
			if (this.xlist[i][0] eq xkey) {
				this.requestedIndex = i;
				return this.xlist[i][1];
			}
		}
	}
	return undefined;
};

Hash.prototype.value_bv = function(xkey) {
	for (var i = 0; i<this.xlist.length; i++) {
		if (this.xlist[i][0] == xkey) {
			this.requestedIndex = i;
			return this.xlist[i][1];
		}
	}
	return undefined;
};

Hash.prototype.count = function() {
	return this.xlist.length;
};

Hash.prototype.toarray = function() {
	var nar = [];
	for (var i = 0; i<this.xlist.length; i++) {
		nar.push(this.xlist[i][0]);
		nar.push(this.xlist[i][1]);
	}
	return nar;
};

Hash.prototype.shift = function() {
	var kv = new KeyVal(this.xlist[0][0], this.xlist[0][1]);
	this.xlist.shift();
	return kv;
};

Hash.prototype.pop = function() {
	var kv = new KeyVal(this.xlist[this.xlist.length-1][0], this.xlist[this.xlist.length-1][1]);
	this.xlist.pop();
	return kv;
};

function KeyVal(kk, vv) {
	this.key = kk;
	this.value = vv;
}


function eformat(str, sep1, sep2) {
	var ar = [];
	var meta = xsplit(sep1, str);
	for (var i = 0; i<meta.length; i++) {
		var pairs = xsplit(sep2, meta[i]);
		if (pairs.length<2) {
			pairs.push("");
		}
		ar = ar.concat(pairs);
	}
	return ar;
}
