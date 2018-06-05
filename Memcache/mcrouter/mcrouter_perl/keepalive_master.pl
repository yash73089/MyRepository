#!/usr/bin/perl
use DBI;
require "/usr/local/netmagic/cloud/bin/confuat.pl";
use Fcntl;
use Date::Calc qw(:all);
use Time::Local;
use POSIX ":sys_wait_h";
use Proc::Daemon;
use Proc::PID::File;
use IO::Socket;
use Digest::MD5;
use Fcntl qw(:DEFAULT :flock);
use VMware::Vix::Simple;
use VMware::Vix::API::Constants;
$cloud_app_component_id = $ARGV[0];
$cloud_component_id = $ARGV[1];
$dbh=DBI->connect("dbi:mysql:$conf{'database'}:$conf{'nbssdbHost'}:$conf{'nbssdbPort'}","$conf{'nbssdbUsername'}","$conf{'nbssdbPassword'}", {RaiseError => 2});

my $guest_config_script = '/home/keepalive_master.sh'.time.$ARGV[1];
my $host_config_script = '/usr/local/netmagic/cloud/bin/shell_scripts/memcached/mcrouter/keepalive_master.sh';
my $guest_getip_file = '/home/keepalive_conf_master.txt';
my $host_getip_file = "/usr/local/netmagic/cloud/bin/shell_scripts/memcached/mcrouter/temp/keepalive_conf_master_$cloud_component_id.txt";
my $guest_check_mcrouter_file = '/home/check_mcrouter.sh';
my $host_check_mcrouter_file = '/usr/local/netmagic/cloud/bin/shell_scripts/memcached/mcrouter/check_mcrouter.sh';



#    $sql2 = "SELECT cap.cloud_component_name,cap.initial_password,cg.vcenterserver_url ,cg.vcenterserver_username,cg.vcenterserver_password,cap.parent_id,cap.default_ip_address FROM cloud_app_components as cap, cloud_applications as ca, cloud_grid as cg WHERE (cap.cloud_application_id = ca.cloud_application_id ) AND (cap.cloud_app_component_id=$cloud_app_component_id  or cap.parent_id=$cloud_app_component_id) AND cg.cloud_grid_id=ca.cloud_grid_id";
     $sql2 = "SELECT cap.cloud_component_name,cap.root_password,cg.vcenterserver_url ,cg.vcenterserver_username,cg.vcenterserver_password,cap.parent_id,(select vm_type from cloud_app_components caps where caps.cloud_application_id=cap.firewall_component_id)  FROM cloud_app_components as cap, cloud_applications as ca, cloud_grid as cg WHERE (cap.cloud_application_id = ca.cloud_application_id ) AND (cap.cloud_app_component_id=$cloud_app_component_id) AND cg.cloud_grid_id=ca.cloud_grid_id";


    $cursor2 = $dbh->prepare($sql2);
    $cursor2->execute;

#print $cursor2;

    while(@row2=$cursor2->fetchrow_array)
    {

      $cloud_component_name = $row2[0];
      $vm_properties{$cloud_component_name}{'password'}               = $row2[1];
      $root_password = $row2[1];
      $vm_properties{$cloud_component_name}{'vcenterserver_url'}      = $row2[2];
      $vcenterserver_url = $row2[2];
      $vm_properties{$cloud_component_name}{'vcenterserver_username'} = $row2[3];
      $vcenterserver_username = $row2[3];
      $vm_properties{$cloud_component_name}{'vcenterserver_password'} = $row2[4];
      $vcenterserver_password = $row2[4];
      $parent_id              = $row2[5];
      $localip                = $row2[6];
      if($parent_id eq '')
      {
       $cloud{'master'} = $cloud_component_name;
      }
     # print "$cloud_component_name $vm_properties{$cloud_component_name}{'password'} $row2[2] $row2[3] $row2[4]\n";
    }
    $cursor2->finish();
    $dbh->disconnect();




