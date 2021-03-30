#
# == Class: manila::backend::lvm
#
# Configures Manila to use LVM as a share driver
#
# === Parameters
# [*share_backend_name*]
#   Name of the backend in manila.conf that these settings will reside in
#
# [*driver_handles_share_servers*]
#  (optional) Denotes whether the driver should handle the responsibility of
#  managing share servers. This must be set to false if the driver is to
#  operate without managing share servers.
#  Defaults to: False
#
# [*lvm_share_export_ip*]
#  List of IPs to export shares belonging to the LVM storage driver.
#  lvm_share_export_ip = <None>
#
# [*lvm_share_export_root*]
#  (optional) Base folder where exported shares are located.
#  Defauls to: $state_path/mnt
#
# [*lvm_share_mirrors*]
#  (optional) If set, create LVMs with multiple mirrors. Note that this requires
#  lvm_mirrors + 2 PVs with available space.
#  Defaults to: 0

# [*lvm_share_volume_group*]
#  (optional) Name for the VG that will contain exported shares. (string value)
#  Defaults to: lvm-shares

# [*lvm_share_helpers*]
#  (optional) Specify list of share export helpers. (list value)
#  Defaults to: ['CIFS=manila.share.drivers.helpers.CIFSHelperUserAccess',
#                'NFS=manila.share.drivers.helpers.NFSHelper']
#
define manila::backend::lvm(
  $share_backend_name           = $name,
  $driver_handles_share_servers = false,
  $lvm_share_export_ip          = undef,
  $lvm_share_export_root        = '$state_path/mnt',
  $lvm_share_mirrors            = 0,
  $lvm_share_volume_group       = 'lvm-shares',
  $lvm_share_helpers            = ['CIFS=manila.share.drivers.helpers.CIFSHelperUserAccess',
    'NFS=manila.share.drivers.helpers.NFSHelper'],
) {

  include manila::deps
  $share_driver = 'manila.share.drivers.lvm.LVMShareDriver'

  manila_config {
    "${name}/share_backend_name":           value => $share_backend_name;
    "${name}/share_driver":                 value => $share_driver;
    "${name}/driver_handles_share_servers": value => $driver_handles_share_servers;
    "${name}/lvm_share_export_ip":          value => $lvm_share_export_ip;
    "${name}/lvm_share_export_root":        value => $lvm_share_export_root;
    "${name}/lvm_share_mirrors":            value => $lvm_share_mirrors;
    "${name}/lvm_share_volume_group":       value => $lvm_share_volume_group;
    "${name}/lvm_share_helpers":            value => $lvm_share_helpers;
  }
}
