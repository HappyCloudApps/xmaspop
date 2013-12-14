package com.myhappycloud.xpop.mediators
{
	import com.myhappycloud.xpop.services.IFBService;
	import flashx.textLayout.edit.ModelEdit;

	import com.myhappycloud.xpop.models.IAppVars;
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
		[Inject]
		public var fb : IFBService;
		[Inject]
		public var model : IAppVars;

		override public function onRegister() : void
		{
			trace("GameMediator.onRegister()");
			view.open();
			view.setVol(model.getVolume());
			view.gameOverSignal.addOnce(goGameOver);
			view.toggleVolSignal.add(toggleVolume);
			view.setScores(model.getFriends(), fb.myFirstName, fb.myPicUrl, model.getHighscore());

			eventMap.mapListener(eventDispatcher, ModelEvent.SETTINGS_UPDATED, updateVol, ModelEvent);
		}

		private function updateVol(e : ModelEvent) : void
		{
			trace("GameMediator.updateVol(e)");
			view.setVol(model.getVolume());
		}

		private function toggleVolume() : void
		{
			trace("GameMediator.toggleVolume()");
			dispatch(new ModelEvent(ModelEvent.TOGGLE_VOLUME, {}));
		}

		private function goGameOver() : void
		{
			trace("GameMediator.goGameOver()");
			var data : Object = new Object();
			data.score = view.score;
			dispatch(new ModelEvent(ModelEvent.SET_SCORE, data));
			dispatch(new NavEvent(NavEvent.GO_TO, AppStates.GAME_OVER));
		}
	}
}