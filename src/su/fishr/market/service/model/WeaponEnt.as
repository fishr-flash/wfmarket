package su.fishr.market.service.model 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import su.fishr.market.MarketplaceWF;
	import su.fishr.market.service.Logw;
	import su.fishr.market.service.utils.dateFormat;
	import su.fishr.utils.Dumper;
	/**
	 * ...
	 * @author fishr
	 */
	public class WeaponEnt extends EventDispatcher
	{
		public var host:WeaponGroup;
		
		
		protected var _type:String;
		protected var _key:String;
		protected var _mincost:int;
		protected var _maxcost:int;
		protected var _cost:int;
		protected var _entity_id:int;
		protected var _liquidity:int;
		protected var _diff:int;
		protected var _history:Object = {};
		protected var _session_cost:int;
		private var _takt:int = -1;
		private var _maxBuyCount:int;
		
		
		public function get key():String 
		{
			return _key;
		}
	
		
		public function get sell():uint
		{
			const s:uint = uint( host.autosell );
			return s;
		}
		
		public function get maxcost():int 
		{
			return _maxcost;
		}
		
		public function get cost():int 
		{
			return _cost;
		}
		
		public function get mincost():int 
		{
			return _mincost;
		}
		
		public function get entity_id():int 
		{
			return _entity_id;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get liquidity():int 
		{
			return _liquidity;
		}
		
		public function get diff():int 
		{
			return _diff;
		}
		
		public function get takt():int 
		{
			return _takt;
		}
		
		public function get history():Object 
		{
			return _history;
		}
		
		public function get maxBuyCount():int 
		{
			return _maxBuyCount;
		}
		
		public function set maxBuyCount(value:int):void 
		{
			
			_maxBuyCount = value;
		}
		
		public function WeaponEnt( event:Event = null ) 
		{
			
		}
		
		/**
		 *Object (9): 
			title:(str,13) SAI GRY AR-15
			kind:(str,6) weapon
			type:(str,9) inventory
			item_id:(str,9) ar28_shop
			count:(int,2) 20
			min_cost:(int,4) 2990
			entity_id:(int,4) 1527
			item:Object (4): 
				permanent:(int,1) 1
				count:(int,1) 1
				title:(str,13) SAI GRY AR-15
				id:(str,9) ar28_shop
			class:(str,8) rifleman
		 * @param	data
		 * @return
		 */
		
		public function init(data:Object):WeaponEnt 
		{
			
			if( data.config )		
					maxBuyCount = data.config.mxbuy;
			
			_history.head = {
				key:data.title
				, minc: data.min_cost
				, maxc: data.min_cost
				, id:data.entity_id
				
				
			};
			
			_history.tl = new Array();
			
			_key = data.title;
			setJson( data );
			return this;
		}
		
		/**
		 *Object (9): 
			title:(str,13) SAI GRY AR-15
			kind:(str,6) weapon
			type:(str,9) inventory
			item_id:(str,9) ar28_shop
			count:(int,2) 20
			min_cost:(int,4) 2990
			entity_id:(int,4) 1527
			item:Object (4): 
				permanent:(int,1) 1
				count:(int,1) 1
				title:(str,13) SAI GRY AR-15
				id:(str,9) ar28_shop
			class:(str,8) rifleman
		 * @param	data
		 * @return
		 */
		
		public function setJson( data:Object ):void
		{
			_diff = 0;
			_takt++;
			///FIXME: Место установки случайной цены
			//data.min_cost *=  Math.random();
			const truecost:int = MarketplaceWF.getCostOnCharge( data.min_cost );
			_diff =  truecost - _cost;
			if( _cost && _diff ) _liquidity++;
			_cost = truecost;
			if ( !_session_cost ) _session_cost = _cost;
			else _session_cost = ( _session_cost + _cost );
			
			if ( !_mincost || _mincost > _cost )
					_mincost = _cost;
			if ( _maxcost < _cost )
					_maxcost = _cost;
					
			_entity_id = data.entity_id;
			_type = data.type;
			
			const time:Array = dateFormat();
			_history.tl.push({
				t:{
					d:time[ 0 ]
					,mn:time[ 1 ]
					,yr:time[ 2 ]
					,hrs:time[ 3 ]
					,min:time[ 4 ]
					,sec:time[ 5 ]
				}
				, c:_cost
				, clr: int( ( _cost / MarketplaceWF.CHARGE_RATIO ) * 1 )
				, lq:_liquidity
				, cnt: data.count
				, sess: int( _session_cost / _takt )
			});
			
			
			/**
			 * _history[ 0 ]{
				key:data.title
				, min_cost: data.min_cost
				, max_cost: data.min_cost
				
				};
			 */
				
			
			 if ( _history.head.min_cost > _cost )
							_history.head.min_cost = _cost;
			if ( _history.head.max_cost < _cost )
							_history.head.max_cost = _cost;
			
		}
		
	}

}