package com.myhappycloud.xpop.mediators
{
	import com.myhappycloud.xpop.models.IAppVars;
	import com.myhappycloud.xpop.events.ScreenEvent;
	import com.myhappycloud.xpop.views.ScreensContainer;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * @author Eder
	 */
	public class ScreensContainerMediator extends Mediator
	{
		[Inject]
		public var view : ScreensContainer;
		[Inject]
		public var model : IAppVars;
		
		override public function onRegister() : void
		{
			trace("ScreensContainerMediator.onRegister()");
			view.init();
			eventMap.mapListener(eventDispatcher, ScreenEvent.UPDATE_SCREEN, update, ScreenEvent);
		}

		private function update(e:ScreenEvent) : void
		{
			trace("ScreensContainerMediator.update(e)");
			view.update(model.getState());
		}

	}
}