package com.myhappycloud.xpop.commands
{
	import com.myhappycloud.xpop.events.XPopDataEvent;
	import com.myhappycloud.xpop.models.IAppVars;
	import com.myhappycloud.xpop.services.IDataService;
	import com.myhappycloud.xpop.services.IFBService;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author Eder
	 */
	public class CheckSaveScoreCommand extends Command
	{
		[Inject]
		public var event : XPopDataEvent;
		[Inject]
		public var model : IAppVars;
		[Inject]
		public var dService : IDataService;
		[Inject]
		public var fb : IFBService;

		override public function execute() : void
		{
			trace("CheckSaveScoreCommand.execute()");
			trace('event.result: ' + (event.result));
			if (event.result != "empty")
			{
				trace("event.result.score: " + event.result.score);
				if (event.result.score < model.getScore())
				{
					dService.saveUserScore(fb.uid, model.getScore(), "pitorombo");
					model.setHighscore(model.getScore());
				}
				else
				{
					model.setHighscore(event.result.score);
				}
			}
			else
			{
				dService.saveUserScore(fb.uid, model.getScore(), "pitorombo");
				model.setHighscore(model.getScore());
			}
		}
	}
}
