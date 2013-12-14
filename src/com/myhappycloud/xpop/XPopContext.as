package com.myhappycloud.xpop
{
	import com.myhappycloud.xpop.commands.SetSoundsCommand;
	import com.myhappycloud.xpop.mediators.InviteFriendsMediator;
	import com.myhappycloud.xpop.views.InviteFriendsView;
	import com.myhappycloud.xpop.commands.CheckSaveScoreCommand;
	import com.myhappycloud.xpop.commands.SetFriendsScoreCommand;
	import com.myhappycloud.xpop.events.XPopDataEvent;
	import com.myhappycloud.xpop.services.IDataService;
	import com.myhappycloud.xpop.services.DataService;
	import com.myhappycloud.xpop.services.FakeFBService;
	import com.myhappycloud.xpop.services.FBService;
	import com.myhappycloud.xpop.services.IFBService;
	import com.myhappycloud.xpop.commands.ChangeStateCommand;
	import com.myhappycloud.xpop.commands.FadeSoundsCommand;
	import com.myhappycloud.xpop.commands.InitialSetupCommand;
	import com.myhappycloud.xpop.commands.SetFriendsCommand;
	import com.myhappycloud.xpop.commands.SetScoreCommand;
	import com.myhappycloud.xpop.commands.StartAppCommand;
	import com.myhappycloud.xpop.commands.ToggleVolCommand;
	import com.myhappycloud.xpop.events.ModelEvent;
	import com.myhappycloud.xpop.events.NavEvent;
	import com.myhappycloud.xpop.mediators.GameMediator;
	import com.myhappycloud.xpop.mediators.GameOverMediator;
	import com.myhappycloud.xpop.mediators.InstructionsMediator;
	import com.myhappycloud.xpop.mediators.MainMenuMediator;
	import com.myhappycloud.xpop.mediators.ScreensContainerMediator;
	import com.myhappycloud.xpop.mediators.SplashMediator;
	import com.myhappycloud.xpop.models.AppModel;
	import com.myhappycloud.xpop.models.IAppVars;
	import com.myhappycloud.xpop.services.facebook.FBEvent;
	import com.myhappycloud.xpop.views.ScreensContainer;
	import com.myhappycloud.xpop.views.screens.GameOverScreen;
	import com.myhappycloud.xpop.views.screens.GameScreen;
	import com.myhappycloud.xpop.views.screens.InstructionsScreen;
	import com.myhappycloud.xpop.views.screens.MainMenuScreen;
	import com.myhappycloud.xpop.views.screens.SplashScreen;

	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Eder
	 */
	public class XPopContext extends Context
	{
		public function XPopContext(contextView : DisplayObjectContainer = null)
		{
			trace("XPopContext.XPopContext(contextView)");
			super(contextView);
		}

		override public function startup() : void
		{
			trace("ShapeContext.startup()");

			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, InitialSetupCommand);
			commandMap.mapEvent(NavEvent.GO_TO, ChangeStateCommand);
			commandMap.mapEvent(NavEvent.SETUP_SOUNDS, SetSoundsCommand);

			commandMap.mapEvent(ModelEvent.SET_SCORE, SetScoreCommand);
			commandMap.mapEvent(ModelEvent.TOGGLE_VOLUME, ToggleVolCommand);
			commandMap.mapEvent(ModelEvent.SETTINGS_UPDATED, FadeSoundsCommand);

			commandMap.mapEvent(FBEvent.FB_GOT, StartAppCommand, FBEvent, true);
			commandMap.mapEvent(FBEvent.FRIENDS_GOT, SetFriendsCommand);

			commandMap.mapEvent(XPopDataEvent.MY_SCORE, CheckSaveScoreCommand);
			commandMap.mapEvent(XPopDataEvent.FRIENDS_SCORES, SetFriendsScoreCommand);

			mediatorMap.mapView(ScreensContainer, ScreensContainerMediator);
			mediatorMap.mapView(SplashScreen, SplashMediator);
			mediatorMap.mapView(MainMenuScreen, MainMenuMediator);
			mediatorMap.mapView(InstructionsScreen, InstructionsMediator);
			mediatorMap.mapView(GameScreen, GameMediator);
			mediatorMap.mapView(GameOverScreen, GameOverMediator);
			mediatorMap.mapView(InviteFriendsView, InviteFriendsMediator);

			injector.mapSingletonOf(IAppVars, AppModel);
			injector.mapSingletonOf(IDataService, DataService);

			injector.mapSingletonOf(IFBService, FBService);
//			injector.mapSingletonOf(IFBService, FakeFBService);

			super.startup();
		}
	}
}
