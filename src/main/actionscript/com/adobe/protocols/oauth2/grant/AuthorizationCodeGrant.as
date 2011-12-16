package com.adobe.protocols.oauth2.grant
{
	import flash.media.StageWebView;

	public class AuthorizationCodeGrant implements IGrantType
	{
		private var _stageWebView:StageWebView;
		private var _clientId:String;
		private var _clientSecret:String;
		private var _redirectUri:String;
		private var _scope:String;
		private var _state:Object;
		
		public function AuthorizationCodeGrant(stageWebView:StageWebView, clientId:String, clientSecret:String, redirectUri:String, scope:String = null, state:Object = null)
		{
			_stageWebView = stageWebView;
			_clientId = clientId;
			_clientSecret = clientSecret;
			_redirectUri = redirectUri;
			_scope = scope;
			_state = state;
		}  // AuthorizationCodeGrant
		
		public function get stageWebView():StageWebView
		{
			return _stageWebView;
		}  // stageWebView
		
		public function get clientId():String
		{
			return _clientId;
		}  // clientId
		
		public function get clientSecret():String
		{
			return _clientSecret;
		}  // clientSecret

		public function get redirectUri():String
		{
			return _redirectUri;
		}  // redirectUri
		
		public function get scope():String
		{
			return _scope;
		}  // scope
		
		public function get state():Object
		{
			return _state;
		}  // state
		
		public function getFullAuthUrl(authEndpoint:String):String
		{
			var url:String = authEndpoint + "?response_type=code&client_id=" + clientId + "&redirect_uri=" + redirectUri;
			
			// scope is optional
			if (scope != null && scope.length > 0)
			{
				url += "&scope=" + scope;
			}  // if statement
			
			// state is optional
			if (state != null)
			{
				url += "&state=" + state;
			}  // if statement
			
			return url;
		}  // getFullAuthUrl
	}  // class declaration
}  // package