package com.ederdiaz.utils
{
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author Eder
	 */
	public class MainMc extends MovieClip
	{
		private static var FLASH_VARS:Object;
		public function MainMc()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			FLASH_VARS = stage.loaderInfo.parameters;
		}

		public static function getFlashVars(id:String):*
		{
			return FLASH_VARS[id];
		}
	}
}
