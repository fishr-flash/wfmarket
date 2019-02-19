package su.fishr.utils 
{
	import flash.display.Shape;
	
	/**
	 *  Перед использованием выполнить настройку 
	 * стиля линии и цвет заливки, финализировать
	 * отрисовку ( endFill )следует в вызывающей функции
	 * 
	 * @param	w
	 * @param	h
	 * @param	owner
	 */
	
	public function drawSize( w:uint, h:uint, owner:Shape ):void
	{
		//owner.graphics.beginFill( 0x00FF00 );
		//owner.graphics.lineStyle( .1, 0xFFF00F, 0 );
			owner.graphics.moveTo( 0, 0 );
			owner.graphics.lineTo(w, 0 );
			//owner.graphics.moveTo( w, 0 );
			owner.graphics.lineTo( w, h );
			//owner.graphics.moveTo( w, h );
			owner.graphics.lineTo( 0, h );
			//owner.graphics.moveTo( 0, h );
			owner.graphics.lineTo( 0, 0 );
		//owner.graphics.endFill();
	}

}