package com.ravi.examples.mvc.model
{
    import com.ravi.examples.mvc.common.AbstractClass;
    import com.ravi.examples.mvc.common.AbstractMediator;
    
    import mx.collections.ArrayCollection;
    import mx.collections.ArrayList;

    [Bindable]
    public class AppModuleLocator extends AbstractClass
    {
        //-------------------------------------------------------------------------
        //
        //	Data Providers
        //
        //-------------------------------------------------------------------------

        public var bookList:ArrayCollection = new ArrayCollection();
        public var authorList:ArrayCollection = new ArrayCollection();

		//-------------------------------------------------------------------------
		//
		//	Functions
		//
		//-------------------------------------------------------------------------
		
        public function setAuthors(array:Array):void
        {
            authorList.source = [];
			
            for (var i:int = 0; i < array.length; i++)
            {
                var item:Object = new Object();
                item.label = array[i].toString();
                authorList.addItem(item);
            }
			logger.debug('[AppModuleLocator] setAuthors() authorList = {0}', array);
        }

    }
}