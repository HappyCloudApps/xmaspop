package com.myhappycloud.xpop.utils
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	/**
	 * @author Eder
	 */
	public class BtnUtils
	{
		public static function onClick(btn : MovieClip, func : Function) : void
		{
			btn.buttonMode = true;
			btn.mouseChildren = false;
			btn.addEventListener(MouseEvent.CLICK, func, false, 0, true);
		}
	}
}
