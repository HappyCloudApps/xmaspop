package com.myhappycloud.xpop.events 
{
	import flash.events.Event;
	/**
	 * @author Eder
	 */
	public class ModelEvent extends Event 
	{
		public static const SET_SCORE : String = "SET_SCORE";
		public static const TOGGLE_VOLUME : String = "TOGGLE_VOLUME";
		public static const SETTINGS_UPDATED : String = "SETTINGS_UPDATED";

		private var _type : String;
		private var _data : Object;		
		public function ModelEvent(type:String, data:Object)
		{
			_data = data;
			_type = type;
			super(type, false, false);
		}

		override public function clone():Event
		{
			return new ModelEvent(_type, _data);
		}

		public function get data() : Object
		{
			return _data;
		}
	}
}
