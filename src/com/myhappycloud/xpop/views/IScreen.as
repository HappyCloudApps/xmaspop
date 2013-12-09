package com.myhappycloud.xpop.views
{
	import org.osflash.signals.Signal;

	import flash.display.MovieClip;

	/**
	 * @author Eder
	 */
	public interface IScreen
	{
		function get mc() : MovieClip;

		function close() : void;

		function open() : void;

		function get closeSignal() : Signal
	}
}
