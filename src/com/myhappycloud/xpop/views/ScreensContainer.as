package com.myhappycloud.xpop.views
{
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

		public function init() : void
		{
			trace("ScreensContainer.init()");
		}

		public function update(state : String) : void
		{
			trace("ScreensContainer.update(state) - " + state);
			switch(state)
			{
				case AppStates.SPLASH:
					nextScreen = new SplashScreen();
					break;
				case AppStates.MAIN_MENU:
					nextScreen = new MainMenuScreen();
					break;
				case AppStates.INSTRUCTIONS:
					nextScreen = new InstructionsScreen();
					break;
				case AppStates.GAME:
					nextScreen = new GameScreen();
					break;
				case AppStates.GAME_OVER:
					nextScreen = new GameOverScreen();
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
				removeChild(_currentScreen.mc);
			_currentScreen = nextScreen;
			_currentScreen.open();
			addChild(_currentScreen.mc);
			nextScreen = null;
		}
	}
}
