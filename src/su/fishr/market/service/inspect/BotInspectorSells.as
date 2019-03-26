package su.fishr.market.service.inspect 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import su.fishr.market.WFMEvent;
	
	/**
	 * ...
	 * @author  
	 */
	public class BotInspectorSells extends EventDispatcher 
	{
		
		private static const TIME_INTERVAL:uint = 450000;
		
		private static var _self:BotInspectorSells;
		private var _controlTime:Date;
		private var _identTimeOut:uint;
		
		static public function get self():BotInspectorSells 
		{
			if ( !_self  ) _self = new BotInspectorSells;
			
			return _self;
		}
		
		
		public function BotInspectorSells(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			
		}
		
		
		public function activate( ):void
		{
			_controlTime = new Date;
			//_controlTime = new Date( "Tue Mar 26 13:11:15 GMT+0300 2019" );
			
			if ( _identTimeOut )
					clearTimeout( _identTimeOut );
					
			_identTimeOut = setTimeout( requestHistory, TIME_INTERVAL + ( Math.random() * TIME_INTERVAL ) )
			
			
		}
		
		private function requestHistory():void
		{
			const req:HistorySellReq = new HistorySellReq( histResponse );
		}
		
		private function histResponse( data:* ):void 
		{
			/**
			 * [0] => Object (9): 
					title:(str,21) Жилет медика Синдикат
					method:(str,4) sale
					item:Object (3): 
						count:(int,1) 1
						id:(str,19) medic_vest_syndicat
						permanent:(int,1) 1
					entity_id:(int,4) 3868
					date:(str,19) 2019-03-26 13:55:46
					class:(str,5) medic
					kind:(str,9) equipment
					cost:(int,3) 193
					type:(str,9) inventory
				[1] => Object (9): 
					title:(str,25) Жилет штурмовика Синдикат
					method:(str,3) buy
					item:Object (3): 
						count:(int,1) 1
						id:(str,21) soldier_vest_syndicat
						permanent:(int,1) 1
					entity_id:(int,4) 3875
					date:(str,19) 2019-03-26 13:55:27
					class:(str,8) rifleman
					kind:(str,9) equipment
					cost:(int,3) 350
					type:(str,9) inventory
			 */
					
			 var cash:int = 0;
			 
			 const source:Object = JSON.parse( data );
			 
			 const summSale:int = source.data.filter( excludeBuys ).map( incrementSumm );
			 
			
			 _controlTime = new Date;
			 
			 this.dispatchEvent( new WFMEvent( WFMEvent.UPDATE_CASH, false, false, { "cash":cash } ) );
			
			
			function incrementSumm( item:Object, index:int, array:Array ):void
			{
			
				if ( parseDt( item.date ) > _controlTime )
													cash += item.cost;
			}
			
			
			function excludeBuys( item:Object, index:int, array:Array ):Boolean
			{
										
				return ( item.method == "sale" );
			}
			
			
			function parseDt( ss:String ):Date
			{
				const arr:Array = ss.split( " " );
				const days:Array = arr[ 0 ].split( "-" );
				const times:Array = arr[ 1 ].split( ":" );
				
				
				
				return new Date( days[ 0 ]
								, days[ 1 ] - 1
								, days[ 2 ]
								, times[ 0 ]
								, times[ 1 ]
								, times[ 2 ]
								);
			}
			
			
					
			_identTimeOut = setTimeout( requestHistory, TIME_INTERVAL + ( Math.random() * TIME_INTERVAL ) )
		}
		
		
		
		
		
	}

}