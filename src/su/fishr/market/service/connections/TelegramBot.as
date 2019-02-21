package su.fishr.market.service.connections 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import su.fishr.market.service.model.WeaponGroup;
	
	/**
	 * ...
	 * @author  
	 */
	public class TelegramBot extends EventDispatcher 
	{
		private static const _TOKEN:String = "797426458:AAEUZ4Dc5wYCAx4K-8fBC6PsH3Xf-yv4MAY";
		private static const _URL:String = "https://api.telegram.org/";
		private static const _BOT_WORD:String = "bot";
		private static const _METHOD_GETME:String = "/getMe";
		private static const _METHOD_SENDMESSAGE:String = "/sendMessage";
		private static const _METHOD_GETUPDATES:String = "/getUpdates";
		private static const _CHAT_ID:String = "380504824";
		private static const _PARSE_MOD:String = "HTML";
		private static const _AHREF:String = "<a href=\"https://wf.mail.ru/inventory/\">Market</a>";
		
		
		private static var _self:TelegramBot;
		private var loader:URLLoader;
		static public function get inst():TelegramBot 
		{
			if ( !_self ) _self = new TelegramBot;
			
			return _self;
		}
		
		
		public function TelegramBot(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			
		}
		
		/**
		 * https://api.telegram.org/bot<token>/НАЗВАНИЕ_МЕТОДА
		 * 
		 * weaponGroup: [object WeaponGroup]: 
			variables (1): 
				groupKey = (str,10) SAI GRY AR
			constants (0): 
			accessors (11) 
				readonly alertData = [object WeaponEnt]
				readonly cost = (int,3) 182
				readonly mincost = (int,3) 628
				readonly went = ( 3 )
						[0] => [object WeaponEnt]
						[1] => [object WeaponEnt]
						[2] => [object WeaponEnt]
				readonly maxcost = (int,4) 3140
				readonly entity_id = (int,1) 0
				readonly session_cost = (int,3) 255
				readonly type = (String,0)null
				readonly key = (str,10) SAI GRY AR
				readonly autocost = (int,2) 42
				readonly lowcost = (int,1) 0
		 * @param	str
		 */
		public function setMessageOnPositiveCost( weaponGroup:WeaponGroup ):void
		{
			const alertMess:String = weaponGroup.groupKey 
											+  ": cost: " + weaponGroup.cost 
											+ ",  lastcost: " + ( weaponGroup.cost - weaponGroup.diff )
											+ ",  diff: " +  weaponGroup.diff
											+ ",  session:  " + weaponGroup.session_cost
											+ ",  lowcost: " + weaponGroup.lowcost;
			loader = new URLLoader();
            configureListeners(loader);

			const url:String = _URL 
								+ _BOT_WORD 
								+ _TOKEN 
								+ _METHOD_SENDMESSAGE 
								+ "?chat_id=" + _CHAT_ID 
								+ "&text=" + _AHREF + "  " + alertMess 
								+ "&parse_mode=" + _PARSE_MOD;
								
			var request:URLRequest = new URLRequest( url );
            try {
				loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document. Error: " + error );
            }
		}
		
		public function setMessageOnNegativeCost( weaponGroup:WeaponGroup ):void
		{
			const alertMess:String = weaponGroup.groupKey 
											+  ": cost: " + weaponGroup.cost 
											+ ",  lastcost: " + ( weaponGroup.cost + weaponGroup.diff )
											+ ",  diff: " +  weaponGroup.diff
											+ ",  session:  " + weaponGroup.session_cost
											+ ",  heightcost: " + weaponGroup.heightcost;
											
			
			loader = new URLLoader();
            configureListeners(loader);

			const url:String = _URL 
								+ _BOT_WORD 
								+ _TOKEN 
								+ _METHOD_SENDMESSAGE 
								+ "?chat_id=" + _CHAT_ID 
								+ "&text=" + _AHREF + "  " + alertMess 
								+ "&parse_mode=" + _PARSE_MOD;
								
			var request:URLRequest = new URLRequest( url );
            try {
				loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document. Error: " + error );
            }
		}
		
		
		private function onRequest( alertMess:String ):void
		{
			loader = new URLLoader();
            configureListeners(loader);

			const url:String = _URL 
								+ _BOT_WORD 
								+ _TOKEN 
								+ _METHOD_SENDMESSAGE 
								+ "?chat_id=" + _CHAT_ID 
								+ "&text=" + _AHREF + "  " + alertMess 
								+ "&parse_mode=" + _PARSE_MOD;
								
			var request:URLRequest = new URLRequest( url );
            try {
				loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document. Error: " + error );
            }
		}
		
		public function onBuyResult( msg:String ):void
		{
			loader = new URLLoader();
            configureListeners(loader);

			const url:String = _URL 
								+ _BOT_WORD 
								+ _TOKEN 
								+ _METHOD_SENDMESSAGE 
								+ "?chat_id=" + _CHAT_ID 
								+ "&text=" + _AHREF + "  " + msg 
								+ "&parse_mode=" + _PARSE_MOD;
			

			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "TelegramBot.as" + ". " +  "setMessage ")
				+ ( "\rmsg : " +  msg)
				+ ( "\rurl : " +  url)
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
			
            var request:URLRequest = new URLRequest( url );
            try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document. Error: " + error );
            }
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }
		
		 private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			
			if( true )
			{
				const i:String = 
				( "TelegramBot.as" + ". " +  "completeHandler ")
				+ ("completeHandler: " + JSON.parse( loader.data as String ).result.text )
				//+ ( "\r : " + Dumper.dump( "" ) )
				//+ ( "\r loader.data dump: " + Dumper.dump(  JSON.parse( loader.data as String )) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
        }

        private function openHandler(event:Event):void {
            trace("openHandler: " + event);
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( false )
			{
				const i:String = 
				( "TelegramBot.as" + ". " +  "openHandler ")
				+ ( "\revent : " +  event)
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( false )
			{
				const i:String = 
				( "TelegramBot.as" + ". " +  "progressHandler ")
				+ ( "\r (progressHandler loaded: + event.bytesLoaded +  total:  + event.bytesTotal): " + ("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal) )
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "TelegramBot.as" + ". " +  "securityErrorHandler ")
				+ ("securityErrorHandler: " + event)
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
			
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( false )
			{
				const i:String = 
				( "TelegramBot.as" + ". " +  "httpStatusHandler ")
				+ ("httpStatusHandler: " + event)
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "TelegramBot.as" + ". " +  "ioErrorHandler ")
				+ ( "\r (ioErrorHandler:  + event);: " +  ("ioErrorHandler: " + event))
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
            trace("ioErrorHandler: " + event);
        }
		
		
	}

}