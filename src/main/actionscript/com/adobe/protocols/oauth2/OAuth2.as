package com.adobe.protocols.oauth2
{
	import com.adobe.protocols.dict.events.ErrorEvent;
	import com.adobe.protocols.oauth2.event.GetAccessTokenEvent;
	import com.adobe.protocols.oauth2.grant.AuthorizationCodeGrant;
	import com.adobe.protocols.oauth2.grant.IGrantType;
	import com.adobe.protocols.oauth2.grant.ImplicitGrant;
	import com.adobe.serialization.json.JSONParseError;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.LocationChangeEvent;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.targets.TraceTarget;
	import mx.rpc.CallResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectUtil;

	public class OAuth2 extends EventDispatcher
	{
		private var grantType:IGrantType;
		private var authEndpoint:String;
		private var tokenEndpoint:String;
		private var log:ILogger;
		private var logTarget:TraceTarget;
		
		public function OAuth2(authEndpoint:String, tokenEndpoint:String, logLevel:int = -1)
		{
			// save endpoint properties
			this.authEndpoint = authEndpoint;
			this.tokenEndpoint = tokenEndpoint;
			
			// set up logging
			logTarget = new TraceTarget();
			logTarget.includeCategory = true;
			logTarget.includeDate = true;
			logTarget.includeLevel = true;
			logTarget.includeTime = true;
			logTarget.level = int.MAX_VALUE;
			Log.addTarget(logTarget);
			log = Log.getLogger("com.adobe.protocols.oauth2");
			
			// initialize logging if optional logging param was passed in
			if (logLevel >= 0)
			{
				setLogLevel(logLevel);
			}  // if statement
		} // OAuth2
		
		public function getAccessToken(grantType:IGrantType):void
		{
			if (grantType is AuthorizationCodeGrant)
			{
				getAccessTokenWithAuthorizationCodeGrant(grantType as AuthorizationCodeGrant);
			}
			else if (grantType is ImplicitGrant)
			{
				getAccessTokenWithImplicitGrant(grantType as ImplicitGrant);
			}
		}
		
		public function refreshAccessToken():void
		{
			
		}
		
		public function setLogLevel(logEventLevel:int):void
		{
			if (logEventLevel >= 0)
			{
				logTarget.level = logEventLevel;
			}  // if statement
		}  // setLogLevel
		
		private function getAccessTokenWithAuthorizationCodeGrant(authorizationCodeGrant:AuthorizationCodeGrant):void
		{
			// create result event
			var getAccessTokenEvent:GetAccessTokenEvent = new GetAccessTokenEvent();
			
			// add event listeners
			authorizationCodeGrant.stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChanging);
			authorizationCodeGrant.stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onLocationChanging);
			authorizationCodeGrant.stageWebView.addEventListener(Event.COMPLETE, onStageWebViewComplete);
			authorizationCodeGrant.stageWebView.addEventListener(ErrorEvent.ERROR, onStageWebViewError);
			
			// start the auth process
			var startTime:Number = new Date().time;
			log.info("Loading auth URL: " + authorizationCodeGrant.getFullAuthUrl(authEndpoint));
			authorizationCodeGrant.stageWebView.loadURL(authorizationCodeGrant.getFullAuthUrl(authEndpoint));
			
			function onLocationChanging(locationChangeEvent:LocationChangeEvent):void
			{
				log.info("Loading URL: " + locationChangeEvent.location);
				if (locationChangeEvent.location.indexOf(authorizationCodeGrant.redirectUri) == 0)
				{
					log.info("Redirect URI encountered (" + authorizationCodeGrant.redirectUri + ").  Extracting values from path.");
					
					// stop event from propogating
					locationChangeEvent.preventDefault();
					
					// determine if authorization was successful
					var queryParams:Object = extractQueryParams(locationChangeEvent.location);
					var code:String = queryParams.code;		// authorization code
					if (code != null)
					{
						log.debug("Authorization code: " + code);
						
						// set up HTTP-service call
						var httpService:HTTPService = new HTTPService();
						httpService.url = tokenEndpoint;
						httpService.method = "POST";
						httpService.contentType = "application/x-www-form-urlencoded";
						
						// set up parameters
						var args:Object = new Object();
						args.grant_type = "authorization_code";
						args.code = code;
						args.redirect_uri = authorizationCodeGrant.redirectUri;
						args.client_id = authorizationCodeGrant.clientId;
						args.client_secret = authorizationCodeGrant.clientSecret;
						
						// make the call
						log.debug("Sending access token request with the following values:\n" + ObjectUtil.toString(args));
						var getTokenResponder:CallResponder = new CallResponder();
						getTokenResponder.addEventListener(ResultEvent.RESULT, onGetAccessTokenResult);
						getTokenResponder.addEventListener(FaultEvent.FAULT, onGetAccessTokenFault);
						getTokenResponder.token = httpService.send(args);
					}  // if statement
					else
					{
						log.error("Error encountered during authorization request:\n" + ObjectUtil.toString(queryParams));
						getAccessTokenEvent.errorCode = queryParams.error;
						getAccessTokenEvent.errorMessage = queryParams.error_description;
						dispatchEvent(getAccessTokenEvent);
					}  // else statement
				}  // if statement
				
				function onGetAccessTokenResult(event:ResultEvent):void
				{
					try
					{
						var response:Object = com.adobe.serialization.json.JSON.decode(getTokenResponder.lastResult);
						log.debug("Access token response received with values:\n" + ObjectUtil.toString(response));
						getAccessTokenEvent.parseAccessTokenResponse(response);
					}  // try statement
					catch (error:JSONParseError)
					{
						getAccessTokenEvent.errorCode = "com.adobe.serialization.json.JSONParseError";
						getAccessTokenEvent.errorMessage = "Error parsing output from access token response: \"" + getTokenResponder.lastResult + "\"";
					}  // catch statement
					
					dispatchEvent(getAccessTokenEvent);
				}  // onGetAccessTokenResult
				
				function onGetAccessTokenFault(event:FaultEvent):void
				{
					log.error("Error encountered during access token request:\n" + ObjectUtil.toString(event.fault.content));
					
					try
					{
						var fault:Object = com.adobe.serialization.json.JSON.decode(event.fault.content as String);
						getAccessTokenEvent.errorCode = fault.error;
						getAccessTokenEvent.errorMessage = fault.error_description;
					}  // try statement
					catch (error:JSONParseError)
					{
						getAccessTokenEvent.errorCode = "Unknown";
						getAccessTokenEvent.errorMessage = "Error encountered during access token request.  Unable to parse fault message: \"" + event.fault.content + "\"";
					}  // catch statement
					
					dispatchEvent(getAccessTokenEvent);
				}  // onGetAccessTokenFault
			}  // onLocationChange
			
			function onStageWebViewComplete(event:Event):void
			{
				log.info("Auth URL loading complete after " + (new Date().time - startTime) + "ms");
			}  // onStageWebViewComplete
			
			function onStageWebViewError(event:ErrorEvent):void
			{
				log.error("Error occurred with StageWebView: " + ObjectUtil.toString(event));
				getAccessTokenEvent.errorCode = "STAGE_WEB_VIEW_ERROR";
				getAccessTokenEvent.errorMessage = "Error occurred with StageWebView";
				dispatchEvent(getAccessTokenEvent);
			}  // onStageWebViewError
		}  // getAccessTokenWithAuthorizationCodeGrant
		
		private function getAccessTokenWithImplicitGrant(implicitGrant:ImplicitGrant):void
		{
			// create result event
			var getAccessTokenEvent:GetAccessTokenEvent = new GetAccessTokenEvent();
			
			// add event listeners
			implicitGrant.stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange);
			implicitGrant.stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onLocationChange);
			implicitGrant.stageWebView.addEventListener(ErrorEvent.ERROR, onStageWebViewError);
			
			// start the auth process
			log.info("Loading auth URL: " + implicitGrant.getFullAuthUrl(authEndpoint));
			implicitGrant.stageWebView.loadURL(implicitGrant.getFullAuthUrl(authEndpoint));
			
			function onLocationChange(event:LocationChangeEvent):void
			{
				log.info("Loading URL: " + event.location);
				if (event.location.indexOf(implicitGrant.redirectUri) == 0)
				{
					log.info("Redirect URI encountered (" + implicitGrant.redirectUri + ").  Extracting values from path.");
					
					// stop event from propogating
					event.preventDefault();
					
					// determine if authorization was successful
					var queryParams:Object = extractQueryParams(event.location);
					var accessToken:String = queryParams.access_token;
					if (accessToken != null)
					{
						log.debug("Access token: " + accessToken);
						getAccessTokenEvent.parseAccessTokenResponse(queryParams);
						dispatchEvent(getAccessTokenEvent);
					}  // if statement
					else
					{
						log.error("Error encountered during access token request:\n" + ObjectUtil.toString(queryParams));
						getAccessTokenEvent.errorCode = queryParams.error;
						getAccessTokenEvent.errorMessage = queryParams.error_description;
						dispatchEvent(getAccessTokenEvent);
					}  // else statement
				}  // if statement
			}  // onLocationChange
			
			function onStageWebViewError(event:ErrorEvent):void
			{
				log.error("Error occurred with StageWebView: " + ObjectUtil.toString(event));
				getAccessTokenEvent.errorCode = "STAGE_WEB_VIEW_ERROR";
				getAccessTokenEvent.errorMessage = "Error occurred with StageWebView";
				dispatchEvent(getAccessTokenEvent);
			}  // onStageWebViewError
		}  // getAccessTokenWithImplicitGrant
		
		private function extractQueryParams(url:String):Object
		{
			var delimiter:String = (url.indexOf("?") > 0) ? "?" : "#";
			var queryParamsString:String = url.split(delimiter)[1];
			var queryParamsArray:Array = queryParamsString.split("&");
			var queryParams:Object = new Object();
			
			for each (var queryParam:String in queryParamsArray)
			{
				var keyValue:Array = queryParam.split("=");
				queryParams[keyValue[0]] = keyValue[1];	
			}  // for loop
			
			return queryParams;
		}  // extractQueryParams
	}  // class declaration
}  // package