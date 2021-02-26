#!/bin/sh

# Set global variables
CWD=$(realpath | sed 's|/scripts||g')

check_requirements()
{
  # Check that we are running as root or with sudo
  if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root or with sudo" 1>&2
    exit 1
  fi

  # Check for required packages
  PACKAGES="vm-bhyve expect"

  # Check for 13.0-STABLE kernel

  # Check for GhostBSD repo

  # Check for vm-bhyve

  # Check to make sure vm-bhyve modules are loaded and vm service is started
}

poweroff_vm()
{
  # Check for previously running ghostbsd-openrc-ci vm and power off
}

stop_console_session()
{
  # Stop any previous ghostbsd-openrc-ci vm console sessions
}

export_pool()
{
  # Export pool
}

detach_disk_image()
{
  # Unmount disk image
  mdconfig -d -u 99 >/dev/null 2>/dev/null || true
}

cleanup_vm()
{
  # Cleanup any previous ghostbsd-openrc-ci vm data
  yes | vm destroy ghostbsd-openrc-ci >/dev/null 2>/dev/null || true
}

create_vm()
{
  # Get the location of vm_dir from rc.conf
  VM_DIR=$(sysrc -q -n vm_dir)
  if [ "$VM_DIR" = "" ]; then
    # Fail if vm_dir is not set in /etc/rc.conf
    echo "vm_dir is not set in /etc/rc.conf"
    exit 1
  else
    # Print out the value of vm_dir in /etc/rc.conf 
    echo "vm_dir is set to ${VM_DIR} in /etc/rc.conf"
  fi

  # Always copy the ghostbsd-openrc-ci template to the local directory specified vm_dir
  # Check to see if zfs is used for vm_dir parameter in /etc/rc.conf
  echo "${VM_DIR}" | grep -q zfs
  if [ $? -ne 1 ]; then
    # Get and use the filesystem path for the zfs dataset for copying the template
    VM_DIR_ZFS=$(echo "${VM_DIR}" | grep -o '/.*')
    cp ${CWD}/ghostbsd-openrc-ci.conf ${VM_DIR_ZFS}/.templates/
    echo "Copied ghostbsd-openrc-ci.conf template to ${VM_DIR_ZFS}/.templates/"
  else
    # Use the filesystem path specified by vm_dir in /etc/rc.conf
    cp ${CWD}/ghostbsd-openrc-ci.conf ${VM_DIR}
    echo "Copied ghostbsd-openrc-ci.conf template to ${VM_DIR}/.templates/"
  fi

  # Check vm-bhyve to determine which switch is default
  # Check to see if zfs is used for vm_dir parameter in /etc/rc.conf
  echo "${VM_DIR}" | grep -q zfs
  if [ $? -ne 1 ]; then
    # Get and use the filesystem path for the zfs dataset for copying the template
    # Enable the default switch in ghostbsd-core-ci template in vm_dir location
    SWITCH=$(vm switch list | awk 'FNR==2{print $0}' | awk '{print $1}')
    sed -i '' -e 's/changeme/"'"${SWITCH}"'"/' ${VM_DIR_ZFS}/.templates/ghostbsd-openrc-ci.conf
  else
    # Use the filesystem path specified by vm_dir in /etc/rc.conf
    # Enable the default switch in ghostbsd-core-ci template in vm_dir location
    SWITCH=$(vm switch list | awk 'FNR==2{print $0}' | awk '{print $1}')
    sed -i '' -e 's/changeme/"'"${SWITCH}"'"/' ${VM_DIR}/.templates/ghostbsd-openrc-ci.conf
  fi

  # Create ghostbsd-openrc-ci vm
  vm create -t ghostbsd-openrc-ci ghostbsd-openrc-ci
}

attach_disk_image()
{
  # Mount ghostbsd-openrc-ci disk image
  # Check to see if zfs is used for vm_dir parameter in /etc/rc.conf
  echo "${VM_DIR}" | grep -q zfs
  if [ $? -ne 1 ]; then
    # Get and use the filesystem path for the zfs dataset for mounting the vm disk
    VM_DIR_ZFS=$(echo "${VM_DIR}" | grep -o '/.*')
    mdconfig -f "${VM_DIR_ZFS}/ghostbsd-openrc-ci/disk0.img" -u 99
  else
    # Use the filesystem path specified by vm_dir in /etc/rc.conf for mounting the vm disk
    mdconfig -f "${VM_DIR}/ghostbsd-openrc-ci/disk0.img" -u 99 
  fi
}

create_pool()
{
  # Create partitions in disk image

  # Image bootloader

  # Create pool
}

import_pool()
{
  # Import pool for ghostbsd-openrc-ci
}

install_os_packages()
{
  # Install 13-stable packages in disk image
}

install_repo_overlay()
{
  # Copy libexec/rc/etc.init.d/ contents to /etc/init.d/ in disk image
}

boot_vm()
{
  # start the vm
}

start_console_session()
{
  # Begin console session

  # Login as root

  # Run command to print deptree to log
}

shutdown_vm()
{
  # Cleanly shutdown the vm to get shutdown logs properly
}

get_logs()
{
  # Grab /var/log/rc.log

  # Grab deptree log
}

check_logs()
{
  # Check for any errors in /var/rc.log and return 0 or 1

  # Present messaging on how to start vm and console in if any problems were encountered
}

# Run our functions
check_requirements
poweroff_vm
stop_console_session
export_pool
detach_disk_image
cleanup_vm
create_vm
attach_disk_image
create_pool
import_pool
install_os_packages
install_repo_overlay
boot_vm
start_console_session
shutdown_vm
stop_console_session
import_pool
get_logs
export_pool
detach_disk_image
check_logs
