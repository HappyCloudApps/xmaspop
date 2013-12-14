package com.myhappycloud.xpop.commands
{
	import com.myhappycloud.xpop.services.IFBService;
	import com.myhappycloud.xpop.services.IDataService;
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
		[Inject]
		public var dService : IDataService;
		[Inject]
		public var fb : IFBService;

		override public function execute() : void
		{
			model.setScore(event.data.score);
			dService.getUserScore(fb.uid);
		}
	}
}
