# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_r2flickr-test_session',
  :secret      => 'a845c8e79430715c7680c2f8719788ddea0c6957d9c5e83dc1b9c4233927b5f207216fe8bb7dce5c2473bb840e06eced8b40a7669935245f9690e182f34d5aac'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
