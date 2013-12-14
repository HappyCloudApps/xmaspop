package com.myhappycloud.xpop.services
{
	import flash.geom.Vector3D;
	import com.myhappycloud.xpop.services.facebook.FBEvent;
	import com.facebook.graph.data.FacebookAuthResponse;
	import com.myhappycloud.xpop.events.NavEvent;
	import com.myhappycloud.xpop.services.facebook.FacebookPost;
	import com.myhappycloud.xpop.services.facebook.FriendObj;

	import org.robotlegs.mvcs.Actor;

	import flash.display.Bitmap;

	/**
	 * @author Eder
	 */
	public class FakeFBService extends Actor implements IFBService
	{
		private var currentSession : FacebookAuthResponse;
		private var sessionGot : Boolean;
		private var initializing : Boolean;
		private var initialized : Boolean = false;
		private var permissions : Array;

		public function init(... permissions) : void
		{
			trace("[FakeFBService::init()] ");
			this.permissions = permissions.concat();
			if (!initialized)
			{
				initialized = true;
				initializing = true;
				sessionGot = false;
				onInit(null, null);
			}
			else
			{
				trace("Already initialized");
			}
		}

		private function onInit(success : Object, fail : Object) : void
		{
			trace("[FakeFBService::onInit()] success: " + success + " | fail: " + fail);
			if (success)
			{
				saveSession(success);
				dispatch(new FBEvent(FBEvent.FB_GOT));
			}
			else
			{
				dispatch(new FBEvent(FBEvent.FB_FAIL));
			}
			initializing = false;
		}

		private function saveSession(success : Object) : void
		{
			trace("[FakeFBService::saveSession(success)] ");
			sessionGot = true;
			currentSession = new FacebookAuthResponse();
			currentSession.accessToken = "fake_token";
			// success.accessToken;
			currentSession.expireDate = new Date();
			// success.expireDate;
			currentSession.uid = "100001021987712" + "027";
			// success.uid;
			trace("accessToken: " + currentSession.accessToken);
			trace("expireDate: " + currentSession.expireDate);
			trace("uid: " + currentSession.uid);
		}

		public function login() : void
		{
			trace("[FakeFBService::login()] ");
			if (initializing)
			{
				trace("Wait please, FB is initializing");
				return;
			}

			if (sessionGot)
			{
				trace("Session already gotten");
				dispatch(new FBEvent(FBEvent.FB_GOT));
				return;
			}

			var perms : String = "";
			for (var i : int = 0; i < permissions.length; i++)
			{
				if (i < permissions.length - 1)
					perms += permissions[i] + ",";
				else
					perms += permissions[i];
			}
			trace('perms: ' + (perms));

			onLogin({accessToken:"fakeAccessToken", expireDate:new Date(), uid:"0001"}, {});
		}

		private function onLogin(success : Object, fail : Object) : void
		{
			trace("[FakeFBService::onLogin()] success: " + success + " | fail: " + fail);
			if (success)
			{
				saveSession(success);
				dispatch(new FBEvent(FBEvent.FB_GOT));
			}
			else
			{
				dispatch(new FBEvent(FBEvent.FB_FAIL));
			}
		}

		public function get uid() : String
		{
			return currentSession.uid;
		}

		public function loadFriends() : void
		{
			trace("FakeFBService.loadFriends()");
			dispatch(new FBEvent(FBEvent.FRIENDS_GOT));
		}

		public function get myPicUrl() : String
		{
			return "http://profile.ak.fbcdn.net/hprofile-ak-prn2/188012_168494531913_1842586405_q.jpg";
		}

		public function get myName() : String
		{
			return "Fake Name :)";
		}

		public function get myFirstName() : String
		{
			return "Fake";
		}

		public function get myLastName() : String
		{
			return "Name";
		}

		public function get myEmail() : String
		{
			return "fake@fake.com";
		}

		public function get myGender() : String
		{
			return "male";
		}

		public function get myBirthday() : String
		{
			return "1/1/1980";
		}

		public function postToWall(uid : String, fbPost : FacebookPost) : void
		{
			trace("[FakeFBService::postToWall(uid, fbPost)] ");
		}

		public function savePic(image : Bitmap, message : String, fileName : String) : void
		{
			trace("[FakeFBService::savePic(image, message, fileName)] ");
		}

		public function createAppAlbum(name : String, description : String) : void
		{
		}

		public function get lastPicUrl() : String
		{
			return "http://profile.ak.fbcdn.net/hprofile-ak-prn2/188012_168494531913_1842586405_q.jpg";
		}

		public function inviteFriends(friends : Array, fbPost : FacebookPost) : void
		{
		}

		public function set uid(str : String) : void
		{
		}

		public function set access_token(str : String) : void
		{
		}

		public function get friends() : Vector.<FriendObj>
		{
			var friends:Vector.<FriendObj>=new Vector.<FriendObj>()
			
			var f:FriendObj=new FriendObj();
			f.uid="eder";
			f.name="eder";
			f.picUrl="http://profile.ak.fbcdn.net/hprofile-ak-prn2/188012_168494531913_1842586405_q.jpg";
			f.score=12;
			friends.push(f);
			
			f=new FriendObj();
			f.uid="eder2";
			f.name="eder2";
			f.picUrl="http://profile.ak.fbcdn.net/hprofile-ak-prn2/188012_168494531913_1842586405_q.jpg";
			f.score=13;
			friends.push(f);
			
			f=new FriendObj();
			f.uid="eder3";
			f.name="eder3";
			f.picUrl="http://profile.ak.fbcdn.net/hprofile-ak-prn2/188012_168494531913_1842586405_q.jpg";
			f.score=13;
			friends.push(f);
			
			f=new FriendObj();
			f.uid="eder4";
			f.name="eder4";
			f.picUrl="http://profile.ak.fbcdn.net/hprofile-ak-prn2/188012_168494531913_1842586405_q.jpg";
			f.score=13;
			friends.push(f);
			
			f=new FriendObj();
			f.uid="eder5";
			f.name="eder5";
			f.picUrl="http://profile.ak.fbcdn.net/hprofile-ak-prn2/188012_168494531913_1842586405_q.jpg";
			f.score=13;
			friends.push(f);
			
			return friends;
		}
	}
}
