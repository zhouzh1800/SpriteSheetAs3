package com.tiled
{
	import utils.base64.Base64Util;
	import com.probertson.utils.GZIPBytesEncoder;
	
	import flash.utils.ByteArray;
	
	public class TMXLayerInfo
	{
		public var mName: String;
		public var mWidth: int;
		public var mHeight: int;
		public var mDataEncoding: String;
		public var mDataCompression: String;
		public var mTiles: Array = new Array();
		
		
		public function Init(xmlConfig:XML): void
		{
			mName = xmlConfig.attribute("name");
			mWidth = xmlConfig.attribute("width");
			mHeight = xmlConfig.attribute("height");
			mDataEncoding = xmlConfig.data.attribute("encoding");
			mDataCompression = xmlConfig.data.attribute("compression");

			var data: String = xmlConfig.data;
			
			var mData: ByteArray;
			if(mDataEncoding == "base64")
			{
				mData = Base64Util.decode(data);
				mData.position = 0;
				
				if(mDataCompression == "gzip")
				{
					var encoder: GZIPBytesEncoder = new GZIPBytesEncoder();
					mData = encoder.uncompressToByteArray(mData);
				}
				else
				{
					trace("tiled map compression error: " + mDataCompression);
					return;
				}
			}
			else
			{
				mData.writeUTFBytes(data);
			}
			
			for(var i: int = 0; i < mData.length; i += 4)
			{
				var tileGid: int = mData[i] | (mData[i + 1] << 8) | (mData[i + 2] << 16) | (mData[i + 3] << 24);
				mTiles.push(tileGid);
			}
		}
		
		public function GetTileGid(tileId: int): int
		{
			return mTiles[tileId];
		}
	}
}