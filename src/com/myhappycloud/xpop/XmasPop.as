package com.myhappycloud.xpop
{
	import flash.display.Sprite;

	public class XmasPop extends Sprite
	{
		private var context : XPopContext;
		public function XmasPop()
		{
			trace("XmasPop.XmasPop()");
			context = new XPopContext(this);
		}
	}
}
