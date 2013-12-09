package com.myhappycloud.xpop.events 
{
	import flash.events.Event;
	/**
	 * @author Eder
	 */
	public class NavEvent extends Event 
	{
		public static const GO_TO : String = "GO_TO";

		private var _type : String;
		private var _state : String;		
		public function NavEvent(type:String, state:String)
		{
			_state = state;
			_type = type;
			super(type, false, false);
		}

		override public function clone():Event
		{
			return new NavEvent(_type, _state);
		}

		public function get state() : String
		{
			return _state;
		}
	}
}
