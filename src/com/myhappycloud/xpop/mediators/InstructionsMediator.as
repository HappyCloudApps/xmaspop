package com.myhappycloud.xpop.mediators
{
	import com.myhappycloud.xpop.models.AppStates;
	import com.myhappycloud.xpop.events.NavEvent;
	import com.myhappycloud.xpop.views.screens.InstructionsScreen;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eder
	 */
	public class InstructionsMediator extends Mediator
	{
		[Inject]
		public var view : InstructionsScreen;

		override public function onRegister() : void
		{
			trace("InstructionsMediator.onRegister()");
			view.open();
			view.playSignal.addOnce(goPlay);
		}

		private function goPlay() : void
		{
			dispatch(new NavEvent(NavEvent.GO_TO, AppStates.GAME));
		}
	}
}