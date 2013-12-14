package com.myhappycloud.xpop.commands
{
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import com.greensock.TweenLite;
	import com.myhappycloud.xpop.models.IAppVars;
	import org.robotlegs.mvcs.Command;
	/**
	 * @author Eder
	 */
	public class FadeSoundsCommand extends Command
	{
		[Inject]
		public var model : IAppVars;

		public var vol : int;

		override public function execute() : void
		{
			vol = Math.abs(model.getVolume()-1);
			TweenLite.to(this, .5, {vol:model.getVolume(), onUpdate:updateVol});
		}

		private function updateVol() : void
		{
			SoundMixer.soundTransform = new SoundTransform(vol);
		}

	}
}
