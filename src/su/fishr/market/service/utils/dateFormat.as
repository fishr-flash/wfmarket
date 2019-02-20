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
		return [
			AddZerroDate( date.date )
			,AddZerroDate( date.month + 1) 
			,AddZerroDate( date.fullYear ) 
			,AddZerroDate( date.hours ) 
			,AddZerroDate( date.minutes ) 
			,AddZerroDate( date.seconds ) 
			,AddZerroDate( date.milliseconds, 3 )
		];
			
	}
		
	

}