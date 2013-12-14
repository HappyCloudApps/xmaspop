/**
 * 
 * WScrollPane by GrupoW
 * Copyright (c) 2003-2010 GrupoW
 * 
 * this file is part of com.grupow.controls package
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 **/
package com.grupow.controls
{
	import flash.events.MouseEvent;
	import flash.events.Event;

	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	/**
	 * ...
	 * @author Raúl Uranga
	 */
	public class WScrollPane extends WAbstractControl
	{
		public var easefunc:Function = Cubic.easeOut;
		public var easeduration:Number = 0.4;
		protected var _content:DisplayObject;
		protected var _holder:MovieClip;
		protected var _mask:MovieClip;
		protected var _scrollTrack:WScrollTrack;
		private var wheelScrollEnabled:Boolean = false;

		public function WScrollPane()
		{
			super();

			_holder = getChildByName("holder_mc") as MovieClip;
			_mask = getChildByName("mask_mc") as MovieClip;
			_scrollTrack = getChildByName("scrollTrack_mc") as WScrollTrack;

			if (stage)
				setMouseWheel();
			else
				addEventListener(Event.ADDED_TO_STAGE, setMouseWheel);
		}

		private function setMouseWheel(e:Event = null):void
		{
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, scrollHandler);
		}

		private function scrollHandler(e:MouseEvent):void
		{
			if (wheelScrollEnabled&&_scrollTrack.visible)
				_scrollTrack.move(e.delta * .3);
		}

		public function set content(target:DisplayObject):void
		{
			_content = target;
			_content.x = 0;
			_content.y = 0;

			this._holder.addChild(target);

			if (_mask.height - _holder.height > 0)
			{
				_scrollTrack.visible = false;
			}
		}

		public function get content():DisplayObject
		{
			return _content;
		}

		protected override function init():void
		{
			_scrollTrack.min = 0;
			_scrollTrack.max = 1;
			_scrollTrack.addEventListener(WScrollTrackEvent.CHANGE, change_handler, false, 0, true);
		}

		protected override function destroy():void
		{
			_scrollTrack.removeEventListener(WScrollTrackEvent.CHANGE, change_handler);
		}

		protected function change_handler(e:WScrollTrackEvent):void
		{
			TweenLite.to(_holder, easeduration, {y:(_mask.height - _holder.height - 15) * e.position, ease:easefunc});

			// TODO bubbles event 
			// dispatchEvent (e);
		}

		public function setEnabled(val:Boolean):void
		{
			wheelScrollEnabled = val;
		}

		public function updated():void
		{
			trace("[WScrollPane::updated()] ");
			// _content.x = 0;
			// _content.y = 0;
			_holder.y = 0;
			_scrollTrack.position = 0;
			if (_mask.height - _holder.height > 0)
			{
				_scrollTrack.visible = false;
			}
			else
			{
				_scrollTrack.visible = true;
			}
		}
		// TODO implement functions
		/*/
		
		public function get vScrollPolicy() : Boolean
		{
			
		}
		
		public function set vScrollPolicy (foo : Boolean)
		{
			
		}
		public function get enabled () : Boolean
		{
			
		}
		public function set enabled (foo : Boolean)
		{
			
		}
		public function get max () : Number
		{
			
		}
		public function set max (foo : Number)
		{
			
		}
		public function get min () : Number
		{
			
		}
		public function set min (foo : Number)
		{
		
		}
		public function get scrollPosition () : Number
		{
			
		}
		public function set scrollPosition (foo : Number)
		{
			
		}
		// */
	}
}