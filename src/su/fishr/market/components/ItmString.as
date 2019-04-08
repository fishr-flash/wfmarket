package su.fishr.market.components 
{
	import fl.controls.NumericStepper;
	import flash.display.Sprite;
	import flash.events.Event;
	import su.fishr.market.MarketplaceWF;
	import su.fishr.market.WFMEvent;
	
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
		private var _colorLiquidity:uint;
		private var _oldLiquidity:uint;
		private var _nStep:NumericStepper;
		private var _entity_id:int;
		
		
		
		
		public function ItmString( arr:Array ) 
		{
			super();
			
			init( arr );
		}
		
		
		public function setData( arr:Array ):void
		{
			
			
			_mainItm.htmlText = formatWeaponEnt( arr );
			_nStep.move( _mainItm.textWidth - 5, _nStep.y );
			_entity_id = arr[ 4 ];
		}
		
		private function init(arr:Array):void 
		{
			_colorLiquidity = _colorCost = _colorSession =  MarketplaceWF.FONT_COLOR;
			_mainItm = new TFItem;
			this.addChild( _mainItm );
			
			_nStep = new NumericStepper;
			_nStep.x = _mainItm.x + _mainItm.width;
			_nStep.y = _mainItm.y;
			_nStep.width = 45;
			_nStep.height = 20;
			_nStep.setSize( 45, 20 );
			_nStep.validateNow();
			setData( arr );
			_nStep.value = 0;
			this.addChild( _nStep );
			_nStep.addEventListener(Event.CHANGE, onChangeStepper );
			
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
							
			if ( arr.length > 7 ) 
			{
					_colorSession = _oldSession > 0 && _oldSession < arr[ 5 ]?COLOR_UP:_oldSession > 0 && _oldSession > arr[ 5 ]?COLOR_DOWN:_colorSession;
					_oldSession = arr[ 5 ];
					resar += "ss: <font color=\"#" + _colorSession.toString( 16 ) + "\" ><b>" + addgap( arr[ 5 ] ) + "</b></font>";
					
					_colorLiquidity = _oldLiquidity > 0  && _oldLiquidity < arr[ 7 ]?COLOR_UP:MarketplaceWF.FONT_COLOR;
					resar += "lq: <font color=\"#" + _colorLiquidity.toString( 16 ) + "\" ><b>" + addgap( arr[ 7 ] ) + "</b></font>";
					
					_oldLiquidity = arr[ 7 ];
					_nStep.value = arr[ 6 ];
					
			}
			else
			{
				_colorLiquidity = _oldLiquidity > 0  && _oldLiquidity < arr[ 6 ]?COLOR_UP:MarketplaceWF.FONT_COLOR;
					resar += "lq: <font color=\"#" + _colorLiquidity.toString( 16 ) + "\" ><b>" + addgap( arr[ 6 ] ) + "</b></font>";
				_oldLiquidity = arr[ 6 ];
				_nStep.value = arr[ 5 ];
				
			}
			
			return resar;
		}
		
		private function addgap( str:String, prev:Boolean = false ):String
		{
			const strLen:int = prev?WIDTH_COLUMN:WIDTH_COLUMN_2;
			
			if ( strLen > str.length )
			{
				const len:int = strLen - str.length;
				for (var i:int = 0; i < len; i++) 
				{
					str += " ";
				}
			}
			else
			{
				str = str.slice( 0, strLen - 2 );
				str += "+ ";
			}
			
			return str
		}
		
		
		private function onChangeStepper(e:Event):void 
		{
			this.dispatchEvent( new WFMEvent( WFMEvent.ON_CHANGE_MBUY, false, false, { entity_id: _entity_id,  mbuy: _nStep.value } ) );
		}
	}

}