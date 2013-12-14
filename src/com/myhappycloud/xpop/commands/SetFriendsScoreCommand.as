package com.myhappycloud.xpop.commands
{
	import com.myhappycloud.xpop.models.IAppVars;
	import com.myhappycloud.xpop.events.XPopDataEvent;
	import org.robotlegs.mvcs.Command;
	/**
	 * @author Eder
	 */
	public class SetFriendsScoreCommand extends Command
	{
		[Inject]
		public var event : XPopDataEvent;
		[Inject]
		public var model : IAppVars;

		override public function execute() : void
		{
			for each (var i : Object in event.result) 
			{
				trace("SetFriendsScoreCommand.execute() - "+i.uid+": "+i.score);
				model.setFriendScore(i.uid, i.score);
			}
		}

	}
}
