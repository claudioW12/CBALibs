/**
 * Copyright (c) 2010 Johnson Center for Simulation at Pine Technical College
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package QuickB2.loaders.proxies
{
	import QuickB2.loaders.proxies.qb2Proxy;
	
	/**
	 * ...
	 * @author Doug Koellmer
	 */
	public class qb2ProxyObject extends qb2Proxy
	{
		[Inspectable(defaultValue="", type='String')]
		public var _handler_addedToWorld:String = "";
		
		[Inspectable(defaultValue="", type='String')]
		public var _handler_removedFromWorld:String = "";
		
		[Inspectable(defaultValue="", type='String')]
		public var _handler_preUpdate:String = "";
		
		[Inspectable(defaultValue="", type='String')]
		public var _handler_postUpdate:String = "";
		
		
		[Inspectable(defaultValue="default",enumeration="default,true,false", name='joinsInDeepCloning (default=true)')]
		public var _bool_joinsInDeepCloning:String = "default";
		
		[Inspectable(defaultValue="default",enumeration="default,true,false", name='joinsInDebugDrawing (default=true)')]
		public var _bool_joinsInDebugDrawing:String = "default";
		
		[Inspectable(defaultValue="default",enumeration="default,true,false", name='joinsInUpdateChain (default=true)')]
		public var _bool_joinsInUpdateChain:String = "default";
		
		[Inspectable(defaultValue="", type='String', name='userData')]
		public var userData:String = "";
	}
}