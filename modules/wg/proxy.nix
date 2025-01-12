{ config, ... }:
{
  oxalab.wg = [
    {
      networkName = "0xa-proxy";
      CIDRs = [
        "10.89.88.0/24"
        "fd31:185d:722f::/48"
      ];

      hosts = {
        "cloud" = {
          address = [
            "10.89.88.1/24"
            "fd31:185d:722f::1/48"
          ];
          publicKey = "XdUqSz0W6aqJET/9wNwoRyR8mgPs2dRWm+ijNwzEyE0=";
          privateKeyFile = config.sops.secrets."wg/0xa-proxy".path;
          endpoint = {
            enable = true;
            endpoint = "188.245.196.27";
            port = 51821;
            publicIface = "enp1s0";
          };
        };
        "authentik" = {
          address = [
            "10.89.88.2/24"
            "fd31:185d:722f::2/48"
          ];
          publicKey = "";
          privateKeyFile = config.sops.secrets."wg/0xa-proxy".path;
        };
      };
    }
  ];

}
