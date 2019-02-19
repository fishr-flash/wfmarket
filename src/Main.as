package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import su.fishr.market.MarketplaceWF;
	
	/**
	 * ...
	 * @author  
	 */
	public class Main extends Sprite 
	{
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			
			
		}
		
		private function init(e:Event = null):void 
		{
			
			
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.stageWidth = 1266;
			stage.stageHeight = 900;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			this.addChild( new MarketplaceWF ); 
		}
		
	}
	
}