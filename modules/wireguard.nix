{ config, ... }:

{
  networking.wg-quick.interfaces = {
    wg-zw = {
      privateKeyFile = config.sops.secrets."wg/wg-zw-seckey".path;
      address = [ "172.20.76.226" ];
      dns = [ "172.20.73.8" ];
      peers = [
        {
          publicKey = "PG2VD0EB+Oi+U5/uVMUdO5MFzn59fAck6hz8GUyLMRo=";
          endpoint = "81.201.149.152:1337";
          allowedIPs = [ "172.20.72.0/21" "172.22.99.0/24" ];
        }
      ];
    };
    wg-dvb = {
      privateKeyFile = config.sops.secrets."wg/wg-dvb-seckey".path;
      address = [ "10.13.37.3/32" ];

      peers = [
        {
          publicKey = "WDvCObJ0WgCCZ0ORV2q4sdXblBd8pOPZBmeWr97yphY=";
          allowedIPs = [ "10.13.37.0/24" ];
          endpoint = "academicstrokes.com:51820";
          persistentKeepalive = 25;
        }
      ];
    };

    mlwd-nl = {
      privateKeyFile = config.sops.secrets."wg/mlwd-nl-seckey".path;
      address = [ "10.65.79.164/32" "fc00:bbbb:bbbb:bb01::2:4fa3/128" ];
      dns = [ "193.138.218.74" ];

      peers = [{
        publicKey = "StMPmol1+QQQQCJyAkm7t+l/QYTKe5CzXUhw0I6VX14=";
        allowedIPs = [ "0.0.0.0/0" "::0/0" ];
        endpoint = "92.60.40.194:51820";
      }];
    };
  };
}
