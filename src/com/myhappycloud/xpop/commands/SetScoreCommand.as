package com.myhappycloud.xpop.commands
{
	import com.myhappycloud.xpop.models.IAppVars;
	import com.myhappycloud.xpop.events.ModelEvent;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author Eder
	 */
	public class SetScoreCommand extends Command
	{
		[Inject]
		public var event : ModelEvent;
		[Inject]
		public var model : IAppVars;

		override public function execute() : void
		{
			model.setScore(event.data.score);
		}
	}
}
