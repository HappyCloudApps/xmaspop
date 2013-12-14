package com.myhappycloud.xpop.views.screens
{
	import com.facebook.graph.Facebook;
	import assets.FriendScore;
	import assets.GameOverView;

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.data.TweenMaxVars;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.grupow.events.ViewEvent;
	import com.myhappycloud.xpop.services.facebook.FriendObj;
	import com.myhappycloud.xpop.utils.BtnUtils;
	import com.myhappycloud.xpop.utils.Scroller;
	import com.myhappycloud.xpop.utils.XpopSounds;
	import com.myhappycloud.xpop.views.IScreen;
	import com.myhappycloud.xpop.views.InviteFriendsView;
	import com.reintroducing.sound.SoundManager;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Eder
	 */
	public class GameOverScreen extends MovieClip implements IScreen
	{
		private var _closeSignal : Signal;
		private var view : GameOverView;
		private var _instSignal : Signal;
		private var _playSignal : Signal;
		private var _friends : Array;
		private var scoreFriendsArray : Array;
		private var picUrl : String;
		private var myName : String;
		private var myScore : uint;
		private var myScoreMc : FriendScore;
		private var scroller : Scroller;
		private var myHighScore : uint = 0;

		public function GameOverScreen()
		{
			trace("GameOverScreen.GameOverScreen()");
			_closeSignal = new Signal();
			_playSignal = new Signal();
			_instSignal = new Signal();

			view = new GameOverView();
			addChild(view);

			var sm : SoundManager = SoundManager.getInstance();
			sm.stopAllSounds();
			sm.playSound(XpopSounds.SLAM);
			sm.playSound(XpopSounds.GAME_OVER_LOOP);

			// view.loop_mc.addEventListener(Event.ENTER_FRAME, updateLooping);
		}

		// private function updateLooping(e : Event) : void
		// {
		// view.loop_mc.rotation -= 0.1;
		// }
		public function get mc() : MovieClip
		{
			return this;
		}

		public function close() : void
		{
			// view.loop_mc.removeEventListener(Event.ENTER_FRAME, updateLooping);
			_closeSignal.dispatch();
		}

		public function open() : void
		{
			setButtons();
		}

		private function setButtons() : void
		{
			BtnUtils.onClick(view.btn_play, goPlay);
			BtnUtils.onClick(view.btn_inst, goInst);
			BtnUtils.onClick(view.btn_invite, showInviteFriends);
		}

		private function showInviteFriends(e : MouseEvent) : void
		{
			var fbPost : Object = new Object();
			fbPost.message = "Te reto a superarme en Xmas Pop. Entra e intenta superar mi puntaje.";
			fbPost.link = "http://apps.facebook.com/xmaspop/";
			fbPost.caption = "Happy Cloud";
			fbPost.description = "¡Diviértete acomodando adornos navideños, mejora tu record y compite con tus amigos.";
			fbPost.pictureUrl = "http://myhappycloud.com.mx/xmaspop/thumb.png";
			Facebook.ui("apprequests", fbPost);
//			addChild(new InviteFriendsView());
		}

		private function goInst(e : MouseEvent) : void
		{
			_instSignal.dispatch();
		}

		private function goPlay(e : MouseEvent) : void
		{
			_playSignal.dispatch();
		}

		public function get closeSignal() : Signal
		{
			return _closeSignal;
		}

		public function get playSignal() : Signal
		{
			return _playSignal;
		}

		public function get instSignal() : Signal
		{
			return _instSignal;
		}

		public function setScore(score : uint, getHighscore : uint) : void
		{
			myHighScore = getHighscore;
			myScore = score;
			view.score_txt.text = String(score);
		}

		public function setName(_name : String) : void
		{
			myName = _name;
			view.name_txt.text = _name;
		}

		public function setAvatar(_url : String) : void
		{
			picUrl = _url;
			view.avatar_mc.alpha = 0;
			while (view.avatar_mc.numChildren > 0)
				view.avatar_mc.removeChildAt(0);
			var vars : ImageLoaderVars = new ImageLoaderVars();

			vars.onComplete(showAvatar);
			vars.container(view.avatar_mc);

			var imgLoader : ImageLoader = new ImageLoader(_url, vars);
			imgLoader.load();
		}

		private function showAvatar(e : LoaderEvent) : void
		{
			var vars : TweenMaxVars = new TweenMaxVars();
			vars.scaleX(1);
			vars.scaleY(1);
			vars.autoAlpha(1);

			TweenMax.to(view.avatar_mc, .5, vars);
		}

		public function setScores(friends : Vector.<FriendObj>) : void
		{
			_friends = [];

			BtnUtils.clearMc(view.score_container_mc);
			scoreFriendsArray = [];
			for (var i : int = 0; i < friends.length; i++)
			{
				if (friends[i].score > -1)
					scoreFriendsArray.push(friends[i]);
				if (friends[i].uid != "hc")
					_friends.push(friends[i]);
			}

			var me : FriendObj = new FriendObj();
			me.name = myName;
			me.picUrl = picUrl;
			if (myHighScore < myScore)
				me.score = myScore;
			else
				me.score = myHighScore;

			scoreFriendsArray.push(me);
			scoreFriendsArray.sortOn("score", Array.NUMERIC | Array.DESCENDING);

			var friendMc : FriendScore;
			for (i = 0; i < scoreFriendsArray.length; i++)
			{
				friendMc = new FriendScore();
				friendMc.name_txt.text = scoreFriendsArray[i].name;
				friendMc.score_txt.text = scoreFriendsArray[i].score;
				BtnUtils.clearMc(friendMc.avatar_mc);
				var imgLoader : ImageLoader = new ImageLoader(scoreFriendsArray[i].picUrl, {container:friendMc.avatar_mc});
				imgLoader.load();

				friendMc.x = 0;
				friendMc.y = i * 65;
				view.score_container_mc.addChild(friendMc);

				if (scoreFriendsArray[i] == me)
				{
					myScoreMc = friendMc;
					myScoreMc.gotoAndStop(2);
				}
			}

			view.score_container_mc.cacheAsBitmap = true;
			view.mask_mc.cacheAsBitmap = true;
			view.score_container_mc.mask = view.mask_mc;

			setScroller();
			setScoresY();
		}

		private function setScroller() : void
		{
			trace("GameOverScreen.setScroller()");
			scroller = new Scroller(view.scroller_mc, view.score_container_mc);
		}

		private function setScoresY() : void
		{
			trace("GameScreen.setScoresY()");
			var targetY : Number = -myScoreMc.y + 260 + 120;
			trace('targetY: ' + (targetY));
			if (targetY > 260)
			{
				targetY = 260;
			}

			// TweenLite.to(view.scores_container_mc, .3, {y:targetY});
			scroller.targetY = targetY;
		}
	}
}
