package su.fishr.market.lootdog 
{
	import flash.display.Sprite;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import su.fishr.market.lootdog.service.LDListRequest;
	import su.fishr.market.lootdog.service.LDgInspector;
	import su.fishr.utils.Dumper;
	
	/**
	 * ...
	 * @author fishr
	 */
	public class LootDog extends Sprite 
	{
		
		private static var _list:Array;
		
		private var _onStopped:Boolean = false;
		private var _delayPeriod:int = 1000 * 60 * 120;
		private var _idInterval:int;
		
		
		static public function list():Array
		{
			return _list;
			
		}
		public function LootDog() 
		{
			super();

			
			
		}
		
		public function start():void
		{
			new LDListRequest( _callback );
		}
		
		public function setState( stopped:Boolean = false ):void
		{
			_onStopped = stopped;
			
			if ( _onStopped === false )
				_idInterval = setInterval( _onRequest, _delayPeriod );
			else
				clearInterval( _idInterval );
						
			
		}
		
		private function _onRequest():void
		{
			new LDListRequest( _callback );
		}
		
		private function _callback( result:Object ):void
		{
			
			if ( result.state.indexOf( "Operation successful" ) > -1 )
			{
				/**
				 * [3] => Object (20): 
						game:Object (15): 
							icon:(str,66) /pre_0x0_resize/hotbox/lootdog_products/game_pic/2018/09/19/43.png
							instruction_url:(str,0) 
							activation_url:(str,46) https://wf.mail.ru/pin/activate/?code=%%CODE%%
							show_close_key:(bool) true
							bind_url:(str,42) https://wf.mail.ru/inventory/#lootdog_auth
							product_back:(str,80) /pre_0x0_resize/hotbox/lootdog_products/game_product_back/2018/12/18/warface.png
							type:(str,6) mailru
							game_url:(str,57) https://1l-go.mail.ru/r/adid/2588966_1/pid/274/pof/1/f/3/
							name:(str,7) Warface
							cluster:(str,3) RUS
							background:(str,67) /pre_0x0_resize/hotbox/lootdog_products/game_back/2018/09/19/43.png
							rating:(int,2) 12
							code:(str,2) wf
							id:(int,2) 43
							popularity:(int,6) 333996
						description:Object (3): 
							rarity_color:(str,6) ffb042
							descriptions:Array(1):
								[0] => Object (2): 
									value:(str,400) Уникальная внешность «Абсолют» - это экипировка, не меняющая боевых характеристик владельца, но вселяющая страх в сердца врагов благодаря ужасающему внешнему виду! Костюм не только выделит своего владельца на поле боя, но и деморализует врага, снизив его боевой дух. Именно так выглядели солдаты отряда «Абсолют», прославившиеся в антитеррористических спецоперациях «Абсолютной власти» по всему миру.
									type:(str,4) html
							is_rare:(bool) false
						description_text:(str,407) <p>Уникальная внешность «Абсолют» - это экипировка, не меняющая боевых характеристик владельца, но вселяющая страх в сердца врагов благодаря ужасающему внешнему виду! Костюм не только выделит своего владельца на поле боя, но и деморализует врага, снизив его боевой дух. Именно так выглядели солдаты отряда «Абсолют», прославившиеся в антитеррористических спецоперациях «Абсолютной власти» по всему миру.</p>
						name_color:(str,7) inherit
						commission:Object (2): 
							fixed:(int,1) 0
							percent:(number,1.2) 0.15
						on_sale_count:(int,3) 180
						kind:(str,6) mailru
						picture_orig:(str,70) /pre_0x0_resize/hotbox/lootdog_products/product_pic/2018/09/03/913.png
						name:(str,24) Штурмовик отряда Абсолют
						tags:Object (0): 
						buy_price:Object (3): 
							caption:(str,8) 228.58 ₽
							amount:(number,3.2) 228.58
							currency:(str,3) RUB
						thumbnail_square:(str,74) /pre_137x137_resize/hotbox/lootdog_products/product_pic/2018/09/03/913.png
						platform:Object (4): 
							id:(int,1) 2
							image_big:(str,69) /pre_0x0_resize/hotbox/lootdog_products/platform_big/2018/09/19/2.png
							image:(str,65) /pre_0x0_resize/hotbox/lootdog_products/platform/2018/09/19/2.png
							name:(str,7) Mail.Ru
						is_approved:(bool) true
						id:(int,3) 913
						popularity:(int,2) 57
						rarity_color:(str,7) #FFB042
						is_key:(bool) true
						thumbnail_wide:(str,74) /pre_290x133_resize/hotbox/lootdog_products/product_pic/2018/09/03/913.png
						thumbnail_rect:(str,74) /pre_335x223_resize/hotbox/lootdog_products/product_pic/2018/09/03/913.png
				 */
				
				const data:Object = JSON.parse( result.data );
				
				_list = data.results.map( mapFunc );
				
				function mapFunc( element:*, index:int, arr:Array ):Object
				{
					return {
						name: element.name
						, id: element.id
						, popularity: element.popularity
						, amount: element.buy_price.amount
					};
				}
				
			}
			
			
			/**
			 * [0] => Object (4): 
					amount:(number,2.2) 15.99
					popularity:(int,3) 367
					id:(int,5) 12073
					name:(str,27) АК «Альфа» «Абсолют» (6 ч.)
				[1] => Object (4): 
					amount:(int,3) 220
					popularity:(int,2) 69
					id:(int,3) 913
					name:(str,24) Штурмовик отряда Абсолют
				[2] => Object (4): 
					amount:(number,3.2) 225.99
					popularity:(int,2) 49
					id:(int,3) 910
					name:(str,23) Шлем инженера "Абсолют"
			 */
			this.dispatchEvent( new LDgEvent( LDgEvent.ON_UPDATED_LOOTDOG_LIST, false, false,  _list ) );
			
			
		}
		
	}

}