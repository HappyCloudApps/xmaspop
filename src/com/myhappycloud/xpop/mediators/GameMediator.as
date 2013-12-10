package com.myhappycloud.xpop.mediators
{
	import com.myhappycloud.xpop.events.ModelEvent;
	import com.myhappycloud.xpop.models.AppStates;
	import com.myhappycloud.xpop.events.NavEvent;
	import com.myhappycloud.xpop.views.screens.GameScreen;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eder
	 */
	public class GameMediator extends Mediator
	{
		[Inject]
		public var view : GameScreen;

		override public function onRegister() : void
		{
			trace("GameMediator.onRegister()");
			view.open();
			view.gameOverSignal.addOnce(goGameOver);
		}

		private function goGameOver() : void
		{
			trace("GameMediator.goGameOver()");
			var data:Object = new Object();
			data.score = view.score;
			dispatch(new ModelEvent(ModelEvent.SET_SCORE, data));
			dispatch(new NavEvent(NavEvent.GO_TO, AppStates.GAME_OVER));
		}
	}
}