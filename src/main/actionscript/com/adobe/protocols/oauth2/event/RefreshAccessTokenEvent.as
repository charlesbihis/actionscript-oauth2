package com.adobe.protocols.oauth2.event
{
	import flash.events.Event;

	public class RefreshAccessTokenEvent extends Event implements IOAuth2Event
	{
		public static const TYPE:String = "refreshAccessToken";
		
		private var _errorCode:String;
		private var _errorMessage:String;
		private var _accessToken:String;
		private var _tokenType:String;
		private var _expiresIn:int;
		private var _refreshToken:String;
		private var _scope:String;
		private var _state:String;
		private var _response:Object;
		
		public function RefreshAccessTokenEvent(bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(TYPE, bubbles, cancelable);
		}
		
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
		
		public override function clone():Event
		{
			return new GetAccessTokenEvent();
		}  // clone
		
		public function get errorCode():String
		{
			return _errorCode;
		}
		
		public function set errorCode(errorCode:String):void
		{
			_errorCode = errorCode;
		}
		
		public function get errorMessage():String
		{
			return _errorMessage;
		}
		
		public function set errorMessage(errorMessage:String):void
		{
			_errorMessage = errorMessage;
		}
		
		public function get accessToken():String
		{
			return _accessToken;
		}
		
		public function get tokenType():String
		{
			return _tokenType;
		}
		
		public function get expiresIn():int
		{
			return _expiresIn;
		}
		
		public function get refreshToken():String
		{
			return _refreshToken;
		}
		
		public function get scope():String
		{
			return _scope;
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function get response():Object
		{
			return _response;
		}
	}
}