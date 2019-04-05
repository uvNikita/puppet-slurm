# File::      <tt>common/redhat.pp</tt>
# Author::    UL HPC Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2017 UL HPC Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# = Class: slurm::common::redhat
#
# Specialization class for Redhat systems
class slurm::common::redhat inherits slurm::common {

  include ::yum
  include ::selinux

  yum::group { $slurm::params::groupinstall:
    ensure  => 'present',
    timeout => 600,
  }

  if $slurm::manage_epel {
    include ::epel
    Yum::Group[$slurm::params::groupinstall] -> Class['::epel']
  }

  # Resource default statements
  Package {
    require => Yum::Group[$slurm::params::groupinstall],
  }

  if $slurm::manage_firewall and versioncmp($facts['os']['release']['major'], '7') >= 0 {
    include ::firewalld
  }

}
