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
        "auth" = {
          address = [
            "10.89.88.11/24"
            "fd31:185d:722f::11/48"
          ];
          publicKey = "5pW+lt3Xty8IdQ3ndcIXR3B7pl3hV+8M+EgvGmaRhyU=";
          privateKeyFile = config.sops.secrets."wg/0xa-proxy".path;
        };
        "radicale" = {
          address = [
            "10.89.88.12/24"
            "fd31:185d:722f::12/48"
          ];
          publicKey = "EIdTwWTqGJv9i2rV+Uu8d/QptGwFAFjHcHp/Hquhr3g=";
          privateKeyFile = config.sops.secrets."wg/0xa-proxy".path;
        };
      };
    }
  ];

}
