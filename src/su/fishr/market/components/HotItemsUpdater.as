package su.fishr.market.components 
{
	import fl.controls.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import su.fishr.market.MarketplaceWF;
	
	/**
	 * ...
	 * @author  
	 */
	public class HotItemsUpdater extends Sprite 
	{
		private var _hotUpItems:ButtonClr;
		private var _callback:Function;
		private var _file:FileReference;
		
		public function HotItemsUpdater( onLoadHotItems:Function ) 
		{
			super();
			
			_callback = onLoadHotItems;
			
			init();
		}
		
		private function init():void 
		{
			_hotUpItems = new ButtonClr;
			_hotUpItems.label = "upi";
			_hotUpItems.setSize( MarketplaceWF.WIDTH_BUTTONS + 5, _hotUpItems.height );
			_hotUpItems.colorFill( "1d5ee2" );
			this.addChild( _hotUpItems );
			_hotUpItems.addEventListener( MouseEvent.CLICK, onBtnUpItems );
			//_hotUpItems.enabled = false;
		}
		
		private function onBtnUpItems(e:MouseEvent):void 
		{
			//_btnLoad.enabled = false;
			
			
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "HotItemsUpdater.as" + ". " +  "onBtnUpItems ")
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
			_file = new FileReference;
			_file.addEventListener( Event.SELECT, onSelectFile );
			_file.browse();
			
		}
		
		
		private function onSelectFile(e:Event):void 
		{
			_file.removeEventListener( Event.SELECT, onSelectFile );
			_file.addEventListener(Event.COMPLETE, onLoadFile );
			_file.load();
		}
		
		private function onLoadFile(e:Event):void 
		{
			e.target.removeEventListener( Event.SELECT, onSelectFile );
			
			const b:ByteArray = e.target.data;
			b.position = 0;
			
			_callback( JSON.parse(  b.readUTFBytes( b.bytesAvailable ) ) );
		}
		
		
		
	}

}