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
		protected var _type:String;
		protected var _key:String;
		protected var _mincost:int;
		protected var _maxcost:int;
		protected var _cost:int;
		protected var _entity_id:int;
		protected var _liquidity:int;
		protected var _diff:int;
		protected var _history:Array = new Array;
		
		
		
		
		public function get key():String 
		{
			return _key;
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
		
		public function get history():Array 
		{
			return _history;
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
			///FIXME: Место установки случайной цены
			//data.min_cost *=  Math.random();
			const truecost:int = MarketplaceWF.getCostOnCharge( data.min_cost );
			_diff =  truecost - _cost;
			if( _cost && _diff ) _liquidity++;
			_cost = truecost;
			
			
			if ( !_mincost || _mincost > _cost )
					_mincost = _cost;
			if ( _maxcost < _cost )
					_maxcost = _cost;
					
			_entity_id = data.entity_id;
			_type = data.type;
			
			const time:Array = dateFormat();
			_history.push({
				time:{
					day:time[ 0 ]
					,month:time[ 1 ]
					,year:time[ 2 ]
					,hourse:time[ 3 ]
					,minutes:time[ 4 ]
					,seconds:time[ 5 ]
				}
				,key:_key
				, entity_id:_entity_id
				, cost:_cost
				, liquidity:_liquidity
				, count: data.count
				
			});
			
			
		}
		
	}

}