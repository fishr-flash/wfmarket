package su.fishr.market.seller.nets 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.*;
	import flash.net.*;
	import su.fishr.market.MarketplaceWF;
	import su.fishr.market.service.Logw;
	import su.fishr.utils.Dumper;
	
	/**
	 * ...
	 * @author fishr
	 */
	public class SellRequest extends EventDispatcher 
	{
		
		
		
		private var loader:URLLoader;
		private var _call:Function;
        
        public function SellRequest(entity_id:int, cost:int, callback:Function, target:IEventDispatcher = null  ) {
			
			super(target);
			
			_call = callback;
            loader = new URLLoader();
            configureListeners(loader);

            const sellCost:int = int( ( cost / MarketplaceWF.CHARGE_RATIO ) * 1 );
            var request:URLRequest = new URLRequest("https://wf.mail.ru/minigames/inventory/api/sale");
			request.method = URLRequestMethod.POST;
			var variables:URLVariables = new URLVariables;
			variables.item_id = entity_id + "";
			variables.cost = sellCost + "";
			request.data = variables;
			
			//////////////////////TRACE/////////////////////////////////
			
			import su.fishr.market.service.Logw;
			import su.fishr.utils.Dumper;
			if( true )
			{
				const i:String = 
				( "SellRequest.as" + ". " +  "SellRequest ")
				//+ ( "\r : " + Dumper.dump( true ) )
				//+ ( "\r request: " + Dumper.dump( request, 6, true, true ) )
				+ ( "\r variables: " + Dumper.dump( variables, 6, true, true ) )
				//+ ( "\r variables: " + variables.type )
				//+ ( "\r entity_id: " +entity_id )
				//+ ( "\r cost: " +cost )
				
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			/////////////////////END TRACE//////////////////////////////
            try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
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
			_call( loader.data );
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
				( "SellRequest.as" + ". " +  "securityErrorHandler ")
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
				( "SellRequest.as" + ". " +  "ioErrorHandler ")
				+ ( "\r event.toString(): " +  event.toString())
				+ ( "\r end" );
				Logw.inst.up( i );
			}
			
        }
    }
		
	

}