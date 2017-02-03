package com.cba_team.app_comuna_zip;

import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;
import android.net.Uri;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;

import java.util.ArrayList;
import com.data.Comuna;
import com.data.Provincia;
import com.data.Region;
import com.sql.ManagerSQL;
import com.utils.Dloader;
import android.view.*;
import android.view.ContextMenu.ContextMenuInfo;
import android.widget.*;
import android.widget.AdapterView.*;

public class InputActivity extends Activity {

	public static final String RETORNADO 	= "ULTIMO";
	public static final String GRADO 		= "GRADO";
	public static final int REQUEST_CODE 	= 10;
	
    private final int C_WHITE 				= Color.WHITE;
    private final int C_BLACK 				= Color.parseColor("#052439");
    private final int C_L_BLUE				= Color.parseColor("#2da5da");
    

	private ManagerSQL DB;
	private Spinner CB_REGION, CB_PROVINCIA;
	private ArrayAdapter<Region> ADAPTER1;
	private ArrayAdapter<Provincia> ADAPTER2;
	private ArrayAdapter<Comuna> ADAPTER3;
	private ListView LISTVIEW;
	private TextView LABEL;
	private String PREFIJO, COPY, PACKAGE_NAME;
	private int POSITION;
	private Intent DIAL_INTENT;
	private Dloader CBA;
	private Intent INTENCION;
	private AdapterContextMenuInfo INFO;
	
    private Typeface FONT_N, FONT_B;

	@Override
	protected void onCreate(Bundle APP) {
		super.onCreate(APP);
		setContentView(R.layout.activity_input);
		initAPP();
		loadTables();
		addListener();
		getAllRegion();
		finishAPP();
	}
	
	private void initAPP(){
		PACKAGE_NAME 	= getApplicationContext().getPackageName();
		CBA  			= new Dloader(PACKAGE_NAME, this);
		DB 				= new ManagerSQL(getApplicationContext());
		CB_REGION		= (Spinner) findViewById(R.id.REGIONES);
		CB_PROVINCIA	= (Spinner) findViewById(R.id.PROVINCIAS);
		LISTVIEW		= (ListView) findViewById(R.id.LISTVIEW);
		LABEL 			= CBA.rTxt("LABEL");
		PREFIJO			= CBA.getString("PREFIJO");
		COPY			= CBA.getString("COPY");

		
		FONT_N 			= Typeface.createFromAsset(getAssets(),"fonts/Mark Simonson - Proxima Nova Regular.otf");
		FONT_B 			= Typeface.createFromAsset(getAssets(),"fonts/Mark Simonson - Proxima Nova Semibold.otf");
		LABEL.setTypeface(FONT_N);
		
		CB_PROVINCIA.setBackgroundColor(C_L_BLUE);
		
		registerForContextMenu(LABEL);
		return;
	}
	
	private void loadTables(){
		new AllSQL(DB);
		return;
	}
	
	private void finishAPP(){
		DB.closeDB();
		return;
	}
	
