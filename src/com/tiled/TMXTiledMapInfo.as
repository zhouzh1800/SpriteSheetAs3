package com.tiled
{
	import XML;
	
	import flash.utils.Dictionary;

	public class TMXTiledMapInfo
	{
		public var mVersion: String;
		public var mOrientation: String;
		public var mWidth: int;
		public var mHeight: int;
		public var mTileWidth: int;
		public var mTileHeight: int;
		
		public var mTilesets: Array = new Array();
		public var mLayers: Array = new Array();
		
		public function Init(xmlConfig:XML): void
		{
			mVersion = xmlConfig.attribute("version");
			mOrientation = xmlConfig.attribute("orientation");
			mWidth = xmlConfig.attribute("width");
			mHeight = xmlConfig.attribute("height");
			mTileWidth = xmlConfig.attribute("tilewidth");
			mTileHeight = xmlConfig.attribute("tileheight");
			
			var tilesetList: XMLList = xmlConfig.elements("tileset");
			for each(var i:XML in tilesetList)
			{
				var tilesetInfo: TMXTilesetInfo = new TMXTilesetInfo();
				tilesetInfo.Init(i);
				mTilesets.push(tilesetInfo);
			}
			
			var layerList: XMLList = xmlConfig.elements("layer");
			for each(var l:XML in layerList)
			{
				var layerInfo: TMXLayerInfo = new TMXLayerInfo();
				layerInfo.Init(l);
				mLayers.push(layerInfo);
			}
		}
	}
}