package com.myhappycloud.xpop.models
{
	import com.myhappycloud.xpop.services.facebook.FriendObj;
	import com.myhappycloud.xpop.events.ModelEvent;
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
		private var _score : uint=0;
		private var _vol : int=1;
		private var fbName : String;
		private var fbPic : String;
		private var fbFriends : Vector.<FriendObj>;
		private var _highScore : uint=0;

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

		public function getVolume() : int
		{
			return _vol;
		}

		public function toggleVol() : void
		{
			if (_vol == 0)
				_vol = 1;
			else
				_vol = 0;

			dispatch(new ModelEvent(ModelEvent.SETTINGS_UPDATED, {}));
		}

		public function setFbData(name : String, avatarUrl : String) : void
		{
			this.fbPic = avatarUrl;
			this.fbName = name;
		}

		public function setFbFriends(friends : Vector.<FriendObj>) : void
		{
			this.fbFriends = friends;
		}

		public function getUserName() : String
		{
			return fbName;
		}

		public function getUserPic() : String
		{
			return fbPic;
		}

		public function setFriendScore(uid : String, score : int) : void
		{
			for (var i : int = 0; i < fbFriends.length; i++) 
			{
				if(fbFriends[i].uid==uid)
				{
					fbFriends[i].score=score;
					return;
				}
			}
		}

		public function getFriends() : Vector.<FriendObj>
		{
			return fbFriends;
		}

		public function setHighscore(score : uint) : void
		{
			_highScore = score;
		}

		public function getHighscore() : uint
		{
			return _highScore;
		}
	}
}
