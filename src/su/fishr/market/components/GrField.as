package su.fishr.market.components 
{
	import fl.controls.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	/**
	 * ...
	 * @author fishr
	 */
	public class GrField extends Sprite 
	{
		private var _keyWord:String;
		private var _list:Vector.<ItmString>;
		private var _btnOpn:Button;
		
		public function get keyWord():String 
		{
			return _keyWord;
			
		}
		
		public function GrField( wi:Array ) 
		{
			super();
			
			init( wi );
		}
		
		public function setNewWInf( wi:Array ):void
		{
			var yy:int = 0;
			const len:int = wi.length;
			
			
			_list[ 0 ].setData( wi[ 0 ] );
			yy += _list[ inx ].height;
			
			for (var i:int = 1; i < len ; i++) 
			{
				
				
				const inx:int = searchTf( wi[ i ][ 4 ] );
				
				
				
				if ( inx > -1 )
				{
					_list[ inx ].setData( wi[ i ] );
					yy += _list[ inx ].height;
					
				}
				else
				{
					const mainItm:ItmString = new ItmString( wi[ i ]  );
					mainItm.name = wi[ i ][ 4 ];
					mainItm.x = i?10:0;
					mainItm.y = yy;
					yy += mainItm.height;
					_list.push( mainItm );
					
				}
				
			}
			
			
		}
		
		private function init(wi:Array):void 
		{
			
			
			
			
			_keyWord = wi[ 0 ][ 0 ];
			
			_list = new Vector.<ItmString>;
			
			const len:int = wi.length;
			var yy:int = 0;
			for ( var i:int = 0; i < len; i++ )
			{
				const mainItm:ItmString = new ItmString(  wi[ i ] ) ;
				if( i > 0 )mainItm.name = wi[ i ][ 4 ];
				mainItm.x = i?10:0;
				mainItm.y = i?yy+ 5:yy;
				yy += mainItm.height + 1;
				
				
				_list.push( mainItm );
				
			}
			
			this.addChild( _list[ 0 ] );
			
			_btnOpn = new Button;
			_btnOpn.label = "+";
			_btnOpn.setSize( 20, 20 );
			_btnOpn.addEventListener( MouseEvent.CLICK, onOpnClick );
			_btnOpn.x = this.width;
			/// добавляем кнопку позже потому, что иначе ресайзинг окна данных работает неправильно
			this.addChild( _btnOpn );
			
		}
		
		private function onOpnClick(e:MouseEvent):void 
		{
			if ( _btnOpn.label == "+" )
				_btnOpn.label = "-";
			else
				_btnOpn.label = "+";
				
			onChangeVisible( _btnOpn.label == "-" );
				
			this.dispatchEvent( new Event( Event.RESIZE ) );
			
		}
		
		
		
		
		private function searchTf( key:int ):int
		{
			const len:int = _list.length;
			
			for (var i:int = 0; i < len ; i++) 
			{
				if ( int( _list[ i ].name ) == key )
				return i;
			}
			
			return -1;
		}
		
		private function onChangeVisible( on:Boolean ):void
		{
			const len:int = _list.length;
			for (var i:int = 1; i < len; i++) 
			{
				if ( on )
					this.addChild( _list[ i ] );
				else
					this.removeChild( _list[ i ] );
			}
			
		}
		
	}

}