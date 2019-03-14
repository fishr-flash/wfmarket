package su.fishr.market 
{
	import fl.controls.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import su.fishr.bases.BaseSprites;
	import su.fishr.market.components.BackgroundShape;
	import su.fishr.market.components.PriceOfWeapons;
	import su.fishr.market.components.TFItem;
	import su.fishr.market.seller.Sellerq;
	import su.fishr.market.service.BotRequest;
	import su.fishr.market.service.ItemsServant;
	import su.fishr.market.service.Logw;
	import su.fishr.market.service.bayer.BotBuyer;
	import su.fishr.market.service.connections.TelegramBot;
	import su.fishr.utils.createCustomTextField;
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
		public static const VERSION:Array = [ 1, 12, 4 ];
		
		public static const MAX_REQUEST_DELAY:int = 25000;
		public static const WIDTH_BUTTONS:int = 35;
		public static const MIN_REQUEST_DELAY:int = 40000;
		public static const CHARGE_RATIO:Number = 1.05;
		public static const DELAY_ON_BUYER:int = 1500;
		public static const TEME_COLOR:uint = 0x343343;
		public static const FONT_COLOR:uint = 0xAAAAAA;
		public static const IGNORE_HIDDEN:Boolean = false;
		/// загужать все данные игнорируя джейсон файл перечня
		public static const IGNORE_CONFIG:Boolean = false;
		
		static public const PROP_LIQUIBITY:String = "liquidity";
		static public const PROP_COST:String = "cost";
		
		/// может переопределяться ниже
		public static var SORT_PROP:String = "cost";
		public static var _CASH:int = 0;
		
		
		private var _btnRequest:Button;
		private var _botReqest:BotRequest;
		private var _btnStop:Button;
		private var _btnPlay:Button;
		private var _servant:ItemsServant;
		private var _infoField:Sprite;
		private var _price:PriceOfWeapons;
		private var _btnOnAlert:Button;
		private var _buy_counter:int = 100;
		private var _btnAutoBuy:Button;
		private var _onPausePlay:Boolean;
		private var _versionLabel:TFItem;
		private var _btnUnload:Button;
		private var _btnLoad:Button;
		private var _file:FileReference;
		private var _btnCfg:Button;
		private var _seller:Sellerq;
		private var _tfCash:TextField;
		
		public static function getCostOnCharge( cost:int ):int
		{
			return Math.ceil( cost * MarketplaceWF.CHARGE_RATIO );
		}
		
		public function MarketplaceWF() 
		{
			super();
			init();
			
			// задаем свойство сортировки
			SORT_PROP = PROP_LIQUIBITY;
			
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
			
			
			
			_btnPlay = new Button;
			_btnPlay.label = "run";
			_btnPlay.x = 0;
			_btnPlay.y = 0;
			_btnPlay.setSize( WIDTH_BUTTONS, _btnPlay.height );
			_btnPlay.addEventListener( MouseEvent.CLICK, onPlay );
			this.addChild( _btnPlay );
			
			_btnStop = new Button;
			_btnStop.label = "stop";
			_btnStop.x = _btnPlay.x + _btnPlay.width + 5;
			_btnStop.y = _btnPlay.y;
			_btnStop.enabled = false;
			_btnStop.setSize( WIDTH_BUTTONS, _btnStop.height );
			_btnStop.addEventListener( MouseEvent.CLICK, onStop );
			this.addChild( _btnStop );
			
			_btnRequest = new Button;
			_btnRequest.label = "req";
			_btnRequest.x = _btnStop.x + _btnStop.width + 5;
			_btnRequest.y = _btnStop.y;
			_btnRequest.setSize( WIDTH_BUTTONS, _btnRequest.height );
			_btnRequest.addEventListener( MouseEvent.CLICK, onRequest );
			this.addChild( _btnRequest );
			
			_btnUnload = new Button;
			_btnUnload.label = "unl";
			_btnUnload.x = _btnRequest.x + _btnRequest.width + 25;
			_btnUnload.y = _btnRequest.y;
			_btnUnload.setSize( WIDTH_BUTTONS, _btnRequest.height );
			_btnUnload.addEventListener( MouseEvent.CLICK, onUnload );
			this.addChild( _btnUnload );
			_btnUnload.enabled = false;
			
			_btnLoad = new Button;
			_btnLoad.label = "dwn";
			_btnLoad.x = _btnUnload.x + _btnUnload.width + 5;
			_btnLoad.y = _btnUnload.y;
			_btnLoad.setSize( WIDTH_BUTTONS + 5, _btnLoad.height );
			this.addChild( _btnLoad );
			_btnLoad.addEventListener( MouseEvent.CLICK, btnOnLoad );
			
			_btnCfg = new Button;
			_btnCfg.label = "cfg";
			_btnCfg.x = _btnLoad.x + _btnLoad.width + 5;
			_btnCfg.y = _btnLoad.y;
			_btnCfg.setSize( WIDTH_BUTTONS + 5, _btnCfg.height );
			this.addChild( _btnCfg );
			_btnCfg.addEventListener( MouseEvent.CLICK, onBtnCfg );
			_btnCfg.enabled = false;
			
			
			_btnOnAlert = new Button;
			_btnOnAlert.label = "alrt";
			_btnOnAlert.x = _btnCfg.x + _btnCfg.width + 25;
			_btnOnAlert.y = _btnCfg.y;
			_btnOnAlert.setSize( WIDTH_BUTTONS, _btnOnAlert.height );
			_btnOnAlert.addEventListener( MouseEvent.CLICK, onBtnAlert );
			this.addChild( _btnOnAlert );
			_btnOnAlert.toggle = true;
			_btnOnAlert.selected = true;
			
			
			_tfCash = createCustomTextField( 0, 0, 40, 20 );
			_tfCash.x = _btnOnAlert.x + _btnOnAlert.width + 5;
			_tfCash.y = _btnOnAlert.y;
			this.addChild( _tfCash );
			_tfCash.addEventListener( Event.CHANGE, inputCash );
			
			_btnAutoBuy = new Button;
			_btnAutoBuy.label = "abuy";
			_btnAutoBuy.x = _tfCash.x + _tfCash.width + 5;
			_btnAutoBuy.y = _tfCash.y;
			_btnAutoBuy.setSize( WIDTH_BUTTONS + 5, _btnAutoBuy.height );
			_btnAutoBuy.toggle = true;
			_btnAutoBuy.selected = false;
			_btnAutoBuy.enabled = false;
			this.addChild( _btnAutoBuy );
			_btnAutoBuy.addEventListener( MouseEvent.CLICK, btnBuyHandler );
			
			
			
			
			const href:TFItem = new TFItem;
			href.htmlText = '<a href="https://wf.mail.ru/inventory" target="_blank" > market</a>';
			href.y = _btnAutoBuy.y - 5;
			href.x = _btnAutoBuy.x + _btnAutoBuy.width + 5;					
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
			
			
			_seller = new Sellerq;
			_seller.x = href.x + href.width + 100;
			_seller.y = _btnAutoBuy.y;
			this.addChild( _seller );
			
			
			
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
		
		private function inputCash(e:Event):void 
		{
			
			_CASH = int( e.target.text );
			if ( _CASH ) _btnAutoBuy.enabled = true;
			else _btnAutoBuy.enabled = false;
		   
		}
		
		private function btnOnLoad(e:MouseEvent):void 
		{
			//_btnLoad.enabled = false;
			
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "MarketplaceWF.as" + ". " +  "btnOnLoad ")
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
			
			_file = new FileReference;
			_file.addEventListener( Event.SELECT, onSelectFile );
			_file.browse();
			
		}
		
		private function onSelectFile(e:Event):void 
		{
			
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "MarketplaceWF.as" + ". " +  "onSelectFile ")
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
			_file.removeEventListener( Event.SELECT, onSelectFile );
			_file.addEventListener(Event.COMPLETE, onCompleteFile );
			_file.load();
		}
		
		private function onCompleteFile(e:Event):void 
		{
			_file.removeEventListener(Event.COMPLETE, onCompleteFile );
			/**
			 * -{
				"c" : 105,
				"lq" : 5,
					"t" : -{
							"mn" : 02,
							"min" : 04,
							"sec" : 18,
							"yr" : 2019,
							"d" : 27,
							"hrs" : 19
							},
				"sess" : 104,
				"cnt" : 1323
				}
				],
				"head" : -{
							"key" : AWM Карбон,
							"maxc" : 100,
							"minc" : 100,
							"id" : 3863
						}
				},
			 */
				
				import su.fishr.market.service.Logw;
				import su.fishr.utils.Dumper;
				if( true )
				{
					const i:String = 
					( "MarketplaceWF.as" + ". " +  "onCompleteFile ")
					//+ ( "\r : " + Dumper.dump( true ) )
					+ ( "\r load file name: " + e.target.name )
					+ ( "\r end" );
					Logw.inst.up( i );
				}
				
			const b:ByteArray = e.target.data;
			b.position = 0;
			_servant.setStory( JSON.parse(  b.readUTFBytes( b.bytesAvailable ) ) as Array);
			_btnUnload.enabled = true;
		}
		
		private function btnBuyHandler(e:MouseEvent):void 
		{
			if ( _btnAutoBuy.selected )
						_buy_counter = 100;
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
			var name:String = "hist_" 
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
								
								

		    if ( IGNORE_CONFIG ) name += "_a";
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
			const went:WeaponEnt = e.data as WeaponEnt;
			
			_servant.removeEventListener( WFMEvent.ON_AUTOBUY, onBayOperation );
			
			if ( _buy_counter > 0 && _btnAutoBuy.selected == true  )
			{
				
				if ( _CASH >= int( went.cost ) )
				{

					if ( went.parent.maxBuyCount > 0 )
					{
						if ( !_btnPlay.enabled )
							_onPausePlay = true;
							
						onStop( null );
							
						new BotBuyer( went.entity_id, went.cost, went.type, buyResult )
					}
					else
					{
						//////////////////////TRACE/////////////////////////////////
						
						import su.fishr.market.service.Logw;
						import su.fishr.utils.Dumper;
						if( true )
						{
							const j:String = 
							( "MarketplaceWF.as" + ". " +  "onBayOperation ")
							//+ ( "\r : " + Dumper.dump( true ) )
							+ ( "\r : " + "the purchase limit for this product has been reached" )
							+ ( "\rwent.key : " + went.key )
							+ ( "\r went.parent.groupKey: " + went.parent.groupKey )
							+ ( "\rwent.parent.maxBuyCount : " + went.parent.maxBuyCount )
							+ ( "\r : " + "" )
							+ ( "\r end" );
							Logw.inst.up( j );
						}
						/////////////////////END TRACE//////////////////////////////
					}
					
				}
				else
				{
					_servant.addEventListener( WFMEvent.ON_AUTOBUY, onBayOperation );
					
					//////////////////////TRACE/////////////////////////////////
					
					import su.fishr.market.service.Logw;
					import su.fishr.utils.Dumper;
					if( true )
					{
						const i:String = 
						( "MarketplaceWF.as" + ". " +  "onBayOperation ")
						+ ( "\r : " + "not enough money to buy, need: " + went.cost )
						+ ( "\r : " + "_CASH: " + _CASH )
						//+ ( "\r : " + Dumper.dump( "" ) )
						+ ( "\r end" );
						Logw.inst.up( i );
					}
					/////////////////////END TRACE//////////////////////////////
				}
				
			}
			else if ( _btnAutoBuy.selected == true )
			{
				_btnAutoBuy.selected = false;
				
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
			 * 15:22:19:845                              ===>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
				 MarketplaceWF.as. buyResult 
				 d: Object (3): 
					cost:(int,2) 42
					entity_id:(int,4) 3900
					state:(str,63) ***************Operation successfull***************************
				 end

				 15:22:19:983                              ===>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
				 BotRequest.as. callLoader 
				 onload: 

				 15:22:24:372                              ===>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
				 MarketplaceWF.as. buyResult 
				 d: Object (2): 
					detals:Object (2): 
						state:(str,7) Success
						data:Object (2): 
							inv_id:(int,9) 140557407
							cost:(int,3) 120
					status:(str,47) The operation was cancelled. Price has changed.
				 end
			 */
			
			
			 import su.fishr.market.service.Logw;
			 import su.fishr.utils.Dumper;
			 if( true )
			 {
				 const i:String = 
				 ( "MarketplaceWF.as" + ". " +  "buyResult ")
				 + ( "\r : " + "" )
				 + ( "\r d: " + Dumper.dump( d ) )
				 //+ ( "\r : " + Dumper.dump( "" ) )
				 + ( "\r end" );
				 Logw.inst.up( i );
			 }
			 
			 const res:String = " status: " + d.state;
			 
			if ( _btnOnAlert.selected )
					TelegramBot.inst.onBuyResult( res );
					
			if ( _onPausePlay )
					onPlay( null );
					
			_onPausePlay = false;
					
			if ( res.indexOf( "Operation successfull" ) > -1 )
			{
				_buy_counter--;
				const onBuyCost:int = _servant.getBuyCost( int( d.entity_id ) );
				_CASH -= onBuyCost;
				_tfCash.text = _CASH + "";
				
				_seller.sell( int( d.entity_id ), int( ( Math.random() * 5 ) + ( onBuyCost + 2000 ) ) );
			}
			
			_servant.addEventListener( WFMEvent.ON_AUTOBUY, onBayOperation );
		}
		
		private function onBtnAlert(e:MouseEvent):void 
		{
			_btnOnAlert.selected = _btnOnAlert.selected == true;
			
			
		}
		
		private function onBtnCfg(e:MouseEvent):void 
		{
			
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "MarketplaceWF.as" + ". " +  "onBtnCfg ")
				+ ( "\r _servant.generateCofig(): " + _servant.generateCofig() )
				+ ( "\r : " + "" )
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
			
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
			_btnCfg.enabled = true;
		}
		
		

	}

}