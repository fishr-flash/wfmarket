package su.fishr.market 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author  
	 */
	public class WFMEvent extends Event 
	{
		public static const ON_LOW_COST:String = "onLowCost";
		static public const ON_AUTOBUY:String = "onAutobuy";
		static public const ON_HEIGHT_COST:String = "onHeightCost";
		
		private var _data:Object;
		public function get data():Object 
		{
			return _data;
			
		}
		
		public function WFMEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object = null ) 
		{ 
			super(type, bubbles, cancelable);
			_data  = data;
		} 
		
		public override function clone():Event 
		{ 
			return new WFMEvent(type, bubbles, cancelable, data );
		} 
		
		public override function toString():String 
		{ 
			return formatToString("WFMEvents", "type", "bubbles", "cancelable", "eventPhase", "data"); 
		}
		
		
		
	}
	
}