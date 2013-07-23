#!/usr/bin/perl

use warnings;
use strict;
use File::Path qw(mkpath rmtree);

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
my $home = $ENV{'HOME'};
my $ret;

foreach(@cfg)
{
    $_ =~ s/\n//gmx;
    
    if($_ !~ /^\w+\@\w+:[\/*\w+\/*]*/)
    {
        print qq{Invalid parameter: $_\n};
        next;
    }
    my ($hostname) = $_ =~ /^.*@(.*):/;
    my ($username) = $_ =~ /^(.*)\@/;
    my ($remote_path) = $_ =~ /:([\/*\w+\/*]+)$/;
    my $dirname = qq{$username on $hostname};
    my $mounted = `mount|grep sshfs`;
    
    
    if(($umount == 0) && (!-d qq{$home/$dirname/$remote_path}))
    {
        mkpath(qq{$home/$dirname/$remote_path})
            or die qq{Can't create directory $home/$dirname/$remote_path: $!};
    }
    
    my $cmd;
    $dirname =~ s{\s}{\\ }g;
    
    if ($umount == 1)
    {
        $cmd = qq{fusermount -u $home/$dirname/$remote_path};
    }
    else
    {
        $cmd = qq{sshfs $_ $home/$dirname/$remote_path};
    }
    
    print qq{Executing: "$cmd"...\n};
    $cmd .= qq{ >/dev/null 2>&1};
    $ret = system(qq{$cmd});
    
    if(($umount == 1) && (-d qq{$home/$dirname/$remote_path}) && ($ret == 0))
    {
        rmtree(qq{$home/$dirname})
            or die qq{cant delete $home/$dirname: $!};
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