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
    locations."/oauth2/" = {
      proxyPass = "http://10.89.88.11:4180/";
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Auth-Request-Redirect $scheme://$host$request_uri;
      '';
    };
    locations."/oauth2/auth" = {
      proxyPass = "http://10.89.88.11:4180";
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Uri $request_uri;
        proxy_set_header Content-Length "";
        proxy_pass_request_body off;
      '';
    };
    locations."/" = {
      proxyPass = "http://radicale/";
      extraConfig = ''
        auth_request /oauth2/auth;
        error_page 401 =403 /oauth2/sign_in;

        auth_request_set $user $upstream_http_x_auth_request_user;

        auth_request_set $auth_cookie $upstream_http_set_cookie;
        # add_header Set-Cookie $auth_cookie;

        proxy_set_header X-Remote-User $user;
        proxy_set_header X-User $user;
        proxy_set_header X-Real-IP $remote_addr;

      '';
    };
  };
}
