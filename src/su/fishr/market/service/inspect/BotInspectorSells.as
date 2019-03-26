package su.fishr.market.service.inspect 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author  
	 */
	public class BotInspectorSells extends EventDispatcher 
	{
		
		private static const TIME_INTERVAL:uint = 900000;
		
		private static var _self:BotInspectorSells;
		private var _controlTime:uint;
		
		static public function get self():BotInspectorSells 
		{
			if ( !_self  ) _self = new BotInspectorSells;
			
			return _self;
		}
		
		
		public function BotInspectorSells(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			
		}
		
		
		public function ini( time:uint ):void
		{
			_controlTime = time;
			
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
					
			 const source:Object = JSON.parse( data );
			 
			 source.data.filter( excludeBuys );
			 
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "BotInspectorSells.as" + ". " +  "histResponse ")
				+ ( "\r source: " + Dumper.dump( source.data[ 0 ] ) )
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r source.data[ 0 ].date ): " +  source.data[ 0 ].date )
				+ ( "\r new Date( source[ 0 ].date ): " +  new Date( source.data[ 0 ].date ).toDateString() )
				+ ( "\rparseDt( source.data[ 0 ].date ): " + parseDt( source.data[ 0 ].date ) )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
			
			
			function parseDt( ss:String ):Date
			{
				const arr:Array = ss.split( " " );
				const days:Array = arr[ 0 ].split( "-" );
				const times:Array = arr[ 1 ].split( ":" );
				
				
				
				return new Date( days[ 0 ]
								, days[ 1 ]
								, days[ 2 ]
								, times[ 0 ]
								, times[ 1 ]
								, times[ 2 ]
								);
			}
			
			function excludeBuys( item:Object ):Boolean
			{
				//////////////////////TRACE/////////////////////////////////
				
				import su.fishr.market.service.Logw;
				import su.fishr.utils.Dumper;
				if( true )
				{
					const j:String = 
					( "BotInspectorSells.as" + ". " +  "histResponse ")
					+ ( "\r item: " + Dumper.dump( item ) )
					//+ ( "\r : " + Dumper.dump( true ) )
					+ ( "\r item.method: " + item.method )
					+ ( "\r : " + "" )
					+ ( "\r end" );
					Logw.inst.up( j );
				}
				/////////////////////END TRACE//////////////////////////////
				/*if ( item.method == "sale" )
						return true*/;
						
				return true;
			}
		}
		
		
		
		
		
	}

}