# -*- coding: utf-8 -*-
#
# Cookbook Name:: postgresql cookbook
# Definition:: database
#
# Create postgresql database
#
# :copyright: (c) 2013 by Alexandr Lispython (alex@obout.ru).
# :license: BSD, see LICENSE for more details.
# :github: http://github.com/Lispython/chef-postgresql
#

define :pg_database,
       :name => nil,
       :owner => nil,
       :locale => "en_US.UTF-8",
       :template => "template0",
       :encoding => "UTF-8",
       :host => nil,
       :port => nil,
       :execute => nil do

  port = params[:port]

  create_database_command = "sudo -u postgres createdb -h #{node[:postgresql][:data_run]} -p #{params[:port]} -E #{params[:encoding]} -O #{params[:owner]} " +
    "--locale #{params[:locale]} -T #{params[:template]} #{params[:name]}"

  Chef::Log.info("Creating database by command #{create_database_command}")

  bash "create_database-#{params[:name]}-#{params[:port]}" do
    user "root"
    code <<-EOH
        #{create_database_command}
    EOH
    not_if "sudo -u postgres psql -l -h #{node[:postgresql][:data_run]} -p #{params[:port]} | grep #{params[:name]}"
  end


  if params[:execute]

    execute_command = "echo '#{execute_command}' | sudo -u postgres psql -h #{node[:postgresql][:data_run]} -p #{params[:port]} #{params[:name]}"
    Chef::Log.info("Execute sql commands: #{execute_command}")

    bash "execute_custom_command-#{params[:name]}-#{params[:port]}" do
      user "root"
      code "#{execute_command}"
    end
  end
end
