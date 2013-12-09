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
		private var _view : MovieClip;
		private var _updateScoreSignal : Signal;
		private var _updateTimeSignal : Signal;
		private var _gameOverSignal : Signal;
		private var startTime : int;
		private var acumTime : int;
		private var bonusTime : int;
		private var totalTime : int;
		private var timeTimer : Timer;

		public function GemsGame(container : MovieClip)
		{
			trace("GemsGame.GemsGame(view)");
			this._view = container;
			_updateScoreSignal = new Signal(int);
			_updateTimeSignal = new Signal(String);
			_gameOverSignal = new Signal();
			_view.addChild(new GemsMechanics());
		}

		public function start() : void
		{
			startTime = getTimer();
			acumTime = 0;
			bonusTime = 0;
			totalTime = 60000;
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
			min = Math.floor(sec / 60);
			sec = sec % 60;
			if (sec < 10)
				_updateTimeSignal.dispatch(min + ":0" + sec);
			else
				_updateTimeSignal.dispatch(min + ":" + sec);

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
	}
}
