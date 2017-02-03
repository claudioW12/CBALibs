package com.data;

public class Comuna {
	
	private int id, pro;
	private String nm, code;

	public Comuna(){ }
	
	public Comuna(int id, int provincia, String nombre, String code){
		this.id 			= id;
		this.pro	 		= provincia;
		this.nm 			= nombre;
		this.code 			= code;
	}
//GETTER
	public int ID(){
		return this.id;
	}
	
	public int provinciaID(){
		return this.pro;
	}
	
	public String nombre(){
		return this.nm;
	}
	
	public String ZIP(){
		return this.code;
	}
	
//SETTER	
	public void ID(int ID){
		this.id 			= ID;
		return;
	}
	
	public void provinciaID(int ID){
		this.pro 			= ID;
		return;
	}
	
	public void nombre(String nm){
		this.nm				= nm;
		return;
	}
	
	public void ZIP(String ZIP){
		this.code			= ZIP;
	}
	
	@Override
	public String toString(){
		return ZIP()+" : "+nombre();
	}
	
}