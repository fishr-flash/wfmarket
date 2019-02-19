package su.fishr.bases 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author  
	 */
	public class BaseSprites extends Sprite 
	{
		
		public function BaseSprites() 
		{
			super();
			
		}
		
		protected function setSize( w:int, h:int ):void
		{
			//this.graphics.beginFill( 0x00FF00 );
			this.graphics.lineStyle( .1, 0xFFF00F, 0 );
			this.graphics.moveTo( 0, 0 );
			this.graphics.lineTo(w, 0 );
			//this.graphics.moveTo( w, 0 );
			this.graphics.lineTo( w, h );
			//this.graphics.moveTo( w, h );
			this.graphics.lineTo( 0, h );
			//this.graphics.moveTo( 0, h );
			this.graphics.lineTo( 0, 0 );
			this.graphics.endFill();
		}
		
	}

}