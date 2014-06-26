#
class manila::params {

  $manila_conf = '/etc/manila/manila.conf'
  $manila_paste_api_ini = '/etc/manila/api-paste.ini'

  if $::osfamily == 'Debian' {
    $package_name       = 'manila-common'
    $client_package     = 'python-manilaclient'
    $api_package        = 'manila-api'
    $api_service        = 'manila-api'
    $scheduler_package  = 'manila-scheduler'
    $scheduler_service  = 'manila-scheduler'
    $share_package     = 'manila-share'
    $share_service     = 'manila-share'
    $db_sync_command    = 'manila-manage db sync'
    $tgt_package_name   = 'tgt'
    $tgt_service_name   = 'tgt'
    $ceph_init_override = '/etc/init/manila-share.override'
    $iscsi_helper       = 'tgtadm'
    $lio_package_name   = 'targetcli'

  } elsif($::osfamily == 'RedHat') {

    $package_name       = 'openstack-manila'
    $client_package     = 'python-manilaclient'
    $api_package        = false
    $api_service        = 'openstack-manila-api'
    $backup_package     = false
    $backup_service     = 'openstack-manila-backup'
    $scheduler_package  = false
    $scheduler_service  = 'openstack-manila-scheduler'
    $share_package     = false
    $share_service     = 'openstack-manila-share'
    $db_sync_command    = 'manila-manage db sync'
    $tgt_package_name   = 'scsi-target-utils'
    $tgt_service_name   = 'tgtd'
    $ceph_init_override = '/etc/sysconfig/openstack-manila-share'
    $lio_package_name   = 'targetcli'

    if $::operatingsystem == 'RedHat' and $::operatingsystemrelease >= 7 {
      $iscsi_helper = 'lioadm'
    } else {
      $iscsi_helper = 'tgtadm'
    }

  } else {
    fail("unsuported osfamily ${::osfamily}, currently Debian and Redhat are the only supported platforms")
  }
}
