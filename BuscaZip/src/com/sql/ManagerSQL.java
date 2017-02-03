package com.sql;

import com.data.*;

import java.text.SimpleDateFormat;
import java.util.*;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class ManagerSQL extends SQLiteOpenHelper{

	private static final int DATABASE_VERSION 	= 1;

	private static final String DATABASE_NAME 	= "DATOS_DE_CHILE";

	private static final String TB_REGIONES 	= "REGIONES";
	private static final String TB_PROVINCIAS	= "PROVINCIAS";
	private static final String TB_COMUNAS 		= "COMUNAS";

	//ID ES COMÚN
	private static final String KEY_ID 			= "ID";
	private static final String KEY_NOMBRE 		= "NOMBRE";

	//TABLA REGIONES
	private static final String KEY_REGION 		= "ODEPLAN";
	private static final String KEY_CAPITAL 	= "CAPITAL";

	//TABLA PROVINCIAS
	private static final String KEY_REGION_ID	= "REGION_ID";
	private static final String KEY_PREFIJO 	= "PREFIJO";

	//TABLA COMUNAS
	private static final String KEY_PROV_ID		= "PROVINCIA_ID";
	private static final String KEY_ZIP 		= "ZIP";
	
	private static final String CR_TB_REGION 	= "CREATE TABLE "+TB_REGIONES+"("+KEY_ID+" INTEGER PRIMARY KEY, "+KEY_REGION+" TEXT, "+KEY_NOMBRE+" TEXT, "+KEY_CAPITAL+" TEXT)";
	private static final String CR_TB_PROVINCIA	= "CREATE TABLE "+TB_PROVINCIAS+"("+KEY_ID+" INTEGER PRIMARY KEY, "+KEY_REGION_ID+" INTEGER, "+KEY_NOMBRE+" TEXT, "+KEY_CAPITAL+" TEXT, "+KEY_PREFIJO+" INTEGER)";
	private static final String CR_TB_COMUNA 	= "CREATE TABLE "+TB_COMUNAS+"("+KEY_ID+" INTEGER PRIMARY KEY, "+KEY_PROV_ID+" INTEGER, "+KEY_NOMBRE+" TEXT, "+KEY_ZIP+" TEXT )";
	
	public ManagerSQL(Context context){
		super(context, DATABASE_NAME, null, DATABASE_VERSION);
	}

	@Override
	public void onCreate(SQLiteDatabase db){
		dropTables(db);
		db.execSQL(CR_TB_REGION);
		db.execSQL(CR_TB_PROVINCIA);
		db.execSQL(CR_TB_COMUNA);
		return;
	}

	@Override
	public void onUpgrade(SQLiteDatabase DB, int OLD, int NEW){
		dropTables(DB);
		onCreate(DB);
		return;
	}
	
	private void dropTables(SQLiteDatabase db){
		db.execSQL("DROP TABLE IF EXISTS "+TB_REGIONES);
		db.execSQL("DROP TABLE IF EXISTS "+TB_PROVINCIAS);
		db.execSQL("DROP TABLE IF EXISTS "+TB_COMUNAS);
		return;
	}
/*REGIONES*/	
	public long crRegion(Region r){
		SQLiteDatabase db 		= this.getWritableDatabase();
		ContentValues values 	= new ContentValues();
		values.put(KEY_ID, r.ID());
		values.put(KEY_REGION, r.odeplan());
		values.put(KEY_NOMBRE, r.nombre());
		values.put(KEY_CAPITAL, r.capital());
		garbage(db, values);
		return db.insert(TB_REGIONES, null, values);
	}

	public ArrayList<Region> getAllRegion(){
		ArrayList<Region> lista = new ArrayList<Region>();
		String query 			= "SELECT "+KEY_ID+", "+KEY_REGION+", "+KEY_NOMBRE+", "+KEY_CAPITAL+" FROM "+TB_REGIONES+" ORDER BY "+KEY_ID+" COLLATE NOCASE ASC";
	
		SQLiteDatabase db 		= this.getReadableDatabase();
		Cursor cursor 			= db.rawQuery(query, null);
	
		if(cursor.moveToFirst()){
			do{
				Region r 		= new Region();
				r.ID(cursor.getInt((cursor.getColumnIndex(KEY_ID))));
				r.odeplan(cursor.getString((cursor.getColumnIndex(KEY_REGION))));
				r.nombre(cursor.getString((cursor.getColumnIndex(KEY_NOMBRE))));
				r.capital(cursor.getString((cursor.getColumnIndex(KEY_CAPITAL))));
				lista.add(r);
			}while(cursor.moveToNext());
		}
		cursor.close();
		garbage(query, db, cursor);
		return lista;
	}
	
	public Region getRegion(int ID){
		String query	 		= "SELECT "+KEY_ID+", "+KEY_REGION+", "+KEY_NOMBRE+", "+KEY_CAPITAL+" FROM "+TB_REGIONES+" WHERE "+KEY_ID+" = "+String.valueOf(ID);
		SQLiteDatabase db 		= this.getReadableDatabase();
		Cursor cursor			= db.rawQuery(query, null);
	
		if(cursor!=null) cursor.moveToFirst();
	
		Region r 				= new Region();
		r.ID(cursor.getInt((cursor.getColumnIndex(KEY_ID))));
		r.odeplan(cursor.getString((cursor.getColumnIndex(KEY_REGION))));
		r.nombre(cursor.getString((cursor.getColumnIndex(KEY_NOMBRE))));
		r.capital(cursor.getString((cursor.getColumnIndex(KEY_CAPITAL))));
		cursor.close();
		garbage(query, db, cursor);
		return r;
	}

	public int countRegion(){
		String query 	 		= "SELECT  "+KEY_ID+" FROM "+TB_REGIONES;
		SQLiteDatabase db 		= this.getReadableDatabase();
		Cursor cursor			= db.rawQuery(query, null);
		int c 					= cursor.getCount();
		cursor.close();
		garbage(query, db, cursor);
		return c;
	}

	public int updRegion(Region r){
		SQLiteDatabase db 		= this.getWritableDatabase();
		ContentValues values 	= new ContentValues();
		values.put(KEY_REGION, r.odeplan());
		values.put(KEY_NOMBRE, r.nombre());
		values.put(KEY_CAPITAL, r.capital());
		garbage(db, values);
		return db.update(TB_REGIONES, values, KEY_ID+" = ?", new String[]{ String.valueOf(r.ID()) });
	}	
	
	public void delRegion(int ID){
		SQLiteDatabase db = this.getWritableDatabase();
		db.delete(TB_REGIONES, KEY_ID+" = ?", new String[]{ String.valueOf(ID) });
		garbage(db);
		return;
	}
/*REGIONES*/
/*PROVINCIAS*/
	public long crProvincia(Provincia r){
		SQLiteDatabase db 		= this.getWritableDatabase();
		ContentValues values 	= new ContentValues();
		values.put(KEY_ID, r.ID());
		values.put(KEY_REGION_ID, r.regionID());
		values.put(KEY_NOMBRE, r.nombre());
		values.put(KEY_CAPITAL, r.capital());
		values.put(KEY_PREFIJO, r.prefijo());
		garbage(db, values);
		return db.insert(TB_PROVINCIAS, null, values);
	}
	
	public List<Provincia> getAllProvincia(){
		List<Provincia> lista 	= new ArrayList<Provincia>();
		String query 			= "SELECT "+KEY_ID+", "+KEY_REGION_ID+", "+KEY_NOMBRE+", "+KEY_CAPITAL+", "+KEY_PREFIJO+" FROM "+TB_PROVINCIAS+" ORDER BY "+KEY_NOMBRE+" COLLATE NOCASE ASC";
	
		SQLiteDatabase db 		= this.getReadableDatabase();
		Cursor cursor 			= db.rawQuery(query, null);
	
		if(cursor.moveToFirst()){
			do{
				Provincia p 	= new Provincia();
				p.ID(cursor.getInt((cursor.getColumnIndex(KEY_ID))));
				p.regionID(cursor.getInt((cursor.getColumnIndex(KEY_REGION_ID))));
				p.nombre(cursor.getString((cursor.getColumnIndex(KEY_NOMBRE))));
				p.capital(cursor.getString((cursor.getColumnIndex(KEY_CAPITAL))));
				p.prefijo(cursor.getInt((cursor.getColumnIndex(KEY_PREFIJO))));
				lista.add(p);
			}while(cursor.moveToNext());
		}
		cursor.close();
		garbage(query, db, cursor);
		return lista;
	}

	public Provincia getProvincia(int ID){
		String query	 		= "SELECT "+KEY_ID+", "+KEY_REGION_ID+", "+KEY_NOMBRE+", "+KEY_CAPITAL+", "+KEY_PREFIJO+" FROM "+TB_PROVINCIAS+" WHERE "+KEY_ID+" = "+String.valueOf(ID);
		SQLiteDatabase db 		= this.getReadableDatabase();
		Cursor cursor			= db.rawQuery(query, null);
	
		if(cursor!=null) cursor.moveToFirst();
	
		Provincia p 			= new Provincia();
		p.ID(cursor.getInt((cursor.getColumnIndex(KEY_ID))));
		p.regionID(cursor.getInt((cursor.getColumnIndex(KEY_REGION_ID))));
		p.nombre(cursor.getString((cursor.getColumnIndex(KEY_NOMBRE))));
		p.capital(cursor.getString((cursor.getColumnIndex(KEY_CAPITAL))));
		p.prefijo(cursor.getInt((cursor.getColumnIndex(KEY_PREFIJO))));
		cursor.close();
		garbage(query, db, cursor);
		return p;
	}

 	public int countProvincia(){
		String query 			= "SELECT "+KEY_ID+" FROM "+TB_PROVINCIAS;
		SQLiteDatabase db 		= this.getReadableDatabase();
		Cursor cursor 			= db.rawQuery(query, null);
		int c 					= cursor.getCount();
		cursor.close();
		garbage(query, db, cursor);
		return c;
	}

	public int updProvincia(Provincia p){
		SQLiteDatabase db 		= this.getWritableDatabase();
		ContentValues values 	= new ContentValues();
		values.put(KEY_ID, p.ID());
		values.put(KEY_REGION_ID, p.regionID());
		values.put(KEY_NOMBRE, p.nombre());
		values.put(KEY_CAPITAL, p.capital());
		values.put(KEY_PREFIJO, p.prefijo());
		garbage(db, values);
		return db.update(TB_PROVINCIAS, values, KEY_ID+" = ?", new String[]{ String.valueOf(p.ID()) });
	}	
	
	public void delProvincia(int ID){
		SQLiteDatabase db 		= this.getWritableDatabase();
		db.delete(TB_PROVINCIAS, KEY_ID+" = ?", new String[]{ String.valueOf(ID) });
		garbage(db);
		return;
	}
/*PROVINCIAS*/	
/*COMUNAS*/
	public long crComuna(Comuna c){
		SQLiteDatabase db 		= this.getWritableDatabase();
		ContentValues values 	= new ContentValues();
		values.put(KEY_ID, c.ID());
		values.put(KEY_PROV_ID, c.provinciaID());
		values.put(KEY_NOMBRE, c.nombre());
		values.put(KEY_ZIP, c.ZIP());
		garbage(db, values);
		return db.insert(TB_COMUNAS, null, values);
	}
	
	public List<Comuna> getAllComuna(){
		List<Comuna> lista		= new ArrayList<Comuna>();
		String query 			= "SELECT  "+KEY_ID+", "+KEY_PROV_ID+", "+KEY_NOMBRE+", "+KEY_ZIP+" FROM "+TB_COMUNAS+" ORDER BY "+KEY_NOMBRE+" COLLATE NOCASE ASC";
	
		SQLiteDatabase db 		= this.getReadableDatabase();
		Cursor cursor 			= db.rawQuery(query, null);
	
		if(cursor.moveToFirst()){
			do{
				Comuna c		= new Comuna();
				c.ID(cursor.getInt((cursor.getColumnIndex(KEY_ID))));
				c.provinciaID(cursor.getInt((cursor.getColumnIndex(KEY_PROV_ID))));
				c.nombre(cursor.getString((cursor.getColumnIndex(KEY_NOMBRE))));
				c.ZIP(cursor.getString((cursor.getColumnIndex(KEY_ZIP))));
				lista.add(c);
			}while(cursor.moveToNext());
		}
		return lista;
	}
	
	public Comuna getComuna(int ID){
		String query	 		= "SELECT "+KEY_ID+", "+KEY_PROV_ID+", "+KEY_NOMBRE+", "+KEY_ZIP+" FROM "+TB_COMUNAS+" WHERE "+KEY_ID+" = "+String.valueOf(ID);		
		SQLiteDatabase db 		= this.getReadableDatabase();
		Cursor cursor			= db.rawQuery(query, null);
	
		if(cursor!=null) cursor.moveToFirst();
	
		Comuna c 				= new Comuna();
		c.ID(cursor.getInt((cursor.getColumnIndex(KEY_ID))));
		c.provinciaID(cursor.getInt((cursor.getColumnIndex(KEY_PROV_ID))));
		c.nombre(cursor.getString((cursor.getColumnIndex(KEY_NOMBRE))));
		c.ZIP(cursor.getString((cursor.getColumnIndex(KEY_ZIP))));
		garbage(query, db, cursor);
		return c;
	}

 	public int countComuna(){
		String query 	 		= "SELECT "+KEY_ID+" FROM "+TB_COMUNAS;
		SQLiteDatabase db 		= this.getReadableDatabase();
		Cursor cursor			= db.rawQuery(query, null);
		int c 					= cursor.getCount();
		cursor.close();
		garbage(query, db, cursor);
		return c;
	}	
	
	public int updComuna(Comuna c){
		SQLiteDatabase db 		= this.getWritableDatabase();
		ContentValues values 	= new ContentValues();
		values.put(KEY_ID, c.ID());
		values.put(KEY_PROV_ID, c.provinciaID());
		values.put(KEY_NOMBRE, c.nombre());
		values.put(KEY_ZIP, c.ZIP());
		return db.update(TB_COMUNAS, values, KEY_ID+" = ?", new String[]{ String.valueOf(c.ID()) });
	}
	
	public void delComuna(int ID){
		SQLiteDatabase db 		= this.getWritableDatabase();
		db.delete(TB_COMUNAS, KEY_ID+" = ?", new String[]{ String.valueOf(ID) });
		return;
	}
/*COMUNAS*/
/*BUSQUEDA PROVINCIAS SEGÚN REGIÓN*/	
	public ArrayList<Provincia> provinciaFromRegion(int ID){
		ArrayList<Provincia> lista	= new ArrayList<Provincia>();
		String query 				= "SELECT "+KEY_ID+", "+KEY_REGION_ID+", "+KEY_NOMBRE+", "+KEY_CAPITAL+", "+KEY_PREFIJO+" FROM "+TB_PROVINCIAS+" WHERE "+KEY_REGION_ID+" = "+String.valueOf(ID)+" ORDER BY "+KEY_NOMBRE+" COLLATE NOCASE ASC";
	
		SQLiteDatabase db 			= this.getReadableDatabase();
		Cursor cursor 				= db.rawQuery(query, null);
	
		if(cursor.moveToFirst()){
			do{
				Provincia c		= new Provincia();
				c.ID(cursor.getInt((cursor.getColumnIndex(KEY_ID))));
				c.regionID(cursor.getInt((cursor.getColumnIndex(KEY_REGION_ID))));
				c.nombre(cursor.getString((cursor.getColumnIndex(KEY_NOMBRE))));
				c.capital(cursor.getString((cursor.getColumnIndex(KEY_CAPITAL))));
				c.prefijo(cursor.getInt((cursor.getColumnIndex(KEY_PREFIJO))));
				lista.add(c);
			}while(cursor.moveToNext());
		}
		return lista;
	}
/*BUSQUEDA COMUNAS SEGÚN PROVINCIA*/	
	public ArrayList<Comuna> comunaFromProvincia(int ID){
		ArrayList<Comuna> lista		= new ArrayList<Comuna>();
		String query 				= "SELECT  "+KEY_ID+", "+KEY_PROV_ID+", "+KEY_NOMBRE+", "+KEY_ZIP+" FROM "+TB_COMUNAS+" WHERE "+KEY_PROV_ID+" = "+String.valueOf(ID)+" ORDER BY "+KEY_NOMBRE+" COLLATE NOCASE ASC";
	
		SQLiteDatabase db 			= this.getReadableDatabase();
		Cursor cursor 				= db.rawQuery(query, null);
	
		if(cursor.moveToFirst()){
			do{
				Comuna c			= new Comuna();
				c.ID(cursor.getInt((cursor.getColumnIndex(KEY_ID))));
				c.provinciaID(cursor.getInt((cursor.getColumnIndex(KEY_PROV_ID))));
				c.nombre(cursor.getString((cursor.getColumnIndex(KEY_NOMBRE))));
				c.ZIP(cursor.getString((cursor.getColumnIndex(KEY_ZIP))));
				lista.add(c);
			}while(cursor.moveToNext());
		}
		return lista;
	}

	public void closeDB(){
		SQLiteDatabase db = this.getReadableDatabase();
		if(db != null && db.isOpen()) db.close();
		garbage(db);
		return;
	}

	private String getDateTime(){
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
		return dateFormat.format(new Date());
	}
	
	private void garbage(Object ... strings){
		for (Object className : strings) strings = null;
		return;
	}	
}


