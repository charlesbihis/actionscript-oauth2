package com.adobe.protocols.oauth2.event
{
	/**
	 * Interface describing generic OAuth 2.0 events.
	 * 
	 * @author Charles Bihis (www.whoischarles.com)
	 */
	public interface IOAuth2Event
	{
		function get errorCode():String;
		function set errorCode(errorCode:String):void;
		
		function get errorMessage():String;
		function set errorMessage(errorMessage:String):void;
	}  // interface declaration
}  // package