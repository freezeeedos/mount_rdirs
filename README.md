mount_rdirs
===========

mount remote dirs with sshfs

Usage:
=====
        Create a "mount_rdirs.cfg" files containing the list
        of the remote directories you want to mount. eg:
        user@remote_pc:/path/to/directory
        
        Options:
        
        -u Unmount mode.

Sample Output:

    quentin@kboum:~> ./mount_rdirs.pl 
    Executing: "sshfs quentin@maison:/home/quentin /home/quentin/quentin_on_maison"...
    Executing: "sshfs quentin@obiwan:/mnt/backup/quentin /home/quentin/quentin_on_obiwan"...
    Executing: "sshfs quentin@obiwan:/mnt/backup/punk /home/quentin/punk_on_obiwan"...
    Executing: "sshfs quentin@obiwan:/mnt/backup/kboum /home/quentin/kboum_on_obiwan"...
    Executing: "sshfs quentin@obiwan:/home/quentin /home/quentin/quentin_on_obiwan"...

NOTE: It is imperative that you use pubkey authentication.
