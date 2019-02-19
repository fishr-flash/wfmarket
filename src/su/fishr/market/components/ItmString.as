package su.fishr.market.components 
{
	import flash.display.Sprite;
	import su.fishr.market.MarketplaceWF;
	
	/**
	 * ...
	 * @author  
	 */
	public class ItmString extends Sprite 
	{
		private const COLOR_UP:uint  = 0xCC6666;
		private const COLOR_DOWN:uint  = 0x00BB00;
		private const WIDTH_COLUMN:int  = 28;
		private const WIDTH_COLUMN_2:int  = 6;
		
					  
		
		private var _mainItm:TFItem;
		private var _oldCost:int;
		private var _oldMin:int;
		private var _oldMax:int;
		private var _oldSession:int;
		private var ownerName:String;
		private var _colorCost:uint;
		private var _colorSession:uint;
		
		
		
		
		public function ItmString( arr:Array ) 
		{
			super();
			
			init( arr );
		}
		
		
		public function setData( arr:Array ):void
		{
			
			_mainItm.htmlText = formatWeaponEnt( arr );
		}
		
		private function init(arr:Array):void 
		{
			_colorCost = _colorSession =  MarketplaceWF.FONT_COLOR;
			_mainItm = new TFItem;
			this.addChild( _mainItm );
			
			setData( arr );
			
		}
		
		
		/**
		 *  arr: Array(6):
			[0] => (str,10) SAI GRY AR
			[1] => (int,3) 699 // cost
			[2] => (int,3) 699 // min cost
			[3] => (int,4) 3140 // max cost
			[4] => (int,4) 1505 // entity_id
			[5] => (int,1) 0 // session_cost
		 * @param	arr
		 */
		private function formatWeaponEnt( arr:Array ):String 
		{
			
			
			
			
			_colorCost = _oldCost > 0 && _oldCost < arr[ 1 ]?COLOR_UP:_oldCost > 0 && _oldCost > arr[ 1 ]?COLOR_DOWN:_colorCost;
			const colorMin:uint = _oldMin > 0 && _oldMin > arr[ 2 ]?COLOR_DOWN:MarketplaceWF.FONT_COLOR;
			const colorMax:uint = _oldMax > 0 && _oldMax < arr[ 3 ]?COLOR_UP:MarketplaceWF.FONT_COLOR;
			
			
			
			
			_oldCost = arr[ 1 ];
			_oldMin = arr[ 2 ];
			_oldMax = arr[ 3 ];
			
					
			
					
			
			var resar:String  =
				 addgap( arr[ 0 ], true )  + ""
							+ "cc: <font color=\"#" + _colorCost.toString( 16 ) + "\" ><b>" + addgap( arr[ 1 ] ) + "</b></font>"
							+ "mn: <font color=\"#" + colorMin.toString( 16 ) + "\" ><b>" + addgap( arr[ 2 ] ) + "</b></font>"
							+ "mx: <font color=\"#" + colorMax.toString( 16 ) + "\" ><b>" + addgap( arr[ 3 ] ) + "</b></font>"
							+ "";
							
			if ( arr.length > 5 ) 
			{
					_colorSession = _oldSession > 0 && _oldSession < arr[ 5 ]?COLOR_UP:_oldSession > 0 && _oldSession > arr[ 5 ]?COLOR_DOWN:_colorSession;
					_oldSession = arr[ 5 ];
					resar += "ss: <font color=\"#" + _colorSession.toString( 16 ) + "\" ><b>" + addgap( arr[ 5 ] ) + "</b></font>"
			}
			
			
							
					  
			return resar;
		}
		
		private function addgap( str:String, prev:Boolean = false ):String
		{
			const strLen:int = prev?WIDTH_COLUMN:WIDTH_COLUMN_2;
			
			const len:int = strLen - str.length;
			for (var i:int = 0; i < len; i++) 
			{
				str += " ";
			}
			
			return str
		}
	}

}