package com.adobe.protocols.oauth2.grant
{
	public class ResourceOwnerCredentialsGrant implements IGrantType
	{
		private var _clientId:String;
		private var _clientSecret:String;
		private var _username:String;
		private var _password:String;
		private var _scope:String;
		
		public function ResourceOwnerCredentialsGrant(clientId:String, clientSecret:String, username:String, password:String, scope:String = null)
		{
			_clientId = clientId;
			_clientSecret = clientSecret;
			_username = username;
			_password = password;
			_scope = scope;
		}

		public function get clientId():String
		{
			return _clientId;
		}  // clientId
		
		public function get clientSecret():String
		{
			return _clientSecret;
		}  // clientSecret
		
		public function get username():String
		{
			return _username;
		}
		
		public function get password():String
		{
			return _password;
		}
		
		public function get scope():String
		{
			return _scope;
		}
	}
}