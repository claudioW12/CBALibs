package com.cba_team.app_comuna_zip;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Typeface;
import android.view.ContextMenu;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ContextMenu.ContextMenuInfo;
import android.widget.TextView;
import android.widget.Toast;

public class AboutActivity extends Activity {
	
	public static final String RETORNADO 	= "ULTIMO";
	private TextView TEXT_M_DEV, TEXT_M_LAY, TEXT_N_DEV, TEXT_N_LAY, TEXT_P_DEV, TEXT_P_LAY;
	private Intent INTENCION;
	private String TITLE_LAYOUT, TITLE_DEVELOPER;
	private String MAIL_LAYOUT, MAIL_DEVELOPER;
	private String SUBJECT, EXTRAS, CHOICE, SENDING;
    private Typeface FONT_N, FONT_B;

	@Override
	protected void onCreate(Bundle APP) {
		super.onCreate(APP);
		setContentView(R.layout.activity_about);
		Bundle b  			= getIntent().getExtras();
		if (b == null) return;
		String MESSAGE		= b.getString("MSG");
		if(MESSAGE != null){  }
		
		TEXT_M_DEV			= (TextView) findViewById(R.id.TEXT_DEVELOPED_MAIL);
		TEXT_M_LAY			= (TextView) findViewById(R.id.TEXT_LAYOUT_MAIL);
		
		TEXT_N_DEV			= (TextView) findViewById(R.id.TEXT_DEVELOPED_BY);
		TEXT_N_LAY			= (TextView) findViewById(R.id.TEXT_LAYOUT_BY);

		TEXT_P_DEV			= (TextView) findViewById(R.id.TEXT_DEVELOPED);
		TEXT_P_LAY			= (TextView) findViewById(R.id.TEXT_LAYOUT);

	
		TITLE_LAYOUT 		= getString(R.string.DEV_LAYOUT_BY);
		TITLE_DEVELOPER		= getString(R.string.DEV_DEVELOPED_BY);
		
		MAIL_LAYOUT 		= getString(R.string.DEV_LAYOUT_MAIL);
		MAIL_DEVELOPER		= getString(R.string.DEV_DEVELOPED_MAIL);
		
		SUBJECT				= getString(R.string.SUBJECT);
		EXTRAS				= getString(R.string.EXTRAS);
		CHOICE				= getString(R.string.CHOICE);
		SENDING				= getString(R.string.SENDING);
		
		FONT_N 				= Typeface.createFromAsset(getAssets(),"fonts/Mark Simonson - Proxima Nova Regular.otf");
		FONT_B 				= Typeface.createFromAsset(getAssets(),"fonts/Mark Simonson - Proxima Nova Semibold.otf");

		TEXT_M_DEV.setTypeface(FONT_N);
		TEXT_M_LAY.setTypeface(FONT_N);
		TEXT_N_DEV.setTypeface(FONT_B);
		TEXT_N_LAY.setTypeface(FONT_B);
		TEXT_P_DEV.setTypeface(FONT_N);
		TEXT_P_LAY.setTypeface(FONT_N);
		
		registerForContextMenu(TEXT_M_DEV);
		registerForContextMenu(TEXT_M_LAY);
		return;
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu MENU) {
		getMenuInflater().inflate(R.menu.back, MENU);
		return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem ITEM) {
		switch(ITEM.getItemId()){
			case R.id.BACK:
				finish();
			return true;
			default:
			return super.onOptionsItemSelected(ITEM);
		}
	}
	
	@Override
	public void onCreateContextMenu(ContextMenu MENU, View V, ContextMenuInfo MENU_INFO) {
		super.onCreateContextMenu(MENU, V, MENU_INFO);
		MenuInflater INFLA	= getMenuInflater();
		switch(V.getId()){
			case R.id.TEXT_DEVELOPED_MAIL:
				MENU.setHeaderTitle(TITLE_DEVELOPER);
				INFLA.inflate(R.menu.send_mail_developer, MENU);
			return;
			case R.id.TEXT_LAYOUT_MAIL:
				MENU.setHeaderTitle(TITLE_LAYOUT);
				INFLA.inflate(R.menu.send_mail_layout, MENU);
			return;
			default: return;
		}
	}

	@Override
	public boolean onContextItemSelected(MenuItem ITEM) {
		switch(ITEM.getItemId()) {
			case R.id.SEND_DEVELOPER:
				sendMail(MAIL_DEVELOPER);
			return true;
			case R.id.SEND_LAYOUT:
				sendMail(MAIL_LAYOUT);
			return true;
			default: return super.onContextItemSelected(ITEM);
		}
	}

	private void MSG(String S){
		Toast.makeText(this, S, Toast.LENGTH_LONG).show();
		return;
	}
	
	private void sendMail(String S){
		MSG(SENDING+": "+S);
		final String DIRS[] 	= {S};
		INTENCION				= new Intent(Intent.ACTION_SEND);
		INTENCION.setType("plain/text");
		INTENCION.putExtra(Intent.EXTRA_EMAIL, DIRS);
		INTENCION.putExtra(Intent.EXTRA_SUBJECT, SUBJECT);
		INTENCION.putExtra(Intent.EXTRA_TEXT, EXTRAS);
		startActivity(Intent.createChooser(INTENCION, CHOICE));		
	}

	@Override
	public void finish(){
		INTENCION				= new Intent();
		INTENCION.putExtra(RETORNADO, "SI");
		setResult(RESULT_OK, INTENCION);
		super.finish();
	}
}

