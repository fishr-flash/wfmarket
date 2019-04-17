package su.fishr.market.lootdog 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author  
	 */
	public class LDgEvent extends Event 
	{
		static public const PLEASE_REQUEST_QUEUE:String = "pleaseRequestQueue";
		
		
		private var _data:Object;
		public function get data():Object 
		{
			return _data;
			
		}
		
		public function LDgEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object = null ) 
		{ 
			super(type, bubbles, cancelable);
			_data  = data;
		} 
		
		public override function clone():Event 
		{ 
			return new LDgEvent(type, bubbles, cancelable, data );
		} 
		
		public override function toString():String 
		{ 
			return formatToString("WFMEvents", "type", "bubbles", "cancelable", "eventPhase", "data"); 
		}
		
		
		
	}
	
}