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

Will stay silent unless there are errors.

NOTE: It is imperative that you use pubkey authentication.
