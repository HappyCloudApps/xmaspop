package com.myhappycloud.xpop.views.screens
{
	import assets.SplashView;
	import flash.utils.setTimeout;
	import flash.display.MovieClip;

	import org.osflash.signals.Signal;

	import com.myhappycloud.xpop.views.IScreen;

	/**
	 * @author Eder
	 */
	public class SplashScreen extends MovieClip implements IScreen
	{
		private var _closeSignal : Signal;
		private var delay : Number = 3000;
		private var _goMenu : Signal;
		private var view : SplashView;

		public function SplashScreen()
		{
			trace("SplashScreen.SplashScreen()");
			_closeSignal = new Signal();
			_goMenu = new Signal();
			setTimeout(goMainMenu, delay);
			view = new SplashView();
			addChild(view);
		}

		private function goMainMenu() : void
		{
			_goMenu.dispatch();
		}

		public function get mc() : MovieClip
		{
			return this;
		}

		public function close() : void
		{
			_closeSignal.dispatch();
		}

		public function open() : void
		{
		}

		public function get closeSignal() : Signal
		{
			return _closeSignal;
		}

		public function get gomenu() : Signal
		{
			return _goMenu;
		}
	}
}
