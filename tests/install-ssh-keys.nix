# Only for testing. Don't use in production !

{ config, ... }: 

{
  system.activationScripts.agenixInstall.deps = [ "installSSHKeys" ];

  system.activationScripts.installSSHKeys.text = ''
    mkdir -p /etc/ssh
    (
      umask u=rw,g=r,o=r
      cp ${./server-host-key.pub} /etc/ssh/ssh_host_ed25519_key.pub
    )
    (
      umask u=rw,g=,o=
      cp ${./server-host-key.private} /etc/ssh/ssh_host_ed25519_key
    )
  '';
}
