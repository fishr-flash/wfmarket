package su.fishr.market.components 
{
	import fl.controls.Button;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author fishr
	 */
	public class ButtonClr extends Button 
	{
		private var _back:Shape;
		public function ButtonClr() 
		{
			super();
			
		}
		
		
		public function colorFill( color:String ):void
		{
			if ( _back )
				this.removeChild( _back );
			
			//setTimeout( fill, 3000, color );
			
			fill( color );
			
			
			
		}
		
		
		
		private function fill( color:String ):void
		{
			const clr:uint = uint( Number( "0x" + color ) );
			_back = new Shape;
			const gr:Graphics = _back.graphics;
			gr.beginFill( clr, .2 );
			gr.drawRoundRect( 0, 0, this.width, this.height, 7, 7 );
			gr.endFill();
			this.addChildAt( _back, 0 );
		}
		
	}

}