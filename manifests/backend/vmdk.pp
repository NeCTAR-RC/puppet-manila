# == define: manila::backend::vmdk
#
# Configure the VMware VMDK driver for manila.
#
# === Parameters
#
# [*host_ip*]
#   The IP address of the VMware vCenter server.
#
# [*host_username*]
#   The username for connection to VMware vCenter server.
#
# [*host_password*]
#   The password for connection to VMware vCenter server.
#
# [*share_backend_name*]
#   Used to set the share_backend_name in multiple backends.
#   Defaults to $name as passed in the title.
#
# [*api_retry_count*]
#   (optional) The number of times we retry on failures,
#   e.g., socket error, etc.
#   Defaults to 10.
#
# [*$max_object_retrieval*]
#   (optional) The maximum number of ObjectContent data objects that should
#   be returned in a single result. A positive value will cause
#   the operation to suspend the retrieval when the count of
#   objects reaches the specified maximum. The server may still
#   limit the count to something less than the configured value.
#   Any remaining objects may be retrieved with additional requests.
#   Defaults to 100.
#
# [*task_poll_interval*]
#   (optional) The interval in seconds used for polling of remote tasks.
#   Defaults to 5.
#
# [*image_transfer_timeout_secs*]
#   (optional) The timeout in seconds for VMDK share transfer between Manila and Glance.
#   Defaults to 7200.
#
# [*wsdl_location*]
#   (optional) VIM Service WSDL Location e.g
#   http://<server>/vimService.wsdl. Optional over-ride to
#   default location for bug work-arounds.
#   Defaults to None.
#
# [*share_folder*]
#   (optional) The name for the folder in the VC datacenter that will contain manila shares.
#   Defaults to 'manila-shares'.
#
define manila::backend::vmdk (
  $host_ip,
  $host_username,
  $host_password,
  $share_backend_name         = $name,
  $share_folder               = 'manila-shares',
  $api_retry_count             = 10,
  $max_object_retrieval        = 100,
  $task_poll_interval          = 5,
  $image_transfer_timeout_secs = 7200,
  $wsdl_location               = undef
  ) {

  manila_config {
    "${name}/share_backend_name":                value => $share_backend_name;
    "${name}/share_driver":                      value => 'manila.share.drivers.vmware.vmdk.VMwareVcVmdkDriver';
    "${name}/vmware_host_ip":                     value => $host_ip;
    "${name}/vmware_host_username":               value => $host_username;
    "${name}/vmware_host_password":               value => $host_password;
    "${name}/vmware_share_folder":               value => $share_folder;
    "${name}/vmware_api_retry_count":             value => $api_retry_count;
    "${name}/vmware_max_object_retrieval":        value => $max_object_retrieval;
    "${name}/vmware_task_poll_interval":          value => $task_poll_interval;
    "${name}/vmware_image_transfer_timeout_secs": value => $image_transfer_timeout_secs;
  }

  if $wsdl_location {
    manila_config {
      "${name}/vmware_wsdl_location":               value => $wsdl_location;
    }
  }

  package { 'python-suds':
    ensure   => present
  }
}
