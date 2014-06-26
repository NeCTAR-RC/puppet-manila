# == define: manila::backend::netapp
#
# Configures Manila to use the NetApp unified share driver
# Compatible for multiple backends
#
# === Parameters
#
# [*netapp_login*]
#   (required) Administrative user account name used to access the storage
#   system or proxy server.
#
# [*netapp_password*]
#   (required) Password for the administrative user account specified in the
#   netapp_login parameter.
#
# [*netapp_server_hostname*]
#   (required) The hostname (or IP address) for the storage system or proxy
#   server.
#
# [*netapp_server_port*]
#   (optional) The TCP port to use for communication with ONTAPI on the
#   storage system. Traditionally, port 80 is used for HTTP and port 443 is
#   used for HTTPS; however, this value should be changed if an alternate
#   port has been configured on the storage system or proxy server.
#   Defaults to 80
#
# [*netapp_size_multiplier*]
#   (optional) The quantity to be multiplied by the requested share size to
#   ensure enough space is available on the virtual storage server (Vserver) to
#   fulfill the share creation request.
#   Defaults to 1.2
#
# [*netapp_storage_family*]
#   (optional) The storage family type used on the storage system; valid values
#   are ontap_7mode for using Data ONTAP operating in 7-Mode or ontap_cluster
#   for using clustered Data ONTAP, or eseries for NetApp E-Series.
#   Defaults to ontap_cluster
#
# [*netapp_storage_protocol*]
#   (optional) The storage protocol to be used on the data path with the storage
#   system; valid values are iscsi or nfs.
#   Defaults to nfs
#
# [*netapp_transport_type*]
#   (optional) The transport protocol used when communicating with ONTAPI on the
#   storage system or proxy server. Valid values are http or https.
#   Defaults to http
#
# [*netapp_vfiler*]
#   (optional) The vFiler unit on which provisioning of block storage shares
#   will be done. This parameter is only used by the driver when connecting to
#   an instance with a storage family of Data ONTAP operating in 7-Mode and the
#   storage protocol selected is iSCSI. Only use this parameter when utilizing
#   the MultiStore feature on the NetApp storage system.
#   Defaults to ''
#
# [*netapp_share_list*]
#   (optional) This parameter is only utilized when the storage protocol is
#   configured to use iSCSI. This parameter is used to restrict provisioning to
#   the specified controller shares. Specify the value of this parameter to be
#   a comma separated list of NetApp controller share names to be used for
#   provisioning.
#   Defaults to ''
#
# [*netapp_vserver*]
#   (optional) This parameter specifies the virtual storage server (Vserver)
#   name on the storage cluster on which provisioning of block storage shares
#   should occur. If using the NFS storage protocol, this parameter is mandatory
#   for storage service catalog support (utilized by Manila share type
#   extra_specs support). If this parameter is specified, the exports belonging
#   to the Vserver will only be used for provisioning in the future. Block
#   storage shares on exports not belonging to the Vserver specified by
#   this parameter will continue to function normally.
#   Defaults to ''
#
# [*expiry_thres_minutes*]
#   (optional) This parameter specifies the threshold for last access time for
#   images in the NFS image cache. When a cache cleaning cycle begins, images
#   in the cache that have not been accessed in the last M minutes, where M is
#   the value of this parameter, will be deleted from the cache to create free
#   space on the NFS share.
#   Defaults to 720
#
# [*thres_avl_size_perc_start*]
#   (optional) If the percentage of available space for an NFS share has
#   dropped below the value specified by this parameter, the NFS image cache
#   will be cleaned.
#   Defaults to 20
#
# [*thres_avl_size_perc_stop*]
#   (optional) When the percentage of available space on an NFS share has
#   reached the percentage specified by this parameter, the driver will stop
#   clearing files from the NFS image cache that have not been accessed in the
#   last M minutes, where M is the value of the expiry_thres_minutes parameter.
#   Defaults to 60
#
# [*nfs_shares_config*]
#   (optional) File with the list of available NFS shares
#   Defaults to ''
#
# [*netapp_copyoffload_tool_path*]
#   (optional) This option specifies the path of the NetApp Copy Offload tool
#   binary. Ensure that the binary has execute permissions set which allow the
#   effective user of the manila-share process to execute the file.
#   Defaults to ''
#
# [*netapp_controller_ips*]
#   (optional) This option is only utilized when the storage family is
#   configured to eseries. This option is used to restrict provisioning to the
#   specified controllers. Specify the value of this option to be a comma
#   separated list of controller hostnames or IP addresses to be used for
#   provisioning.
#   Defaults to ''
#
# [*netapp_sa_password*]
#   (optional) Password for the NetApp E-Series storage array.
#   Defaults to ''
#
# [*netapp_storage_pools*]
#   (optional) This option is used to restrict provisioning to the specified
#   storage pools. Only dynamic disk pools are currently supported. Specify the
#   value of this option to be a comma separated list of disk pool names to be
#   used for provisioning.
#   Defaults to ''
#
# [*netapp_webservice_path*]
#   (optional) This option is used to specify the path to the E-Series proxy
#   application on a proxy server. The value is combined with the value of the
#   netapp_transport_type, netapp_server_hostname, and netapp_server_port
#   options to create the URL used by the driver to connect to the proxy
#   application.
#   Defaults to '/devmgr/v2'
#
# === Examples
#
#  manila::backend::netapp { 'myBackend':
#    netapp_login           => 'clusterAdmin',
#    netapp_password        => 'password',
#    netapp_server_hostname => 'netapp.mycorp.com',
#    netapp_server_port     => '443',
#    netapp_transport_type  => 'https',
#    netapp_vserver         => 'openstack-vserver',
#  }
#
# === Authors
#
# Bob Callaway <bob.callaway@netapp.com>
#
# === Copyright
#
# Copyright 2014 NetApp, Inc.
#
define manila::backend::netapp (
  $netapp_login,
  $netapp_password,
  $netapp_server_hostname,
  $share_backend_name          = $name,
  $netapp_server_port           = '80',
  $netapp_size_multiplier       = '1.2',
  $netapp_storage_family        = 'ontap_cluster',
  $netapp_storage_protocol      = 'nfs',
  $netapp_transport_type        = 'http',
  $netapp_vfiler                = '',
  $netapp_share_list           = '',
  $netapp_vserver               = '',
  $expiry_thres_minutes         = '720',
  $thres_avl_size_perc_start    = '20',
  $thres_avl_size_perc_stop     = '60',
  $nfs_shares_config            = '',
  $netapp_copyoffload_tool_path = '',
  $netapp_controller_ips        = '',
  $netapp_sa_password           = '',
  $netapp_storage_pools         = '',
  $netapp_webservice_path       = '/devmgr/v2',
) {

  manila_config {
    "${share_backend_name}/share_backend_name":          value => $share_backend_name;
    "${share_backend_name}/share_driver":                value => 'manila.share.drivers.netapp.common.NetAppDriver';
    "${share_backend_name}/netapp_login":                 value => $netapp_login;
    "${share_backend_name}/netapp_password":              value => $netapp_password, secret => true;
    "${share_backend_name}/netapp_server_hostname":       value => $netapp_server_hostname;
    "${share_backend_name}/netapp_server_port":           value => $netapp_server_port;
    "${share_backend_name}/netapp_size_multiplier":       value => $netapp_size_multiplier;
    "${share_backend_name}/netapp_storage_family":        value => $netapp_storage_family;
    "${share_backend_name}/netapp_storage_protocol":      value => $netapp_storage_protocol;
    "${share_backend_name}/netapp_transport_type":        value => $netapp_transport_type;
    "${share_backend_name}/netapp_vfiler":                value => $netapp_vfiler;
    "${share_backend_name}/netapp_share_list":           value => $netapp_share_list;
    "${share_backend_name}/netapp_vserver":               value => $netapp_vserver;
    "${share_backend_name}/expiry_thres_minutes":         value => $expiry_thres_minutes;
    "${share_backend_name}/thres_avl_size_perc_start":    value => $thres_avl_size_perc_start;
    "${share_backend_name}/thres_avl_size_perc_stop":     value => $thres_avl_size_perc_stop;
    "${share_backend_name}/nfs_shares_config":            value => $nfs_shares_config;
    "${share_backend_name}/netapp_copyoffload_tool_path": value => $netapp_copyoffload_tool_path;
    "${share_backend_name}/netapp_controller_ips":        value => $netapp_controller_ips;
    "${share_backend_name}/netapp_sa_password":           value => $netapp_sa_password;
    "${share_backend_name}/netapp_storage_pools":         value => $netapp_storage_pools;
    "${share_backend_name}/netapp_webservice_path":       value => $netapp_webservice_path;
  }
}
