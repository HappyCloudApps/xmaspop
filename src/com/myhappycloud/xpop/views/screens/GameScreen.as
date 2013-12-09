package com.myhappycloud.xpop.views.screens
{
	import flash.utils.getTimer;
	import com.myhappycloud.xpop.views.game.GemsGame;
	import assets.GameView;
	import flash.utils.setTimeout;
	import org.osflash.signals.Signal;

	import flash.display.MovieClip;

	import com.myhappycloud.xpop.views.IScreen;

	/**
	 * @author Eder
	 */
	public class GameScreen extends MovieClip implements IScreen
	{
		private var _closeSignal : Signal;
		private var _gameOverSignal : Signal;
		private var view : GameView;
		private var gameController : GemsGame;

		public function GameScreen()
		{
			trace("GameScreen.GameScreen()");
			_closeSignal = new Signal();
			_gameOverSignal = new Signal();
			
			view = new GameView();
			addChild(view);

			while(view.container_mc.numChildren>0)
				view.container_mc.removeChildAt(0);

			gameController = new GemsGame(view.container_mc);
			gameController.updateScoreSignal.add(updateScore);
			gameController.updateTimeSignal.add(updateTime);
			gameController.gameOverSignal.addOnce(gameOver);
		}

		private function updateScore(score:int) : void
		{
			view.score_txt.text = String(score);
		}
		
		private function updateTime(time:String) : void
		{
			view.time_txt.text = time;
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
//			setTimeout(gameOver, 3000);
			gameController.start();
		}

		private function gameOver() : void
		{
			trace("GameScreen.gameOver()");
			_gameOverSignal.dispatch();
		}

		public function get closeSignal() : Signal
		{
			return _closeSignal;
		}

		public function get gameOverSignal() : Signal
		{
			return _gameOverSignal;
		}
	}
}
