package com.data;

public class Region {
	private int id;
	private String ode, nm, cap;
	
	public Region(){ }
	
	public Region(int id, String odeplan, String nombre, String capital){
		this.id 			= id;
		this.ode	 		= odeplan;
		this.nm		 		= nombre;
		this.cap	 		= capital;
	}
//GETTER
	public int ID(){
		return this.id;
	}
	
	public String odeplan(){
		return this.ode;
	}
	
	public String nombre(){
		return this.nm;
	}

	public String capital(){
		return this.cap;
	}
//SETTER	
	public void ID(int id){
		this.id 			= id;
		return;
	}
	
	public void odeplan(String ode){
		this.ode			= ode;
		return;
	}
	
	public void nombre(String nm){
		this.nm 			= nm;
		return;
	}

	public void capital(String cap){
		this.cap 			= cap;
		return;
	}
	
	@Override
	public String toString(){
		return ("Región de "+nombre()).toUpperCase();
	}
	
}