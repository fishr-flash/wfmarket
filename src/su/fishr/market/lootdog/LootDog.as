package su.fishr.market.lootdog 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import su.fishr.market.MarketplaceWF;
	import su.fishr.market.components.ButtonClr;
	import su.fishr.market.lootdog.service.LDgInspector;
	
	/**
	 * ...
	 * @author fishr
	 */
	public class LootDog extends Sprite 
	{
		private var _btnStart:ButtonClr;
		
		
		public function LootDog() 
		{
			super();
			
			init();
		}
		
		private function init():void 
		{
			_btnStart = new ButtonClr;
			_btnStart.label = "ldg";
			_btnStart.x = 0;
			_btnStart.y = 0;
			_btnStart.enabled = true;
			_btnStart.toggle = true;
			_btnStart.setSize( MarketplaceWF.WIDTH_BUTTONS, _btnStart.height );
			_btnStart.colorFill( "993333" );
			_btnStart.addEventListener( MouseEvent.CLICK, onButtonStart );
			this.addChild( _btnStart );
		}
		
		private function onButtonStart(e:MouseEvent):void 
		{
			if ( _btnStart.selected )
			{
				LDgInspector.self.start();
			}
			else
			{
				LDgInspector.self.kill();
			}
			
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "LootDog.as" + ". " +  "onButtonStart ")
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
		}
		
	}

}