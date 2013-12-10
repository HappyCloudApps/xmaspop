package com.myhappycloud.xpop.models
{
	/**
	 * @author Eder
	 */
	public interface IAppVars
	{
		function setState(splash : String) : void;

		function getState() : String;

		function setScore(score : uint) : void;

		function getScore() : uint;
	}
}
