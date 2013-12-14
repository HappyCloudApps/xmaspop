package com.myhappycloud.xpop.models
{
	import com.myhappycloud.xpop.services.facebook.FriendObj;

	/**
	 * @author Eder
	 */
	public interface IAppVars
	{
		function setState(splash : String) : void;

		function getState() : String;

		function setScore(score : uint) : void;

		function getScore() : uint;

		function getVolume() : int;

		function toggleVol() : void;

		function setFbData(name : String, avatarUrl : String) : void;

		function setFbFriends(friends : Vector.<FriendObj>) : void;

		function getUserName() : String;

		function getUserPic() : String;

		function setFriendScore(uid : String, score : int) : void;

		function getFriends() : Vector.<FriendObj>;

		function setHighscore(score : uint) : void;

		function getHighscore() : uint;
	}
}
