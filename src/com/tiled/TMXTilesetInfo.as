package com.tiled
{
	import XML;
	
	import flash.utils.Dictionary;
	

	public class TMXTilesetInfo
	{
		public var mFirstGid: int;
		public var mName: String;
		public var mTileWidth: int;
		public var mTileHeight: int;
		public var mSpacing: int;
		public var mMargin: int;
		
		public var mImageSource: String;
		public var mImageWidth: int;
		public var mImageHeight: int;
		
		public var mTileMap: Dictionary = new Dictionary();
		
		public function Init(xmlConfig:XML): void
		{
			mFirstGid = xmlConfig.attribute("firstgid");
			mName = xmlConfig.attribute("name");
			mTileWidth = xmlConfig.attribute("tilewidth");
			mTileHeight = xmlConfig.attribute("tileheight");
			mSpacing = xmlConfig.attribute("spacing");
			mMargin = xmlConfig.attribute("margin");
			
			mImageSource = xmlConfig.image.@source;
			mImageWidth = xmlConfig.image.@width;
			mImageHeight = xmlConfig.image.@height;
			
			var tileChildList: XMLList = xmlConfig.elements("tile");
			for each(var i:XML in tileChildList)
			{
				var id: int = i.attribute("id");
				var tilePropertyMap: Dictionary = new Dictionary(); 
				for(var j: int = 0; j < i.properties.property.length();j++)
				{
					var propertyName:String = i.properties.property[j].attribute("name");
					var propertyValue:String = i.properties.property[j].attribute("value");
					tilePropertyMap[propertyName] = propertyValue;
				}
				mTileMap[id] = tilePropertyMap;
			}
		}
	}
}