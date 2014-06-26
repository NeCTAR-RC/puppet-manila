require 'spec_helper'

describe 'manila::backend::vmdk' do

  let(:title) { 'hippo' }

  let :params do
    {
        :host_ip => '172.16.16.16',
        :host_password => 'asdf',
        :host_username => 'user'
    }
  end

  let :optional_params do
    {
        :share_folder => 'manila-share-folder',
        :api_retry_count => 5,
        :max_object_retrieval => 200,
        :task_poll_interval => 10,
        :image_transfer_timeout_secs => 3600,
        :wsdl_location => 'http://127.0.0.1:8080/vmware/SDK/wsdl/vim25/vimService.wsdl'
    }
  end

  it 'should configure vmdk driver in manila.conf' do
    should contain_manila_config('hippo/share_backend_name').with_value('hippo')
    should contain_manila_config('hippo/share_driver').with_value('manila.share.drivers.vmware.vmdk.VMwareVcVmdkDriver')
    should contain_manila_config('hippo/vmware_host_ip').with_value(params[:host_ip])
    should contain_manila_config('hippo/vmware_host_username').with_value(params[:host_username])
    should contain_manila_config('hippo/vmware_host_password').with_value(params[:host_password])
    should contain_manila_config('hippo/vmware_share_folder').with_value('manila-shares')
    should contain_manila_config('hippo/vmware_api_retry_count').with_value(10)
    should contain_manila_config('hippo/vmware_max_object_retrieval').with_value(100)
    should contain_manila_config('hippo/vmware_task_poll_interval').with_value(5)
    should contain_manila_config('hippo/vmware_image_transfer_timeout_secs').with_value(7200)
    should_not contain_manila_config('hippo/vmware_wsdl_location')
  end

  it 'installs suds python package' do
    should contain_package('python-suds').with(
               :ensure => 'present')
  end

  context 'with optional parameters' do
    before :each do
      params.merge!(optional_params)
    end

    it 'should configure vmdk driver in manila.conf' do
      should contain_manila_config('hippo/vmware_share_folder').with_value(params[:share_folder])
      should contain_manila_config('hippo/vmware_api_retry_count').with_value(params[:api_retry_count])
      should contain_manila_config('hippo/vmware_max_object_retrieval').with_value(params[:max_object_retrieval])
      should contain_manila_config('hippo/vmware_task_poll_interval').with_value(params[:task_poll_interval])
      should contain_manila_config('hippo/vmware_image_transfer_timeout_secs').with_value(params[:image_transfer_timeout_secs])
      should contain_manila_config('hippo/vmware_wsdl_location').with_value(params[:wsdl_location])
    end
  end
end
