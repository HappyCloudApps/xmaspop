package com.myhappycloud.xpop.views.screens
{
	import com.facebook.graph.Facebook;

	import flash.utils.setTimeout;

	import assets.FriendScore;
	import assets.GameView;

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.loading.ImageLoader;
	import com.myhappycloud.xpop.services.facebook.FriendObj;
	import com.myhappycloud.xpop.utils.BtnUtils;
	import com.myhappycloud.xpop.utils.XpopSounds;
	import com.myhappycloud.xpop.views.IScreen;
	import com.myhappycloud.xpop.views.InviteFriendsView;
	import com.myhappycloud.xpop.views.game.GemsGame;
	import com.myhappycloud.xpop.views.game.VolumeBtn;
	import com.reintroducing.sound.SoundManager;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Eder
	 */
	public class GameScreen extends MovieClip implements IScreen
	{
		private var _closeSignal : Signal;
		private var _gameOverSignal : Signal;
		private var view : GameView;
		private var gameController : GemsGame;
		private var _score : int;
		private var _toggleVolSignal : Signal;
		private var volBtn : VolumeBtn;
		private var friendsArray : Array;
		private var myScoreMc : FriendScore;
		private var friendMcs : Array;
		private var hurry : Boolean = false;
		private var scoreGrowness : int = 0;

		public function GameScreen()
		{
			trace("GameScreen.GameScreen()");
			_closeSignal = new Signal();
			_gameOverSignal = new Signal();
			_toggleVolSignal = new Signal();

			view = new GameView();
			addChild(view);

			reset();

			BtnUtils.onClick(view.btn_pause, pauseGame);
			BtnUtils.onClick(view.btn_restart, restartGame);
			BtnUtils.onClick(view.btn_mute, muteSound);
			BtnUtils.onClick(view.btn_invite, openInvite);

			BtnUtils.onClick(view.pause_mc.btn_resume, resumeGame);
			BtnUtils.onClick(view.pause_mc.btn_retry, restartGame);

			volBtn = new VolumeBtn(view.btn_mute);

			view.loop_mc.addEventListener(Event.ENTER_FRAME, updateLooping);

			var sm : SoundManager = SoundManager.getInstance();
			sm.fadeSound(XpopSounds.GAME_OVER_LOOP, 0, 1, true);
			sm.fadeSound(XpopSounds.INTRO_LOOP, 0, 1, true);
		}

		private function openInvite(e : MouseEvent) : void
		{
			var fbPost : Object = new Object();
			fbPost.message = "Te reto a superarme en Xmas Pop. Entra e intenta conseguir mas puntos que yo.";
			fbPost.link = "http://apps.facebook.com/xmaspop/";
			fbPost.caption = "Happy Cloud";
			fbPost.description = "¡Diviértete acomodando adornos navideños, mejora tu record y compite con tus amigos.";
			fbPost.pictureUrl = "http://myhappycloud.com.mx/xmaspop/thumb.png";
			Facebook.ui("apprequests", fbPost);
			pauseGame(e);
//			addChild(new InviteFriendsView());
		}

		private function updateLooping(e : Event) : void
		{
			// view.loop_mc.rotation -= 0.1;
			var targetScale : Number = (1 + scoreGrowness / 20) - view.score_mc.scaleX;
			view.score_mc.scaleX += targetScale / 10;
			view.score_mc.scaleY += targetScale / 10;
			scoreGrowness -= Math.ceil(scoreGrowness / 10);
			if (scoreGrowness < 0)
				scoreGrowness = 0;
		}

		private function resumeGame(e : MouseEvent) : void
		{
			trace("GameScreen.resumeGame(e)");
			gameController.resume();
			view.pause_mc.visible = false;
			var sm : SoundManager = SoundManager.getInstance();
			if (sm.isSoundPaused(XpopSounds.GAME_LOOP))
			{
				sm.stopSound(XpopSounds.GAME_LOOP);
				sm.playSound(XpopSounds.GAME_LOOP, 1, 0, 999999);
				sm.stopSound(XpopSounds.GAME_LOOP);
				sm.playSound(XpopSounds.GAME_LOOP, 1, 0, 999999);
			}
			else if (sm.isSoundPaused(XpopSounds.GAME_HURRY_LOOP))
			{
				sm.stopSound(XpopSounds.GAME_HURRY_LOOP);
				sm.playSound(XpopSounds.GAME_HURRY_LOOP, 1, 0, 999999);
				sm.stopSound(XpopSounds.GAME_HURRY_LOOP);
				sm.playSound(XpopSounds.GAME_HURRY_LOOP, 1, 0, 999999);
			}
		}

		private function muteSound(e : MouseEvent) : void
		{
			trace("GameScreen.muteSound(e)");
			_toggleVolSignal.dispatch();
		}

		private function restartGame(e : MouseEvent) : void
		{
			trace("GameScreen.restartGame()");
			reset();
			waitThenStart();
			// gameController.start();
		}

		private function reset() : void
		{
			trace("GameScreen.reset()");
			while (view.container_mc.numChildren > 0)
				view.container_mc.removeChildAt(0);

			view.pause_mc.visible = false;

			if (gameController)
			{
				gameController.updateScoreSignal.removeAll();
				gameController.updateTimeSignal.removeAll();
				gameController.gameOverSignal.removeAll();
			}

			gameController = new GemsGame(view.container_mc);
			gameController.updateScoreSignal.add(updateScore);
			gameController.updateTimeSignal.add(updateTime);
			gameController.gameOverSignal.addOnce(gameOver);
		}

		private function pauseGame(e : MouseEvent) : void
		{
			trace("GameScreen.pauseGame(e)");
			gameController.pause();
			var sm : SoundManager = SoundManager.getInstance();
			sm.pauseAllSounds();
			view.pause_mc.visible = true;
		}

		private function updateScore(score : int) : void
		{
			view.score_mc.score_txt.text = String(score);
			if (score == _score)
				return;

			scoreGrow(score - _score);

			_score = score;

			var sm : SoundManager = SoundManager.getInstance();
			sm.playSound(XpopSounds.SCORE_UP);

			myScoreMc.score = score;
			myScoreMc.score_txt.text = String(score);

			var oldY : Number = myScoreMc.y;

			friendMcs.sortOn("score", Array.NUMERIC | Array.DESCENDING);

			var friendMc : FriendScore;
			for (var i : int = 0; i < friendMcs.length; i++)
			{
				friendMc = friendMcs[i];
				friendMc.oldY = friendMc.y;
				friendMc.y = i * 65;
			}
			if (myScoreMc.y != oldY)
			{
				setScoresY();

				for (var j : int = 0; j < friendMcs.length; j++)
				{
					friendMc = friendMcs[j];
					TweenLite.from(friendMc, .3, {y:friendMc.oldY})
					// friendMc.oldY = friendMc.y;
					// friendMc.y = i * 65;
				}

				// var sm : SoundManager = SoundManager.getInstance();
				sm.playSound(XpopSounds.GOING_UP);
			}
		}

		private function scoreGrow(i : int) : void
		{
			scoreGrowness += i;
		}

		private function updateTime(time : int) : void
		{
			view.time_mc.time_txt.text = String(time);
			if (time < 15)
				hurryUp();
			else
				youGotTime();
		}

		private function youGotTime() : void
		{
			if (hurry)
			{
				hurry = false;
				TweenLite.killTweensOf(view.time_mc);
				TweenLite.to(view.time_mc, .5, {scaleX:1, scaleY:1});

				var sm : SoundManager = SoundManager.getInstance();
				sm.fadeSound(XpopSounds.GAME_HURRY_LOOP, 0, 1, true);
				sm.playSound(XpopSounds.GAME_LOOP, 0, 0, 9999999);
				sm.fadeSound(XpopSounds.GAME_LOOP, 1, 1);
			}
		}

		private function hurryUp() : void
		{
			if (!hurry)
			{
				hurry = true;
				var sm : SoundManager = SoundManager.getInstance();
				sm.fadeSound(XpopSounds.GAME_LOOP, 0, 1, true);
				sm.playSound(XpopSounds.GAME_HURRY_LOOP, 0, 0, 9999999);
				sm.fadeSound(XpopSounds.GAME_HURRY_LOOP, 1, 1);
				clockBig();
			}
		}

		private function clockBig() : void
		{
			TweenLite.to(view.time_mc, .5, {scaleX:1.2, scaleY:1.2, onComplete:clockSmall});
		}

		private function clockSmall() : void
		{
			TweenLite.to(view.time_mc, .5, {scaleX:1, scaleY:1, onComplete:clockBig});
		}

		public function get mc() : MovieClip
		{
			return this;
		}

		public function close() : void
		{
			_closeSignal.dispatch();
		}

		public function open() : void
		{
			waitThenStart();
		}

		private function waitThenStart() : void
		{
			view.mouseChildren = view.mouseEnabled = false;

			view.container_mc.visible = false;
			view.num_mc.visible = true;
			view.num_mc.alpha = 1;
			view.num_mc.num_txt.text = "";

			var sm : SoundManager = SoundManager.getInstance();
			sm.stopAllSounds();

			trace("GameScreen.waitThenStart()");
			setTimeout(startCount, 700);
		}

		private function startCount() : void
		{
			view.num_mc.num_txt.text = "3";
			view.addChild(view.num_mc);
			TweenLite.to(view.num_mc, .7, {scaleX:1.2, scaleY:1.2, alpha:0.1, onComplete:showNum, onCompleteParams:[2]});
			var sm : SoundManager = SoundManager.getInstance();
			sm.playSound(XpopSounds.FIRST_BEEP);
		}

		private function showNum(num : int) : void
		{
			if (num == 0)
			{
				view.num_mc.num_txt.text = "¡Ya!";
				view.num_mc.alpha = 1;
				view.num_mc.scaleX = 1;
				view.num_mc.scaleY = 1;

				view.container_mc.visible = true;
				// view.container_mc.alpha = 0;
				// view.container_mc.scaleY = .8;

				TweenMax.to(view.num_mc, .5, {scaleX:1.2, scaleY:1.2, autoAlpha:0, onComplete:startGame});
				// TweenMax.to(view.container_mc, .5, {scaleX:1, scaleY:1, ease:Back.easeOut, onComplete:startGame});

				view.num_mc.num_txt.text = "";
				view.num_mc.visible = false;
			}
			else
			{
				view.num_mc.num_txt.text = num;
				view.num_mc.alpha = 1;
				view.num_mc.scaleX = 1;
				view.num_mc.scaleY = 1;
				num--;
				TweenLite.to(view.num_mc, .7, {scaleX:1.2, scaleY:1.2, alpha:0.1, onComplete:showNum, onCompleteParams:[num]});
				var sm : SoundManager = SoundManager.getInstance();
				sm.playSound(XpopSounds.FIRST_BEEP);
			}
		}

		private function startGame() : void
		{
			var sm : SoundManager = SoundManager.getInstance();
			sm.stopAllSounds();
			sm.stopSound(XpopSounds.GAME_LOOP);
			sm.playSound(XpopSounds.GAME_LOOP, 1, 0, 99999);
			sm.stopSound(XpopSounds.GAME_LOOP);
			sm.playSound(XpopSounds.GAME_LOOP, 1, 0, 999999);
			sm.stopSound(XpopSounds.GAME_HURRY_LOOP);
			sm.playSound(XpopSounds.GAME_HURRY_LOOP, 1, 0, 999999);
			sm.stopSound(XpopSounds.GAME_HURRY_LOOP);

			view.mouseChildren = view.mouseEnabled = true;
			gameController.start();
		}

		private function gameOver() : void
		{
			trace("GameScreen.gameOver()");
			view.loop_mc.removeEventListener(Event.ENTER_FRAME, updateLooping);
			_gameOverSignal.dispatch();
		}

		public function get closeSignal() : Signal
		{
			return _closeSignal;
		}

		public function get gameOverSignal() : Signal
		{
			return _gameOverSignal;
		}

		public function get score() : int
		{
			return _score;
		}

		public function get toggleVolSignal() : Signal
		{
			return _toggleVolSignal;
		}

		public function setVol(volume : int) : void
		{
			trace("GameScreen.setVol(volume)");
			volBtn.setVol(volume);
		}

		public function setScores(friends : Vector.<FriendObj>, myName : String, myPic : String, myHighscore : uint) : void
		{
			BtnUtils.clearMc(view.scores_container_mc);
			friendMcs = [];
			friendsArray = [];
			for (var i : int = 0; i < friends.length; i++)
			{
				if (friends[i].score > -1)
					friendsArray.push(friends[i]);
			}

			// ading highscore
			if (myHighscore > 0)
			{
				var meBest : FriendObj = new FriendObj();
				meBest.name = myName;
				meBest.score = myHighscore;
				meBest.picUrl = myPic;
				friendsArray.push(meBest);
			}

			friendsArray.sortOn("score", Array.NUMERIC | Array.DESCENDING);

			for (i = 0; i < friendsArray.length; i++)
			{
				var friendMc : FriendScore;
				friendMc = new FriendScore();
				friendMc.score = friendsArray[i].score;
				friendMc.name_txt.text = friendsArray[i].name;
				friendMc.score_txt.text = friendsArray[i].score;
				BtnUtils.clearMc(friendMc.avatar_mc);
				var imgLoader : ImageLoader = new ImageLoader(friendsArray[i].picUrl, {container:friendMc.avatar_mc});
				imgLoader.load();

				friendMc.x = 0;
				friendMc.y = i * 65;
				view.scores_container_mc.addChild(friendMc);

				friendMcs.push(friendMc);
			}

			view.scores_container_mc.cacheAsBitmap = true;
			view.mask_mc.cacheAsBitmap = true;
			view.scores_container_mc.mask = view.mask_mc;

			myScoreMc = new FriendScore();
			myScoreMc.name_txt.text = myName;
			myScoreMc.score_txt.text = "0";
			myScoreMc.score = 0;
			myScoreMc.gotoAndStop(2);
			BtnUtils.clearMc(myScoreMc.avatar_mc);
			imgLoader = new ImageLoader(myPic, {container:myScoreMc.avatar_mc});
			imgLoader.load();

			myScoreMc.x = 0;
			myScoreMc.y = i * 65;
			view.scores_container_mc.addChild(myScoreMc);
			friendMcs.push(myScoreMc);
			trace('friendMcs.length: ' + (friendMcs.length));

			setScoresY();
		}

		private function setScoresY() : void
		{
			trace("GameScreen.setScoresY()");
			var targetY : Number = -myScoreMc.y + 400;
			trace('targetY: ' + (targetY));
			if (targetY > 103)
			{
				targetY = 103;
			}

			TweenLite.to(view.scores_container_mc, .3, {y:targetY});
		}
	}
}
