package com.myhappycloud.xpop.views.screens
{
	import flash.events.MouseEvent;

	import assets.GameOverView;

	import com.myhappycloud.xpop.utils.BtnUtils;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;

	import com.myhappycloud.xpop.views.IScreen;

	/**
	 * @author Eder
	 */
	public class GameOverScreen extends MovieClip implements IScreen
	{
		private var _closeSignal : Signal;
		private var view : GameOverView;
		private var _instSignal : Signal;
		private var _playSignal : Signal;

		public function GameOverScreen()
		{
			trace("GameOverScreen.GameOverScreen()");
			_closeSignal = new Signal();
			_playSignal = new Signal();
			_instSignal = new Signal();

			view = new GameOverView();
			addChild(view);
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
			setButtons();
		}

		private function setButtons() : void
		{
			BtnUtils.onClick(view.btn_play, goPlay);
			BtnUtils.onClick(view.btn_inst, goInst);
		}

		private function goInst(e : MouseEvent) : void
		{
			_instSignal.dispatch();
		}

		private function goPlay(e : MouseEvent) : void
		{
			_playSignal.dispatch();
		}

		public function get closeSignal() : Signal
		{
			return _closeSignal;
		}

		public function get playSignal() : Signal
		{
			return _playSignal;
		}

		public function get instSignal() : Signal
		{
			return _instSignal;
		}
	}
}
