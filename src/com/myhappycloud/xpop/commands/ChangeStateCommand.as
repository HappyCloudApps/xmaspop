package com.myhappycloud.xpop.commands
{
	import com.myhappycloud.xpop.models.IAppVars;
	import com.myhappycloud.xpop.events.NavEvent;
	import org.robotlegs.mvcs.Command;
	/**
	 * @author Eder
	 */
	public class ChangeStateCommand extends Command
	{
		[Inject]
		public var event : NavEvent;
		[Inject]
		public var model : IAppVars;
		
		override public function execute() : void
		{
			trace("ChangeStateCommand.execute()");
			model.setState(event.state);
		}

	}
}
