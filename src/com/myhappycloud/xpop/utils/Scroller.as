package com.myhappycloud.xpop.utils
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	/**
	 * @author Eder
	 */
	public class Scroller
	{
		private var trackMc : MovieClip;
		private var btnUp : MovieClip;
		private var btnDown : MovieClip;
		private var sliderMc : MovieClip;
		private var container : MovieClip;
		private var _targetY : Number = 0;
		private var scrollHeight : Number;
		private var containerRange : Number;
		private var containerInitialY : Number;
		private var scrollPos : Number;

		public function Scroller(scroller_mc : MovieClip, container : MovieClip)
		{
			this.container = container;
			trackMc = MovieClip(scroller_mc.getChildByName("track_mc"));
			btnUp = MovieClip(scroller_mc.getChildByName("btn_up"));
			btnDown = MovieClip(scroller_mc.getChildByName("btn_down"));
			sliderMc = MovieClip(scroller_mc.getChildByName("slider_mc"));

			scrollHeight = trackMc.height - 20;
			containerRange = container.height - 192;
			sliderMc.y = trackMc.y + 10;
			containerInitialY = container.y;
			targetY = containerInitialY;
			sliderMc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

			BtnUtils.onClick(btnUp, scrollUp);
			BtnUtils.onClick(btnDown, scrollDown);

			sliderMc.addEventListener(Event.ENTER_FRAME, update);
		}

		private function update(e : Event) : void
		{
			var perc : Number = scrollPos / scrollHeight;
			// perc = Math.abs(perc-1);
			// trace('perc: ' + (perc));
			var yPos : Number = -(perc * containerRange);
			yPos += containerInitialY;
			targetY = yPos;
			container.y += (yPos - container.y) / 7;
		}

		private function onMouseDown(event : MouseEvent) : void
		{
			sliderMc.startDrag(false, new Rectangle(trackMc.x, trackMc.y + 10, 0, trackMc.height - 20));
			sliderMc.stage.addEventListener(MouseEvent.MOUSE_MOVE, updateTargetY);
			sliderMc.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			sliderMc.stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}

		private function onMouseLeave(e : Event) : void
		{
			stopDragging();
		}

		private function onMouseUp(e : MouseEvent) : void
		{
			stopDragging();
		}

		private function stopDragging() : void
		{
			sliderMc.stopDrag();
			sliderMc.stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateTargetY);
			sliderMc.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			sliderMc.stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}

		private function updateTargetY(e : MouseEvent) : void
		{
			scrollPos = sliderMc.y - (trackMc.y + 10);
		}

		private function scrollUp(e : MouseEvent) : void
		{
			targetY += 65;
		}

		private function scrollDown(e : MouseEvent) : void
		{
			targetY -= 65;
		}

		public function set targetY(targetY : Number) : void
		{
			var perc : Number;
			var yPos:Number;
			yPos = targetY-containerInitialY;
			perc = -yPos/containerRange;
			if(perc<0)perc=0;
			if(perc>1)perc=1;
			
			yPos = -(perc*containerRange);
			targetY = yPos+containerInitialY;
			
			scrollPos = perc*scrollHeight;
			sliderMc.y = scrollPos+(trackMc.y+10);
			
			_targetY = targetY;
		}

		public function get targetY() : Number
		{
			return _targetY;
		}
	}
}
