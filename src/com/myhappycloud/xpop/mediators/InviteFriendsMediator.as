package com.myhappycloud.xpop.mediators
{
	import com.myhappycloud.xpop.services.facebook.FacebookPost;
	import com.myhappycloud.xpop.services.IFBService;
	import com.myhappycloud.xpop.services.FBService;
	import com.myhappycloud.xpop.services.facebook.FBEvent;
	import com.myhappycloud.xpop.events.XPopDataEvent;
	import flash.events.MouseEvent;

	import com.myhappycloud.xpop.services.facebook.FriendObj;
	import com.myhappycloud.xpop.models.IAppVars;
	import com.myhappycloud.xpop.views.InviteFriendsView;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Eder
	 */
	public class InviteFriendsMediator extends Mediator
	{
		[Inject]
		public var view : InviteFriendsView;
		[Inject]
		public var model : IAppVars;
		[Inject]
		public var fb : IFBService;

		override public function onRegister() : void
		{
			trace("InviteFriendsMediator.onRegister()");
			view.initialize();

			var friends : Vector.<FriendObj> = model.getFriends();
			var fParsed : Array = [];

			for (var i : int = 0; i < friends.length; i++)
			{
				if (friends[i].uid != "hc")
					fParsed.push(friends[i]);
			}

			view.setupFriends(fParsed, [], []);
			view.backSignal.addOnce(close);
			view.inviteSignal.addOnce(invite);

			view.open();
		}

		private function invite(data:Object) : void
		{
			var fbPost:FacebookPost = new FacebookPost();
			fbPost.message = data.message;
			if(fbPost.message=="")
			{
				fbPost.message = "Te reto a superarme en Xmas Pop. Entra e intenta superar mi puntaje.";
			}
			
			fbPost.link = "http://apps.facebook.com/xmaspop/";
			fbPost.caption = "Happy Cloud";
			fbPost.description = "¡Diviértete acomodando adornos navideños, mejora tu record y compite con tus amigos.";
			fbPost.pictureUrl = "http://myhappycloud.com.mx/xmaspop/thumb.png";
			
			fb.inviteFriends(data.friends, fbPost);
			view.close();
		}

		private function close(e : MouseEvent) : void
		{
			trace("InviteFriendsMediator.close()");
			view.close();
			view.closedSignal.addOnce(kill);
		}

		private function kill() : void
		{
			trace("InviteFriendsMediator.kill()");
			view.parent.removeChild(view);
		}
	}
}