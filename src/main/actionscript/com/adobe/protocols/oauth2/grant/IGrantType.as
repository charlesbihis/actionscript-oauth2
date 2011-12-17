package com.adobe.protocols.oauth2.grant
{
	/**
	 * Interface used as a marker to signify whether a class
	 * encapsulates the properties of any of the supported
	 * OAuth 2.0 grant types, as described by the v2.15
	 * specification.
	 * 
	 * @see http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-4
	 * 
	 * @author Charles Bihis (charles@whoischarles.com)
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10
	 */
	public interface IGrantType
	{
		function get clientId():String;
	}  // interface declaration
}  // package