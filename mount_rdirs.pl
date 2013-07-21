#!/usr/bin/perl

use warnings;
use strict;
my $umount = 0;
sub helpmsg;

foreach(@ARGV)
{
    if($_ eq "-u")
    {
        $umount = 1;
    }
    else
    {
        helpmsg();
    }
}

open(my $cfg, "<", "mount_rdirs.cfg")
    or die qq{Can't open config file: $!};
    
my @cfg = <$cfg>;

foreach(@cfg)
{
    $_ =~ s/\n//gmx;
    my ($hostname) = $_ =~ /^.*@(.*):/;
    my $home = $ENV{'HOME'};
    my ($dirname) = $_ =~ /[:|\/](\w+)$/;
    $dirname .= qq{_on_$hostname};
    
    if(!-d qq{$home/$dirname})
    {
        mkdir(qq{$home/$dirname})
            or die qq{Can't create directory $dirname: $!};
    }
    
    my $cmd;
    
    if ($umount == 1)
    {
        $cmd = qq{fusermount -u $home/$dirname};
    }
    else
    {
        $cmd = qq{sshfs $_ $home/$dirname/};
    }
    $cmd .= qq{ >/dev/null 2>&1};
    my $cleancmd = $cmd;
    $cleancmd =~ s/\s>\/dev\/null\s2>&1//gmx;
    print qq{Executing: "$cleancmd"...\n};
    system(qq{$cmd});
}

sub helpmsg
{
    print 
    qq{Usage:
        Create a "mount_rdirs.cfg" files containing the list
        of the remote directories you want to mount. eg:
        user\@remote_pc:/path/to/directory
        
        Options:
        
        -u Unmount mode.
            \n};
            exit 0;
}

__END__