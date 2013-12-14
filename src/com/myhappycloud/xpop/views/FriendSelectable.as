package com.myhappycloud.xpop.views
{
	import flash.events.Event;

	import org.osflash.signals.Signal;

	import flash.events.MouseEvent;

	import org.osflash.signals.natives.NativeSignal;

	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * @author Eder
	 */
	public class FriendSelectable extends MovieClip
	{
		private var _name:String;
		private var _picUrl:String;
		private var imgLoader:ImageLoader;
		private var _clickSignal:NativeSignal;
		private var _uid:String;
		private var _selected:Boolean;

		public function FriendSelectable(name:String, picUrl:String, uid:String)
		{
			_uid = uid;
			_picUrl = picUrl;
			_name = name;
			selected = false;

			var nameTxt:TextField = TextField(getChildByName("name_txt"));
			nameTxt.text = _name;

			var picMc:MovieClip = MovieClip(getChildByName("pic_mc"));
			imgLoader = new ImageLoader(picUrl, {container:picMc});
			imgLoader.load();

			buttonMode = true;
			mouseChildren = false;
			_clickSignal = new NativeSignal(this, MouseEvent.CLICK);
			_clickSignal.add(select);

			addEventListener(Event.REMOVED_FROM_STAGE, removeSignals);
		}

		private function removeSignals(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeSignals);
			_clickSignal.removeAll();
		}

		private function select(e:MouseEvent):void
		{
			selected = !selected;
		}

		public function get clickSignal():NativeSignal
		{
			return _clickSignal;
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(selected:Boolean):void
		{
			_selected = selected;
			if (_selected)
				gotoAndStop("selected");
			else
				gotoAndStop("normal");
		}

		public function get uid():String
		{
			return _uid;
		}

		public function disable():void
		{
			mouseChildren = false;
			mouseEnabled = false;
			gotoAndStop("disabled");
		}

		public function get friendName():String
		{
			return _name;
		}

		public function get picUrl():String
		{
			return _picUrl;
		}
	}
}
