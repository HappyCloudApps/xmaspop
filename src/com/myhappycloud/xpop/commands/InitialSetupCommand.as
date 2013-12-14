package com.myhappycloud.xpop.commands
{
	import com.myhappycloud.xpop.services.facebook.FacebookPermission;
	import com.myhappycloud.xpop.services.IFBService;
	import com.reintroducing.sound.SoundManager;
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
		[Inject]
		public var fb : IFBService;

		override public function execute() : void
		{
			trace("InitialSetupCommand.execute()");
			contextView.addChild(new ScreensContainer());
//			model.setState(AppStates.SPLASH);
			
			fb.access_token = contextView.stage.loaderInfo.parameters["access_token"];
			fb.uid = contextView.stage.loaderInfo.parameters["id_user"];
//			fb.init(FacebookPermission.EMAIL, FacebookPermission.USER_BIRTHDAY, FacebookPermission.PUBLISH_STREAM, FacebookPermission.USER_PHOTOS);
			fb.init(FacebookPermission.EMAIL, FacebookPermission.USER_BIRTHDAY, FacebookPermission.PUBLISH_ACTIONS, FacebookPermission.PUBLISH_STREAM);
//			fb.login();
			
			
			var sManager:SoundManager = SoundManager.getInstance();
//			sManager.add
		}
	}
}
