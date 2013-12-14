package com.ederdiaz.utils
{
	import flash.events.FocusEvent;
	import flash.text.TextField;

	/**
	 * @author Eder
	 */
	public class TextInput
	{
		private var txt:TextField;
		private var _defaultString:String;
		private var _defaultColor:uint = 0x000000;
		private var _selectedColor:uint = 0x000000;

		public function TextInput(txt:TextField, defaultString:String)
		{
			this.txt = txt;
			this._defaultString = defaultString;
			this._defaultColor = txt.textColor;

			setText(defaultString);

			txt.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			txt.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}

		private function onFocusIn(e:FocusEvent):void
		{
			if (txt.text == _defaultString)
			{
				setText("");
				setColor(_selectedColor);
			}
		}

		private function onFocusOut(e:FocusEvent):void
		{
			if (txt.text == "")
			{
				setText(_defaultString);
				setColor(_defaultColor);
			}
		}

		private function setColor(color:uint):void
		{
			txt.textColor = color;
		}

		private function setText(str:String):void
		{
			txt.text = str;
		}

		public function get defaultColor():uint
		{
			return _defaultColor;
		}

		public function set defaultColor(defaultColor:uint):void
		{
			_defaultColor = defaultColor;
			txt.textColor = defaultColor;
		}

		public function get selectedColor():uint
		{
			return _selectedColor;
		}

		public function set selectedColor(selectedColor:uint):void
		{
			_selectedColor = selectedColor;
		}

		public function isValid():Boolean
		{
			var resString:String = txt.text;
			resString = resString;

//			trace('resString: ' + (resString)+" | def: "+_defaultString);
			if (_defaultString == resString || resString == "")
			{
				return false;
			}
			return true;
		}

		private function trimWhitespace($string:String):String
		{
			if ($string == null)
			{
				return "";
			}
			return $string.replace(/^\s+|\s+$/g, "");
		}

		public function get text():String
		{
			return txt.text;
		}

		public function changeText(message:String):void
		{
			setText(message);
			setColor(_selectedColor);
		}

		public function resetText():void
		{
			setText(_defaultString);
			txt.textColor = defaultColor;
		}

	}
}
