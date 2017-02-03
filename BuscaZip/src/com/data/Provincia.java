package com.data;

public class Provincia {

	private int id, reg, pre;
	private String nm, cap;

	public Provincia(){ }
	
	public Provincia(int id, int region, String nombre, String capital, int prefijo){
		this.id 			= id;
		this.reg	 		= region;
		this.nm 			= nombre;
		this.cap 			= capital;
		this.pre 			= prefijo;
	}
//GETTER	
	public int ID(){
		return this.id;
	}
	
	public int regionID(){
		return this.reg;
	}
	
	public String nombre(){
		return this.nm;
	}

	public String capital(){
		return this.cap;
	}
	
	public int prefijo(){
		return this.pre;
	}

//SETTER
	public void ID(int ID){
		this.id				= ID;
		return;
	}
	
	public void regionID(int ID){
		this.reg			= ID;
		return;
	}
	
	public void nombre(String nm){
		this.nm				= nm;
		return;
	}

	public void capital(String cap){
		this.cap 			= cap;
		return;
	}
	
	public void prefijo(int pre){
		this.pre			= pre;
		return;
	}	

	@Override
	public String toString(){
		return nombre().toUpperCase();
	}
	
}