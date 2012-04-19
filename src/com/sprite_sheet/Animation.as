package com.sprite_sheet
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class Animation extends Sprite
	{
		public var mType: int;
		
		public var mFps: int;
		public var mWidth: int;
		public var mHeight: int;
		public var mLoopMode: int;
		public var mFrameCount: int;
		public var mIsPlay: Boolean;
		
		protected var mStartTime: int;
		protected var mSumTime: int;
		protected var mFrameIndex: int;
		
		protected var mPreTime: int;
		
		protected var mIsEnable: Boolean;
		
		protected var mAnchor: Point = new Point();
		
		public function Animation(): void
		{
			EnableUpdate(true);
		}
		
		private function enterFrameHandler(e:Event):void{
			var nowTime:int = getTimer();
			var elapseTime:int = nowTime - mPreTime;
			mPreTime = nowTime;
			
			RealEnterFrameHandler(e, elapseTime);
		}
		
		public function Init(): void 
		{
			SetAnchor(0.5, 0.5);
			DoInit();
		}
		
		public function DoInit(): void
		{
			
		}
		
		public function EnablePlay(isEnable:Boolean): void
		{
			mIsPlay = isEnable;
		}
		
		public function IsPlay(): Boolean
		{
			return mIsPlay;
		}
		
		public function GetAnchor(): Point
		{
			return mAnchor;
		}
		
		public function SetAnchor(ax: Number, ay: Number): void
		{
			mAnchor.x = ax;
			mAnchor.y = ay;
			
			var myMatrix:Matrix = new Matrix();
			myMatrix.translate(-mWidth * mAnchor.x, -mHeight * mAnchor.y);
			transform.matrix = myMatrix;
		}
		
		public function EnableUpdate(isEnable:Boolean): void
		{
			if(isEnable)
			{
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		public function IsUpdate(isEnable:Boolean): void
		{
			
		}
		
		public function EnableShow(isEnable:Boolean): void{}
		public function IsShow(): Boolean{ return false; }
		
		public function RealEnterFrameHandler(e:Event, elapseTime:int): void{}
		public function SetFrame(frameIndex:int): void{}
	}
	
}