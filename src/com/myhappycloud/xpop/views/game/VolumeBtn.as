package com.myhappycloud.xpop.views.game
{
	import com.greensock.data.TweenLiteVars;
	import com.greensock.TweenLite;

	import flash.display.MovieClip;

	/**
	 * @author Eder
	 */
	public class VolumeBtn
	{
		private var btn : MovieClip;
		private var bars : Array;

		public function VolumeBtn(btn : MovieClip)
		{
			trace("VolumeBtn.VolumeBtn(btn)");
			this.btn = btn;
			bars = [btn.volbar_mc_1, btn.volbar_mc_2, btn.volbar_mc_3];
		}

		public function setVol(volume : int) : void
		{
			trace("VolumeBtn.setVol(volume)");
			if (volume != 0)
			{
				startAnimating();
			}
			else
			{
				stopAnimating();
			}
		}

		private function startAnimating() : void
		{
			trace("VolumeBtn.startAnimating()");
			animate(bars[0], Math.random() * .3 + .2, Math.random() * .9 + .1);
			animate(bars[1], Math.random() * .3 + .2, Math.random() * .9 + .1);
			animate(bars[2], Math.random() * .3 + .2, Math.random() * .9 + .1);
		}

		private function stopAnimating() : void
		{
			trace("VolumeBtn.stopAnimating()");
			animate(bars[0], .3, 0);
			animate(bars[1], .3, 0);
			animate(bars[2], .3, 0);
		}

		private function animate(btn : MovieClip, time : Number, scale : Number) : void
		{
			var topMc : MovieClip = MovieClip(btn.getChildByName("top_mc"));
			var centerMc : MovieClip = MovieClip(btn.getChildByName("center_mc"));
			var vars : TweenLiteVars = new TweenLiteVars();
			vars.scaleY(scale);
			vars.y(20.5 - 17.2 * scale);
			
			TweenLite.killTweensOf(topMc);
			TweenLite.killTweensOf(centerMc);
			
			if (scale == 0)
			{
				TweenLite.to(topMc, time, {y:17.2 - 17.2 * scale});
			}
			else
			{
				TweenLite.to(topMc, time, {y:17.2 - 17.2 * scale, onComplete:reanimate, onCompleteParams:[btn]});
			}
			TweenLite.to(centerMc, time, vars);
		}

		private function reanimate(btn : MovieClip) : void
		{
			animate(btn, Math.random() * .5 + .2, Math.random() * .9 + .1);
		}
	}
}
