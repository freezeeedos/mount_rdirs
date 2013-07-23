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
    
    if($_ !~ /^\w+\@\w+:[\/*\w+\/*]*/)
    {
        print qq{Invalid parameter: $_\n};
        next;
    }
    my ($hostname) = $_ =~ /^.*@(.*):/;
    my $home = $ENV{'HOME'};
    my ($dirname) = $_ =~ /[:|\/](\w+)$/;
    $dirname .= qq{_on_$hostname};
    my $fullpath = qq{$home/$dirname};
    my $mounted = `mount|grep sshfs`;
    
    if((!-d qq{$fullpath}))
    {
        if($umount == 0)
        {
            mkdir(qq{$fullpath})
                or die qq{Can't create directory $fullpath: $!};
        }
    }
    else
    {
        if(($mounted !~ /^$_/gmx) && ($umount == 0))
        {
            $fullpath .= qq{_1};
            mkdir(qq{$fullpath})
                or die qq{Can't create directory $fullpath: $!};
        }
        
    }
    if(($umount == 1) && (!-d $fullpath) && ($mounted =~ /$_/gmx))
    {
        $fullpath .= qq{_1};
    }
    
    my $cmd;
    
    if ($umount == 1)
    {
        $cmd = qq{fusermount -u $fullpath};
    }
    else
    {
        $cmd = qq{sshfs $_ $fullpath};
    }
    
    print qq{Executing: "$cmd"...\n};
    $cmd .= qq{ >/dev/null 2>&1};
    system(qq{$cmd});
    
    if(($umount == 1) && (-d $fullpath))
    {
        rmdir(qq{$fullpath})
            or die qq{cant delete mount point $fullpath: $!};
    }
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