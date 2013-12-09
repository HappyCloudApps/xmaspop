package com.myhappycloud.xpop.commands
{
	import com.myhappycloud.xpop.models.AppStates;
	import com.myhappycloud.xpop.models.IAppVars;
	import com.myhappycloud.xpop.views.ScreensContainer;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author Eder
	 */
	public class InitialSetupCommand extends Command
	{
		[Inject]
		public var model : IAppVars;

		override public function execute() : void
		{
			trace("InitialSetupCommand.execute()");
			contextView.addChild(new ScreensContainer());

			model.setState(AppStates.SPLASH);
		}
	}
}