	private void addListener(){
		CB_REGION.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){

			@Override
			public void onItemSelected(AdapterView<?> ADAP, View SPIN, int POS, long ID) {
				provinciaFromRegion(((Region) ADAP.getSelectedItem()).ID());
			}

			@Override
			public void onNothingSelected(AdapterView<?> arg0){ }			
		});
		
		
		CB_PROVINCIA.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){
			@Override
			public void onItemSelected(AdapterView<?> ADAP, View SPIN, int POS, long ID) {
				comunaFromProvincia(((Provincia) ADAP.getSelectedItem()));
			}

			@Override
			public void onNothingSelected(AdapterView<?> parent){ }

		});
		
		return;
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu MENU) {
		getMenuInflater().inflate(R.menu.input, MENU);
		return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem ITEM) {
		switch(ITEM.getItemId()){
			case R.id.ITEM_ABOUT:
				INTENCION 		= new Intent(this, AboutActivity.class);
				INTENCION.putExtra("MSG", "HOLA");
				startActivityForResult(INTENCION, REQUEST_CODE);
			return true;
			default:
			return super.onOptionsItemSelected(ITEM);
		}
	}
	
	@Override
	public void onActivityResult(int REQ_CODE, int RES_CODE, Intent DATA) {
		if(RES_CODE==RESULT_OK && REQ_CODE==REQUEST_CODE){
			Bundle b  			= DATA.getExtras();
			if (DATA.hasExtra(RETORNADO)) b.getString(RETORNADO);
		}
	}	

	@Override
	public void onCreateContextMenu(ContextMenu MENU, View V, ContextMenuInfo MENU_INFO) {
		super.onCreateContextMenu(MENU, V, MENU_INFO);
		MenuInflater INFLA 			= getMenuInflater();
		
		if(V.getId() == R.id.LABEL){
			Provincia PRO			= (Provincia) CB_PROVINCIA.getSelectedItem();
			MENU.setHeaderTitle("\""+PRO.toString()+"\"");
			INFLA.inflate(R.menu.call, MENU);
		}else{
			INFO 					= (AdapterContextMenuInfo) MENU_INFO;
			POSITION 				= INFO.position;
			
			Comuna COMUNA 			= ADAPTER3.getItem(POSITION);
			MENU.setHeaderTitle(COPY+" \""+COMUNA.nombre()+"\"");
			INFLA.inflate(R.menu.copy, MENU);
		}
	}

	@Override
	public boolean onContextItemSelected(MenuItem ITEM) {
		Comuna COMUNA 				= ADAPTER3.getItem(POSITION);
		Provincia PROV				= (Provincia) CB_PROVINCIA.getSelectedItem();
		switch(ITEM.getItemId()) {
		case R.id.COPY_ZIP:
			clipBoard(COMUNA.ZIP());
		return true;
		case R.id.COPY_ROW:
			clipBoard(COMUNA.toString());
		return true;
		case R.id.CALL:
			try{
				DIAL_INTENT			= new Intent(Intent.ACTION_DIAL);
				String phNum 		= "tel: +56 0" + String.valueOf(PROV.prefijo())+" ";
				DIAL_INTENT.setData(Uri.parse(phNum));
				startActivity(DIAL_INTENT);				
			}catch(Exception e){
				MSG("FALLA:"+e.getMessage().toString());
			}
		return true;
		default: return super.onContextItemSelected(ITEM);
		}
	}
	
	private void getAllRegion(){
		ArrayList<Region> LISTA 	= DB.getAllRegion();
		ADAPTER1 					= new ArrayAdapter<Region>(this, android.R.layout.simple_spinner_item,  LISTA){
	        @Override
	        public View getView(int POSITION, View C_VIEW, ViewGroup GROUP){
	            View VIEW 			= super.getView(POSITION, C_VIEW, GROUP);
	            TextView TEXTVIEW 	= (TextView) VIEW.findViewById(android.R.id.text1);
	            TEXTVIEW.setTypeface(FONT_N);
	            TEXTVIEW.setTextColor(C_WHITE);
	            return VIEW;
	        }
	    };

		ADAPTER1.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
	    CB_REGION.setAdapter(ADAPTER1);
	    return;
	}
	
	private void provinciaFromRegion(int ID){
		ArrayList<Provincia> LISTA 	= DB.provinciaFromRegion(ID);
		ADAPTER2 					= new ArrayAdapter<Provincia>(this, android.R.layout.simple_spinner_item,  LISTA){
	        @Override
	        public View getView(int POSITION, View C_VIEW, ViewGroup GROUP){
	            View VIEW 			= super.getView(POSITION, C_VIEW, GROUP);
	            TextView TEXTVIEW 	= (TextView) VIEW.findViewById(android.R.id.text1);
	            TEXTVIEW.setTypeface(FONT_N);
	            TEXTVIEW.setTextColor(C_WHITE);
	            return VIEW;
	        }
	    };
	    
		ADAPTER2.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
	    CB_PROVINCIA.setAdapter(ADAPTER2);
	    return;
	}
	
	private void comunaFromProvincia(Provincia PRO){
		
		labeled(PRO);
		
		ArrayList<Comuna> LISTA 	= DB.comunaFromProvincia(PRO.ID());

		ADAPTER3					= new ArrayAdapter<Comuna>(this, android.R.layout.simple_list_item_1, LISTA){
	        @Override
	        public View getView(int POSITION, View C_VIEW, ViewGroup GROUP){
	            View VIEW 			= super.getView(POSITION, C_VIEW, GROUP);
	            TextView TEXTVIEW 	= (TextView) VIEW.findViewById(android.R.id.text1);
	            TEXTVIEW.setTypeface(FONT_N);
	            TEXTVIEW.setTextColor(C_WHITE);
	            TEXTVIEW.setBackgroundColor(C_BLACK);
	            return VIEW;
	        }
	    };
	    
	    registerForContextMenu(LISTVIEW);

	    LISTVIEW.setAdapter(ADAPTER3);
		return;
	}
	
	@SuppressLint("DefaultLocale")
	private void labeled(Provincia PRO){
		PREFIJO				= PREFIJO.toUpperCase();
		LABEL.setText(PREFIJO+" 0"+String.valueOf(PRO.prefijo()));
		return;
	}

	private void MSG(String S){
		CBA.toolTip(S);
		return;
	}
	
	private void clipBoard(String S){
		MSG("\""+S+"\"");
		CBA.clipBoard(S);
		return;
	}

}