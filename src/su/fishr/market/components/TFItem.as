package su.fishr.market.components 
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import su.fishr.market.MarketplaceWF;
	
	/**
	 * ...
	 * @author fishr
	 */
	public class TFItem extends TextField 
	{
		
		public function TFItem() 
		{
			super();
			init();
		}
		
		private function init():void 
		{
			//this.defaultTextFormat = new TextFormat( "Arial");
			this.defaultTextFormat = new TextFormat( "Courier New", 14, MarketplaceWF.FONT_COLOR);
			this.autoSize = TextFieldAutoSize.LEFT;
			
			this.backgroundColor = MarketplaceWF.TEME_COLOR;
			this.background = true;
		}
		
	}

}