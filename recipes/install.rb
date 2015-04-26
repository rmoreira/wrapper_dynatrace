package 'unzip'

install_type = node['wrapper_dynatrace']['install_type']

s3vals = Chef::EncryptedDataBagItem.load("aws", "s3_credentials")

source = ::File.join(Chef::Config[:file_cache_path],
                    node['wrapper_dynatrace']['remote_filename'])
remote_filename = node['wrapper_dynatrace']['remote_filename']

s3_file remote_filename do
  path source
  action :create
  not_if { ::File.exist?(source) }
  remote_path "#{node['wrapper_dynatrace']['s3_path']}/#{node['wrapper_dynatrace']['remote_filename']}"
  aws_access_key_id s3vals['aws_access_key']
  aws_secret_access_key s3vals['aws_secret_key']
  bucket s3vals['bucket']
end

execute "extract #{remote_filename}" do
  action :run
  cwd node['wrapper_dynatrace']['dest_path']
  command "tar -x -f #{source}"
  creates ::File.join(node['wrapper_dynatrace']['dest_path'],
                      node['wrapper_dynatrace']['remote_filename'].gsub('.tgz', '').gsub('.zip', ''),
                      'agent', 'lib64', node['wrapper_dynatrace']['agent_filename'])
end

str = "JAVA_OPTS=\"$JAVA_OPTS -agentpath:/usr/share/dynatrace-#{node['wrapper_dynatrace']['version']}/agent/lib64/libdtagent.so=name=#{node.name.match(/\w+\.\w+/)},server=#{node['wrapper_dynatrace']['server_ip']}\""
config_file = node['wrapper_dynatrace'][install_type]['config_file']

execute "remove dynatrace from #{config_file}" do
  command "sed -i '/dynatrace/d' #{config_file}" 
  action :run
  only_if { ::File.exist?(config_file) }
  not_if "grep 'dynatrace-#{node['wrapper_dynatrace']['version']}' #{config_file}"
end

service "#{install_type}" do
  action :nothing
end

ruby_block "update #{config_file}" do
  action :create
  only_if { ::File.exist?(config_file) }
  not_if "grep 'dynatrace-#{node['wrapper_dynatrace']['version']}' #{config_file}"
  block do
    open(config_file, "a") { |f|
      f.puts str
    }
  end
  notifies :restart, "service[#{install_type}]", :delayed
end
