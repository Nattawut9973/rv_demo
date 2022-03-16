#!/usr/bin/perl
package Cpacct;
use JSON;
use strict;
use warnings;

sub regisaccount{
   Cpacct::log("Function regisaccount");
   my $user = $_[0];
   my $backup_path = "/usr/local/rv_demo_acct_manage/backup";
   my $cmd = 'whmapi1 accountsummary user='.$user.' --output=json';
   my $user_checked = `$cmd`;
   my $json = decode_json($user_checked);
   if($json->{'metadata'}->{'result'} == 1){
      my $create_cmd = system('mkdir -p /usr/local/rv_demo_acct_manage/backup/'.$user); 
      if($create_cmd == 0){
         Cpacct::log("$user directory create success");
         print "$user directory create success\n";
         my $backup_cmd = system('/usr/local/cpanel/bin/pkgacct'.' '.$user.' '.'/usr/local/rv_demo_acct_manage/backup/'.$user);
         if($backup_cmd == 0){           
            Cpacct::log("User $user register success");
            print "User $user register success\n"; 
            return 1;     
         }   
      }
   }else{
      Cpacct::log("User $user can't register");
      print $json->{'metadata'}->{'reason'} ."\n";
      return 0;
   }
}

sub listaccount{
   my $backup_path = "/usr/local/rv_demo_acct_manage/backup";
   opendir(my $dir,$backup_path) or die "Can't opendir $backup_path, $!";
   while(readdir $dir){
      next if $_ eq '.' || $_ eq '..';
      print "- $_\n";
   }
   closedir($dir);
}

sub restoreaccount{
   Cpacct::log("Function restoreaccount");
   my $backup_path = "/usr/local/rv_demo_acct_manage/backup";
   my $user = $_[0];
   opendir(DIR,$backup_path) or die "Can't open directory, $!";
   my @dir = readdir(DIR);
   closedir(DIR); 
   if($user eq '' || $user eq 'all'){
      Cpacct::log("Account restore all");
      foreach(@dir){
         next if $_ eq '.' or $_ eq '..';
         if(-d $backup_path . "/" . $_){
            my $remove_cmd = 'whmapi1 removeacct user=' .$_ .' --output=json';
            my $removed = `$remove_cmd`;
            my $remove_json = decode_json($removed);
            if($remove_json->{'metadata'}->{'result'} == 0){
               Cpacct::log("User $_ restore fail");
               print $remove_json->{'metadata'}->{'reason'} .'\n';
               next;
            }
            if(-f '/usr/local/rv_demo_acct_manage/backup/'.$_.'/cpmove-'.$_ .'.tar.gz'){
               my $restore = system('/usr/local/cpanel/bin/restorepkg --newuser'.' '.$_.' '.'/usr/local/rv_demo_acct_manage/backup/'.$_.'/cpmove-'.$_ .'.tar.gz');
               if($restore == 0){
                  Cpacct::log("User $_ restore success");
                  print "User $_ restore success\n";  
               }
            }else{
               Cpacct::log("User $_ can't restore");
               print "User $_ can't restore\n";
            } 
         }
      }   
   }elsif($user ne '' && $user ne 'all'){
      if(-f '/usr/local/rv_demo_acct_manage/backup/'.$user.'/cpmove-'.$user .'.tar.gz'){
         Cpacct::log("Account $user restore");
         my $remove_cmd = 'whmapi1 removeacct user='.$user.' --output=json';
         my $removed = `$remove_cmd`;
         my $remove_json = decode_json($removed);
         if($remove_json->{'metadata'}->{'result'} == 0){
            Cpacct::log("User $user restore fail");
            print $remove_json->{'metadata'}->{'reason'} .'\n';
            exit;
         }
         my $restore = system('/usr/local/cpanel/bin/restorepkg --newuser'.' '.$user.' '.'/usr/local/rv_demo_acct_manage/backup/'.$user.'/cpmove-'.$user .'.tar.gz');
         if($restore == 0){
            Cpacct::log("User $user has been restored");
            print "User $user restore success\n";   
            return 1;
         }
      }else{
         Cpacct::log("User $user not exists backup file");
         print "User $user not exists backup file\n";
         return 0;
      }
   }
}

sub unregisaccount{
   Cpacct::log("Function unregisaccount");
   my $user = $_[0];
   my $backup_path = "/usr/local/rv_demo_acct_manage/backup";
   if(-d $backup_path ."/" .$user){
      my $remove = system('rm -rf'.' '.$backup_path.'/'.$user);
      if($remove == 0){
         Cpacct::log("User $user has been unregistered");
         print "User $user unregister success\n";
         return 1;
      }
      Cpacct::log("User $user can't remove");
      print "User $user can't remove\n";
      return 0;
   }else{
      Cpacct::log("User $user not exist in backup folder");
      print "User $user not exist in backup folder\n";
      return 0;
   }     
}

sub writelog{
   my $log = "/usr/local/rv_demo_acct_manage/logs/main.log";
   my $size = -s $log;
   if(($size/1048576) > 5){
      system('rm -f '.$log); 
      return 1;
   } 
   return 0;
}

sub log{
   Cpacct::writelog();
   my $message = $_[0];
   my $time = localtime();
   open(my $fh, '>>', '/usr/local/rv_demo_acct_manage/logs/main.log') or die "Can't opern the file: $!";
   print $fh "$time :: $message";
   print $fh "\n";
   close $fh;   
}

# sub listbackup{
#    my ($backup_path) = $_[0];
#    print "$backup_path\n";
#    return if not -d $backup_path;

#    opendir(my $dh,$backup_path) or die "Cannot open directory $backup_path: $!";
#    while (my $sub = readdir($dh)) {
#       next if $sub eq '.' or $sub eq "..";
#       listbackup("$backup_path/$sub");
#    }
#    closedir($dh);
#    return 1;
# }

1;

