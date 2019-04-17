package su.fishr.market.lootdog.service 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import su.fishr.market.lootdog.LDgEvent;
	import su.fishr.market.lootdog.net.AskQueue;
	import su.fishr.market.lootdog.net.CancelSell;
	
	/**
	 * ...
	 * @author  
	 */
	public class BotOfLot extends EventDispatcher 
	{
		private var _id:int;
		private var _name:String;
		private var _amount:Number;
		private var _userId:String;
		private var _callback:Function;
		private var _placeId:String;
		
		public function BotOfLot( id:int
									, place_id:String
									, name:String
									, amount:Number
									, userId:String
									, target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			
			init( id, place_id,  name, amount, userId );
		}
		
		public function start():void
		{
			this.dispatchEvent( new LDgEvent( LDgEvent.PLEASE_REQUEST_QUEUE, false, false, { bot: this, method: askQueue } ) );
		}
		private function init(id:int, place_id:String, name:String, amount:Number, userId:String):void 
		{
			_id = id;
			_name = name;
			_amount = amount;
			_userId = userId;
			_placeId = place_id;
			
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "BotOfLot.as" + ". " +  "init ")
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r _id: " + _id )
				+ ( "\r _name: " + _name )
				+ ( "\r _amount: " + _amount )
				+ ( "\r _userId: " + _userId )
				+ ( "\r _placeId: " + _placeId )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE////////////////////////////// the request queue
			
			
		}
		
		private function askQueue( callback:Function ):void 
		{
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "BotOfLot.as" + ". " +  "askQueue ")
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
			_callback = callback;
			new AskQueue( _id, answerAskQueue );
		}
		
		private function answerAskQueue( data:* ):void 
		{
			const dt:Object = JSON.parse( data );
			
			
			
			const amountOver:Number = dt.results[ 0 ].buy_price.amount;
			
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "BotOfLot.as" + ". " +  "answerAskQueue ")
				//+ ( "\r data : " + Dumper.dump( dt.results[ 0 ].buy_price ) )
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r : " + dt.results[ 0 ].buy_price.amount )
				//+ ( "\r data: " + data )
				+ ( "\r amountOver: " + amountOver )
				+ ( "\r _amount: " + _amount )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
			
			
			if ( amountOver < _amount )
				this.dispatchEvent( new LDgEvent( LDgEvent.PLEASE_REQUEST_QUEUE, false, false, { bot: this, method: cancelSell } ) );
				
				_callback();
			
			
		}
		
		private function cancelSell( callback:Function ):void 
		{
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "BotOfLot.as" + ". " +  "cancelSell ")
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
		
			_callback = callback;
			new CancelSell( _placeId, answCancel );
		}
		
		private function answCancel( data:* = null ):void 
		{
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "BotOfLot.as" + ". " +  "answCancel ")
				+ ( "\r data: " + Dumper.dump( data ) )
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
			
			_callback();
		}
		
		
		
	}

}