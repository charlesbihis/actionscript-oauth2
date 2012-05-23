package com.adobe.protocols.oauth2.event
{
	import flash.events.Event;

	/**
	 * Event that is broadcast when results from a <code>getAccessToken</code>
	 * request are received.
	 * 
	 * @author Charles Bihis (www.whoischarles.com)
	 */
	public class GetAccessTokenEvent extends Event implements IOAuth2Event
	{
		/**
		 * Event type for this event which encapsulates the response from
		 * a <code>getAccessToken</code> request.
		 * 
		 * @eventType getAccessToken
		 */
		public static const TYPE:String = "getAccessToken";
		
		private var _errorCode:String;
		private var _errorMessage:String;
		private var _accessToken:String;
		private var _tokenType:String;
		private var _expiresIn:int;
		private var _refreshToken:String;
		private var _scope:String;
		private var _state:String;
		private var _response:Object;
		
		/**
		 * Constructor.
		 * 
		 * @param bubbles (Optional) Parameter indicating whether or not the event bubbles
		 * @param cancelable (Optional Parameter indicating whether or not the event is cancelable
		 */
		public function GetAccessTokenEvent(bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(TYPE, bubbles, cancelable);
		}  // GetAccessTokenEvent
		
		/**
		 * Convenience function that will take a <code>getAccessToken</code> response
		 * and parse its values.
		 * 
		 * @param response An object representing the response from a <code>getAccessToken</code> request
		 */
		public function parseAccessTokenResponse(response:Object):void
		{
			// required
			_accessToken = response.access_token;
			_tokenType = response.token_type;
			
			// optional
			_expiresIn = int(response.expires_in);
			_refreshToken = response.refresh_token;
			_scope = response.scope;
			_state = response.state;
			
			// extra
			_response = response;
		}
		
		/**
		 * Override of the clone function.
		 * 
		 * @return A new <code>GetAccessTokenEvent</code> object.
		 */
		public override function clone():Event
		{
			return new GetAccessTokenEvent();
		}  // clone
		
		/**
		 * Error code for error after a failed <code>getAccessToken</code> request.
		 */
		public function get errorCode():String
		{
			return _errorCode;
		}  // errorCode
		
		/**
		 * @private
		 */
		public function set errorCode(errorCode:String):void
		{
			_errorCode = errorCode;
		}  // errorCode
		
		/**
		 * Error message for error after a failed <code>getAccessToken</code> request.
		 */
		public function get errorMessage():String
		{
			return _errorMessage;
		}  // errorMessage
		
		/**
		 * @private
		 */
		public function set errorMessage(errorMessage:String):void
		{
			_errorMessage = errorMessage;
		}  // errorMessage
		
		/**
		 * The access token issues by the authorization server.
		 */
		public function get accessToken():String
		{
			return _accessToken;
		}  // accessToken

		/**
		 * The type of the token issued as described in the OAuth 2.0
		 * v2.15 specification, section 7.1, "Access Token Types".
		 * 
		 * @see http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-7.1
		 */
		public function get tokenType():String
		{
			return _tokenType;
		}  // tokenType
		
		/**
		 * The duration in seconds of the access token lifetime.  For example,
		 * the value "3600" denotes that the access token will expire one hour
		 * from the time the response was generated.
		 */
		public function get expiresIn():int
		{
			return _expiresIn;
		}  // expiresIn
		
		/**
		 * The refresh token which can be used ot obtain new access tokens using
		 * the same authorization grant as described in the OAuth 2.0
		 * v2.15 specification, section 6, "Refreshing an Access Token".
		 * 
		 * @see http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-6
		 */
		public function get refreshToken():String
		{
			return _refreshToken;
		}  // refreshToken
		
		/**
		 * The scope of the access request expressed as a list of space-delimited,
		 * case-sensitive strings.
		 */
		public function get scope():String
		{
			return _scope;
		}  // scope
		
		/**
		 * An opaque value used by the client to maintain state between the request
		 * and callback.
		 */
		public function get state():String
		{
			return _state;
		}  // state
		
		/**
		 * Response object to contain all returned response data after a successfull access token request.
		 */
		public function get response():Object
		{
			return _response;
		}  // response
	}  // class declaration
}  // package