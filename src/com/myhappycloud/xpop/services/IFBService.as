package com.myhappycloud.xpop.services
{
	import com.myhappycloud.xpop.services.facebook.FriendObj;
	import com.myhappycloud.xpop.services.facebook.FacebookPost;

	/**
	 * @author Eder
	 */
	public interface IFBService
	{
		function init(... permissions) : void;

		function login() : void;

		function loadFriends() : void;

		function postToWall(uid : String, fbPost : FacebookPost) : void;

		function get uid() : String;

		function get myPicUrl() : String;

		function get myName() : String;

		function get myFirstName() : String;

		function get myLastName() : String;

		function get myEmail() : String;

		function get myGender() : String;

		function get myBirthday() : String;

		function get friends() : Vector.<FriendObj>;

		function get lastPicUrl() : String;

		function set uid(str : String) : void;

		function set access_token(str : String) : void;

		function inviteFriends(friends : Array, fbPost : FacebookPost) : void;
	}
}
