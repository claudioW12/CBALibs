package com.utils;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.view.animation.*;
import android.view.inputmethod.InputMethodManager;
import android.widget.*;

public class Dloader{
	private String PACKAGE_NAME;
	private Context C;  
	private int LONG;
	private int SHORT;
	private final Activity PARENT;
	private int sdk 			= android.os.Build.VERSION.SDK_INT;

	public Dloader(String a, Context CD){
		PACKAGE_NAME 			= a;
		LONG  					= (int) Toast.LENGTH_LONG;
		SHORT  					= (int) Toast.LENGTH_SHORT;
		C 						= CD;
		this.PARENT  			= (Activity) CD;
	}
	
	public double txDouble(TextView t){
		return Double.parseDouble((t).getText().toString());
	}

	public String intToStr(int x){
		return String.valueOf(x);
	}
	
	public int toInt(double x){
		return (int) Math.floor(x);
	}
	
	public boolean toolTip(String s){
		Toast.makeText(C, s, LONG).show();
		return true;
	}
	
	public int getIDDraw(String s){
	    return C.getResources().getIdentifier(s, "drawable", PACKAGE_NAME);
	}

	public int getIDStr(String s){
	    return C.getResources().getIdentifier(s, "string", PACKAGE_NAME);
	}
	
	public int getID(String s){
		return C.getResources().getIdentifier(s, "id", PACKAGE_NAME);
	}
	
	public String getString(String s){
		return C.getString(getIDStr(s));
	}	
	
	public EditText rEdit(String s){
		return (EditText) PARENT.findViewById(getID(s));
	}

	public TextView rTxt(String s){
		return (TextView) PARENT.findViewById(getID(s));
	}

	public ImageView getImgView(String s){
		return (ImageView) PARENT.findViewById(getID(s));
	}	
	
	public boolean notEmpty(EditText txtUserID){
		return !(txtUserID.getText().toString().equals(""));
	}
	
	public boolean isEmpty(EditText txtUserID){
		return txtUserID.getText().toString().equals("");
	}	
	
	public ImageView showIMG(ImageView image, String bitmap){
		image.setImageResource(getIDDraw(bitmap));
		return image;
	}
	
	public boolean alphaIMG(ImageView image, int from, int to, int dur){
		image.startAnimation(alphaAnim(from, to, dur));
		return true;
	}
	
	public AlphaAnimation alphaAnim(int from, int to, int dur){
		AlphaAnimation anim 	= new AlphaAnimation(from, to);
		anim.setInterpolator(new AccelerateDecelerateInterpolator());
		anim.setRepeatCount(Animation.ABSOLUTE);
		anim.setDuration(dur);
		return anim;
	}
	
	public boolean hideKeyBoard(){
		InputMethodManager inputManager = (InputMethodManager) C.getSystemService(Context.INPUT_METHOD_SERVICE); 
		inputManager.hideSoftInputFromWindow(PARENT.getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);		
		return true;
	}
	
	@SuppressLint("NewApi")
	@SuppressWarnings("deprecation")
	public void clipBoard(String s){
		if(sdk < android.os.Build.VERSION_CODES.HONEYCOMB) {
		    android.text.ClipboardManager clipboard = (android.text.ClipboardManager) PARENT.getSystemService(Context.CLIPBOARD_SERVICE);
		    clipboard.setText(s);
		}else{
		    android.content.ClipboardManager clipboard = (android.content.ClipboardManager) PARENT.getSystemService(Context.CLIPBOARD_SERVICE); 
		    android.content.ClipData clip = android.content.ClipData.newPlainText("text label", s);
		    clipboard.setPrimaryClip(clip);
		}	
	}
	
}
