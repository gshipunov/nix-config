{ ... }:
{
  services.nginx.upstreams.radicale = {
    servers = {
      "10.89.88.12:5232" = { };
      "[fd31:185d:722f::12]:5232" = { };
    };
  };

  services.nginx.virtualHosts."dav.oxapentane.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://radicale/";
    };
  };
}
