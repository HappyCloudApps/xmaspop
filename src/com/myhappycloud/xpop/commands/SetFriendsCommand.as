package com.myhappycloud.xpop.commands
{
	import com.myhappycloud.xpop.services.facebook.FriendObj;
	import com.myhappycloud.xpop.services.IDataService;
	import com.myhappycloud.xpop.models.IAppVars;
	import com.myhappycloud.xpop.services.IFBService;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author Eder
	 */
	public class SetFriendsCommand extends Command
	{
		[Inject]
		public var fb : IFBService;
		[Inject]
		public var model : IAppVars;
		[Inject]
		public var dService : IDataService;

		override public function execute() : void
		{
			trace("SetFriendsCommand.execute()");
			var friends : Array = [];
			for (var i : int = 0; i < fb.friends.length; i++)
			{
				friends.push(fb.friends[i].uid);
			}
			
			var modFriends:Vector.<FriendObj> = fb.friends;
			
			var kamy:FriendObj = new FriendObj();
			kamy.name="Kamy";
			kamy.picUrl="http://myhappycloud.com.mx/xmaspop/imagenes/kamy.jpg";
			kamy.score=300;
			kamy.uid="hc";
			modFriends.push(kamy);
			
			var kicho:FriendObj = new FriendObj();
			kicho.name="Kicho";
			kicho.picUrl="http://myhappycloud.com.mx/xmaspop/imagenes/kicho.jpg";
			kicho.score=450;
			kicho.uid="hc";
			modFriends.push(kicho);
			
			var mitta:FriendObj = new FriendObj();
			mitta.name="Mitta";
			mitta.picUrl="http://myhappycloud.com.mx/xmaspop/imagenes/mitta.jpg";
			mitta.score=120;
			mitta.uid="hc";
			modFriends.push(mitta);
			
			model.setFbFriends(modFriends);
			dService.getFriendsScore(friends);
		}
	}
}
