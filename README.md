# ActionScript OAuth 2.0 Library

An ActionScript 3 library for interfacing with OAuth 2.0 services, implemented according to the [OAuth 2.0 v2.15 specification](http://tools.ietf.org/html/draft-ietf-oauth-v2-15).

## Overview

This library is built for use with Flash/Flex/AIR projects to facilitate communication with OAuth 2.0 services.  It provides mechanisms to authenticate against OAuth 2.0 servers using all standard authentication and authorization workflows.

### Features

The ActionScript OAuth 2.0 Library supports the following features...

* Ability to [fetch an access token](http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-4) via the OAuth 2.0 supported workflows...
  * [Authorization Code Grant workflow](http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-4.1)
  * [Implicit Grant workflow](http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-4.2)
  * [Resource Owner Password Credentials workflow](http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-4.3)
* Ability to [refresh an access token](http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-6)
* Robust and adjustable logging
* Ability to log in, view, and interact with the user consent page within a given StageWebView object 

### Dependencies
* [as3corelib](https://github.com/mikechambers/as3corelib)
* [as3commons-logging](http://code.google.com/p/as3-commons/)

## Documentation

### Usage

To use the library, simply drop in the SWC (or the source) into your project, along with the appropriate dependencies, and follow the usage below...

	// set up our StageWebView object to use our visible stage
	stageWebView.stage = stage;
	 
	// set up the call
	var oauth2:OAuth2 = new OAuth2("https://accounts.google.com/o/oauth2/auth", "https://accounts.google.com/o/oauth2/token", LogSetupLevel.ALL);
	var grant:IGrantType = new AuthorizationCodeGrant(stageWebView,						// the StageWebView object for which to display the user consent screen
													  "INSERT_CLIENT_ID_HERE",			// your client ID
													  "INSERT_CLIENT_SECRET_HERE",		// your client secret
													  "INSERT_REDIRECT_URI_HERE",		// your redirect URI
													  "INSERT_SCOPE_HERE",				// (optional) your scope
													  "INSERT_STATE_HERE");				// (optional) your state
	 
	// make the call
	oauth2.addEventListener(GetAccessTokenEvent.TYPE, onGetAccessToken);
	oauth2.getAccessToken(grant);
	 
	function onGetAccessToken(getAccessTokenEvent:GetAccessTokenEvent):void
	{
		if (getAccessTokenEvent.errorCode == null && getAccessTokenEvent.errorMessage == null)
		{
			// success!
			trace("Your access token value is: " + getAccessTokenEvent.accessToken);
		}
		else
		{
			// fail :(
		}
	}  // onGetAccessToken

### Reference

You can find the full ASDocs for the project [here](http://charlesbihis.github.com/actionscript-notification-engine/docs/).

## Author

* Created by Charles Bihis
* Website: [www.whoischarles.com](http://www.whoischarles.com)
* E-mail: [charles@whoischarles.com](mailto:charles@whoischarles.com)
* Twitter: [@charlesbihis](http://www.twitter.com/charlesbihis)

## License

The ActionScript Notification Engine (a.k.a. Project M6D Magnum Sidearm) is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).