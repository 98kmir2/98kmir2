FastNet Tools for Delphi 5 Readme

Section 1.
To make changes to source
1)Change the related .pas file in the /lib directory
2)Recompile NMRecompile.dpr in the /lib directory
3)Recompile DCLNMF50.dpk in the lib directory
4)Copy the resulting DCLNMF50.bpl to the /bin directory
  Note This DCLNMF50.bpl file may be in your /lib or /projects/bpl
  directory after the compile depending on your configuration


Section 2. -- List of known issues as of 11-02-1999
---------------------------------
1) NMFTP  - Executing multiple transactions simultaneously
            will cause an error.

2) NMSMTP - ExpandList method does not work properly

3) NMHTTP - Only the Get, Post, Put and Head methods are known to be
            functional.
            These are the methods that are HTTP/1.0 compliant.
            The Wrapped, and Link methods, in addition to any
            other methods not mentioned here, are HTTP/1.1 or
            HTTP/1.2 compliant, and are not widely supported.

4) NMNNTP - Newsgroups that allow posting are reported as not
            allowing posting. This does not prevent the user from
            posting, however.


5) All Controls - If the physical connection to the remote host is
                  forcefully terminated, the control might
                  not recognize the disconnect, and will
                  hang. A workaround for this is to call
                  the Abort method or to set the timeout value.

We are aware of these problems, and they are being addressed
accordingly.
