{ config, ... }:
{
  networking.firewall.trustedInterfaces = [ "wg-0xa-mgmt" ];
  oxalab.wg = [
    {
      networkName = "0xa-mgmt";
      CIDRs = [ "10.89.87.0/24" "fd31:185d:722e::/48" ];

      hosts = {
        "cloud" = {
          address = [ "10.89.87.1/24"  "fd31:185d:722e::1/48" ];
          publicKey = "zKSaw+SXzWgi/T7ByXHqPk1XNXXapoQYB8UPMTRmhm0=";
          privateKeyFile = config.sops.secrets."wg/0xa-mgmt".path;
          endpoint = {
            enable = true;
            endpoint = "188.245.196.27";
            port = 51820;
            publicIface = "enp1s0";
          };
        };

        "toaster" = {
          address = [ "10.89.87.100/24"  "fd31:185d:722e::100/48" ];
          publicKey = "H+WeYIBdX7ZHwkgm4BGnF0HF0JULkxyNMcvCviHhmks=";
          privateKeyFile = config.sops.secrets."wg/0xa-mgmt".path;
        };
        "minime" = {
          address = [ "10.89.87.10/24"  "fd31:185d:722e::10/48" ];
          publicKey = "zN2Dr/ZGMh1Ftparszp22Qnbz2ISJU12iDVatebOHUE=";
          privateKeyFile = config.sops.secrets."wg/0xa-mgmt".path;
        };
      };
    }
  ];

}
