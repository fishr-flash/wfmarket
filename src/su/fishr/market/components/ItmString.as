package su.fishr.market.components 
{
	import fl.controls.NumericStepper;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
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
		private var _cntStep:NumericStepper;
		private var _entity_id:int;
		private var _buyStep:NumericStepper;
		private var _sellStep:NumericStepper;
		
		
		
		
		public function ItmString( arr:Array ) 
		{
			super();
			
			init( arr );
		}
		
		
		public function setData( arr:Array ):void
		{
			
			
			_mainItm.htmlText = formatWeaponEnt( arr );
			_buyStep.move( _mainItm.textWidth - 5, _buyStep.y );
			_sellStep.move( _buyStep.x + _buyStep.width + 15, _buyStep.y );
			_cntStep.move( _sellStep.x + _sellStep.width + 15, _sellStep.y );
			_entity_id = arr[ 4 ];
		}
		
		private function init(arr:Array):void 
		{
			_colorLiquidity = _colorCost = _colorSession =  MarketplaceWF.FONT_COLOR;
			_mainItm = new TFItem;
			this.addChild( _mainItm );
			
			_buyStep = new NumericStepper;
			_buyStep.x = _mainItm.x + _mainItm.width;
			_buyStep.y = _mainItm.y;
			_buyStep.width = 60;
			_buyStep.height = 20;
			_buyStep.setSize( 60, 20 );
			_buyStep.validateNow();
			_buyStep.value = 0;
			_buyStep.maximum = 100000;
			this.addChild( _buyStep );
			_buyStep.addEventListener(Event.CHANGE, onChangeCostStep );
			
			_sellStep = new NumericStepper;
			_sellStep.x = _buyStep.x + _buyStep.width;
			_sellStep.y = _buyStep.y;
			_sellStep.width = 60;
			_sellStep.height = 20;
			_sellStep.setSize( 60, 20 );
			_sellStep.validateNow();
			_sellStep.value = 0;
			_sellStep.maximum = 100000;
			this.addChild( _sellStep );
			_sellStep.addEventListener(Event.CHANGE, onChangeCostStep );
			

			_cntStep = new NumericStepper;
			_cntStep.x = _sellStep.x + _sellStep.width;
			_cntStep.y = _sellStep.y;
			_cntStep.width = 45;
			_cntStep.height = 20;
			_cntStep.setSize( 45, 20 );
			_cntStep.validateNow();
			_cntStep.value = 0;
			_cntStep.maximum = 100;
			this.addChild( _cntStep );
			_cntStep.addEventListener(Event.CHANGE, onChangeStepper );
			
			
			setData( arr );
			
			onChangeCostStep( null )
			
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
							
			if ( arr.length > 9 ) 
			{
					_colorSession = _oldSession > 0 && _oldSession < arr[ 5 ]?COLOR_UP:_oldSession > 0 && _oldSession > arr[ 5 ]?COLOR_DOWN:_colorSession;
					_oldSession = arr[ 5 ];
					resar += "ss: <font color=\"#" + _colorSession.toString( 16 ) + "\" ><b>" + addgap( arr[ 5 ] ) + "</b></font>";
					
					_colorLiquidity = _oldLiquidity > 0  && _oldLiquidity < arr[ 9 ]?COLOR_UP:MarketplaceWF.FONT_COLOR;
					resar += "lq: <font color=\"#" + _colorLiquidity.toString( 16 ) + "\" ><b>" + addgap( arr[ 9 ] ) + "</b></font>";
					
					_buyStep.value = arr[ 6 ];
					_sellStep.value = arr[ 7 ];
					_cntStep.value = arr[ 8 ];
					_oldLiquidity = arr[ 9 ];
					
			}
			else
			{
				_colorLiquidity = _oldLiquidity > 0  && _oldLiquidity < arr[ 8 ]?COLOR_UP:MarketplaceWF.FONT_COLOR;
					resar += "lq: <font color=\"#" + _colorLiquidity.toString( 16 ) + "\" ><b>" + addgap( arr[ 8 ] ) + "</b></font>";
				
				_buyStep.value = arr[ 5 ];
				_sellStep.value = arr[ 6 ];
				_cntStep.value = arr[ 7 ];
				_oldLiquidity = arr[ 8 ];
				
			}
			
			cntStepColorUpdate();
			
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
			
			
			this.dispatchEvent( new WFMEvent( WFMEvent.ON_CHANGE_MBUY, false, false, { entity_id: _entity_id,  mbuy: _cntStep.value } ) );
			
			
		}
		
		private function onChangeCostStep(e:Event):void 
		{
			const bb:int = _buyStep.value;
			const ss:int = _sellStep.value;
			var tf:TextFormat = new TextFormat;
			
			if ( ( ( ss / MarketplaceWF.CHARGE_RATIO ) * 1 ) <= bb )
			{
				tf.bold = true;
				tf.color = 0xFF9999;
			}
			else
			{
				tf.bold = false;
				tf.color = 0x00;
			}
			
			_sellStep.setStyle( 'textFormat', tf );
			
			this.dispatchEvent( new WFMEvent( WFMEvent.ON_CHANGE_COST_STEPPER, false, false, { entity_id: _entity_id
																								,  cbuy: bb
																								, csell: ss } ) );
		}
		
		
		private function cntStepColorUpdate():void
		{
			
			var tf:TextFormat = new TextFormat;
			
			if ( _cntStep.value )
			{
				tf.bold = false;
				tf.color = 0x00;
			}
			else
			{
				tf.bold = true;
				tf.color = 0xFF9999;
				
			}
			
			_cntStep.setStyle( 'textFormat', tf );
		}
	}

}