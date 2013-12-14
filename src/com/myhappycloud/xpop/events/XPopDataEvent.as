package com.myhappycloud.xpop.events 
{
	import flash.events.Event;
	/**
	 * @author Eder
	 */
	public class XPopDataEvent extends Event 
	{
		public static const FRIENDS_SCORES : String = "FRIENDS_SCORES";
		public static const MY_SCORE : String = "MY_SCORE";
		public static const SCORE_SAVED : String = "SCORE_SAVED";
		public static const USER_SAVED : String = "USER_SAVED";

		private var _type : String;
		private var _result : Object;		
		public function XPopDataEvent(type:String, result:Object)
		{
			_result = result;
			_type = type;
			super(type, false, false);
		}

		override public function clone():Event
		{
			return new XPopDataEvent(_type, _result);
		}

		public function get result() : Object
		{
			return _result;
		}
	}
}
