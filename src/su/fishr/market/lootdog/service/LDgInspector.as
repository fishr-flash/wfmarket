package su.fishr.market.lootdog.service 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import su.fishr.market.lootdog.LDgEvent;
	import su.fishr.market.lootdog.net.AskLootDog;
	
	/**
	 * ...
	 * @author fishr
	 */
	public class LDgInspector extends EventDispatcher 
	{
		private static var _self:LDgInspector;
		static public function get self():LDgInspector 
		{
			if ( !_self ) 
				_self = new LDgInspector;
				
			return _self;
		}
		
		
		private var _bots:Vector.<BotOfLot>;
		private var _queue:Array/*Object*/ = new Array;
		private var _busyNet:Boolean = false;
		
		public function LDgInspector(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			
		}
		
		public function start():void
		{
			new AskLootDog( askResult );
		}
		
		
		
		private function askResult( data:* ):void 
		{
			try{
			
				/**
				 * Inspector.as. askResult 
				 goods.results : Array(2):
					[0] => Object (14): 
						status:(str,4) open
						buy_price:Object (3): 
							caption:(str,5) 599 ₽
							currency:(str,3) RUB
							amount:(int,3) 599
						amount:(number,1.4) 8.2392
						count_served:(int,1) 0
						user:Object (15): 
							id_slug:(str,32) 67838a1a1a7011e9b852002590c7edf4
							feedback_stats:Array(1):
								[0] => Object (2): 
									rating:(int,1) 1
									count:(int,1) 1
							all_feedbacks:(int,1) 1
							avatar:(str,132) https://cp-filin.mail.ru/pic?width=180&height=180&d=3667iMo9HLIsWq90T8D_CpMCbjoQHIG0F6fBRPEbdkDzIhseWE-KmI9Xhbs4Mf6SSJFE_GiIo0Uqu2AD
							able_to_feedback:(bool) false
							language:(str,2) RU
							name:(str,14) Гера Ладожский
							deals_stats:Object (3): 
								bought:(int,1) 0
								sold:(int,2) 10
								total:(int,2) 10
							avatar_medium:(str,0) 
							positive_feedbacks:(int,1) 0
							first_deal:Object (3): 
								caption:(str,14) 10.04.19 18:51
								caption_date:(str,8) 10.04.19
								date:(str,32) 2019-04-10T18:51:04.709258+03:00
							rating:(str,4) 1.00
							id:(str,32) 67838a1a1a7011e9b852002590c7edf4
							added:Object (3): 
								caption:(str,14) 17.01.19 18:56
								caption_date:(str,8) 17.01.19
								date:(str,32) 2019-01-17T18:56:08.685294+03:00
							deleted:(bool) false
						sell_price:Object (3): 
							caption:(str,8) 509.15 ₽
							currency:(str,3) RUB
							amount:(number,3.2) 509.15
						product:Object (16): 
							kind:(str,6) mailru
							rarity_color:(str,7) #FFB042
							thumbnail_wide:(str,74) /pre_290x133_resize/hotbox/lootdog_products/product_pic/2018/09/03/910.png
							is_key:(bool) true
							name:(str,23) Шлем инженера "Абсолют"
							description_text:(str,194) <p>Шлем «Абсолют» повышает защиту головы на 45%, снижает эффект от светошумовых гранат на 70%. Является частью набора экипировки "Абсолют", дающей при сборе комплекта дополнительные бонусы. </p>
							picture_orig:(str,70) /pre_0x0_resize/hotbox/lootdog_products/product_pic/2018/09/03/910.png
							tags:Object (0): 
							thumbnail_rect:(str,74) /pre_335x223_resize/hotbox/lootdog_products/product_pic/2018/09/03/910.png
							id:(int,3) 910
							thumbnail_square:(str,74) /pre_137x137_resize/hotbox/lootdog_products/product_pic/2018/09/03/910.png
							description:Object (3): 
								is_rare:(bool) false
								descriptions:Array(1):
									[0] => Object (2): 
										value:(str,187) Шлем «Абсолют» повышает защиту головы на 45%, снижает эффект от светошумовых гранат на 70%. Является частью набора экипировки "Абсолют", дающей при сборе комплекта дополнительные бонусы. 
										type:(str,4) html
								rarity_color:(str,6) ffb042
							name_color:(str,7) inherit
							popularity:(int,2) 24
							is_approved:(bool) true
							activate_only:(bool) true
						comission:Object (3): 
							caption:(str,7) 89.85 ₽
							currency:(str,3) RUB
							amount:(number,2.2) 89.85
						game:(int,2) 43
						id:(str,32) 38ea140e60f611e9b418002590c7edf4
						is_buy:(bool) false
						item:Object (10): 
							rarity_color:(str,7) #afc2da
							code_opened:(bool) false
							locked:(bool) false
							return_only:(bool) false
							is_verified:(bool) true
							name_color:(str,7) inherit
							description:(str,0) 
							description_text:(str,0) 
							id:(int,7) 6259207
							activate_only:(bool) true
						rank:(int,2) 12
						count_total:(int,1) 0
					
				 */
				const goods:Object = JSON.parse( data );
				
				//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( false )
			{
				const i:String = 
				( "LDgInspector.as" + ". " +  "askResult ")
				+ ( "\r goods.results : " + Dumper.dump( goods.results ) )
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r : " + "" )
				+ ( "\r data : " + data )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
			
				if ( !_bots )
					_bots = new Vector.<BotOfLot>;
					
				const klen:int = goods.results.length;
				
				for (var k:int = 0; k < klen; k++) 
				{ 
					
					//////////////////////TRACE/////////////////////////////////
					
					import su.fishr.market.service.Logw;
					import su.fishr.utils.Dumper;
					if( false )
					{
						const l:String = 
						( "LDgInspector.as" + ". " +  "askResult ")
						//+ ( "\r : " + Dumper.dump( true ) )
						+ ( "\r id: " + goods.results[ k ].product.id  )
						+ ( "\r id2: " + goods.results[ k ].id  )
						+ ( "\r name: " + goods.results[ k ].product.name  )
						+ ( "\r amount: " + goods.results[ k ].buy_price.amount  )
						+ ( "\r amount: " + goods.results[ k ].user.id  )
						+ ( "\r end" );
						Logw.inst.up( l );
					}
					/////////////////////END TRACE//////////////////////////////
					
					const bot:BotOfLot = new BotOfLot( 
												goods.results[ k ].product.id 
												, goods.results[ k ].id
												, goods.results[ k ].product.name  
												, goods.results[ k ].buy_price.amount  
												, goods.results[ k ].user.id  
											);
					bot.addEventListener( LDgEvent.PLEASE_REQUEST_QUEUE, requestQueue );
					bot.start();
					_bots.push( bot );
											
					
												
				}
				
			} catch ( err:Error )
			{
				//////////////////////TRACE/////////////////////////////////
				
				import su.fishr.market.service.Logw;
				import su.fishr.utils.Dumper;
				if( true )
				{
					var j:String = 
					( "LDgInspector.as" + ". " +  "askResult ")
					//+ ( "\r : " + Dumper.dump( true ) )
					+ ( "\r err: " + err )
					+ ( "\r end" );
					Logw.inst.up( j );
				}
				/////////////////////END TRACE//////////////////////////////
			}
			
			
		}
		
		private function requestQueue(e:LDgEvent = null):void 
		{
			
			
			if( e ) _queue.push( e.data );
			
			if ( !_busyNet && _queue.length )
			{
				const data:Object = _queue.splice( 0, 1 )[ 0 ];
				//////////////////////TRACE/////////////////////////////////
				
				import su.fishr.market.service.Logw;
				import su.fishr.utils.Dumper;
				if( true )
				{
					const i:String = 
					( "LDgInspector.as" + ". " +  "requestQueue ")
					+ ( "\r data: " + Dumper.dump( data ) )
					//+ ( "\r : " + Dumper.dump( true ) )
					+ ( "\r : " + "" )
					+ ( "\r end" );
					Logw.inst.up( i );
				}
				/////////////////////END TRACE//////////////////////////////
				
				//data.bot[ data.method ]( completeRequestBot );
				data.method( completeRequestBot );
				_busyNet = true;
			}
			
		}
		
		private function completeRequestBot( data:* = null):void  
		{
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "LDgInspector.as" + ". " +  "completeRequestBot ")
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r _queue: " + _queue.length )
				+ ( "\r data: " + data )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
			
			_busyNet = false;
			requestQueue();
		}
		
		public function kill():void 
		{
			
		}
		
		
	}

}