package com.myhappycloud.xpop.views.screens
{
	import com.myhappycloud.xpop.utils.BtnUtils;
	import flash.events.MouseEvent;
	import assets.MainMenu;
	import org.osflash.signals.Signal;

	import com.myhappycloud.xpop.views.IScreen;

	import flash.display.MovieClip;

	/**
	 * @author Eder
	 */
	public class MainMenuScreen extends MovieClip implements IScreen
	{
		private var _closeSignal : Signal;
		private var view : MainMenu;
		private var _instSignal : Signal;
		private var _playSignal : Signal;
		public function MainMenuScreen()
		{
			trace("MainScreen.MainScreen()");
			_closeSignal = new Signal();
			_instSignal = new Signal();
			_playSignal = new Signal();
			view = new MainMenu();
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
			setBtns();
		}

		private function setBtns() : void
		{
			BtnUtils.onClick(view.btn_play, goGame);
			BtnUtils.onClick(view.btn_inst, goInst);
		}

		private function goInst(e:MouseEvent) : void
		{
			trace("MainScreen.goInst(e)");
			_instSignal.dispatch();
		}

		private function goGame(e:MouseEvent) : void
		{
			trace("MainScreen.goGame(e)");
			_playSignal.dispatch();
		}

		public function get closeSignal() : Signal
		{
			return _closeSignal;
		}

		public function get instSignal() : Signal
		{
			return _instSignal;
		}

		public function get playSignal() : Signal
		{
			return _playSignal;
		}
	}
}
