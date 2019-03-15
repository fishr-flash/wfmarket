package su.fishr.market.service.model 
{
	import su.fishr.market.WFMEvent;
	import su.fishr.market.service.Logw;
	import su.fishr.utils.Dumper;
	import su.fishr.utils.searcPropValueInArr;
	/**
	 * ...
	 * @author fishr
	 */
	public class WeaponGroup extends WeaponEnt 
	{
		public var maxBuyCount:int;
		public var groupKey:String;
		
		private var _went:Vector.<WeaponEnt>;
		//private var _alertData:Object;
		private var _autocost:int;
		private var _lowcost:int;
		private var _owner:int;
		private var _heightcost:int;
		
		
		public function get went():Vector.<WeaponEnt> 
		{
			return _went;
		}
		
		public function get session_cost():int 
		{
			return _session_cost / _went[ 0 ].takt;
		}
		
		/*public function get alertData():Object 
		{
			const ad:Object = _alertData;
			_alertData = null;
			
			return ad;
		}*/
		
		public function get autocost():int 
		{
			return _autocost;
		}
		
		public function get lowcost():int 
		{
			return _lowcost;
		}
		
		public function get heightcost():int 
		{
			return _heightcost;
		}
		
		public function get owner():int 
		{
			return _owner;
		}
		public function WeaponGroup( data:Object ) 
		{
			super();
			
			init( data );
			
		}
		
		/**
		 *                            ===>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
			  Array(3):
				[0] => Object (10): 
					title:(str,21) SAI GRY AR-15 Абсолют
					class:(str,8) rifleman
					config:Object (6): 
						id_market:(str,0) 
						kind:(str,6) weapon
						key_word:(str,10) SAI GRY AR
						auto_cost:(int,2) 42
						low_cost:(int,2) 42
						name:(str,10) SAI GRY AR
					item_id:(str,15) ar28_set10_shop
					type:(str,9) inventory
					min_cost:(int,4) 2500
					entity_id:(int,4) 1505
					item:Object (4): 
						title:(str,21) SAI GRY AR-15 Абсолют
						count:(int,1) 1
						id:(str,15) ar28_set10_shop
						permanent:(int,1) 1
					count:(int,2) 68
					kind:(str,6) weapon
				[1] => Object (9): 
					title:(str,13) SAI GRY AR-15
					class:(str,8) rifleman
					item_id:(str,9) ar28_shop
					type:(str,9) inventory
					min_cost:(int,4) 2990
					entity_id:(int,4) 1527
					item:Object (4): 
						title:(str,13) SAI GRY AR-15
						count:(int,1) 1
						id:(str,9) ar28_shop
						permanent:(int,1) 1
					count:(int,2) 20
					kind:(str,6) weapon
				
		 * @param	data
		 */
		override public function init(data:Object):WeaponEnt 
		{
			
			
			groupKey = _key = data["0"].config.key_word;
			_lowcost = data["0"].config.low_cost;
			_autocost  = data["0"].config.auto_cost;
			_heightcost = data["0"].config.higth_cost;
			maxBuyCount = data["0"].config.mxbuy;
			
			setJsonGroup( data );
			
			return this;
		}
		
		public function setJsonGroup( data:Object ):void
		{
			
			
			if ( !_went ) 
			{
				_went = new Vector.<su.fishr.market.service.model.WeaponEnt>;
				for ( var inx:Object in data )
				{
					const went:WeaponEnt =  new WeaponEnt().init( data[ inx ] );
					went.parent = this;
					_went.push( went );
					
				}
			}
			else
			{
				for ( var inx1:Object in data )
				{
					const index:int = searchKey(  data[ inx1 ].title );
					_went[ index ].setJson( data[ inx1 ] );
				}
			}
			
			
			_session_cost = getSessionCost();
			const dcost:Array = getCost();
			_cost = dcost[ 0 ];
			_owner = dcost[ 1 ];
			
			
				
			
			
			/*if ( _lowcost )
			{
				if( _cost <= _lowcost )
				{
					_alertData = went[ _owner ];
				}
			}
			else if ( _mincost && _mincost > _cost )
			{
				_alertData = went[ _owner ];
			}
			
			if ( _heightcost )
			{
				if( _cost >= _heightcost )
				{
					_alertData = went[ _owner ];
				}
			}*/
			
			_mincost = getMinCost();
			_maxcost = getMaxCost();
			
			
			
			
		}
		
		public function getBuyCost(entity_id:int):int 
		{
			const ilen:int = _went.length;
			var cost:int = 0;
			
			for (var i:int = 0; i < ilen; i++) 
			{
				if ( _went[ i ].entity_id == entity_id )
											return _autocost;
			}
			
			return cost;
		}
		
		private function searchKey( skey:String ):int
		{
			const len:int = _went.length;
			for ( var i:int = 0; i < len; i++ )
			{
				if ( _went[ i ].key == skey ) 
						return i;
			}
			
			return -1;
		}
		
		private function getMinCost():int
		{
			var minc:int = 0;
			const len:int = _went.length;
			for ( var i:int = 0; i < len; i++ )
			{
				if ( !minc || _went[ i ].mincost < minc )
					minc = _went[ i ].mincost
			}
			
			return minc;
		}
		
		private function getMaxCost():int
		{
			var maxc:int = 0;
			const len:int = _went.length;
			for ( var i:int = 0; i < len; i++ )
			{
				if ( !maxc || _went[ i ].maxcost > maxc )
					maxc = _went[ i ].maxcost
			}
			
			return maxc;
		}
		
		
		
		private function getCost():Array
		{
			var cst:int = 0;
			var owner:int = - 1;
			
			const len:int = _went.length;
			for ( var i:int = 0; i < len; i++ )
			{
				if ( !cst || _went[ i ].cost < cst )
				{
					
					cst = _went[ i ].cost;
					owner = i;
					_diff = _went[ i ].diff;
					_liquidity = _went[ i ].liquidity;
					
				}
					
			}
			
			return [ cst, owner ];
		}
		
		private function getSessionCost():int
		{
			if ( _session_cost ) 
				return ( _session_cost + _cost ) ;
			else 
				return _cost;
				
				
			
		}
		
	}

}