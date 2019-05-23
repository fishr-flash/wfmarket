package su.fishr.market.components 
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import su.fishr.display.components.scroller.VScroller;
	import su.fishr.market.MarketplaceWF;
	
	
	/**
	 * ...
	 * @author fishr
	 */
	public class PriceOfWeapons extends Sprite 
	{
		private var _itms:Vector.<GrField>;
		private var _vscroll:VScroller;
		private var _back:BackgroundShape;
		
		public function PriceOfWeapons() 
		{
			super();
			
			_back = new BackgroundShape( 935, 400 );
			this.addChild( _back ) ;
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, init );
			
		}
		
		/**
		 * примерная структура данных, первый подмассив
		 * данные по группе
		 * 
		 * arrw : Array(10):
			[0] => Array(3):
				[0] => Array(4):
					[0] => (str,10) CZ 75-Auto
					[1] => (int,4) 7999
					[2] => (int,4) 7999
					[3] => (int,4) 9497
				[1] => Array(4):
					[0] => (str,18) Золотой CZ 75-Auto
					[1] => (int,4) 9497
					[2] => (int,4) 9497
					[3] => (int,4) 9497
				[2] => Array(4):
					[0] => (str,16) CZ 75-Auto Атлас
					[1] => (int,4) 7999
					[2] => (int,4) 7999
					[3] => (int,4) 7999
			[1] => Array(2):
				[0] => Array(4):
					[0] => (str,11) ПКП Печенег
					[1] => (int,5) 50000
					[2] => (int,5) 50000
					[3] => (int,5) 50000
				[1] => Array(4):
					[0] => (str,11) ПКП Печенег
					[1] => (int,5) 50000
					[2] => (int,5) 50000
					[3] => (int,5) 50000
			
		 * @param	arrw
		 */
		public function setWeaponData( arrw:Array ):void
		{
			
			if( !_itms )_itms = new Vector.<su.fishr.market.components.GrField>;
			
			const len:int = arrw.length;
			var yy:int;
			var xx:int;
			for ( var i:int = 0; i < len; i++ )
			{
				
				
				const inx:int = ( _itms.length > i )?searchItms( arrw[ i ][ 0 ][ 0 ] ): -1;
				
				
				if ( inx > -1 )
				{
					_itms[ inx ].setNewWInf( arrw[ i ] );
					//yy += _itms[ inx ].height;
					
				}
				else
				{
					
					_itms.push( new GrField(  arrw[ i ]  ) );
					//_itms[ i ].y = yy;
					//yy += _itms[ i ].height;
					this.addChild( _itms[ i ] );
					_itms[ i ].addEventListener(Event.RESIZE, onResize );
					
					
					
				}
				
				
			}
			
			
			this.addEventListener(Event.ENTER_FRAME, onEmnterFrame );
			
		}
		
		private function init( e:Event ):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init );
			
			
			
			this.scrollRect = new Rectangle( 0, 0, _back.width, _back.height);
			_vscroll = new VScroller;
			
			_vscroll.x = this.scrollRect.width + 25;
			_vscroll.y = this.y;
			this.parent.addChild( _vscroll );
			
			_vscroll.setClient( this );
		}
		
		
		
		private function onEmnterFrame(e:Event):void 
		{
			this.removeEventListener(Event.ENTER_FRAME, onEmnterFrame );
			onResize( null );
		}
		
		private function onResize(e:Event):void 
		{
			_itms.sort( onsortGroup );
			const len:int = _itms.length;
			var yy:int = 0;
			var xx:int = 0;
			for (var i:int = 0; i < len; i++)  
			{
				_itms[ i ].y = yy;
				yy += _itms[ i ].height + 5;
				
				_itms[ i ].x = xx;
				
				/// исключено разнесение на колонки
				/*if ( i == int( len / 2 ) )
				{
					yy = 0;
					xx += _itms[ i ].width + 20;
				}*/
				
				
			}
			
			_back.scaleY = ( _back.height / this.height );
			
			_vscroll.update();
			
		}
		
		private function searchItms( keyWord:String ):int
		{
			const len:int = _itms.length;
			
			for ( var i:int = 0; i < len; i++ )
			{
				if ( _itms[ i ].keyWord == keyWord )
												return i;
			}
			
			return -1;
		}
		
		private function onsortGroup( x:GrField, y:GrField ):Number
		{
			
			if ( x[ MarketplaceWF.SORT_PROP ] < y[ MarketplaceWF.SORT_PROP ] ) return 1
			else if ( x[ MarketplaceWF.SORT_PROP ] > y[ MarketplaceWF.SORT_PROP ] ) return -1;
			else return 0;
			
			
			/*if ( x.cost < y.cost ) return -1;
			else if ( x.cost > y.cost ) return 1;
			else return 0;*/
		}
		
	}

}