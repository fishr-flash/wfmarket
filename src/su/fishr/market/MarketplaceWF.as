package su.fishr.market 
{
	import fl.controls.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import su.fishr.bases.BaseSprites;
	import su.fishr.market.components.BackgroundShape;
	import su.fishr.market.components.PriceOfWeapons;
	import su.fishr.market.components.TFItem;
	import su.fishr.market.service.BotRequest;
	import su.fishr.market.service.ItemsServant;
	import su.fishr.market.service.Logw;
	import su.fishr.market.service.bayer.BotBuyer;
	import su.fishr.market.service.connections.TelegramBot;
	import su.fishr.market.service.model.WeaponEnt;
	import su.fishr.market.service.model.WeaponGroup;
	import su.fishr.utils.Dumper;
	
	/**
	 * ...
	 * @author  
	 */
	public class MarketplaceWF extends BaseSprites 
	{
		public static const MAX_REQUEST_DELAY:int = 35000;
		public static const MIN_REQUEST_DELAY:int = 35000;
		public static const CHARGE_RATIO:Number = 1.05;
		public static const DELAY_ON_BUYER:int = 2000;
		public static const TEME_COLOR:uint = 0x343343;
		public static const FONT_COLOR:uint = 0xAAAAAA;
		
		private var _btnRequest:Button;
		private var _botReqest:BotRequest;
		private var _btnStop:Button;
		private var _btnPlay:Button;
		private var _servant:ItemsServant;
		private var _infoField:Sprite;
		private var _price:PriceOfWeapons;
		private var _btnOnAlert:Button;
		private var _buy_counter:int = 3;
		private var _btnOnBuy:Button;
		private var _onPausePlay:Boolean;
		
		public static function getCostOnCharge( cost:int ):int
		{
			return Math.ceil( cost * MarketplaceWF.CHARGE_RATIO );
		}
		
		public function MarketplaceWF() 
		{
			super();
			init();
			
		}
		
		
		
		private function init():void 
		{
			//setSize( 1266, 900 );
			
			const back:BackgroundShape = new BackgroundShape( 1600, 1100 );
			this.addChild( back ) ;
			
						
			_price = new PriceOfWeapons;
			_price.x = 50;
			_price.y = 50;
			this.addChild( _price );
			
			Logw.inst.x = _price.x;
			Logw.inst.y = _price.y + _price.height + 40;
			
			this.addChild( Logw.inst );
			
			_servant = new ItemsServant;
			
			const wdthBtns:int = 35;
			
			_btnPlay = new Button;
			_btnPlay.label = "run";
			_btnPlay.x = 0;
			_btnPlay.y = 0;
			_btnPlay.setSize( wdthBtns, _btnPlay.height );
			_btnPlay.addEventListener( MouseEvent.CLICK, onPlay );
			this.addChild( _btnPlay );
			
			_btnStop = new Button;
			_btnStop.label = "stop";
			_btnStop.x = _btnPlay.x + _btnPlay.width + 5;
			_btnStop.y = _btnPlay.y;
			_btnStop.enabled = false;
			_btnStop.setSize( wdthBtns, _btnStop.height );
			_btnStop.addEventListener( MouseEvent.CLICK, onStop );
			this.addChild( _btnStop );
			
			_btnRequest = new Button;
			_btnRequest.label = "req";
			_btnRequest.x = _btnStop.x + _btnStop.width + 5;
			_btnRequest.y = _btnStop.y;
			_btnRequest.setSize( wdthBtns, _btnRequest.height );
			_btnRequest.addEventListener( MouseEvent.CLICK, onRequest );
			this.addChild( _btnRequest );
			
			_btnOnAlert = new Button;
			_btnOnAlert.label = "alrt";
			_btnOnAlert.x = _btnRequest.x + _btnRequest.width + 5;
			_btnOnAlert.y = _btnRequest.y;
			_btnOnAlert.setSize( wdthBtns, _btnOnAlert.height );
			_btnOnAlert.addEventListener( MouseEvent.CLICK, onBtnAlert );
			this.addChild( _btnOnAlert );
			_btnOnAlert.toggle = true;
			_btnOnAlert.selected = true;
			
			_btnOnBuy = new Button;
			_btnOnBuy.label = "abuy";
			_btnOnBuy.x = _btnOnAlert.x + _btnOnAlert.width + 5;
			_btnOnBuy.y = _btnOnAlert.y;
			_btnOnBuy.setSize( wdthBtns + 5, _btnOnBuy.height );
			_btnOnBuy.toggle = true;
			_btnOnBuy.selected = false;
			this.addChild( _btnOnBuy );
			
			const href:TFItem = new TFItem;
			href.htmlText = '<a href="https://wf.mail.ru/inventory" target="_blank" > market</a>';
			href.x = _btnOnBuy.x + _btnOnBuy.width + 5;
			href.y = _btnOnBuy.y;
			this.addChild( href );
			
			
			
			
			
			//this.addChild( new shStyle )
			//TelegramBot.inst.setMessage( '<a href="http://yandex.ru">sdfsdfsdf</a>' );
			//TelegramBot.inst.setMessage( "<font color=0xFF0000><i>hello</i></font>" );
			
			_servant.addEventListener( WFMEvent.ON_LOW_COST, onLowCost );
			_servant.addEventListener( WFMEvent.ON_AUTOBUY, onBayOperation );
			
			_botReqest = new BotRequest;
			_botReqest.addEventListener( BotRequest.ON_RESULT_REQUEST, onResult );
			
			
			
			//const breq:BayRequester = new BayRequester( onResult );
			
		}
		
		/**
		 * e.data: [object WeaponEnt]: 
			variables (0): 
			constants (0): 
			accessors (6) 
				readonly cost = (int,3) 630
				readonly maxcost = (int,3) 630
				readonly mincost = (int,3) 630
				readonly type = (str,9) inventory
				readonly entity_id = (int,4) 3932
				readonly key = (str,22) SAI GRY AR-15 Синдикат
		 * @param	e
		 */
		private function onBayOperation(e:WFMEvent):void 
		{
			_servant.removeEventListener( WFMEvent.ON_AUTOBUY, onBayOperation );
			if ( _buy_counter > 0 && _btnOnBuy.selected == true )
			{
				_buy_counter--;
				const went:WeaponEnt = e.data as WeaponEnt;
			
				new BotBuyer( went.entity_id, went.cost, went.type, bayResult )
			}
			else if ( _btnOnBuy.selected == true )
			{
				_btnOnBuy.selected = false;
				
				bayResult( { status:"You have reached the limit of purchase transactions", data:e.data.key, went:went.cost, count: _buy_counter } );
				
			}
			
			if ( !_btnPlay.enabled )
						_onPausePlay = true;
						
			onStop( null );
			
		}
		
		private function onBuyer(e:MouseEvent):void 
		{
			/**
			 * [323] => Object (9): 
				entity_id:(int,4) 2995
				title:(str,28) K.I.W.I. KA-BAR Кукри-мачете
				count:(int,4) 3495
				kind:(str,6) weapon
				item:Object (4): 
					id:(str,10) kn07_set12
					title:(str,28) K.I.W.I. KA-BAR Кукри-мачете
					count:(int,1) 1
					permanent:(int,1) 1
				min_cost:(int,2) 42
				item_id:(str,10) kn07_set12
				class:(str,9) universal
				type:(str,9) inventory
			 */
			const bot:BotBuyer = new BotBuyer( 2995, 50, "inventory", bayResult )
		}
		
		private function bayResult( d:Object ):void
		{
			
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "MarketplaceWF.as" + ". " +  "bayResult ")
				//+ ( "\r d: " + d )
				+ ( "\r : " + Dumper.dump( d ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
			
			
			
			if ( _btnOnAlert.selected )
					TelegramBot.inst.onBuyResult( Dumper.dump( d ) );
					
			if ( _onPausePlay )
					onPlay( null );
					
			_onPausePlay = false;
					
			
			_servant.addEventListener( WFMEvent.ON_AUTOBUY, onBayOperation );
		}
		
		private function onBtnAlert(e:MouseEvent):void 
		{
			_btnOnAlert.selected = _btnOnAlert.selected == true;
		}
		
		private function onLowCost(e:WFMEvent):void 
		{
			
			if ( _btnOnAlert.selected ) 
								TelegramBot.inst.setMessageOnPositiveCost( e.data as WeaponGroup );

		}
		
		private function onPlay(e:MouseEvent):void 
		{
			_botReqest.play();
			_btnPlay.enabled = false;
			_btnStop.enabled = true;
		}
		
		private function onStop(e:MouseEvent):void 
		{
			_botReqest.stop();
			_btnPlay.enabled = true;
			_btnStop.enabled = false;
		}
		
		private function onRequest(e:MouseEvent):void 
		{
			
			_btnRequest.enabled = false;
			_btnPlay.enabled = false;
			_btnStop.enabled = false;
			_botReqest.onManual();
			
			
		}
		
		private function onResult(e:Event):void 
		{
			_btnRequest.enabled = true;
			
			if ( _botReqest.onplay == false )
			{
				_btnPlay.enabled = true;
				_btnStop.enabled = false;
			}
			else
			{
				_btnPlay.enabled = false;
				_btnStop.enabled = true;
			}
			
			
			
			_servant.setData( _botReqest.loadData );
			
			
			_price.setWeaponData( _servant.getWeaponData() );
		}

	}

}