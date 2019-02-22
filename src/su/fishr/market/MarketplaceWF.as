package su.fishr.market 
{
	import fl.controls.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
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
	import su.fishr.market.service.utils.dateFormat;
	import su.fishr.utils.AddZerroDate;
	import su.fishr.utils.Dumper;
	
	/**
	 * ...
	 * @author  
	 */
	public class MarketplaceWF extends BaseSprites 
	{
		public static const VERSION:Array = [ 1, 5, 2 ];
		
		public static const MAX_REQUEST_DELAY:int = 15000;
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
		private var _buy_counter:int = 10;
		private var _btnOnBuy:Button;
		private var _onPausePlay:Boolean;
		private var _versionLabel:TFItem;
		private var _btnUnload:Button;
		
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
			
			const back:BackgroundShape = new BackgroundShape( 1800, 900 );
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
			
			_btnUnload = new Button;
			_btnUnload.label = "unl";
			_btnUnload.x = _btnRequest.x + _btnRequest.width + 25;
			_btnUnload.y = _btnRequest.y;
			_btnUnload.setSize( wdthBtns, _btnRequest.height );
			_btnUnload.addEventListener( MouseEvent.CLICK, onUnload );
			this.addChild( _btnUnload );
			_btnUnload.enabled = false;
			
			_btnOnAlert = new Button;
			_btnOnAlert.label = "alrt";
			_btnOnAlert.x = _btnUnload.x + _btnUnload.width + 25;
			_btnOnAlert.y = _btnUnload.y;
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
			href.y = _btnOnBuy.y - 5;
			href.x = _btnOnBuy.x + _btnOnBuy.width + 5;
			this.addChild( href );
			
			
			_versionLabel = new TFItem;
			_versionLabel.text = configureVersion();
			_versionLabel.x = href.x + 10;// back.width - _versionLabel.width;
			_versionLabel.y = href.y + 15;
			_versionLabel.scaleX = _versionLabel.scaleY = .7;
			this.addChild( _versionLabel );
			function configureVersion():String
			{
				return AddZerroDate( VERSION[ 0 ] )
				+ "." 
				+ AddZerroDate( VERSION[ 1 ] )
				+ "." 
				+ AddZerroDate( VERSION[ 2 ], 3 );
			}
			
			
			
			
			//this.addChild( new shStyle )
			//TelegramBot.inst.setMessage( '<a href="http://yandex.ru">sdfsdfsdf</a>' );
			//TelegramBot.inst.setMessage( "<font color=0xFF0000><i>hello</i></font>" );
			
			_servant.addEventListener( WFMEvent.ON_LOW_COST, onLowCost );
			_servant.addEventListener( WFMEvent.ON_HEIGHT_COST, onHeightCost );
			_servant.addEventListener( WFMEvent.ON_AUTOBUY, onBayOperation );
			
			_botReqest = new BotRequest;
			_botReqest.addEventListener( BotRequest.ON_RESULT_REQUEST, onResult );
			
			
			
			//const breq:BayRequester = new BayRequester( onResult );
			
		}
		
		
		
		/**
		 * [158] => Object (6): 
					key:(str,29) Fabarm XLR5 Prestige Синдикат
					t:Object (6): 
						minutes:(str,2) 29
						month:(str,2) 02
						seconds:(str,2) 14
						year:(str,4) 2019
						hourse:(str,2) 21
						day:(str,2) 20
					entity_id:(int,4) 3890
					liquidity:(int,1) 0
					count:(int,2) 65
					cost:(int,4) 3150
		 * @param	e
		 */
		private function onUnload(e:MouseEvent):void 
		{
			const data:Array = _servant.getHistory();
			
			
			const jsn:String = JSON.stringify( data );
			const fileRef:FileReference = new FileReference;
			const dt:Array = dateFormat();
			const name:String = "hist_" 
								+  data[ 0 ].tl[ 0 ].t.d 
								+  data[ 0 ].tl[ 0 ].t.mn 
								+  data[ 0 ].tl[ 0 ].t.yr 
								+ "_" 
								+  data[ 0 ].tl[ 0 ].t.hrs
								+  data[ 0 ].tl[ 0 ].t.min
								+ "-"
								+  data[ 0 ].tl[  data[ 0 ].tl.length - 1 ].t.d 
								+  data[ 0 ].tl[  data[ 0 ].tl.length - 1 ].t.mn 
								+  data[ 0 ].tl[  data[ 0 ].tl.length - 1 ].t.yr 
								+ "_" 
								+  data[ 0 ].tl[  data[ 0 ].tl.length - 1 ].t.hrs
								+  data[ 0 ].tl[  data[ 0 ].tl.length - 1 ].t.min;
								
								

			fileRef.save( jsn, name );
			
			
			
			
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
			
				if ( !_btnPlay.enabled )
						_onPausePlay = true;
						
				onStop( null );
						
				new BotBuyer( went.entity_id, went.cost, went.type, buyResult )
			}
			else if ( _btnOnBuy.selected == true )
			{
				_btnOnBuy.selected = false;
				
				buyResult( { status:"You have reached the limit of purchase transactions", data:e.data.key, went:e.data.cost, count: _buy_counter } );
				
				
			}
			
			
						
			
			
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
			const bot:BotBuyer = new BotBuyer( 2995, 50, "inventory", buyResult )
		}
		
		private function buyResult( d:Object ):void
		{
			/**
			 * Object (2): 
				detals:Object (2): 
					state:(str,7) Success
					data:Object (2): 
						cost:(int,3) 124
						inv_id:(int,9) 137663284
				status:(str,47) The operation was cancelled. Price has changed.&parse_mode=HTML
			 */
			
			
			const res:String = "cost: " + d.detals.data.cost + ", status: " + d.status;
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "MarketplaceWF.as" + ". " +  "buyResult ")
				+ ( "\r res: " +  res)
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
			
			if ( _btnOnAlert.selected )
					TelegramBot.inst.onBuyResult( res );
					
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
		
		private function onHeightCost(e:WFMEvent):void 
		{
			if ( _btnOnAlert.selected ) 
								TelegramBot.inst.setMessageOnNegativeCost( e.data as WeaponGroup );
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
			
			_btnUnload.enabled = true;
		}
		
		

	}

}