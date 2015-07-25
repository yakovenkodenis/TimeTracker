def drop_schemas
  connection = ActiveRecord::Base.connection.raw_connection
  schemas = connection.query(%{
    SELECT string_agg(format('DROP SCHEMA %I CASCADE;', nspname), E'\n')
    FROM   pg_namespace WHERE nspname != 'public'
    AND nspname NOT LIKE 'pg_%'
    AND nspname != 'information_schema';
  })
  # %{
  #  CREATE OR REPLACE FUNCTION drop_all () 
  #  RETURNS VOID  AS
  #  $$
  #  DECLARE rec RECORD; 
  #  BEGIN
  #      -- Get all the schemas
  #       FOR rec IN
  #       SELECT DISTINCT schemaname
  #        FROM pg_catalog.pg_tables
  #        -- You can exclude the schema which you don't want to drop by adding another condition here
  #        WHERE schemaname NOT LIKE 'pg_%' AND schemaname != 'public' 
  #        AND schemaname != 'information_schema'
  #          LOOP
  #            EXECUTE 'DROP SCHEMA ' || rec.schemaname || ' CASCADE'; 
  #          END LOOP; 
  #          RETURN; 
  #  END;
  #  $$ LANGUAGE plpgsql;
 
  #  SELECT drop_all();
  # }
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
