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
    
#     $dirname =~ s{\s}{\\ }g;
#     $remote_path =~ s{\s}{\\ }g;
    
    if(($umount == 0))
    {
        my @mkdir = (qq{mkdir}, qq{-p}, qq{$home/$dirname/$remote_path});
        system(@mkdir);
#             or die qq{Failed to create directory $home/$dirname/$remote_path: $!};
    }
    
    my @cmd;
    
    if ($umount == 1)
    {
        @cmd = (qq{fusermount}, qq{-u}, qq{$home/$dirname/$remote_path});
    }
    else
    {
        @cmd = (qq{sshfs}, qq{$_}, qq{$home/$dirname/$remote_path});
    }
    
#     push(@cmd, qq{ >/dev/null 2>&1});
    $ret = system(@cmd);
    if($ret != 0)
    {
        print qq{failed to mount $_: $?\n};
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