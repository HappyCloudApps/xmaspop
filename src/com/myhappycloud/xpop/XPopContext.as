package com.myhappycloud.xpop
{
	import com.myhappycloud.xpop.mediators.MainMenuMediator;
	import com.myhappycloud.xpop.views.screens.MainMenuScreen;
	import com.myhappycloud.xpop.commands.ChangeStateCommand;
	import com.myhappycloud.xpop.commands.InitialSetupCommand;
	import com.myhappycloud.xpop.events.NavEvent;
	import com.myhappycloud.xpop.mediators.GameMediator;
	import com.myhappycloud.xpop.mediators.GameOverMediator;
	import com.myhappycloud.xpop.mediators.InstructionsMediator;
	import com.myhappycloud.xpop.mediators.ScreensContainerMediator;
	import com.myhappycloud.xpop.mediators.SplashMediator;
	import com.myhappycloud.xpop.models.AppModel;
	import com.myhappycloud.xpop.models.IAppVars;
	import com.myhappycloud.xpop.views.ScreensContainer;
	import com.myhappycloud.xpop.views.screens.GameOverScreen;
	import com.myhappycloud.xpop.views.screens.GameScreen;
	import com.myhappycloud.xpop.views.screens.InstructionsScreen;
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

			mediatorMap.mapView(ScreensContainer, ScreensContainerMediator);
			mediatorMap.mapView(SplashScreen, SplashMediator);
			mediatorMap.mapView(MainMenuScreen, MainMenuMediator);
			mediatorMap.mapView(InstructionsScreen, InstructionsMediator);
			mediatorMap.mapView(GameScreen, GameMediator);
			mediatorMap.mapView(GameOverScreen, GameOverMediator);

			injector.mapSingletonOf(IAppVars, AppModel);

			super.startup();
		}
	}
}
