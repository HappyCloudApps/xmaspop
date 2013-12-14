package com.myhappycloud.xpop.views
{
	import com.ederdiaz.utils.TextInput;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.data.TweenMaxVars;
	import com.greensock.easing.Bounce;
	import com.grupow.controls.WScrollPane;
	import com.myhappycloud.xpop.services.facebook.FriendObj;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;

	/**
	 * @author Eder
	 */
	public class InviteFriendsView extends MovieClip
	{
		private var backBtn : MovieClip;
		private var inviteBtn : MovieClip;
		private var _backSignal : NativeSignal;
		private var _closedSignal : Signal;
		private var scrollPane : WScrollPane;
		private var scrollContent : MovieClip;
		private var searchText : TextField;
		private var searchInput : TextInput;
		private var _friends : Array;
		private var friendSelArray : Array;
		private var _inviteSignal : Signal;
		private var clickedInvite : NativeSignal;
		private var _friendsInvited : Array;
		private var _invitedDates : Array;
		private var clearBtn : MovieClip;
		private var clickedClear : NativeSignal;
		private var allBtn : MovieClip;
		private var clickedAll : NativeSignal;
		private var allFriends : Boolean;
		private var selectedBtn : MovieClip;
		private var clickedSelected : NativeSignal;
		private var _allFriends : Array;
		private var _friendsSelected : Array;
		private var _idFriendsSelected : Array;
		private var msgText : TextField;
		private var msgInput : TextInput;
		private var invitedMc : MovieClip;

		public function initialize() : void
		{
			visible = false;
			_closedSignal = new Signal();
			_inviteSignal = new Signal(Object);
			setBtns();
			x = 370;
			y = 303;
		}

		private function setBtns() : void
		{
			backBtn = MovieClip(getChildByName("back_btn"));
			backBtn.buttonMode = true;
			_backSignal = new NativeSignal(backBtn, MouseEvent.CLICK);

			inviteBtn = MovieClip(getChildByName("invite_btn"));
			inviteBtn.buttonMode = true;
			clickedInvite = new NativeSignal(inviteBtn, MouseEvent.CLICK);
			clickedInvite.add(inviteFriends);

			clearBtn = MovieClip(getChildByName("clear_btn"));
			clearBtn.buttonMode = true;
			clickedClear = new NativeSignal(clearBtn, MouseEvent.CLICK);
			clickedClear.add(clearSearchTxt);

			allBtn = MovieClip(getChildByName("all_btn"));
			allBtn.buttonMode = true;
			clickedAll = new NativeSignal(allBtn, MouseEvent.CLICK);
			clickedAll.add(setAllFriends);

			selectedBtn = MovieClip(getChildByName("selected_btn"));
			selectedBtn.buttonMode = true;
			selectedBtn.mouseChildren = false;
			clickedSelected = new NativeSignal(selectedBtn, MouseEvent.CLICK);
			clickedSelected.add(setSelectedFriends);

			scrollPane = WScrollPane(getChildByName("scrollPane_mc"));
			scrollContent = MovieClip(scrollPane.getChildByName("holder_mc"));
			scrollPane.setEnabled(false);

			searchText = TextField(getChildByName("search_txt"));
			searchInput = new TextInput(searchText, "");
			searchText.addEventListener(Event.CHANGE, onSearchChange);

			msgText = TextField(getChildByName("msg_txt"));
			msgInput = new TextInput(msgText, "Agrega un mensaje (opcional)");

			allFriends = true;
			selectedBtn.gotoAndStop(2);

			invitedMc = MovieClip(getChildByName("invited_mc"));
			invitedMc.visible = false;

			clearMc(scrollContent);
		}

		private function setAllFriends(e : MouseEvent = null) : void
		{
			if (!allFriends)
			{
				allFriends = true;
				selectedBtn.gotoAndStop(2);
				allBtn.gotoAndStop(1);

				_friends = _allFriends;
				setFriendsDisplay(_friends.filter(searchFilter));
			}
		}

		private function setSelectedFriends(e : MouseEvent) : void
		{
			if (allFriends)
			{
				allFriends = false;
				selectedBtn.gotoAndStop(1);
				allBtn.gotoAndStop(2);

				_friends = _friendsSelected;
				setFriendsDisplay(_friendsSelected.filter(searchFilter));
			}
		}

		private function clearSearchTxt(e : MouseEvent) : void
		{
			searchInput.changeText("");
			setFriendsDisplay(_friends.filter(searchFilter));
		}

		private function inviteFriends(e : MouseEvent) : void
		{
			var message : String = "";
			if (msgInput.isValid())
			{
				message = msgInput.text;
			}

			setEnabled(false);
			var data : Object = new Object();
			data.friends = [];
			for (var i : int = 0; i < friendSelArray.length; i++)
			{
				var f : FriendSelectable = friendSelArray[i];
				if (f.selected) data.friends.push(f.uid);
			}
			
			data.message = message;
			inviteSignal.dispatch(data);
		}

		private function setEnabled(val : Boolean) : void
		{
			mouseChildren = val;
			mouseEnabled = val;
		}

		private function onSearchChange(e : Event) : void
		{
			if (searchText.text != "" && searchText.text != "buscar...")
			{
				setFriendsDisplay(_friends.filter(searchFilter));
			}
			else
			{
				setFriendsDisplay(_friends);
			}
		}

		private function searchFilter(element : *, index : int, arr : Array) : Boolean
		{
			return (String(element.name).toLowerCase().search(searchText.text.toLowerCase()) != -1);
		}

		private function clearMc(mc : MovieClip) : void
		{
			while (mc.numChildren > 0)
			{
				mc.removeChildAt(0);
			}
		}

		public function open() : void
		{
			msgText.text = "Agrega un mensaje (opcional)";
			msgInput.defaultColor = 0x666666;
			searchText.text = "";

			allFriends = true;
			selectedBtn.gotoAndStop(2);
			allBtn.gotoAndStop(1);

			scrollPane.setEnabled(true);
			visible = true;
			alpha = 1;
			scaleX = scaleY = .85;
			mouseChildren = mouseEnabled = true;
			TweenLite.to(this, .7, {scaleX:1, scaleY:1, onComplete:setEnabled, onCompleteParams:[true], ease:Bounce.easeOut});
		}

		public function get backSignal() : NativeSignal
		{
			return _backSignal;
		}

		public function close() : void
		{
			scrollPane.setEnabled(false);
			setEnabled(false);
			var vars : TweenMaxVars = new TweenMaxVars();
			vars.scale(.7);
			vars.autoAlpha(0);
			vars.onComplete(onClosed);
			invitedMc.visible = false;

			TweenMax.to(this, .2, vars);
		}

		private function onClosed() : void
		{
			visible = false;
			_closedSignal.dispatch();
		}

		public function get closedSignal() : Signal
		{
			return _closedSignal;
		}

		public function setupFriends(friends : Array, friendsInvited : Array, dates : Array) : void
		{
			_friends = friends;
			_allFriends = friends;
			_friendsInvited = friendsInvited;
			_invitedDates = dates;
			_friendsSelected = [];
			_idFriendsSelected = [];

			// trace('_friendsInvited: ' + (_friendsInvited));
			setFriendsDisplay(friends);
		}

		private function setFriendsDisplay(friends : Array) : void
		{
			clearMc(scrollContent);
			var friendBtn : FriendSelectable;
			friendSelArray = [];
			var index : int;
			for (var i : int = 0; i < friends.length; i++)
			{
				friendBtn = new FriendSelectable(friends[i].nameFull, friends[i].picUrl, friends[i].uid);

				var col : int = i % 4;
				var row : int = Math.floor(i / 4);
				friendBtn.x = col * 155 + 25;
				friendBtn.y = row * 75 + 8;
				friendBtn.clickSignal.add(checkSelected);
				if (_idFriendsSelected.indexOf(friendBtn.uid) > -1)
				{
					friendBtn.selected = true;
				}

				scrollContent.addChild(friendBtn);

				friendSelArray.push(friendBtn);

				/*
				index = getStringIndex(_friendsInvited, friends[i].uid);
				trace(friends[i].uid);
				trace('index: ' + (index));
				if (index != -1)
				{
				trace("date: " + new Date(_invitedDates[index]));
				if (isToday(new Date(_invitedDates[index])))
				{
				friendBtn.disable();
				}
				}
				 */
			}
			checkFriendsSelected();

			scrollPane.updated();
		}

		private function checkSelected(e : MouseEvent) : void
		{
			var fBtn : FriendSelectable = FriendSelectable(e.currentTarget);

			if (fBtn.selected)
			{
				var friend : FriendObj = new FriendObj();
				friend.name = fBtn.friendName;
				friend.uid = fBtn.uid;
				friend.picUrl = fBtn.picUrl;

				_friendsSelected.push(friend);
				_idFriendsSelected.push(fBtn.uid);
			}
			else
			{
				_idFriendsSelected.splice(_idFriendsSelected.indexOf(fBtn.uid), 1);
				for (var i : int = 0; i < _friendsSelected.length; i++)
				{
					if (_friendsSelected[i].uid == fBtn.uid)
					{
						_friendsSelected.splice(i, 1);
						break;
					}
				}
			}

			checkFriendsSelected();
		}

		private function checkFriendsSelected() : void
		{
			var lblTxt : TextField = TextField(selectedBtn.getChildByName("label_txt"));
			lblTxt.text = "Seleccionados (" + _friendsSelected.length + ")";

			if (_friendsSelected.length > 0)
				setEnabledInviteBtn(true);
			else
				setEnabledInviteBtn(false);
		}

		private function setEnabledInviteBtn(val : Boolean) : void
		{
			inviteBtn.mouseChildren = val;
			inviteBtn.mouseEnabled = val;
			if (val)
				inviteBtn.alpha = 1;
			else
				inviteBtn.alpha = .5;
		}

		private function getStringIndex(invitedFriends : Array, search : String) : int
		{
			for (var i : int = 0; i < invitedFriends.length; i++)
			{
				var str : String = invitedFriends[i];
				trace('str: ' + (str));
				trace('search: ' + (search));
				if (str == search)
					return i;
			}
			return -1;
		}

		public function get inviteSignal() : Signal
		{
			return _inviteSignal;
		}

		private function isToday(date : Date) : Boolean
		{
			var today : Date = new Date();
			var milliseconds : Number = today.getTime() - date.getTime();

			if (milliseconds > 0)
			{
				var seconds : Number = milliseconds / 1000;
				var minutes : Number = seconds / 60;
				var hours : Number = minutes / 60;
				var days : Number = Math.floor(hours / 24);

				trace("days left: " + days);

				if (days == 0)
					return true;
			}

			return false;
		}

		public function closeInvited() : void
		{
			scrollPane.setEnabled(false);
			mouseChildren = mouseEnabled = false;

			invitedMc.visible = true;
			invitedMc.y = -350;
			TweenLite.to(invitedMc, .5, {y:0, onComplete:waitInvitedOut});
		}

		private function waitInvitedOut() : void
		{
			setTimeout(takeInvitedOut, 550);
		}

		private function takeInvitedOut() : void
		{
			TweenLite.to(invitedMc, .5, {y:350, onComplete:close});
		}

		public function get friends() : Array
		{
			return _friends;
		}
	}
}
