package com.myhappycloud.xpop.views.screens
{
	import flash.events.MouseEvent;

	import com.myhappycloud.xpop.utils.BtnUtils;

	import assets.InstructionsView;

	import org.osflash.signals.Signal;

	import com.myhappycloud.xpop.views.IScreen;

	import flash.display.MovieClip;

	/**
	 * @author Eder
	 */
	public class InstructionsScreen extends MovieClip implements IScreen
	{
		private var _closeSignal : Signal;
		private var view : InstructionsView;
		private var _playSignal : Signal;
		private var numInst : int;
		private var currInst : int;

		public function InstructionsScreen()
		{
			trace("InstructionsScreen.InstructionsScreen()");
			_closeSignal = new Signal();
			_playSignal = new Signal();
			view = new InstructionsView();
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
			setContentFunctions();
			setButtons();
		}

		private function setContentFunctions() : void
		{
			numInst = view.content_mc.totalFrames;
			setInst(1);
		}

		private function setInst(num : int) : void
		{
			if (num < 1 || num > numInst)
				return;
			currInst = num;
			view.content_mc.gotoAndStop(num);

			view.btn_left.visible = true;
			view.btn_right.visible = true;
			if (num == 1)
				view.btn_left.visible = false;
			if (num == numInst)
				view.btn_right.visible = false;
		}

		private function setButtons() : void
		{
			BtnUtils.onClick(view.btn_play, goPlay);
			BtnUtils.onClick(view.btn_left, prevInst);
			BtnUtils.onClick(view.btn_right, nextInst);
		}

		private function prevInst(e:MouseEvent) : void
		{
			setInst(currInst-1);
		}
		
		private function nextInst(e:MouseEvent) : void
		{
			setInst(currInst+1);
		}

		private function goPlay(e : MouseEvent) : void
		{
			trace("InstructionsScreen.goPlay(e)");
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
	}
}
