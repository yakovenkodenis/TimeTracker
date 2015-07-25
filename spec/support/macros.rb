def drop_schemas
  connection = ActiveRecord::Base.connection.raw_connection
  schemas = connection.query(%{
    SELECT n.nspname AS "Name",
      pg_catalog.pg_get_userbyid(n.nspowner) AS "Owner"
    FROM pg_catalog.pg_namespace n
    WHERE n.nspname !~ '^pg_'
    AND n.nspname <> 'information_schema'
    AND n.nspname != 'public';
  })
  schemas.each do |query|
    connection.query(query.values.first)
  end
end

def sign_user_in(user, opts = {})
  if opts[:subdomain]
    visit new_user_session_url(subdomain: opts[:subdomain])
  else
    visit new_user_session_path
  end
  fill_in 'Email', with: user.email
  fill_in 'Password', with: (opts[:password] || user.password)
  click_button 'Log in'
end

def set_subdomain(subdomain)
  Capybara.app_host = "http://#{subdomain}.example.com"
end
