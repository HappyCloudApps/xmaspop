package com.myhappycloud.xpop.services.facebook 
{
	import flash.events.Event;
	/**
	 * @author Eder
	 */
	public class FBEvent extends Event 
	{
		public static const FB_GOT : String = "FB_GOT";
		public static const FB_FAIL : String = "FB_FAIL";
		public static const FRIENDS_GOT : String = "FRIENDS_GOT";

		private var _type : String;
		
		public function FBEvent(type:String)
		{
			_type = type;
			super(type, false, false);
		}

		override public function clone():Event
		{
			return new FBEvent (_type);
		}
	}
}
