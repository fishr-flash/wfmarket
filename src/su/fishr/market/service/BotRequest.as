package su.fishr.market.service 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import su.fishr.market.MarketplaceWF;
	import su.fishr.utils.Dumper;
	
	/**
	 * ...
	 * @author  
	 */
	public class BotRequest extends EventDispatcher 
	{
		
		static public const ON_RESULT_REQUEST:String = "onResultRequest";
		private var _interval:int;
		private var _onplay:Boolean;
		private var _loadData:Object;
		
		
		
		public function get loadData():Object 
		{
			return _loadData;
		}
		
		public function get onplay():Boolean 
		{
			return _onplay;
		}
		
		
		public function BotRequest(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			
			
		}
		
		public function play():void
		{
			if ( _interval ) clearInterval( _interval );
			_onplay = true;
			_interval = setInterval( onRequest, MarketplaceWF.MIN_REQUEST_DELAY + ( Math.random() * MarketplaceWF.MAX_REQUEST_DELAY) );
			//onRequest();
		}
		
		public function stop():void
		{
			if( _interval ) clearInterval( _interval );
			_onplay = false;
		}
		
		public function onManual():void 
		{
			if( _interval ) clearInterval( _interval );
			
			new Requester( callLoader );
		}
		
		private function onRequest():void 
		{
			new Requester( callLoader );
		}
		
		private function callLoader( inf:String ):void
		{
			
			try
			{
				_loadData = JSON.parse( inf );
				
				
				
				import su.fishr.market.service.Logw;
				import su.fishr.utils.Dumper;
				if( true )
				{
					const i:String = 
					( "BotRequest.as" + ". " +  "callLoader ")
					//+ ( "\r _loadData: " + Dumper.dump( _loadData ) )
					+ ( "\r onload: " )
					;
					Logw.inst.up( i );
				}
				
				//////////////////////TRACE/////////////////////////////////
				
				import su.fishr.market.service.Logw;
				import su.fishr.utils.Dumper;
				if( false )
				{
					const j:String = 
					( "BotRequest.as" + ". " +  "callLoader ")
					//+ ( "\r : " +  )
					+ ( "\r _loadData: " + Dumper.dump( _loadData ) )
					+ ( "\r end" );
					Logw.inst.up( j );
				}
				/////////////////////END TRACE//////////////////////////////
				
				this.dispatchEvent( new Event( ON_RESULT_REQUEST ) );
			}
			catch ( e:Error )
			{
				
				Logw.inst.up( inf );
				Logw.inst.up( e.getStackTrace() );
				_onplay = false;
			}
			
			if( _interval ) clearInterval( _interval );
			
			if ( _onplay ) _interval = setInterval( onRequest, MarketplaceWF.MIN_REQUEST_DELAY + ( Math.random() * MarketplaceWF.MAX_REQUEST_DELAY) );
			
			
			
			
			
			
			
		}
		
		private function parseJson(objson:Object):void 
		{
			const len:int = objson.data.length;
			for ( var i:int = 0; i < len; i++ )
			{
				
				Logw.inst.up(  Dumper.dump( objson.data[ i ]) );
			}
		}
		
		
	}

}