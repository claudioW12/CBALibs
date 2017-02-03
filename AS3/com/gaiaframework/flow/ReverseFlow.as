﻿/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the GPL License:
* http://www.opensource.org/licenses/gpl-2.0.php 
*****************************************************************************************************/

package com.gaiaframework.flow
{
        public class ReverseFlow
        {               
                internal static function start():void
                {
                        FlowManager.preload();
                }               
                internal static function afterPreloadDone():void
                {
                        FlowManager.transitionIn();
                }
                internal static function afterTransitionInDone():void
                {
                        FlowManager.transitionOut();
                }               
                internal static function afterTransitionOutDone():void
                {
                        FlowManager.complete();
                }
        }
}
