require 'spec_helper'

describe 'wrapper_dynatrace::default' do
  let(:chef_run) do 
    ChefSpec::Runner.new(platform:'centos', version:'6.5', :log_level => :error,:evaluate_guards => true) do |node|
      ChefSpec::Server.create_environment('testing', { description: '...' })
      Chef::Config[:client_key] = "/etc/chef/client.pem"
      Chef::Resource::Execute.any_instance.stub(:should_skip?).and_return(false)
      allow(Chef::EncryptedDataBagItem).to receive(:load_secret).with(anything).and_return("secret")
      allow(Chef::EncryptedDataBagItem).to receive(:load).with(any_args).and_return({})
      node.override['wrapper_dynatrace']['version'] = "6.1.0"
    end.converge "wrapper_dynatrace::default"
  end  
  before(:each){ File.stub(:exists?).and_call_original }
end
