package com.sprite_sheet
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import utils.loading.BigLoader;
	import utils.plist.PDict;
	import utils.plist.Plist10;
	
	public class SpriteFrameCache
	{
		private static var sSingleton: SpriteFrameCache = null;
		public static function Singleton(): SpriteFrameCache
		{
			if(sSingleton == null)
			{
				sSingleton = new SpriteFrameCache();
			}
			return sSingleton;
		}
		
		private var mLoader: BigLoader = null;
		private var mFrameMap: Dictionary = new Dictionary();
		
		public function SetLoader(loader: BigLoader): void
		{
			mLoader = loader;
		}
		
		public function AddSpriteFrames(frameFileName: String): Boolean
		{
			if(mLoader == null)
			{
				return false;
			}
			
			var xml: XML = XML(mLoader.getLoadedAssetById(frameFileName));
			var plist:Plist10 = new Plist10();
			plist.parse(xml);
			
			var metadataDict:PDict = plist.root["metadata"];
			var metadataInfo: MetadataInfo = new MetadataInfo();
			metadataInfo.mFormat = metadataDict["format"];
			metadataInfo.mRealTextureFileName = metadataDict["realTextureFileName"];
			metadataInfo.mSize = ConvertStringToPoint(metadataDict["size"]);
			metadataInfo.mSmartupdate = metadataDict["smartupdate"];
			metadataInfo.mTextureFileName = metadataDict["textureFileName"];
			
			var framesDict:PDict = plist.root["frames"];
			for (var key:String in framesDict.object)
			{
				var frameDict: PDict = framesDict.object[key];
				var frame: FrameInfo = new FrameInfo();
				frame.mFrame = ConvertStringToRect(frameDict.object["frame"]);
				frame.mOffset = ConvertStringToPoint(frameDict.object["offset"]);
				frame.mRotated = frameDict.object["rotated"].object;
				frame.mSourceColorRect = ConvertStringToRect(frameDict.object["sourceColorRect"]);
				frame.mSourceSize = ConvertStringToPoint(frameDict.object["sourceSize"]);
				frame.mMetadataInfo = metadataInfo;
				if(mFrameMap[key] == null)
				{
					mFrameMap[key] = frame;	
				}
				else
				{
					trace("frame name duplicate: " + key);
				}
			}
			
			return true;
		}
		
		private function ConvertStringToRect(str: String): Rectangle
		{
			var regExp: RegExp = /[{},]+/;
			var strs: Array = str.split(regExp);
			var rx: int = strs[1];
			var ry: int = strs[2];
			var rw: int = strs[3];
			var rh: int = strs[4];
			var rect: Rectangle = new Rectangle(rx, ry, rw, rh);
			return rect;
		}
		
		private function ConvertStringToPoint(str: String): Point
		{
			var regExp: RegExp = /[{},]+/;
			var strs: Array = str.split(regExp);
			var rx: int = strs[1];
			var ry: int = strs[2];
			var point: Point = new Point(rx, ry);
			return point;
		}
		
		public function CreateSpriteSheetFrame(frameName: String): SpriteSheetFrame
		{
			var frameInfo: FrameInfo = mFrameMap[frameName];
			if(frameInfo == null)
			{
				return null;
			}
			
			var spriteSheet: SpriteSheet = TextureCache.Singleton().getSpriteSheet(frameInfo.mMetadataInfo.mRealTextureFileName);
			if(spriteSheet == null)
			{
				return null;
			}
			
			var rx: int = frameInfo.mFrame.left;
			var ry: int = frameInfo.mFrame.top;
			var rw: int = frameInfo.mFrame.width;
			var rh: int = frameInfo.mFrame.height;
			
			if(frameInfo.mRotated)
			{
				var temp: int = rh;
				rh = rw;
				rw = temp;
			}
			
			var rect: Rectangle = new Rectangle(rx, ry, rw, rh);
			
			var bmp: Bitmap = spriteSheet.getBitmapByRect(rect);
			
			bmp.x = frameInfo.mSourceColorRect.left;
			bmp.y = frameInfo.mSourceColorRect.top;
			
			if(frameInfo.mRotated)
			{
				bmp.rotation = -90;
				bmp.y += frameInfo.mFrame.height;
			}
			
			var ssbmp: SpriteSheetFrame = new SpriteSheetFrame(bmp, frameInfo.mSourceSize.x, frameInfo.mSourceSize.y);
			
			return ssbmp;
		}
	}
}
import flash.geom.Point;
import flash.geom.Rectangle;

class FrameInfo
{
	//public var mName: String;
	public var mFrame:Rectangle;
	public var mOffset:Point;
	public var mRotated: Boolean;
	public var mSourceColorRect: Rectangle;
	public var mSourceSize: Point;
	
	public var mMetadataInfo: MetadataInfo;
}

class MetadataInfo
{
	public var mFormat: int;
	public var mRealTextureFileName: String;
	public var mSize: Point;
	public var mSmartupdate: String;
	public var mTextureFileName: String;
}