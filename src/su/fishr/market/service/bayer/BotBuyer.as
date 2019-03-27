package su.fishr.market.service.bayer 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.setTimeout;
	import su.fishr.market.MarketplaceWF;
	import su.fishr.utils.Dumper;
	
	/**
	 * ...
	 * @author  
	 */
	public class BotBuyer extends EventDispatcher 
	{
		private var _callback:Function;
		private var _entity_id:int;
		private var _cost:int;
		private var _type:String;
		
		public function BotBuyer( entity_id:int, cost:int, type:String, callback:Function, target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			
			
			
			
			setTimeout( init, MarketplaceWF.DELAY_ON_BUYER * 2, entity_id, cost, type, callback );
			
			
			
		}
		
		
		
		public function init( entity_id:int, cost:int, type:String, callback:Function ):void
		{
			_callback = callback;
			_entity_id = entity_id;
			_cost = cost;
			_type = type;
			
			
			const prebayer:PrebuyRequest = new PrebuyRequest( _entity_id, _type,  resPrebay );
		}
		
		private function resPrebay( d:Object ):void 
		{
			/**
			 * d:  value = ( str,57 ) {"state":"Success","data":{"inv_id":134491111,"cost":42}}
			 * 
			 * bayData: Object (2): 
				data:Object (2): 
					inv_id:(int,9) 134491111
					cost:(int,2) 42
				state:(str,7) Success
 			 */
			
			var bayData:Object = JSON.parse( String( d ) );
			
			if ( bayData.state == "Success" )
			{
				if ( MarketplaceWF.getCostOnCharge( bayData.data.cost ) <= _cost )
				{
					setTimeout( onBay, MarketplaceWF.DELAY_ON_BUYER * .5, bayData );
					
				}
				else
				{
					_callback( { status:"The operation was cancelled. Price has changed.", detals:bayData } );
				}
			}
			else
			{
				_callback( { status:"The operation failed.", detals:bayData } );
			}
			
		}
		
		private function onBay( bayData:Object ):void 
		{
			
			const bayreq:BuyRequest = new BuyRequest( _entity_id, bayData.data.cost, _type, resBay );
			
		}
		
		private function resBay( data:Object ):void 
		{
			
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "BotBuyer.as" + ". " +  "resBay ")
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r data: " + Dumper.dump( data ) )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
			_callback({state: data.state
						//, detals: data.data?data.data:Dumper.dump( data )
						, entity_id: _entity_id
						, cost: _cost
			});
			
		}
		
		
		
	}

}