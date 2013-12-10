package com.myhappycloud.xpop.views.screens
{
	import flash.events.MouseEvent;
	import com.myhappycloud.xpop.utils.BtnUtils;
	import assets.GameView;

	import com.myhappycloud.xpop.views.IScreen;
	import com.myhappycloud.xpop.views.game.GemsGame;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;

	/**
	 * @author Eder
	 */
	public class GameScreen extends MovieClip implements IScreen
	{
		private var _closeSignal : Signal;
		private var _gameOverSignal : Signal;
		private var view : GameView;
		private var gameController : GemsGame;
		private var _score : int;

		public function GameScreen()
		{
			trace("GameScreen.GameScreen()");
			_closeSignal = new Signal();
			_gameOverSignal = new Signal();

			view = new GameView();
			addChild(view);

			while (view.container_mc.numChildren > 0)
				view.container_mc.removeChildAt(0);

			gameController = new GemsGame(view.container_mc);
			gameController.updateScoreSignal.add(updateScore);
			gameController.updateTimeSignal.add(updateTime);
			gameController.gameOverSignal.addOnce(gameOver);
			
			BtnUtils.onClick(view.btn_pause, pauseGame);
		}

		private function pauseGame(e:MouseEvent) : void
		{
			gameController.pause();
		}

		private function updateScore(score : int) : void
		{
			_score = score;
			view.score_txt.text = String(score);
		}

		private function updateTime(time : String) : void
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
			// setTimeout(gameOver, 3000);
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

		public function get score() : int
		{
			return _score;
		}
	}
}
