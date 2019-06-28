package su.fishr.market.service.utils 
{
	import su.fishr.utils.AddZerroDate;
	/**
	 * ...
	 * @author  
	 */
	
		
	public function dateFormat():Array
	{
		
		const date:Date = new Date;
		
		try{
		
			const arr:Array = [
			AddZerroDate( date.date )
			,AddZerroDate( date.month + 1) 
			,AddZerroDate( date.fullYear ) 
			,AddZerroDate( date.hours ) 
			,AddZerroDate( date.minutes ) 
			,AddZerroDate( date.seconds ) 
			,AddZerroDate( date.milliseconds, 3 )
			];
		}
		catch ( e:Error )
		{
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				var i:String = 
				( "dateFormat.as" + ". " +  "dateFormat ")
				//+ ( "\r : " + Dumper.dump( true ) )
				+ ( "\r e: " + e )
				+ ( "\r date: " + date )
				+ ( "\r : " + "" )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
			
			return [ "00", "00" ];
		}
		
		
		
		return arr;
			
	}
		
	

}