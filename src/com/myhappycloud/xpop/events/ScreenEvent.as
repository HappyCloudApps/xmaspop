package com.myhappycloud.xpop.events 
{
	import flash.events.Event;
	/**
	 * @author Eder
	 */
	public class ScreenEvent extends Event 
	{
		public static const UPDATE_SCREEN : String = "UPDATE_SCREEN";

		private var _type : String;
		
		public function ScreenEvent(type:String)
		{
			_type = type;
			super(type, false, false);
		}

		override public function clone():Event
		{
			return new ScreenEvent (_type);
		}
	}
}
