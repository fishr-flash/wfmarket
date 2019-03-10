package su.fishr.utils 
{
	import flash.text.TextField;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author fishr
	 */
	public function createCustomTextField(x:Number, y:Number, width:Number, height:Number):TextField {
            var result:TextField = new TextField();
            result.x = x;
            result.y = y;
            result.width = width;
            result.height = height;
            result.background = true;
            result.border = true;
			result.type = TextFieldType.INPUT;
            return result;
     }

}