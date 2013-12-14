package com.myhappycloud.xpop.services
{
	/**
	 * @author Eder
	 */
	public interface IDataService
	{
		function saveUserData(uid : String, email : String, firstName : String, lastName : String, gender : String, birthday : String) : void;

		function saveUserScore(uid : String, score : int, magicKey : String) : void;

		function getUserScore(uid : String) : void;

		function getFriendsScore(uids : Array) : void;
	}
}
