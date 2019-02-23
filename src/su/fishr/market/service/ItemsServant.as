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
			
			
			var itms:Array;
			const len:int = _configItems.length;
			for ( var i:int = 0; i < len; i++ )
			{
				
				
				
				
				itms = parseJson( objson, _configItems[ i ]);
				
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
			
			_weaponGroups.sort( onsortGroup );
			
			selectLowCost();
			selectAutoBuy();
			
		}
		
		private function onsortGroup( x:WeaponGroup, y:WeaponGroup ):Number
		{
			
			if ( x.cost < y.cost ) return -1;
			else if ( x.cost > y.cost ) return 1;
			else return 0;
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
			const len:int = _weaponGroups.length;
			for (var i:int = 0; i < len; i++) 
			{
				const jlen:int = _weaponGroups[ i ].went.length;
				for (var j:int = 0; j < jlen; j++) 
				{
					data = data.concat( _weaponGroups[ i ].went[ j ].history );
				}
			}
			
			return data;
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
		
		private function parseJson(objson:Object, confItem:Object ):Array
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
		
	}

}