package com.myhappycloud.xpop.commands
{
	import com.myhappycloud.xpop.utils.XpopSounds;
	import com.reintroducing.sound.SoundManager;

	import org.robotlegs.mvcs.Command;
	/**
	 * @author Eder
	 */
	public class SetSoundsCommand extends Command
	{
		override public function execute() : void
		{
			trace("SetSoundsCommand.execute()");
			var sm : SoundManager = SoundManager.getInstance();
			sm.addSound(XpopSounds.INTRO_LOOP);
			sm.addSound(XpopSounds.GAME_LOOP);
			sm.addSound(XpopSounds.GAME_HURRY_LOOP);
			sm.addSound(XpopSounds.GAME_OVER_LOOP);
			sm.addSound(XpopSounds.SCORE_UP);
			sm.addSound(XpopSounds.FIRST_BEEP);
			sm.addSound(XpopSounds.GOING_UP);
			sm.addSound(XpopSounds.CLICK);
			sm.addSound(XpopSounds.SLAM);
			
			sm.playSound(XpopSounds.INTRO_LOOP,1,0,999999);
		}

	}
}
