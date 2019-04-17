package su.fishr.market.lootdog.net 
{
	import flash.display.Sprite;
    import flash.events.*;
    import flash.net.*;
	import su.fishr.market.service.Logw;
	import su.fishr.utils.Dumper;
	
	/**
	 * ...
	 * @author  
	 */
	public class AskQueue 
	{
		
		
		
		private var loader:URLLoader;
		private var _call:Function;
		private var _request:URLRequest;
        
        public function AskQueue( id:int, callback:Function ) {
			
			_call = callback;
            loader = new URLLoader();
            configureListeners(loader);
			
			

            _request = new URLRequest("https://lootdog.io/api/orders/?format=json&product=" + id + "&page=1&limit=5&is_buy=false&user=all&sorting=price");
            try {
                loader.load(_request);
            } catch (error:Error) {
				//////////////////////TRACE/////////////////////////////////
				
				import su.fishr.market.service.Logw;
				import su.fishr.utils.Dumper;
				if( true )
				{
					var i:String = 
					( "AskQueue.as" + ". " +  "AskQueue ")
					//+ ( "\r : " + Dumper.dump( true ) )
					+ ("Unable to load requested document." + "request: " + _request.url)
					+ ( "\r : " + "" )
					+ ( "\r end" );
					Logw.inst.up( i );
				}
				/////////////////////END TRACE//////////////////////////////
               
            }
        }

        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
           ///  trace("completeHandler: " + loader.data);
			_call( loader.data );
        }

        private function openHandler(event:Event):void {
           ///  trace("openHandler: " + event);
			
        }

        private function progressHandler(event:ProgressEvent):void {
           ///  trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
           ///  trace("securityErrorHandler: " + event);
			
			
			if( true )
			{
				const i:String = 
				( "AskQueue.as" + ". " +  "securityErrorHandler ")
				+ ( "\r event.toString(): " +  event.toString())
				+ ( "\r request: " + _request.url)
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
           ///  trace("httpStatusHandler: " + event);
			
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
           ///  trace("ioErrorHandler: " + event);
			
			
			if( true )
			{
				const i:String = 
				( "AskQueue.as" + ". " +  "ioErrorHandler ")
				+ ( "\r event.toString(): " +  event.toString())
				+ ( "\r request: " + _request.url)
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
        }
    }

}