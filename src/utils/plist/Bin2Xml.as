/*
 * Licensed under the MIT License
 * 
 * Copyright (c) 2010 Daisuke Yanagi
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
 */
package utils.plist
{	
	import flash.utils.*;
	import flash.errors.*;
	import com.hurlant.util.Hex;
	
	public class Bin2Xml extends Object
	{
		static private var _instance:Bin2Xml;
		
		private var _offsets:Array;
		private var _countObjects:int;
		private var _objectRefSize:int;

		public function Bin2Xml()
		{
			super();
			
			_offsets=[];
		}
		
		static public function getXML(data:ByteArray):XML
		{
			if(!_instance)
			{
				_instance=new Bin2Xml();
			}
			return _instance.read(data);
		}
		
		private function read(data:ByteArray):XML
		{
			data.endian=Endian.BIG_ENDIAN;
			data.position=0;
			
			var xml:XML=<plist></plist>
			xml.@version="1.0";
			
			var bpli:int=data.readInt();
			var st00:int=data.readInt();
			var offsetSize:int;
			var objectRefSize:int;
			var numberOfObjects:int;
			var topObject:int;
			var tableOffset:int;
			var codedOffsetTable:ByteArray;
			var offset:int;
			
			if(bpli!=0x62706c69 || st00!=0x73743030)
			{
				throw Error("Definition Error.");
			}
			
			data.position=data.length-32;
			
			try
			{
				data.position=data.position+6;
				offsetSize=data.readByte();
				objectRefSize=data.readByte();
				_objectRefSize=objectRefSize;
				
				data.position=data.position+4;
				numberOfObjects=data.readInt();
				_countObjects=numberOfObjects;
				
				data.position=data.position+4;
				topObject=data.readInt();
				
				data.position=data.position+4;
				tableOffset=data.readInt();
				
				codedOffsetTable=new ByteArray();
				data.position=tableOffset;
				data.readBytes(codedOffsetTable,0,numberOfObjects*offsetSize);
			
			}
			catch(e:Error)
			{
				
			}	
			
			codedOffsetTable.position=0;
			//decode offset table
			for (var i:int = 0; i < codedOffsetTable.length; i++)
			{
				
				offset=codedOffsetTable.readUnsignedByte();
				_offsets.push(offset);
			}
			
			xml.appendChild(parseAt(data,topObject));
			
			return xml;
			
		}
		
		private function parseAt(data:ByteArray, pos:int):*
		{
			data.position=_offsets[pos];
			
			return parse(data);
		}
		
		private function parse(data:ByteArray):*
		{
			var marker:int;
			var objectType:int;
			var len:int;
			var retval:*;
			
			marker=data.readByte();
			len =  (marker & 0xf);
			objectType=(marker&0xf0)>>4;
			if(objectType!=0x0&&len==15)
			{
				len=count(data);
			}
			
			switch(objectType)
			{
				case 0x0:
					retval = readPrimitive(data,len);
					break;
				case 0x1:
					retval = readInt(data,len);
					break;
				case 0x2:
					retval = readReal(data,len);
					break;
				case 0x3:
					retval = readDate(data,len);
					break;
				case 0x4:
					retval = readRAW(data,len);
					break;
				case 0x5:
					retval = readUTF(data,len);
					break;
				case 0x6:
					retval = readASCII(data,len);
					break;
				case 0xa:
					retval = readArr(data,len);
					break;
				case 0xd:
					retval = readDic(data, len);
					break;
				
			}
			////Debug.trace(XML(retval).toXMLString(), //Debug.LEVEL_FATAL);
			return retval;
		}
		
		private function readPrimitive(data:ByteArray, len:int):*
		{
			switch(len)
			{
				case 0:
				return 0;
				
				case 8:
				return <false/>;
				
				case 9:
				return <true/>;
				
				case 15:
				return 15;
				
				default:
				return null; 
			}
		}
		
		private function readInt(data:ByteArray, len:int):*
		{
			var retval:*;
			
			if(len>8)
			{
				//error
				return;
			}
			
			
			switch(len)
			{
				case 0://8bit
					retval = data.readByte();
					break;
				
				case 1://16bit
					retval =  data.readShort();
					break;
				
				case 2://32bit
					retval=  data.readInt();
					break;
				
				case 3://64bit for minus numbers
					var h:int=data.readInt();
					var l:int=data.readInt();
					retval=  ((h*4294967296+l)<<32);
					break;
			}
			
			return <integer>{retval}</integer>;
		}
		
		private function readReal(data:ByteArray, len:int):*
		{
			var retval:*;
			
			switch(len)
			{
				case 2://32bit
					retval = data.readFloat();
					
					break;
		
				case 3://64bit
					retval = data.readDouble();
					
					break;
			}
			return <real>{retval}</real>;
		}
		
		private function readDate(data:ByteArray, len:int):*
		{
			var n:Number;
			
			switch(len)
			{
				case 2:
				n=data.readFloat();
				break;
				
				case 3:
				n=data.readDouble();
				break;
			}
			var date:Date=new Date((n+978307200)*1000);
			var tag:XML=<date>{formatDate(date.getUTCFullYear())}-{formatDate(date.getUTCMonth()+1)}-{formatDate(date.getUTCDate())}T{formatDate(date.getUTCHours())}:{formatDate(date.getUTCMinutes())}:{formatDate(date.getUTCSeconds())}Z</date>;
			
			return tag;
		}
		
		private function readRAW(data:ByteArray, len:int):*
		{
			var dat:ByteArray=new ByteArray();
			data.readBytes(dat, 0, len);
			return <data>{dat}</data>;
		}
		
		private function readUTF(data:ByteArray, len:int):*
		{
			var str:String=data.readUTFBytes(len);
			return <string>{str}</string>;
		}
		
		private function readASCII(data:ByteArray, len:int):*
		{
			var buf:ByteArray=new ByteArray();
			data.readBytes(buf, 0, len);
			var str:String = Hex.fromArray(buf);
			return <string>{str}</string>;
		}
		
		private function readArr(data:ByteArray, len:int):*
		{
			
			
			var retval:XML=<array></array>
			var arr:Array=[];
			var buf:ByteArray;
			var obj:*;
			var objects:Array=[];
			var i:int;
			
			if(len==0)
			{
				
				return retval;
			}
			
			buf=new ByteArray();
			data.readBytes(buf,0,_objectRefSize*len);
			
			for (i = 0; i < len; i++)
			{
				objects.push(buf.readByte());
			}
			
			for (i = 0; i < len; i++)
			{
				
				obj=parseAt(data,objects[i]);
				arr.push(obj);
				retval.appendChild(obj);
				
			}
			
			return retval;
		}
		
		private function readDic(data:ByteArray, len:int):*
		{
			
			var retval:XML=<dict></dict>
			var dic:Object=new Object();
			var buf:ByteArray;
			var keys:Array=[];
			var key:*;
			var obj:*;
			var objects:Array=[];
			var i:int;
			
			if(len==0)
			{
				return null;
			}
			
			//key
			buf=new ByteArray();
			data.readBytes(buf,0,_objectRefSize*len);
			
			for (i = 0; i < len; i++)
			{
				keys.push(buf.readByte());
			}
			
			//value
			buf=new ByteArray();
			data.readBytes(buf,0,_objectRefSize*len);
			
			for (i = 0; i < len; i++)
			{
				objects.push(buf.readByte());
			}
			
			//k/v pear
			for (i = 0; i < len; i++)
			{
				key=parseAt(data,keys[i]);
				
				obj=parseAt(data,objects[i]);
				dic[key]=obj;
				retval.appendChild(<key>{key.toString()}</key>);
				retval.appendChild(obj);
				
			}
			
			
			return retval;
			
			
		}
		
		private function count(data:ByteArray):int
		{
			var marker:int;
			var count:int;
			var b:int;
			var i:int;
			var value:int;
			
			try
			{
				marker = data.readByte();
				
				if (((marker & 0xf0) >> 4) != 1) 
				{
		            throw new Error("Illegal marker.")
		        }
		        count = 1 << (marker & 0xf);
		        value = 0;
		        for (i=0; i < count; i++) 
				{
		            b = data.readByte();
		            if (b == -1) 
					{
		                throw new Error("Illegal EOF.")
		            }
		            value = (value << 8) | b;
		        }
		    
			}
			catch(e:Error)
			{
				//EOF
				return -1;
			}
	        
			return value;
	        
		}
		
		private function formatDate(n:Number):String
		{
			if(n<10)
			{
				return "0"+n.toString();
			}
			return n.toString();
		}

	}
}