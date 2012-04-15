/*
 * Licensed under the MIT License
 * 
 * Copyright (c) 2008 Daisuke Yanagi
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
	/**
	 *	Useful Utility for parsing data 
	 * @author dai
	 * 
	 */	
	public class ParseUtils
	{
		public function ParseUtils()
		{
		}
		
		
		static public function valueFromXML(node:XML):*
		{
			var val:*;

			switch(node.name().toString())
			{
				case "array":
					val=new PArray(node);
					break;
				case "dict":
					val=new PDict(node);
					break;
				case "date":
					val=new PDate(node);
					break;
				case "string":
				case "data": 
					val=new PString(node);
					break;
				case "true": 
				case "false":
					val=new PBoolean(node);
					break;
				case "real":
				case "integer":
					val=new PNumber(node);

			}
			return val;
		}
	}
}