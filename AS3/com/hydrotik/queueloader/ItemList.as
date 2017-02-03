﻿/*
 * Copyright 2007-2009 (c) Donovan Adams, http://blog.hydrotik.com/
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */


package com.hydrotik.queueloader {
	import flash.utils.Dictionary;	
	import com.hydrotik.queueloader.items.*;
	/**
	 * @author Donovan Adams | Hydrotik | http://blog.hydrotik.com
	 * @version: 3.1.8
	 */
	public class ItemList {
		
		public static var itemArray:Dictionary = new Dictionary();
		
		public static function initItems():Boolean{
			
			itemArray[QueueLoaderConst.FILE_IMAGE] = {classRef:ImageItem, regEx:/^.+\.((jpg)|(gif)|(jpeg)|(png))/i};
			itemArray[QueueLoaderConst.FILE_SWF] = {classRef:SWFItem, regEx:/^.+\.((swf))/i};
			itemArray[QueueLoaderConst.FILE_XML] = {classRef:XMLItem, regEx:/^.+\.((xml))/i};
			//itemArray[QueueLoaderConst.FILE_CSS] = {classRef:CSSItem, regEx:/^.+\.((css))/i};
			//itemArray[QueueLoaderConst.FILE_MP3] = {classRef:MPSoundItem, regEx:/^.+\.((mp3))/i};
			//itemArray[QueueLoaderConst.FILE_ZIP] = {classRef:ZIPItem, regEx:/^.+\.((zip))/i};
			//itemArray[QueueLoaderConst.FILE_WAV] = {classRef:PCMSoundItem, regEx:/^.+\.((wav))/i};
			itemArray[QueueLoaderConst.FILE_FLV] = {classRef:FLVItem, regEx:/^.+\.((flv)|(f4v)|(mp4)|(m4v)|(m4a)|(mov)|(3gp))/i};
			itemArray[QueueLoaderConst.FILE_GENERIC] = {classRef:GenericItem, regEx:/^.+\.((dae)|(txt)|(php)|(html))/i};
			
			return true;
		}
		
	}
}
