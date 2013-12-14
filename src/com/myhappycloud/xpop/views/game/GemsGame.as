package com.myhappycloud.xpop.views.game
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;

	/**
	 * @author Eder
	 */
	public class GemsGame
	{
		private static const TOTAL_TIME : int = 90000;
//		private static const TOTAL_TIME : int = 5000;
		private var _view : MovieClip;
		private var _updateScoreSignal : Signal;
		private var _updateTimeSignal : Signal;
		private var _gameOverSignal : Signal;
		private var startTime : int;
		private var acumTime : int;
		private var bonusTime : int;
		private var totalTime : int;
		private var timeTimer : Timer;
		private var paused : Boolean = false;
		private var gameMech : GemsMechanics;

		public function GemsGame(container : MovieClip)
		{
			trace("GemsGame.GemsGame(view)");
			this._view = container;
			gameMech = new GemsMechanics();
			_view.addChild(gameMech);
			_updateScoreSignal = gameMech.scoreUpdate;
			_updateTimeSignal = new Signal(int);
			_gameOverSignal = new Signal();
		}

		public function start() : void
		{
			startTime = getTimer();
			acumTime = 0;
			bonusTime = 0;
			totalTime = TOTAL_TIME;
			calculateRemainingTime();

			timeTimer = new Timer(100);
			timeTimer.addEventListener(TimerEvent.TIMER, onTimer);
			timeTimer.start();
		}

		private function onTimer(e : TimerEvent) : void
		{
			calculateRemainingTime();
		}

		private function calculateRemainingTime() : void
		{
			var min : int = 0;
			var sec : int = 0;
			var remainingTime : int = totalTime - acumTime + bonusTime;
			remainingTime = remainingTime - (getTimer() - startTime);
			sec = remainingTime / 1000;
			// min = Math.floor(sec / 60);
			// sec = sec % 60;
			// if (sec < 10)
			// _updateTimeSignal.dispatch(min + ":0" + sec);
			// else
			// _updateTimeSignal.dispatch(min + ":" + sec);
			_updateTimeSignal.dispatch(sec);

			if (remainingTime <= 0)
				gameOver();
		}


		private function gameOver() : void
		{
			_gameOverSignal.dispatch();
			timeTimer.stop();
			timeTimer.removeEventListener(TimerEvent.TIMER, onTimer);
		}

		public function get updateScoreSignal() : Signal
		{
			return _updateScoreSignal;
		}

		public function get updateTimeSignal() : Signal
		{
			return _updateTimeSignal;
		}

		public function get gameOverSignal() : Signal
		{
			return _gameOverSignal;
		}

		public function pause() : void
		{
			if (paused)
				return;
			acumTime += getTimer() - startTime;
			paused = true;
			timeTimer.stop();
			gameMech.visible = false;
		}

		public function resume() : void
		{
			if (!paused)
				return;
			startTime = getTimer();
			paused = false;
			timeTimer.start();
			gameMech.visible = true;
		}
	}
}
