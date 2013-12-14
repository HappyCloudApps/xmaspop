package com.myhappycloud.xpop.commands
{
	import org.robotlegs.mvcs.Command;
	import com.myhappycloud.xpop.models.IAppVars;
	/**
	 * @author Eder
	 */
	public class ToggleVolCommand extends Command
	{
		[Inject]
		public var model : IAppVars;

		override public function execute() : void
		{
			model.toggleVol();
		}
	}
}