foreach $cloud_name (sort keys %vm_properties)
{
  ($err, $hostHandle) = HostConnect(VIX_API_VERSION,
                                   VIX_SERVICEPROVIDER_VMWARE_VI_SERVER,
                                   "$vm_properties{$cloud_name}{'vcenterserver_url'}",       # hostName
                                   443,                        # hostPort
                                   "$vm_properties{$cloud_name}{'vcenterserver_username'}",  # userName
                                   "$vm_properties{$cloud_name}{'vcenterserver_password'}",  # password
                                   0,                          # options
                                   VIX_INVALID_HANDLE) ;       # propertyListHandle
if ($err != VIX_OK)
{
 print "error HostConnect()\n";
 die "HostConnect() failed, $err ", GetErrorText($err), "\n" if $err != VIX_OK;
} 

# ...Do everything in your program...
my @vms = FindRunningVMs($hostHandle, 100);
#my @vms = FindItems($hostHandle, VIX_FIND_REGISTERED_VMS, 100);
my $err = shift @vms;
die "Error $err finding running VMs ", GetErrorText($err),"\n" if $err != VIX_OK;

foreach $vms (@vms)
{
#print $cloud_name;
 if($vms =~ /\/$cloud_name/)
  {
   ($err, $vmHandle) = VMOpen($hostHandle,$vms);
        if( $err != VIX_OK)
        {
         print "error VMOpen()\n";
         die "VMOpen() failed, $err ", GetErrorText($err), "\n"
           if $err != VIX_OK;

        }
                       
   $err = VMPowerOn($vmHandle,
                    0,                    # powerOnOptions
                    VIX_INVALID_HANDLE);  # propertyListHandle
   die "VMPowerOn() failed, $err ", GetErrorText($err), "\n" if $err != VIX_OK;
$err = VMWaitForToolsInGuest($vmHandle,
                            600); # timeoutInSeconds
die "VMWaitForToolsInGuest() failed, $err ", GetErrorText($err), "\n" if $err != VIX_OK;

   $err = VMLoginInGuest($vmHandle,
                         "root",                                    # userName
                         "$vm_properties{$cloud_name}{'password'}",   # password
                         0);                                          # options
   die "VMLoginInGuest() failed, $err ", GetErrorText($err), "\n" if $err != VIX_OK;

   $err = VMCopyFileFromHostToGuest ($vmHandle,
                                    "$host_config_script",     # src name
                                    "$guest_config_script",   # dest name
                                    0,                     # options
                                    VIX_INVALID_HANDLE);   # propertyListHandle
   die "VMCopyFileFromHostToGuest() failed, $err ", GetErrorText($err), " \n" if $err != VIX_OK;

  $err = VMCopyFileFromHostToGuest ($vmHandle,
                                    "$host_getip_file",     # src name
                                    "$guest_getip_file",   # dest name
                                    0,                     # options
                                    VIX_INVALID_HANDLE);   # propertyListHandle
   die "VMCopyFileFromHostToGuest() failed, $err ", GetErrorText($err), " \n" if $err != VIX_OK;

   $err = VMCopyFileFromHostToGuest ($vmHandle,
                                    "$host_check_mcrouter_file",     # src name
                                    "$guest_check_mcrouter_file",   # dest name
                                    0,                     # options
                                    VIX_INVALID_HANDLE);   # propertyListHandle
   die "VMCopyFileFromHostToGuest() failed, $err ", GetErrorText($err), " \n" if $err != VIX_OK;




	$err = VMRunProgramInGuest(
            $vmHandle,
            "$guest_config_script",                             # prog name
            " >> /home/master.out" ,                     # arguements
            0,                                         # options
            VIX_INVALID_HANDLE                         # propertyListHandle
        );

        die "VMRunProgramInGuest() failed, $err ", GetErrorText($err), "\n"
          if $err != VIX_OK;
	

}

  }
}

#print "Success\n";
