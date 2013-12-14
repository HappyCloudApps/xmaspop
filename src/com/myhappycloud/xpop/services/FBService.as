package com.myhappycloud.xpop.services
{
	import com.facebook.graph.data.Batch;
	import com.myhappycloud.xpop.services.facebook.FriendObj;
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookAuthResponse;
	import com.myhappycloud.xpop.services.facebook.FBEvent;
	import com.myhappycloud.xpop.services.facebook.FacebookPost;

	import org.robotlegs.mvcs.Actor;

	import flash.display.Bitmap;

	/**
	 * @author Eder
	 */
	public class FBService extends Actor implements IFBService
	{
		private static const APP_ID : String = "1412692515634293";
		private var currentSession : FacebookAuthResponse;
		private var sessionGot : Boolean;
		private var initializing : Boolean;
		private var initialized : Boolean = false;
		private var permissions : Array;
		private var _access_token : String;
		private var friendsDataGot : Boolean;
		private var _myName : String;
		private var _myPicUrl : String;
		private var _myFirstName : String;
		private var _myLastName : String;
		private var _myEmail : String;
		private var _myGender : String;
		private var _myBirthday : String;
		private var _uid : String;
		private var albumId : String;
		private var _lastPicURL : String;
		private var _friends : Vector.<FriendObj>;

		public function init(... permissions) : void
		{
			trace("[FBService::init()] ");
			this.permissions = permissions.concat();
			checkFlashVars();

			if (!initialized)
			{
				initialized = true;
				initializing = true;
				sessionGot = false;
				Facebook.init(APP_ID, onInit);
			}
			else
			{
				trace("Already initialized");
			}
		}

		private function checkFlashVars() : void
		{
			trace("[FBService::checkFlashVars()] ");
			trace('access_token: ' + (_access_token));
			trace('uid: ' + (_uid));
			if (_access_token != null)
			{
				initialized = true;
				initializing = true;
				sessionGot = false;
				Facebook.init(APP_ID, null, null, _access_token);

				onInit({accessToken:_access_token, uid:uid}, null);
			}
		}

		private function onInit(success : Object, fail : Object) : void
		{
			trace("[FBService::onInit()] success: " + success + " | fail: " + fail);
			if (success)
			{
				saveSession(success);
				// dispatch(new AppEvent(AppEvent.LOGGED_IN));
				// dispatch(new FBEvent(FBEvent.FB_GOT));
				// trace('FBEvent.FB_GOT: ' + (FBEvent.FB_GOT));
			}
			else
			{
				dispatch(new FBEvent(FBEvent.FB_FAIL));
				trace('FBEvent.FB_FAIL: ' + (FBEvent.FB_FAIL));
			}
			initializing = false;
		}

		private function saveSession(success : Object) : void
		{
			trace("[FBService::saveSession(success)] ");
			sessionGot = true;
			currentSession = new FacebookAuthResponse();
			currentSession.accessToken = success.accessToken;
			// currentSession.expireDate = success.expireDate;
			currentSession.uid = String(success.uid);
			trace("accessToken: " + currentSession.accessToken);
			// trace("expireDate" + currentSession.expireDate);
			trace("uid: " + currentSession.uid);

			Facebook.api("me?fields=picture,first_name,last_name,email,gender,birthday&", myInfoGot);
		}

		private function myInfoGot(success : Object, fail : Object) : void
		{
			trace("[FBService::myInfoGot(success, fail)] ");
			_myName = success.first_name + " " + success.last_name;
			_myPicUrl = success.picture.data.url;
			_myFirstName = success.first_name;
			_myLastName = success.last_name;
			_myEmail = success.email;
			_myGender = success.gender;
			_myBirthday = success.birthday;
			dispatch(new FBEvent(FBEvent.FB_GOT));
			trace('FBEvent.FB_GOT: ' + (FBEvent.FB_GOT));
		}

		public function login() : void
		{
			trace("[FBService::login()] ");
			if (initializing)
			{
				trace("Wait please, FB is initializing");
				return;
			}

			if (sessionGot)
			{
				trace("Session already gotten");
				// dispatch(new NavEvent(NavEvent.FB_GOT));
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

			Facebook.login(onLogin, {scope:perms});
		}

		private function onLogin(success : Object, fail : Object) : void
		{
			trace("[FBService::onLogin()] success: " + success + " | fail: " + fail);
			if (success)
			{
				saveSession(success);
				dispatch(new FBEvent(FBEvent.FB_GOT));
				trace('FBEvent.FB_GOT: ' + (FBEvent.FB_GOT));
			}
			else
			{
				dispatch(new FBEvent(FBEvent.FB_FAIL));
				trace('FBEvent.FB_FAIL: ' + (FBEvent.FB_FAIL));
			}
		}

		public function get uid() : String
		{
			if (currentSession && currentSession.uid)
				return String(currentSession.uid);
			return _uid;
		}

		public function loadFriends() : void
		{
			if (!friendsDataGot)
				Facebook.api("me/friends?fields=picture,first_name,last_name&", friendsGot);
			else
			{
				dispatch(new FBEvent(FBEvent.FRIENDS_GOT));
			}
		}

		private function friendsGot(success : Object, fail : Object) : void
		{
			trace("FBService.friendsGot(success, fail)");

			if (success)
			{
				trace("[FBService::friendsGot(success, fail)] ");
				_friends = new Vector.<FriendObj>();
				;
				var friend : FriendObj;
				for each (var obj : Object in success)
				{
					// trace(obj);
					friend = new FriendObj();
					friend.name = obj.first_name;// + " " + obj.last_name;
					friend.nameFull = obj.first_name + " " + obj.last_name;
					friend.uid = obj.id;
					friend.picUrl = obj.picture.data.url;
					_friends.push(friend);
				}

				// friends.sortOn("name");
				friendsDataGot = true;

				dispatch(new FBEvent(FBEvent.FRIENDS_GOT));
			}
			else
			{
				trace("error", "facebook/obtener_amigos");
			}
		}

		public function postToWall(uid : String, fbPost : FacebookPost) : void
		{
			/*
			trace("[FBService::postToWall(uid, fbPost)] ");
			var fbData:Object = {};
			fbData.message = fbPost.message;
			fbData.picture = fbPost.pictureUrl;
			fbData.link = fbPost.link;
			fbData.caption = fbPost.caption;
			fbData.description = fbPost.description;
			Facebook.api("/" + uid + "/feed", postedToWall, fbData, "POST");
			 */
		}

		public function inviteFriends(friends : Array, fbPost : FacebookPost) : void
		{
			trace("[FBService::postToWall(uid, fbPost)] ");
			var fbData : Object = {};
			fbData.message = fbPost.message;
			fbData.picture = fbPost.pictureUrl;
			fbData.link = fbPost.link;
			fbData.caption = fbPost.caption;
			fbData.description = fbPost.description;
			// Facebook.api("/" + uid + "/feed", postedToWall, fbData, "POST");

			var currFriend : int = 0;
			var batchCount : int = 0;
			var batch : Batch = new Batch();
			while (currFriend < friends.length)
			{
				trace("[FBService::inviteFriends(friends, fbPost)] - added friend to batch");
				batch.add("/" + friends[currFriend] + "/feed", null, fbData, "POST");
				batchCount++;
				currFriend++;
				if (batchCount >= 20)
				{
					Facebook.batchRequest(batch, friendsInvited);
					batch = new Batch();
					batchCount = 0;
				}
			}
			if (batchCount > 0)
			{
				Facebook.batchRequest(batch, friendsInvited);
			}
		}

		private function friendsInvited(success : Object) : void
		{
			trace('success: ' + (success));
			if (success)
			{
				trace("[FBService::friendsInvited(success, fail)] - posted batch");
			}
			else
			{
				trace("[FBService::friendsInvited(success, fail)] - ERROR posting batch!");
			}
		}

		private function postedToWall(success : Object, fail : Object) : void
		{
			/*
			if (success)
			{
			trace("[FBService::postedToWall(success, fail)] - posted to wall");
			dispatch(new AppEvent(AppEvent.POSTED_TO_FACEBOOK));
			}
			else
			{
			dispatch(new TrackEvent(TrackEvent.TRACK, "error", "facebook/publicar_a_muro"));
			trace("[FBService::postedToWall(success, fail)] - ERROR posting to wall!");
			}
			 * 
			 */
		}

		public function savePic(image : Bitmap, message : String, fileName : String) : void
		{
			/*
			trace("[FBService::savePic(image, message, fileName)] " + 'albumId: ' + (albumId));
			picToSave = {message:message, fileName:fileName, image:image};
			// Facebook.api(albumId + "/photos", picUploaded, picToSave, 'POST');
			Facebook.api("me/photos", picUploaded, picToSave, 'POST');
			 * 
			 */
		}

		private function albumsGot(success : Object, fail : Object) : void
		{
			trace("[FBService::albumsGot(success, fail)] ");
			trace('success: ' + (success));
			trace('fail: ' + (fail));
		}

		private function albumCreated(success : Object, fail : Object) : void
		{
			trace("[FBService::albumCreated(success, fail)] ");
			trace('success: ' + (success));
			trace('fail: ' + (fail));
			if (success)
			{
				albumId = success.id;
			}
		}

		private function picUploaded(success : Object, fail : Object) : void
		{
			/*
			trace("[FBService::picUploaded(success, fail)] ");
			trace('success: ' + (success));
			trace('fail: ' + (fail));
			if (success)
			{
			trace("[FBService::picUploaded(response, fail)] - posted to album");
			dispatch(new AppEvent(AppEvent.POSTED_TO_FB_ALBUM));
			_lastPicURL = "http://facebook.com/" + success.id;
			}
			else
			{
			dispatch(new TrackEvent(TrackEvent.TRACK, "error", "facebook/publicar_a_album"));
			trace("[FBService::picUploaded(success, fail)] - Error posting pic to album: ");
			for each (var i : * in fail)
			{
			trace(i);
			}
			}
			 * 
			 */
		}

		public function createAppAlbum(name : String, description : String) : void
		{
			// Facebook.api("me/albums", albumsGot, null, 'GET');
			// Facebook.api('/me/albums', albumCreated, {name:name, message:description}, URLRequestMethod.POST);
		}

		public function get myPicUrl() : String
		{
			return _myPicUrl;
		}

		public function get myName() : String
		{
			return _myName;
		}

		public function get myFirstName() : String
		{
			return _myFirstName;
		}

		public function get myLastName() : String
		{
			return _myLastName;
		}

		public function get myEmail() : String
		{
			return _myEmail;
		}

		public function get myGender() : String
		{
			return _myGender;
		}

		public function get myBirthday() : String
		{
			return _myBirthday;
		}

		public function get lastPicUrl() : String
		{
			return _lastPicURL;
		}

		public function set uid(str : String) : void
		{
			_uid = str;
		}

		public function set access_token(str : String) : void
		{
			_access_token = str;
		}

		public function get friends() : Vector.<FriendObj>
		{
			if (!_friends)
				_friends = new Vector.<FriendObj>();
			return _friends;
		}
	}
}
