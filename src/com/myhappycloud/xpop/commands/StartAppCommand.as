package com.myhappycloud.xpop.commands
{
	import com.myhappycloud.xpop.services.IDataService;
	import com.myhappycloud.xpop.services.IFBService;
	import com.myhappycloud.xpop.models.AppStates;
	import com.myhappycloud.xpop.models.IAppVars;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author Eder
	 */
	public class StartAppCommand extends Command
	{
		[Inject]
		public var model : IAppVars;
		[Inject]
		public var fb : IFBService;
		[Inject]
		public var dService : IDataService;

		override public function execute() : void
		{
			trace("StartAppCommand.execute()");
			model.setState(AppStates.SPLASH);
			model.setFbData(fb.myName, fb.myPicUrl);
			fb.loadFriends();
			
			dService.saveUserData(fb.uid, fb.myEmail, fb.myFirstName, fb.myLastName, fb.myGender, fb.myBirthday);
			
			dService.getUserScore(fb.uid);
		}
	}
}
