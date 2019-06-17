package su.fishr.market.seller 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
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
		//static public const DELAY_ON_MONITORING:int = 1000 * 60 * 60 * 3;
		static public const DELAY_ON_MONITORING:int = 1000 * 2;
		
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
			
			new ListSellsRequest( onList );
			
			
			const d:Date  = new Date();
			//2019-06-22
			_control_day= int(  d.date - 1 );
			
			
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
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
				//////////////////////TRACE/////////////////////////////////
				
				import su.fishr.market.service.Logw;
				import su.fishr.utils.Dumper;
				if( true )
				{
					const j:String = 
					( "SalesMonitoringService.as" + ". " +  "onList ")
					+ ( "\r dt.data.inventory: " + Dumper.dump( dt.data.inventory ) )
					//+ ( "\r : " + Dumper.dump( true ) )
					+ ( "\r : " + "" )
					+ ( "\r end" );
					Logw.inst.up( j );
				}
				/////////////////////END TRACE//////////////////////////////
				
				var dd:int = 0;
				var dstr:String = "";
				const len:int = dt.data.inventory.length;
				for (var k:int = 0; k < len; k++) 
				{
					dstr = dt.data.inventory[ k ].blocked_nearest_date;
					
					dd = int( dstr.slice( dstr.length - 2 ) );
					
					if ( dd <= _control_day )
					{
						/// here report of moment sale
						
						return;
					}
					//////////////////////TRACE/////////////////////////////////
					
					import su.fishr.market.service.Logw;
					import su.fishr.utils.Dumper;
					if( true )
					{
						const l:String = 
						( "SalesMonitoringService.as" + ". " +  "onList ")
						//+ ( "\r : " + Dumper.dump( true ) )
						+ ( "\r : " + dt.data.inventory[ k ].blocked_nearest_date )
						+ ( "\r : " + "" )
						+ ( "\r end" );
						Logw.inst.up( l );
					}
					/////////////////////END TRACE//////////////////////////////
				}
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
		
	}

}