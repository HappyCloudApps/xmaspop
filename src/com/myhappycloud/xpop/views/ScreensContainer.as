package com.myhappycloud.xpop.views
{
	import com.greensock.easing.Bounce;
	import com.greensock.TweenLite;
	import com.myhappycloud.xpop.views.screens.GameOverScreen;
	import com.myhappycloud.xpop.views.screens.GameScreen;
	import com.myhappycloud.xpop.views.screens.InstructionsScreen;
	import com.myhappycloud.xpop.models.AppStates;
	import com.myhappycloud.xpop.views.screens.MainMenuScreen;
	import com.myhappycloud.xpop.views.screens.SplashScreen;

	import flash.display.MovieClip;

	/**
	 * @author Eder
	 */
	public class ScreensContainer extends MovieClip
	{
		private var _currentScreen : IScreen;
		private var nextScreen : IScreen;
		private var transition : int;

		public function init() : void
		{
			trace("ScreensContainer.init()");
		}

		public function update(state : String) : void
		{
			trace("ScreensContainer.update(state) - " + state);
			transition = 0;
			switch(state)
			{
				case AppStates.SPLASH:
					nextScreen = new SplashScreen();
					break;
				case AppStates.MAIN_MENU:
					nextScreen = new MainMenuScreen();
					transition = 2;
					break;
				case AppStates.INSTRUCTIONS:
					nextScreen = new InstructionsScreen();
					transition = 2;
					break;
				case AppStates.GAME:
					nextScreen = new GameScreen();
					transition = 2;
					break;
				case AppStates.GAME_OVER:
					nextScreen = new GameOverScreen();
					transition = 1;
					break;
				default:
					trace("ScreensContainer.update(state) - state without screen");
					nextScreen = null;
			}

			if (nextScreen)
				changeToNextScreen();
		}

		private function changeToNextScreen() : void
		{
			if (_currentScreen)
			{
				_currentScreen.closeSignal.addOnce(switchToNextScreen);
				_currentScreen.close();
			}
			else
			{
				switchToNextScreen();
			}
		}

		private function switchToNextScreen() : void
		{
			if (_currentScreen)
			{
				_currentScreen.mc.mouseChildren = _currentScreen.mc.mouseEnabled = false;

				// removeChild(_currentScreen.mc);
				var oldScreen:MovieClip=_currentScreen.mc;
				_currentScreen = nextScreen;
				_currentScreen.open();
				addChild(_currentScreen.mc);

				if (transition == 1)
					TweenLite.from(_currentScreen.mc, .5, {y:-760, onComplete:removeScr, onCompleteParams:[oldScreen]});
				if (transition == 2)
					TweenLite.from(_currentScreen.mc, .7, {x:600, onComplete:removeScr, onCompleteParams:[oldScreen]});
			}
			else
			{
				_currentScreen = nextScreen;
				_currentScreen.open();
				addChild(_currentScreen.mc);
			}
			nextScreen = null;
		}

		private function removeScr(mc:MovieClip) : void
		{
			removeChild(mc);
		}
	}
}
