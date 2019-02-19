package su.fishr.market.components 
{
	import flash.display.Shape;
	import su.fishr.market.MarketplaceWF;
	import su.fishr.utils.drawSize;
	
	/**
	 * ...
	 * @author  
	 */
	public class BackgroundShape extends Shape 
	{
		
		public function BackgroundShape( wdth:int, hght:int, backclr:uint = 0xFFFFFF ) 
		{
			super();
			
			init( wdth, hght, backclr );
		}
		
		private function init(wdth:int, hght:int, backclr:uint):void 
		{
			
			this.graphics.lineStyle( 0.1, 0, 0 );
			this.graphics.beginFill( MarketplaceWF.TEME_COLOR, 1 );
			drawSize( wdth, hght, this );
			this.graphics.endFill();
		}
		
		
	}

}