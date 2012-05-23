package com.adobe.protocols.oauth2.grant
{
	/**
	 * Class to encapsulate all of the relevant properties used during
	 * a get-access-token request using the resource owner password
	 * credentials grant type.
	 * 
	 * @author Charles Bihis (www.hoischarles.com)
	 */
	public class ResourceOwnerCredentialsGrant implements IGrantType
	{
		private var _clientId:String;
		private var _clientSecret:String;
		private var _username:String;
		private var _password:String;
		private var _scope:String;
		
		/**
		 * Constructor.
		 * 
		 * @param clientId The client identifier
		 * @param clientSecret The client secret
		 * @param username The resource owner's username for the authorization server
		 * @param password The resource owner's password for the authorization server
		 * @param scope (Optional) The scope of the access request expressed as a list of space-delimited, case-sensitive strings
		 */
		public function ResourceOwnerCredentialsGrant(clientId:String, clientSecret:String, username:String, password:String, scope:String = null)
		{
			_clientId = clientId;
			_clientSecret = clientSecret;
			_username = username;
			_password = password;
			_scope = scope;
		}  // ResourceOwnserCredentialsGrant

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
		 * The resource owners username.
		 */
		public function get username():String
		{
			return _username;
		}  // username
		
		/**
		 * The resource owner password.
		 */
		public function get password():String
		{
			return _password;
		}  // password
		
		/**
		 * The scope of the access request expressed as a list of space-delimited,
		 * case-sensitive strings.
		 */
		public function get scope():String
		{
			return _scope;
		}  // scope
	}  // class declaration
}  // package