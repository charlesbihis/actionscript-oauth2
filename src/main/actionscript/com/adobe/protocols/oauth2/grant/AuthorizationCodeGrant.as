package com.adobe.protocols.oauth2.grant
{
	import flash.media.StageWebView;

	/**
	 * Class to encapsulate all of the relevant properties used during
	 * a get-access-token request using the authorization code grant type.
	 * 
	 * @author Charles Bihis (www.whoischarles.com)
	 */
	public class AuthorizationCodeGrant implements IGrantType
	{
		private var _stageWebView:StageWebView;
		private var _clientId:String;
		private var _clientSecret:String;
		private var _redirectUri:String;
		private var _scope:String;
		private var _state:Object;
		private var _queryParams:Object;
		
		/**
		 * Constructor.
		 * 
		 * @param stageWebView The <code>StageWebView</code> object for which to display the user-consent page
		 * @param clientId The client identifier
		 * @param clientSecret The client secret
		 * @param redirectUri The redirect URI to return to after the authorization process has completed
		 * @param scope (Optional) The scope of the access request expressed as a list of space-delimited, case-sensitive strings
		 * @param state (Optional) An opaque value used by the client to maintain state between the request and callback
		 * @param queryParams (Optional) Additional query parameters that can be passed to the authorization URL
		 */
		public function AuthorizationCodeGrant(stageWebView:StageWebView, clientId:String, clientSecret:String, redirectUri:String, scope:String = null, state:Object = null, queryParams:Object = null)
		{
			_stageWebView = stageWebView;
			_clientId = clientId;
			_clientSecret = clientSecret;
			_redirectUri = redirectUri;
			_scope = scope;
			_state = state;
			_queryParams = queryParams;
		}  // AuthorizationCodeGrant
		
		/**
		 * The <code>StageWebView</code> object for which to display the user-consent page.
		 */
		public function get stageWebView():StageWebView
		{
			return _stageWebView;
		}  // stageWebView
		
		/**
		 * The client identifier as described in the OAuth spec v2.15,
		 * section 3, Client Authentication.
		 * 
		 * @see http://tools.ietf.org/html/draft-ietf-oauth-v2-15#section-3
		 */
		public function get clientId():String
		{
			return _clientId;
		}  // clientId
		
		/**
		 * The client secret.
		 */
		public function get clientSecret():String
		{
			return _clientSecret;
		}  // clientSecret

		/**
		 * The redirect endpoint for the client as described in the OAuth
		 * spec v2.15, section 3.1.2, Redirection Endpoint.
		 * 
		 * @see http://tools.ietf.org/html/draft-ietf-oauth-v2-20#section-3.1.2
		 */
		public function get redirectUri():String
		{
			return _redirectUri;
		}  // redirectUri
		
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
		public function get state():Object
		{
			return _state;
		}  // state
		
		/**
		 * Additional query parameters that can be passed to the authorization URL.
		 */
		public function get queryParams():Object
		{
			return _queryParams;
		}  // queryParams
		
		/**
		 * Convenience method for getting the full authorization URL.
		 */
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
			
			// add additional optional query params, if any
			if (queryParams != null)
			{
				for (var queryParam:String in queryParams)
				{
					url += "&" + queryParam + "=" + queryParams[queryParam];
				}  // for loop
			}  // if statement
			
			return url;
		}  // getFullAuthUrl
	}  // class declaration
}  // package