require 'spec_helper'

# Test Tomcat
describe 'wrapper_dynatrace::install' do
  let(:chef_run) do 
    ChefSpec::Runner.new(platform:'centos', version:'6.5', :log_level => :error) do |node|
      ChefSpec::Server.create_environment('testing', { description: '...' })
      Chef::Config[:client_key] = "/etc/chef/client.pem"
      Chef::Config[:file_cache_path] = "/var/chef/cache"
      Chef::Resource::Execute.any_instance.stub(:should_skip?).and_return(false)

      allow(Chef::EncryptedDataBagItem).to receive(:load).with("aws", "s3_credentials").and_return(
        {
          "id" => "s3_credentials",
          "aws_access_key" => "BOGUS",
          "user" => "repowriter",
          "bucket" => "install_files",
          "aws_secret_key" => "BOGUS"
        }
      )
      node.override['wrapper_dynatrace']['version'] = "6.1.0"
      node.override['wrapper_dynatrace']['remote_filename'] = "dynatrace-agent-6.1.0.tgz"
      node.override['wrapper_dynatrace']['install_type'] = 'tomcat7'
      node.override['wrapper_dynatrace']['role_testnav8']['install'] = "true"
    end.converge(described_recipe)
  end

  it 'downloads some file from s3' do
    expect(chef_run).to create_s3_file('dynatrace-agent-6.1.0.tgz').with(bucket: "install_files", remote_path: "/dynatrace/dynatrace-agent-6.1.0.tgz")
  end

  it 'extracts dynatrace-agent-6.1.0.tgz' do
    expect(chef_run).to run_execute("extract dynatrace-agent-6.1.0.tgz")
  end

  it 'deletes dynatrace-agent-6.1.0.tgz' do
    expect(chef_run).to run_execute('remove dynatrace from /etc/default/tomcat7')
  end

end

# Test Jboss
describe 'wrapper_dynatrace::install' do
  let(:chef_run) do 
    ChefSpec::Runner.new(platform:'centos', version:'6.5', :log_level => :error) do |node|
      ChefSpec::Server.create_environment('testing', { description: '...' })
      Chef::Config[:client_key] = "/etc/chef/client.pem"
      Chef::Resource::Execute.any_instance.stub(:should_skip?).and_return(false)

      allow(Chef::EncryptedDataBagItem).to receive(:load).with("aws", "s3_credentials").and_return(
        {
          "id" => "s3_credentials",
          "aws_access_key" => "BOGUS",
          "user" => "repowriter",
          "bucket" => "install_files",
          "aws_secret_key" => "BOGUS"
        }
      )
      node.override['wrapper_dynatrace']['version'] = "6.1.0"
      node.override['wrapper_dynatrace']['remote_filename'] = "dynatrace-agent-6.1.0.tgz"
      node.override['wrapper_dynatrace']['install_type'] = 'jboss'
      node.override['wrapper_dynatrace']['role_testnav8']['install'] = "true"
    end.converge(described_recipe)
  end

  it 'downloads some file from s3' do
    expect(chef_run).to create_s3_file('dynatrace-agent-6.1.0.tgz').with(bucket: "install_files", remote_path: "/dynatrace/dynatrace-agent-6.1.0.tgz")
  end

  it 'extracts dynatrace-agent-6.1.0.tgz' do
    expect(chef_run).to run_execute("extract dynatrace-agent-6.1.0.tgz")
  end

  it 'deletes dynatrace-agent-6.1.0.tgz' do
    expect(chef_run).to run_execute('remove dynatrace from /usr/local/jboss/bin/standalone.conf')
  end
end