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
			
			//stage.stageWidth = 2400;
			//stage.stageHeight = 1200;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			const mp:MarketplaceWF = new MarketplaceWF;
			mp.scaleX = mp.scaleY = 1.2;
			this.addChild( mp ); 
		}
		
	}
	
}