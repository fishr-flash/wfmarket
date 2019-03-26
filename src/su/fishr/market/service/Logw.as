package su.fishr.market.service 
{
	import fl.controls.ScrollPolicy;
	import fl.controls.TextArea;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import su.fishr.bases.BaseSprites;
	import su.fishr.market.MarketplaceWF;
	import su.fishr.market.components.BackgroundShape;
	import su.fishr.market.service.utils.dateFormat;
	import su.fishr.utils.AddZerroDate;
	
	/**
	 * ...
	 * @author  
	 */
	public class Logw extends BaseSprites 
	{
		private static var _area:TextArea;
		private static var _self:Logw;
		private const _MY_WIDTH:int = 1000;
		private const _MY_HEIGHT:int = 300;
		static public function get inst():Logw
		{
			if ( !_self )_self = new Logw;
			return _self;
		}
		
		public function Logw() 
		{
			super();
			
			init();
			
		}
		
		public function up( str:String ):void
		{
			
			
			const date:Array = dateFormat();
			const strDate:String = date[ 3 ]
									+ ":" + date[ 4 ]
									+ ":" + date[ 5 ]
									+ ":" + date[ 6 ];
			/*if ( _area.text.length > 30000 ) 
					_area.text = _area.text.slice( 0, 2000);*/
			
			_area.text = _area.text + "\r\r " + strDate + "                              ===>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \r " + str;
			_area.setSelection( _area.length, _area.length );
			
		}
		
		public function conf_up(i:String):void 
		{
			_area.text = i;
		}
		
		private function init():void 
		{
			const back:BackgroundShape = new BackgroundShape( _MY_WIDTH, _MY_HEIGHT );
			this.addChild( back ) ;
			
			configureArea();
			this.addChild( _area );
		}
		
		
		private function configureArea():void
		{
			_area = new TextArea;
			//_area.autoSize = TextFieldAutoSize.LEFT;
			_area.wordWrap = true;
			const tf:TextFormat = new TextFormat( null, 18, MarketplaceWF.FONT_COLOR, false  );
			_area.setStyle( "textFormat", tf );
			_area.textField.background = true;
			_area.textField.backgroundColor = MarketplaceWF.TEME_COLOR;
			
			//_area.border = true;
			//_area.borderColor = 0x00;
			_area.verticalScrollPolicy = ScrollPolicy.ON;
			_area.setSize( _MY_WIDTH, _MY_HEIGHT );
			
			_area.text = "Nothing has changed since the last compile. Skip... ";
		}
		
		
		
	}

}