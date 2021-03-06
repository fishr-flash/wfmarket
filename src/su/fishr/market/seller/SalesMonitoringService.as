package su.fishr.market.seller 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import su.fishr.market.MarketplaceWF;
	import su.fishr.market.WFMEvent;
	import su.fishr.market.seller.nets.ListSellsRequest;
	import su.fishr.utils.AddZerroDate;
	
	/**
	 * ...
	 * @author  
	 */
	public class SalesMonitoringService extends EventDispatcher 
	{
		private var _tm:int;
		private var _control_day:int;
		private var _serverJSON:Object;
		private var _iterator:int;
		
		//static public const DELAY_ON_MONITORING:int = 1000 * 60 * 60 * 3;
		static public const DELAY_ON_MONITORING:int = 1000 * 10;
		static public const TIME_OUT_ON_ITERATION:int = 1000 * 30;
		private var _lastTimeOpenWindow:int;
		
		public function SalesMonitoringService(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			
			
			init();
		}
		
		private function init():void 
		{
			_tm = setTimeout( onMonitoring, DELAY_ON_MONITORING );
		}
		
		
		private function onMonitoring():void 
		{
			
			clearTimeout( _tm );
			
			const d:Date  = new Date();
			//2019-06-22
			_control_day = int(  d.date );
			
			new ListSellsRequest( onList );
			
			
			
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( false )
			{
				const i:String = 
				( "SalesMonitoringService.as" + ". " +  "onMonitoring ")
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r : " + "ON MONITORING" )
				+ ( "\r _control_date: " + _control_day )
				
				
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
		}
		
		private function onList( data:* ):void 
		{
			
			/**
			 * [0] => Object (9): 
				blocked_nearest_date:(str,10) 2019-06-22
				blocked_count:(int,1) 1
				possible:(bool) false
				game_item:Object (5): 
					exchangeable:(bool) false
					sale:(bool) true
					can_send_to_game:(bool) true
					item:Object (4): 
						count:(int,1) 1
						permanent:(int,1) 1
						id:(str,14) ar27_bp05_shop
						title:(str,23) Beretta ARX160 Синдикат
					item_type:Object (2): 
						class:(str,8) rifleman
						type:(str,6) weapon
				count:(int,1) 1
				lootdog:(bool) false
				available_count:(int,1) 0
				id:(int,9) 148828166
				item_id:(int,4) 3864
			 */
			var dt:Object = JSON.parse( data );
			
			if ( dt.state === "Success" )
			{
				
				_serverJSON = dt;
				_iterator = 0;
				
				runSearch();
			}
			else
			{
				//////////////////////TRACE/////////////////////////////////
				
				import su.fishr.market.service.Logw;
				import su.fishr.utils.Dumper;
				if( true )
				{
					const i:String = 
					( "SalesMonitoringService.as" + ". " +  "onList ")
					+ ( "\r data: " + Dumper.dump( data ) )
					//+ ( "\r : " + Dumper.dump( true ) )
					+ ( "\r data: " + data )
					+ ( "\r end" );
					Logw.inst.up( i );
				}
				/////////////////////END TRACE//////////////////////////////
			}
			
			
			
		}
		
		private function runSearch():void
		{
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "SalesMonitoringService.as" + ". " +  "runSearch ")
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r _iterator: " + _iterator )
				+ ( "\r _listItems.data.inventory.length: " + _serverJSON.data.inventory.length )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
			
			
			clearTimeout( _tm );
			
			
			const timeOpenWindow:int = getTimer();
						
			//min * sec * miliseconds
			if ( !_lastTimeOpenWindow || ( ( timeOpenWindow - ( MarketplaceWF.DELAY_CALL_MARKET * 60 * 1000 ) ) >  _lastTimeOpenWindow  ) )
			{
				
				ExternalInterface.call( "function(){ window.open(\"https://wf.mail.ru/inventory/\"); }" );
				_lastTimeOpenWindow = timeOpenWindow;
			}
			
			
			var dd:int = 0;
			var dstr:String = "";
			var available:int = 0;
			var items:Array = _serverJSON.data.inventory.slice();
			const len:int = items.length;
			items = items.reverse();
			for ( ; _iterator < len; _iterator++) 
			{
				dstr = items[ _iterator ].blocked_nearest_date;
				available = items[ _iterator ].available_count;
				
				//////////////////////TRACE/////////////////////////////////
				
				import su.fishr.market.service.Logw;
				import su.fishr.utils.Dumper;
				if( true )
				{
					const j:String = 
					( "SalesMonitoringService.as" + ". " +  "runSearch ")
					//+ ( "\r : " + Dumper.dump( true ) )
					+ ( "\r items[ _iterator ]: " + Dumper.dump( items[ _iterator ] ) )
					+ ( "\r : " + '' )
					+ ( "\r : " + "" )
					+ ( "\r end" );
					Logw.inst.up( j );
				}
				/////////////////////END TRACE//////////////////////////////
				
				//dd = int( dstr.slice( dstr.length - 2 ) );
				dd = dstr?int( dstr.slice( 8, 10 ) ):_control_day;
				
				if (items[ _iterator ].game_item.sale === true
					&& dd <= _control_day  
					&& available > 0)
				{
					
					
						items[ _iterator ].available_count--;
						dispatchEvent( new WFMEvent( WFMEvent.NEED_SELL, false, false,  items[ _iterator ]  ) );
						_tm = setTimeout( runSearch, TIME_OUT_ON_ITERATION + ( TIME_OUT_ON_ITERATION * Math.random() ) ) ;
						return;
				}
				
				
				
			}
			
			//_tm = setTimeout( onMonitoring, DELAY_ON_MONITORING );
			
			dispatchEvent( new WFMEvent( WFMEvent.SERVICE_OSALE_ON_COMPLETE ) );
			
		}
		
	}

}