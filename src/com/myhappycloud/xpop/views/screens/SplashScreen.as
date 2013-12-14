package com.myhappycloud.xpop.views.screens
{
	import flash.utils.getTimer;

	import com.greensock.events.LoaderEvent;

	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	import com.greensock.loading.SWFLoader;
	import com.greensock.TweenLite;

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
		private var context : LoaderContext;
		private var soundLoader : SWFLoader;
		private var _soundsLoaded : Signal;
		private var startTime : int;

		public function SplashScreen()
		{
			trace("SplashScreen.SplashScreen()");
			_closeSignal = new Signal();
			_goMenu = new Signal();

			//
			startTime = getTimer();

			view = new SplashView();
			addChild(view);

			TweenLite.from(view.mitta_mc, .5, {y:view.mitta_mc.y - 300, x:view.mitta_mc.x - 300});
			TweenLite.from(view.kicho_mc, .65, {y:view.kicho_mc.y + 300, x:view.kicho_mc.x - 300});
			TweenLite.from(view.kamy_mc, .8, {y:view.kamy_mc.y + 300, x:view.kamy_mc.x + 300});

			_soundsLoaded = new Signal();

			context = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			soundLoader = new SWFLoader("sounds.swf", {onComplete:loadComplete, context:context});
			soundLoader.load();
		}

		private function loadComplete(e : LoaderEvent) : void
		{
			trace("SplashScreen.loadComplete(e)");
			goMainMenu();
		}

		private function goMainMenu() : void
		{
			if (getTimer() - startTime > delay)
			{
				_soundsLoaded.dispatch();
				_goMenu.dispatch();
			}
			else
			{
				setTimeout(goMainMenu, 250);
			}
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

		public function get soundsLoaded() : Signal
		{
			return _soundsLoaded;
		}
	}
}
