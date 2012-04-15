/**
 * Standard by Big Spaceship. 2009-2010
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2009 Big Spaceship, LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 **/
package utils.loading
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.formats.WhiteSpaceCollapse;
	
	
	/**
	 *  Multiple file loader.
	 *	Basic syntax requires creation of an instance of BigLoader. To which assets can then be added.  
	 *	Loader is started with "start" after all assets are queued.  All events dispatched are in relation to global load.
	 *	<code>
	 *		var l:BigLoader = new BigLoader();
	 *		l.add("assets/myImage.jpg", "assetID", 234);	// parameters are (asset path, uniquie id [not required], weight in bytes [not required])
	 *		l.add("assets/audioLib.swf", null, 2700);
	 *		l.start();
	 *  </code>
	 *	
	 *	Additionally <code>loader.add()</code> will return an instance of BigLoadItem which will also dispatch PROGRESS and COMPLETE events for itself.
	 *	
	 *	@dispatches Event.COMPLETE
	 *	@dispatches ProgressEvent.PROGRESS
	 *	
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 10.0.0
	 *
	 *  @author Charlie Whitney, Jamie Kosoy
	 *  @since  25.05.2010
	 */
	public class BigLoader extends EventDispatcher {
		public static var verbose		:Boolean = true;

		private const MAX_CONNECTIONS	:int = 2;

		private var _itemsToLoad	:Vector.<BigLoadItem>;
		private var _itemsComplete	:Dictionary = new Dictionary(true);
		private var _curLoadIndex	:int = 0;
		private var _activeLoads	:int = 0;
		private var _numComplete	:int = 0;
		private var _loaderActive	:Boolean = false;
		private var _totalWeight	:int;
		private var _loadComplete	:Boolean = false;
		
		public function get loadComplete():Boolean{
			return _loadComplete;
		}

		public function BigLoader() {
			_totalWeight = 0;
			_itemsToLoad = new Vector.<BigLoadItem>();
		};

		public function add($url:*, $id:String=null, $weight:int=1, $type:String = null):BigLoadItem {
			if(_loaderActive){ _log("You can't add anything after the loader is started.");	return null; }
			if($id == null) $id = $url;
			
			var _loadItem:BigLoadItem = new BigLoadItem($url, $id, $weight,$type);
			_loadItem.addEventListener(ProgressEvent.PROGRESS, _onItemProgress, false, 999, true);
			_loadItem.addEventListener(IOErrorEvent.IO_ERROR, _onItemLoadError, false, 999, true);
			_loadItem.addEventListener('bigloaditemcomplete', _onItemLoadComplete, false, 999, true);
			
			_itemsToLoad.push(_loadItem);
			
			_totalWeight += $weight;
			_loadComplete = false;
			return _loadItem;
		};
		
		public function destroy():void
		{
			for(var i:int=0;i<_itemsToLoad.length;i++) { _itemsToLoad[i].destroy(); }

			_itemsToLoad = null;
			_itemsComplete = null;
		};
		
		public function reset():void
		{
			for(var i:int=0;i<_itemsToLoad.length;i++) { _itemsToLoad[i].destroy(); }
			while (_itemsToLoad.length > 0) _itemsToLoad.pop();
			
			_curLoadIndex=0;
			_activeLoads= 0;
			_numComplete= 0;
			
			_itemsComplete = new Dictionary(true);
		};
		
		
		public function start():void {
			if(_loaderActive){ _log("Loader is already started."); return; }
			_log("Starting load of "+_itemsToLoad.length+" items.");
			
			_loaderActive = true;
			
			// load the maximum number possible
			var numToLoad:int = (_itemsToLoad.length < MAX_CONNECTIONS) ? _itemsToLoad.length : MAX_CONNECTIONS;
			while(_activeLoads < numToLoad){
				_loadItem(_curLoadIndex);
			}
		};
		
		/**
		 *	Returns the BigLoadItem instance for the passed ID.
		 */
		public function getLoadedItemById($id:String):* {
			if(_itemsComplete[$id] == null) {
				_log("Warning: Asset not loaded yet.");
				return null;
			}
			return _itemsComplete[$id];
		};
		
		public function collectAllItems(arData:Array):void
		{
			for (var i:int=0; i < _itemsToLoad.length; i++) {
				arData[_itemsToLoad[i].id] = _itemsToLoad[i].content;
			}
		}
		
		
		/**
		 *	Returns the asset from the BigLoadItem instance for the passed ID
		 */
		public function getLoadedAssetById($id:String):* {
			if(_itemsComplete[$id] == null){ 
				_log("Warning: Asset not loaded yet.");
				return null;
			}
			return BigLoadItem(_itemsComplete[$id]).content;
		};
		
		// ---------------------------
		// PRIVATE
		// ---------------------------
		private function _loadItem($index:int):void {
			var nextItem:BigLoadItem = _itemsToLoad[$index];
			nextItem.startLoad();
			
			_log("Starting load of "+nextItem);
			
			++_activeLoads;
			++_curLoadIndex;
		};
		
		private function _onItemProgress($evt:Event):void {
			var totalPercent:Number = 0;
			var i:int=_itemsToLoad.length;
			while(--i > -1){
				totalPercent += _itemsToLoad[i].getWeightedPercentage(_totalWeight);
			}
			
			// totalPercent will be a number between 0-1
			// ProgressEvent acts weird when you give it floats, so multiply by 100
			dispatchEvent( new ProgressEvent(ProgressEvent.PROGRESS, false, false, totalPercent*100, 100) );
		};
		
		private function _onItemLoadError($evt:IOErrorEvent):void {
			_log("Error loading item. "+$evt);
			
			// remove events
			$evt.target.removeEventListener(ProgressEvent.PROGRESS, _onItemProgress);
			$evt.target.addEventListener(IOErrorEvent.IO_ERROR, _onItemLoadError);
			$evt.target.removeEventListener(Event.COMPLETE, _onItemLoadComplete);
			
			
			dispatchEvent( $evt );
			
			_itemLoadedCleanup(true);
		};
		
		// when a single item completes its load
		private function _onItemLoadComplete($evt:Event):void {
			_log("Completed load of :: "+$evt.target);
			// store content of loader
			_itemsComplete[$evt.target.id] = $evt.target;
			
			
			// remove events
			$evt.target.removeEventListener(ProgressEvent.PROGRESS, _onItemProgress);
			$evt.target.addEventListener(IOErrorEvent.IO_ERROR, _onItemLoadError);
			$evt.target.removeEventListener(Event.COMPLETE, _onItemLoadComplete);
			
			// dispatch complete event
			_itemLoadedCleanup();
		};
		
		// remove listeners, update counters
		private function _itemLoadedCleanup(fail:Boolean=false):void {
			
			
			if (fail) {
				return;
			}
			
			// reduce number of loads
			--_activeLoads;
			
			// check if it should start another load
			++_numComplete;
			if(_numComplete == _itemsToLoad.length){
				_allLoadsComplete();
			}else if(_curLoadIndex < _itemsToLoad.length){
				_loadItem(_curLoadIndex);
			}
		};
		
		private function _allLoadsComplete():void {
			_loaderActive = false;
			_loadComplete = true;
			// dispatch all complete event
			dispatchEvent( new Event(Event.COMPLETE) );
		};
		
		// tracing
		override public function toString():String {
			return "[BigLoader: "+_itemsToLoad.length+" items]";
		};
		
		// logging
		private function _log($str:String):void 
		{
			if(verbose) trace( $str);
		};
	}
}