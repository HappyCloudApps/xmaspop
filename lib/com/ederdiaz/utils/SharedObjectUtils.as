package com.ederdiaz.utils
{
	import flash.net.SharedObject;
	/**
	 * @author Eder
	 */
	public class SharedObjectUtils
	{
		public static function load(id:String):SharedObject
		{
			var so:SharedObject = SharedObject.getLocal(id);
			return so;
		}

		public static function save(so:SharedObject):void
		{
			so.flush();
		}
	}
}
