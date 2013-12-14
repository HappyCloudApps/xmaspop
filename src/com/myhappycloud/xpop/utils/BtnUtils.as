package com.myhappycloud.xpop.utils
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.reintroducing.sound.SoundManager;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

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
			btn.addEventListener(MouseEvent.CLICK, snd, false, 0, true);
			btn.addEventListener(MouseEvent.ROLL_OVER, overBouncy, false, 0, true);
			btn.addEventListener(MouseEvent.ROLL_OUT, outBouncy, false, 0, true);
		}

		private static function snd(event : MouseEvent) : void
		{
			var sm:SoundManager = SoundManager.getInstance();
			sm.playSound(XpopSounds.CLICK);
		}

		private static function outBouncy(e : MouseEvent) : void
		{
			var btn : MovieClip = MovieClip(e.currentTarget);
			TweenLite.to(btn, .5, {ease:Elastic.easeOut, scaleX:1, scaleY:1});
		}

		private static function overBouncy(e : MouseEvent) : void
		{
			var btn : MovieClip = MovieClip(e.currentTarget);
			TweenLite.to(btn, .5, {ease:Elastic.easeOut, scaleX:1.1, scaleY:1.1});
		}

		public static function clearMc(mc : MovieClip) : void
		{
			while (mc.numChildren)
				mc.removeChildAt(0);
		}
	}
}
