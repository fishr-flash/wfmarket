package su.fishr.market.lootdog.service 
{
	import flash.events.*;
	import flash.net.*;
	import su.fishr.market.service.Logw;
	import su.fishr.utils.Dumper;
	
	/**
	 * ...
	 * @author  
	 */
	public class LDListRequest 
	{
		
		private static const _URL:String = 'https://lootdog.io/api/products/?format=json&search=%D0%90%D0%B1%D1%81%D0%BE%D0%BB%D1%8E%D1%82&on_sale=1&game=&price_min=&price_max=&kind=&sorting=popular&page=1&limit=72';
		
		private var loader:URLLoader;
		private var _call:Function;
        
        public function LDListRequest( callback:Function ) {
			
			_call = callback;
            loader = new URLLoader();
            configureListeners(loader);
			

            
            var request:URLRequest = new URLRequest( _URL );
			request.method = URLRequestMethod.GET;
			/*var variables:URLVariables = new URLVariables;
			variables.entity_id = entity_id + "";
			variables.cost = cost + "";
			variables.type = type;
			request.data = variables;*/
			
			
            try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document of lootdog.");
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
            trace("completeHandler: " + loader.data);
			
			_call( { data:loader.data, state:   "***************Operation successfull***************************" } );
        }

        private function openHandler(event:Event):void {
            trace("openHandler: " + event);
			
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
			
			
			if( true )
			{
				const i:String = 
				( "BayRequest.as" + ". " +  "securityErrorHandler ")
				+ ( "\r event.toString(): " +  event.toString())
				//+ ( "\r : " + Dumper.dump( "" ) )
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
			
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
			
			
			if( true )
			{
				const i:String = 
				( "BayRequest.as" + ". " +  "ioErrorHandler ")
				+ ( "\r event.toString(): " +  event.toString())
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
			
			_call({
				event: event.toString() 
				, state: "on fail request, server no respond"
			});
			
			
        }
    }

}