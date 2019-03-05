package su.fishr.market.service 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import su.fishr.market.MarketplaceWF;
	import su.fishr.market.WFMEvent;
	import su.fishr.market.service.model.WeaponGroup;
	import su.fishr.utils.Dumper;
	/**
	 * ...
	 * @author  
	 */
	public class ItemsServant extends EventDispatcher
	{
		[Embed(source = "../../../../../assets/items.json", mimeType = "application/octet-stream")]
		private const Items:Class;
		
		private var _self:ItemsServant;
		private var _configItems:Array;
		private var _weaponGroups:Vector.<WeaponGroup>;
		private var _bufferStory:Array = new Array;
		public function get inst():ItemsServant
		{
			if ( !_self ) _self = new ItemsServant;
			return _self;
		}
		public function ItemsServant( event:Event = null ) 
		{
			
			init();
		}
		
		public function setData( objson:Object  ):void
		{
			
			if ( MarketplaceWF.IGNORE_CONFIG && !_weaponGroups )
			{
			
				_configItems = [];
				
				const jlen:int = objson.data.length;
				
				
				
				for (var j:int = 0; j < jlen ; j++) 
				{
					/**
					 * objson.data[ j ]: Object (9): 
						min_cost:(int,2) 75
						title:(str,30) Камуфляж Город для Steyr M9-A1
						entity_id:(int,3) 555
						item:Object (4): 
							id:(str,16) pt06_camo04_shop
							title:(str,30) Камуфляж Город для Steyr M9-A1
							count:(int,1) 1
							regular:(int,1) 1
						type:(str,9) inventory
						class:(str,9) universal
						count:(int,4) 1030
						item_id:(str,16) pt06_camo04_shop
						kind:(str,10) camouflage
					 */
					if ( objson.data[ j ].min_cost < 100
						|| objson.data[ j ].title == ""
						|| objson.data[ j ].item == null 
						) continue;
						
						/*,{
						"name":"ОРСИС Т-5000 Карбон"
						, "key_word":"ОРСИС Т-5000 Карбон"
						, "id_market":""
						, "kind":"weapon"
						, "higth_cost":0
						, "low_cost":1008
						, "hidden": 1
						, "auto_cost":60
						, "exclude":[ "Золот" ]*/
	
						_configItems.push( {
							name: objson.data[ j ].title
							,key_word:objson.data[ j ].title
							, id_market:""
							, kind:objson.data[ j ].kind
							, heigth_cost: 0
							, low_cost: 42
							, hidden: 0
							, auto_cost: 42
							, exclude: [ "Камуфляж Абсолют" ]
						} );
					
				}
			}
				
				
			
			var itms:Array;
			const len:int = _configItems.length;
			for ( var i:int = 0; i < len; i++ )
			{
				
				
				
				
				itms = findMatch( objson, _configItems[ i ]);
				
				if ( itms[ 0 ] )
				{
					itms[ 0 ].config = _configItems[ i ];
					
					
					if ( !_weaponGroups )
					{
						_weaponGroups = new Vector.<WeaponGroup>;
						_weaponGroups.push( new WeaponGroup( itms ) );
						
					}
					else
					{
						const inx:int = searchKey( _configItems[ i ].key_word );
						
						if ( inx == -1 )
						{
							_weaponGroups.push( new WeaponGroup( itms ) );
							
						}
						else
						{
							_weaponGroups[ inx ].setJsonGroup( itms );
							
						}
						
						
					}
					
					
				}
				
				
			}
			
			
			try 
			{
				
			
				selectLowCost();
				selectAutoBuy();
				
			}
			catch ( e:Error )
			{
				Logw.inst.up( "not once group configure, error: " + e );
			}
			
		}
		
		
		
		public function getWeaponData():Array 
		{
			var wg:Array = [];
			var wi:Array = [];
			
			const len:int = _weaponGroups.length;
			for ( var i:int = 0; i < len; i++ )
			{
				wi.push( [ _weaponGroups[ i ].groupKey
								, _weaponGroups[ i ].cost
								, _weaponGroups[ i ].mincost
								, _weaponGroups[ i ].maxcost 
								, _weaponGroups[ i ].went[ 0 ].entity_id
								, _weaponGroups[ i ].session_cost 
								, _weaponGroups[ i ].liquidity] );
								
								
				const lenj:int = _weaponGroups[ i ].went.length;
				for ( var j:int = 0; j < lenj; j++ )
				{
					wi.push( [ _weaponGroups[ i ].went[ j ].key
								, _weaponGroups[ i ].went[ j ].cost
								, _weaponGroups[ i ].went[ j ].mincost
								, _weaponGroups[ i ].went[ j ].maxcost 
								, _weaponGroups[ i ].went[ j ].entity_id 
								, _weaponGroups[ i ].went[ j ].liquidity ] );
								
								
				}
				
				wg.push( wi.slice() );
				wi = [];
			}
			
			return wg;
		}
		
		public function getHistory():Array
		{
			var data:Array = [];
			const len:int = _weaponGroups?_weaponGroups.length:0;
			for (var i:int = 0; i < len; i++) 
			{
				const jlen:int = _weaponGroups[ i ].went.length;
				for (var j:int = 0; j < jlen; j++) 
				{
					data = data.concat( _weaponGroups[ i ].went[ j ].history );
				}
			}
			
			if ( _bufferStory.length )
					data = joinStory( data );
					
			return data;
		}
		
		public function setStory( loadedStory:Array ):void
		{
			_bufferStory.push( loadedStory );
		}
		
		
		private function joinStory(data:Array):Array 
		{
			if( data.length ) _bufferStory.push( data );
			
			if( _bufferStory.length > 1 ) _bufferStory.sort( sortBuffer );
			
			/**
			 * var arrsort:Array = [ 512, 1, 3 , 2, 7 ];
					arrsort.sort( sortBuffer );
					trace( Dumper.dump( arrsort ) );
					
					function sortBuffer( a:int, b:int ):int
					{
						if ( a > b ) return 1;
						else if ( a < b ) return -1;
						
						trace( " a: ", a )
						trace( " b: ", b )
						
						return 0;
					}
			 * @return
			 */
			
			function sortBuffer( b:Array, a:Array ):int
			{
				
				// года
				if ( b[ 0 ].tl[ 0 ].t.yr > a[ 0 ].tl[ 0 ].t.yr ) 
															return  1;
				else if ( b[ 0 ].tl[ 0 ].t.yr < a[ 0 ].tl[ 0 ].t.yr )
															return -1;
						
				/// месяцы
				if ( b[ 0 ].tl[ 0 ].t.mn > a[ 0 ].tl[ 0 ].t.mn ) 
															return  1;
				else if ( b[ 0 ].tl[ 0 ].t.mn < a[ 0 ].tl[ 0 ].t.mn )
															return -1;
							
				/// дни
				if ( b[ 0 ].tl[ 0 ].t.d > a[ 0 ].tl[ 0 ].t.d ) 
															return  1;
				else if ( b[ 0 ].tl[ 0 ].t.d < a[ 0 ].tl[ 0 ].t.d )
															return -1;
				/// часы
				if ( b[ 0 ].tl[ 0 ].t.hrs > a[ 0 ].tl[ 0 ].t.hrs ) 
															return  1;
				else if ( b[ 0 ].tl[ 0 ].t.hrs < a[ 0 ].tl[ 0 ].t.hrs )
															return -1;
															
				/// минуты
				if ( b[ 0 ].tl[ 0 ].t.min > a[ 0 ].tl[ 0 ].t.min ) 
															return  1;
				else if ( b[ 0 ].tl[ 0 ].t.min < a[ 0 ].tl[ 0 ].t.min )
															return -1;
															
				/// секунды
				if ( b[ 0 ].tl[ 0 ].t.sec > a[ 0 ].tl[ 0 ].t.sec ) 
															return  1;
				else if ( b[ 0 ].tl[ 0 ].t.sec < a[ 0 ].tl[ 0 ].t.sec )
															return -1;
															
															
				
				return 0;
			}
			/**
			 * [19] => Object (2): 
						head:Object (4): 
							key:(str,17) РПД Custom Карбон
							maxc:(int,3) 799
							id:(int,4) 3935
							minc:(int,3) 799
						tl:Array(44):
							[0] => Object (5): 
								c:(int,3) 839
								cnt:(int,4) 1005
								lq:(int,1) 0
								t:Object (6): 
									mn:(str,2) 02 
									sec:(str,2) 03
									yr:(str,4) 2019
									min:(str,2) 10
									hrs:(str,2) 01
									d:(str,2) 26
								sess:(int,3) 839
			 */
			var ilen:int = _bufferStory.length;
			const llen:int = _bufferStory[ 0 ].length;
			
			
			
			for (var l:int = 0; l < llen; l++) 
			{
					
				
					for (var i:int = 1; i < ilen; i++) 
					{
				
				
					
					const tl:Array = searchTimeLine( _bufferStory[ 0 ][ l ].head.key, _bufferStory[ i ] );
					if ( tl )
					{
						--i;
						//--ilen;
						_bufferStory[ 0 ][ l ].tl = _bufferStory[ 0 ][ l ].tl.concat( tl );
						
						
					}
					
					
					
							
				}
				
				
			}
			
			
				
				function searchTimeLine( headKey:String, giver:Array  ):Array 
				{
					var result:Array;
					var len:int = giver.length;
					for (var n:int = 0; n < len; n++) 
					{
						if ( giver[ n ].head.key == headKey )
						{
							result = giver.splice( n, 1 )[ 0 ].tl;
							len--;
							n--;
							
							
						}
						
					}
					
					return result as Array;
				}
			
			return _bufferStory[ 0 ];
		}
		
		
		
		
		
		private function init():void 
		{
			const itemsStr:String = new Items;
			
			var arr:Array = JSON.parse( itemsStr ) as Array; 
			_configItems = [];
			
			const len:int = arr.length;
			for (var i:int = 0; i < len; i++) 
			{
				
					if ( MarketplaceWF.IGNORE_HIDDEN == true || arr[ i ].hidden == 0 ) 
																				_configItems.push( arr[ i ] );
			}
			
			
				
		}
		
		private function findMatch(objson:Object, confItem:Object ):Array
		{
			
			
			var itms:Array = [];
			
			const len:int = objson.data.length;
			for ( var i:int = 0; i < len; i++ )
			{
				
				
				
				if (  ( objson.data[ i ][ "title" ].indexOf( confItem[ "key_word" ]  ) > -1 )
						&& ( objson.data[ i ][ "kind" ] == confItem[ "kind" ]  )
						&& checkExclude( objson.data[ i ], confItem[ "exclude" ] ) != true 
				)
				{
					
														itms.push( objson.data[ i ] );
				}
				
				
				
			}
			
			return itms;
		}
		
		/**
		 *  data: Object (9): 
			count:(int,1) 8
			title:(str,18) Золотой РПД Custom
			class:(str,8) rifleman
			kind:(str,6) weapon
			item_id:(str,16) mg23_gold01_shop
			min_cost:(int,5) 10000
			item:Object (4): 
				id:(str,16) mg23_gold01_shop
				count:(int,1) 1
				permanent:(int,1) 1
				title:(str,18) Золотой РПД Custom
			type:(str,9) inventory
			entity_id:(int,4) 2798
		 excludes: Array(1):
			[0] => (str,5) Золот
		 * @param	data
		 * @param	excludes
		 * @return
		 */
		private function checkExclude( data:Object, excludes:Array ):Boolean
		{
			var res:Boolean = false;
			if ( !excludes || !excludes.length ) 
						return res;
			
			const len:int = excludes.length;
			for (var j:int = 0; j < len; j++) 
			{
				
				if (  String( data[ "title" ] ).indexOf( excludes[ j ] ) > -1 ) 
																		return true;
				
			}
			
			return res;
		}
		
		private function searchKey( skey:String ):int
		{
			const len:int = _weaponGroups.length;
			for ( var i:int = 0; i < len; i++ )
			{
				if ( _weaponGroups[ i ].groupKey == skey ) 
						return i;
			}
			
			return -1;
		}
		
		private function selectAutoBuy():void
		{
			const len:int = _weaponGroups.length;
			var autocost:int;
			
			for (var i:int = 0; i < len; i++) 
			{
				if ( _weaponGroups[ i ].cost <= _weaponGroups[ i ].autocost )
				{
					this.dispatchEvent( new WFMEvent( WFMEvent.ON_AUTOBUY, false, false, _weaponGroups[ i ].went[ _weaponGroups[ i ].owner ] ) );
					break;
				}
			}
		}
		
		private function selectLowCost():void
		{
			const len:int = _weaponGroups.length;
			
			
			
			for (var i:int = 0; i < len; i++) 
			{
				
					if ( _weaponGroups[ i ].session_cost >  0 
							&& _weaponGroups[ i ].lowcost > 0 
							&& _weaponGroups[ i ].diff < 0 
							&& _weaponGroups[ i ].cost < _weaponGroups[ i ].lowcost )
						this.dispatchEvent( new WFMEvent( WFMEvent.ON_LOW_COST, false, false, _weaponGroups[ i ] ) );
					else if ( _weaponGroups[ i ].lowcost == 0 
								&& _weaponGroups[ i ].session_cost >  0 
								&& _weaponGroups[ i ].diff < 0  )
						this.dispatchEvent( new WFMEvent( WFMEvent.ON_LOW_COST, false, false, _weaponGroups[ i ] ) );
						
						
					if (  _weaponGroups[ i ].heightcost > 0 
						&& _weaponGroups[ i ].diff > 0
						&& _weaponGroups[ i ].session_cost >  0 
						&& _weaponGroups[ i ].cost >= _weaponGroups[ i ].heightcost )
						this.dispatchEvent( new WFMEvent( WFMEvent.ON_HEIGHT_COST, false, false, _weaponGroups[ i ] ) );
			}
		}
		
		private function onsortGroup( x:WeaponGroup, y:WeaponGroup ):Number
		{
			if ( x.liquidity < y.liquidity ) return 1
			else if ( x.liquidity > y.liquidity ) return -1;
			else return 0;
			
			
			/*if ( x.cost < y.cost ) return -1;
			else if ( x.cost > y.cost ) return 1;
			else return 0;*/
		}
		
	}

}