package com.myhappycloud.xpop.models
{
	import com.myhappycloud.xpop.events.ScreenEvent;

	import stateMachine.StateMachineEvent;
	import stateMachine.StateMachine;

	import org.robotlegs.mvcs.Actor;

	/**
	 * @author Eder
	 */
	public class AppModel extends Actor implements IAppVars
	{
		private var sMachine : StateMachine;
		private var _score : uint;

		public function AppModel()
		{
			trace("AppModel.AppModel()");
			sMachine = new StateMachine();

			sMachine.addState(AppStates.EMPTY);
			sMachine.addState(AppStates.SPLASH, {from:AppStates.EMPTY});
			sMachine.addState(AppStates.MAIN_MENU);
			sMachine.addState(AppStates.INSTRUCTIONS, {from:[AppStates.MAIN_MENU, AppStates.GAME_OVER]});
			sMachine.addState(AppStates.GAME, {from:[AppStates.INSTRUCTIONS, AppStates.MAIN_MENU, AppStates.GAME_OVER]});
			sMachine.addState(AppStates.GAME_OVER, {from:AppStates.GAME});

			sMachine.initialState = AppStates.EMPTY;

			sMachine.addEventListener(StateMachineEvent.TRANSITION_DENIED, transitionDeniedFunction);
			sMachine.addEventListener(StateMachineEvent.TRANSITION_COMPLETE, transitionCompleteFunction);
		}

		private function transitionDeniedFunction(e : StateMachineEvent) : void
		{
			trace("AppModel.transitionDeniedFunction(e)");
		}

		private function transitionCompleteFunction(e : StateMachineEvent) : void
		{
			trace("AppModel.transitionCompleteFunction(e)");
			dispatch(new ScreenEvent(ScreenEvent.UPDATE_SCREEN));
		}

		public function setState(state : String) : void
		{
			trace("AppModel.setState(state) - " + state);
			sMachine.changeState(state);
		}

		public function getState() : String
		{
			return sMachine.state;
		}

		public function setScore(score : uint) : void
		{
			_score = score;
		}
		
		public function getScore() : uint
		{
			return _score;
		}
	}
}
