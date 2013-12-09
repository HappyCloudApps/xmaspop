package com.myhappycloud.xpop.mediators
{
	import com.myhappycloud.xpop.models.AppStates;
	import com.myhappycloud.xpop.events.NavEvent;
	import com.myhappycloud.xpop.views.screens.GameOverScreen;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eder
	 */
	public class GameOverMediator extends Mediator
	{
		[Inject]
		public var view : GameOverScreen;

		override public function onRegister() : void
		{
			trace("GameOverMediator.onRegister()");
			view.open();
			view.playSignal.addOnce(goPlay);
			view.instSignal.addOnce(goInst);
		}

		private function goInst() : void
		{
			dispatch(new NavEvent(NavEvent.GO_TO, AppStates.INSTRUCTIONS));
		}

		private function goPlay() : void
		{
			dispatch(new NavEvent(NavEvent.GO_TO, AppStates.GAME));
		}
	}
}