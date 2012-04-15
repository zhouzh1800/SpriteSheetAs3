package com.sprite_sheet
{
	import flash.events.Event;
	public class AnimSpriteSheet extends Animation
	{
		protected var mBmps: Array = new Array();
		
		public function AnimSpriteSheet(bmps: Array): void
		{
			mBmps = bmps;
		}
		
		override public function DoInit(): void
		{
			SetFrame(0);
			EnableShow(false);
		}
		
		override public function EnableShow(isEnable:Boolean): void
		{
			for each(var i:Object in mBmps)
			{
				i.visible = isEnable;
			}
		}
		
		override public function IsShow(): Boolean
		{
			for each(var i:Object in mBmps)
			{
				return i.visible;
			}
			
			return false;
		}
		
		override public function RealEnterFrameHandler(e:Event, elapseTime:int): void
		{
			if(mIsPlay)
			{
				var speed: Number = 1000 / mFps;
				mSumTime += elapseTime;
				var newFrameIndex:int = mSumTime / speed + 0.5;
				newFrameIndex %= mBmps.length;
				
				if(newFrameIndex != mFrameIndex)
				{
					SetFrame(newFrameIndex);
				}
			}
		}
		
		override public function SetFrame(frameIndex:int): void
		{
			if(numChildren != 0)
			{
				removeChild(mBmps[mFrameIndex]);
			}
			
			mFrameIndex = frameIndex;
			addChild(mBmps[mFrameIndex]);
		}
	}
}
