# Build a Win 2012 R2 box with SSHd

* `install_ssh.ps1` which has the instructions to install `OpenSSH-Win64`.
* `ssh_config\ssh_config` has the OpenSSH server configuration - copied in with Vagrant installation.

# Test PS Remoting over SSH from Mac:

```powershell
# from Mac
powershell

# ps remoting over SSH
Enter-PSSession -HostName 172.28.128.200 -UserName vagrant
```
