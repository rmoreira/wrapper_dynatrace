install_type = node['wrapper_dynatrace']['install_type'] 
config_file = node['wrapper_dynatrace'][install_type]['config_file']

service "#{install_type}" do
  action :nothing
end

execute "Remove Dynatrace from #{config_file}" do
  command "sed -i '/dynatrace/d' #{config_file}" 
  action :run
  only_if { ::File.exist?(config_file) }
  notifies :restart, "service[#{install_type}]", :delayed
end