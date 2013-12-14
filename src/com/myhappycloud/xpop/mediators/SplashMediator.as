package com.myhappycloud.xpop.mediators
{
	import com.myhappycloud.xpop.events.NavEvent;
	import com.myhappycloud.xpop.models.AppStates;
	import com.myhappycloud.xpop.views.screens.SplashScreen;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eder
	 */
	public class SplashMediator extends Mediator
	{
		[Inject]
		public var view : SplashScreen;

		override public function onRegister() : void
		{
			trace("SplashMediator.onRegister()");
			view.open();
			view.gomenu.addOnce(dispatchMenu);
			view.soundsLoaded.addOnce(dispatchSounds);
		}

		private function dispatchSounds() : void
		{
			dispatch(new NavEvent(NavEvent.SETUP_SOUNDS, ""));
		}

		private function dispatchMenu() : void
		{
			dispatch(new NavEvent(NavEvent.GO_TO, AppStates.MAIN_MENU));
		}
	}
}