package com.myhappycloud.xpop.services
{
	import com.myhappycloud.xpop.events.XPopDataEvent;
	import flash.net.Responder;
	import flash.net.NetConnection;

	import org.robotlegs.mvcs.Actor;

	/**
	 * @author Eder
	 */
	public class DataService extends Actor implements IDataService
	{
		public function saveUserData(uid : String, email : String, firstName : String, lastName : String, gender : String, birthday : String) : void
		{
			trace("DataService.saveUserData(uid, email, firstName, lastName, gender, birthday)");
			var netConnection : NetConnection = new NetConnection();
			var responder : Responder = new Responder(userSaved, null);
			netConnection.connect("http://myhappycloud.com.mx/services/Amfphp/");
			netConnection.call("XmasPop/saveUserInfo", responder, uid, email, firstName, lastName, gender, birthday);
		}

		private function userSaved(result : Object) : void
		{
			trace("DataService.userSaved(result)"+result);
			dispatch(new XPopDataEvent(XPopDataEvent.USER_SAVED, result));
		}

		public function saveUserScore(uid : String, score : int, magicKey : String) : void
		{
			trace("DataService.saveUserScore(uid, score, magicKey)");
			var netConnection : NetConnection = new NetConnection();
			var responder : Responder = new Responder(scoreSaved, null);
			netConnection.connect("http://myhappycloud.com.mx/services/Amfphp/");
			netConnection.call("XmasPop/saveScore", responder, uid, score, magicKey);
		}

		private function scoreSaved(result : Object) : void
		{
			trace("DataService.scoreSaved(result) " + result);
			dispatch(new XPopDataEvent(XPopDataEvent.SCORE_SAVED, result));
		}

		public function getUserScore(uid : String) : void
		{
			trace("DataService.saveUserScore(uid, score, magicKey)");
			var netConnection : NetConnection = new NetConnection();
			var responder : Responder = new Responder(scoreGot, null);
			netConnection.connect("http://myhappycloud.com.mx/services/Amfphp/");
			netConnection.call("XmasPop/getScore", responder, uid);
		}

		private function scoreGot(result : Object) : void
		{
			trace("DataService.scoreGot(result) " + result);
			dispatch(new XPopDataEvent(XPopDataEvent.MY_SCORE, result));
		}

		public function getFriendsScore(uids : Array) : void
		{
			trace("DataService.getFriendsScore(uids)");
			var netConnection : NetConnection = new NetConnection();
			var responder : Responder = new Responder(friendScoreGot, null);
			netConnection.connect("http://myhappycloud.com.mx/services/Amfphp/");
			netConnection.call("XmasPop/getFriendsScore", responder, uids);
		}

		private function friendScoreGot(result : Object) : void
		{
			trace("DataService.friendScoreGot(result)"+result);
			dispatch(new XPopDataEvent(XPopDataEvent.FRIENDS_SCORES, result));
		}
	}
}
