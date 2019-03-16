package su.fishr.market.seller 
{
	import fl.controls.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.setTimeout;
	import su.fishr.market.MarketplaceWF;
	import su.fishr.market.components.TFItem;
	import su.fishr.market.seller.nets.ListSellsRequest;
	import su.fishr.market.seller.nets.SellRequest;
	
	/**
	 * ...
	 * @author fishr
	 */
	public class Sellerq extends Sprite 
	{
		private var _btnOnList:Button;
		private var _tfItemId:TextField;
		private var _tfCost:TextField;
		private var _btnSell:Button;
		
		public function Sellerq() 
		{
			super();
			
			init();
			
			
		}
		
		public function sell(entity_id:int,  cost:int ):void 
		{
			setTimeout( autoSell, int( ( Math.random() * 30000 ) + 25000 ), entity_id, cost );
		}
		
		
		
		private function init():void 
		{
			_btnOnList = new Button;
			_btnOnList.label = "lst";
			_btnOnList.x = 0;
			_btnOnList.y = 0;
			_btnOnList.setSize( MarketplaceWF.WIDTH_BUTTONS, _btnOnList.height );
			_btnOnList.addEventListener( MouseEvent.CLICK, onBtnList );
			this.addChild( _btnOnList );
			
			
			_tfItemId = createCustomTextField( 0, 0, 70, 20 );
			_tfItemId.x = _btnOnList.x + _btnOnList.width + 10;
			this.addChild( _tfItemId );
			_tfItemId.addEventListener( TextEvent.TEXT_INPUT, onTFChange );
			
			
			_tfCost = createCustomTextField( 0, 0, 50, 20 );
			_tfCost.x = _tfItemId.x + _tfItemId.width + 5;
			_tfCost.addEventListener( TextEvent.TEXT_INPUT, onTFChange );
			this.addChild( _tfCost );
			
			_btnSell = new Button;
			_btnSell.label = "sell";
			_btnSell.x = _tfCost.x + _tfCost.width + 10;
			_btnSell.y = 0;
			_btnSell.setSize( MarketplaceWF.WIDTH_BUTTONS, _btnSell.height );
			_btnSell.addEventListener( MouseEvent.CLICK, onBtnSell );
			_btnSell.enabled = false;
			this.addChild( _btnSell );
			
			
			
		}
		
		private function onTFChange(e:Event):void 
		{
			
			if ( _tfItemId.text.length && _tfCost.text.length )
				_btnSell.enabled = true;
			else 
				_btnSell.enabled = false;
		}
		
		private function onBtnSell(e:MouseEvent):void 
		{
			_btnSell.enabled = _btnOnList.enabled = false;
			
			const request:SellRequest = new SellRequest( int( _tfItemId.text ), int( _tfCost.text ), onResultRequest );
			
			//_tfItemId.text = _tfCost.text = "";
			
		}
		
		private function onBtnList(e:MouseEvent):void 
		{
			
			new ListSellsRequest( onListResive );
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "Sellerq.as" + ". " +  "onBtnList ")
				+ ( "\r : " + "" )
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
		}
		
		private function onListResive( data:* ):void 
		{
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "Sellerq.as" + ". " +  "onListResive ")
				+ ( "\r : " + "" )
				+ ( "\rdata : " + Dumper.dump( JSON.parse( data ) ) )
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
		}
		
		private function onResultRequest( data:* ):void
		{
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "Sellerq.as" + ". " +  "onResultRequest ")
				+ ( "\r : " + "" )
				+ ( "\r data: " + Dumper.dump( data ) )
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
			
			_btnOnList.enabled = true;
		}
		
		private function autoSell(entity_id:int,  cost:int ):void 
		{
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "Sellerq.as" + ". " +  "autoSell ")
				+ ( "\rentity_id : " + entity_id )
				+ ( "\r cost: " + cost )
				+ ( "\r : " + "" )
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
			new SellRequest( entity_id, cost, onResultRequest );
		}
		
		private function createCustomTextField(x:Number, y:Number, width:Number, height:Number):TextField {
            var result:TextField = new TextField();
            result.x = x;
            result.y = y;
            result.width = width;
            result.height = height;
            result.background = true;
            result.border = true;
			result.type = TextFieldType.INPUT;
            return result;
        }
		
	}

}