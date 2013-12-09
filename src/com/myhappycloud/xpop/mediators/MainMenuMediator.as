package com.myhappycloud.xpop.mediators
{
	import com.myhappycloud.xpop.events.NavEvent;
	import com.myhappycloud.xpop.models.AppStates;
	import com.myhappycloud.xpop.views.screens.MainMenuScreen;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eder
	 */
	public class MainMenuMediator extends Mediator
	{
		[Inject]
		public var view : MainMenuScreen;

		override public function onRegister() : void
		{
			trace("MainMenuMediator.onRegister()");
			view.open();
			view.playSignal.addOnce(goGame);
			view.instSignal.addOnce(goInst);
		}

		private function goInst() : void
		{
			trace("MainMenuMediator.goInst()");
			dispatch(new NavEvent(NavEvent.GO_TO, AppStates.INSTRUCTIONS));
		}

		private function goGame() : void
		{
			trace("MainMenuMediator.goGame()");
			dispatch(new NavEvent(NavEvent.GO_TO, AppStates.GAME));
		}
	}
}