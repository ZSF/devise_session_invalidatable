# Invalidate the session on logout (i.e. clear the current sign in timestamp and ip)
Warden::Manager.before_logout do |record, warden, options|
  record.invalidate_session! if record
end

# Check for a valid session when fetching the record from the session
Warden::Manager.after_set_user :only => :fetch do |record, warden, options|
  scope = options[:scope]
  if record && record.session_invalidated?
    warden.logout(scope)
    throw :warden, :scope => scope, :message => "Session no longer valid. Please sign in."
  end
end
