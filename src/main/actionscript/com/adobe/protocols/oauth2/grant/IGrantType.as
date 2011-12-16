package com.adobe.protocols.oauth2.grant
{
	public interface IGrantType
	{
		function get clientId():String;
		function get redirectUri():String;
	}  // interface declaration
}  // package