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
    # Radicale
    locations."/" = {
      proxyPass = "http://radicale";
      extraConfig = ''
        # Radicale stuff
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade_keepalive;

        # authentik stuff
        auth_request     /outpost.goauthentik.io/auth/nginx;
        error_page       401 = @goauthentik_proxy_signin;
        auth_request_set $auth_cookie $upstream_http_set_cookie;
        proxy_set_header       Set-Cookie $auth_cookie;

        # translate headers from the outposts back to the actual upstream
        auth_request_set $authentik_username $upstream_http_x_authentik_username;
        auth_request_set $authentik_groups $upstream_http_x_authentik_groups;
        auth_request_set $authentik_entitlements $upstream_http_x_authentik_entitlements;
        auth_request_set $authentik_email $upstream_http_x_authentik_email;
        auth_request_set $authentik_name $upstream_http_x_authentik_name;
        auth_request_set $authentik_uid $upstream_http_x_authentik_uid;

        proxy_set_header X-authentik-username $authentik_username;
        proxy_set_header X-Remote-User $authentik_username;
        proxy_set_header X-authentik-groups $authentik_groups;
        proxy_set_header X-authentik-entitlements $authentik_entitlements;
        proxy_set_header X-authentik-email $authentik_email;
        proxy_set_header X-authentik-name $authentik_name;
        proxy_set_header X-authentik-uid $authentik_uid;
      '';
    };

    locations."/outpost.goauthentik.io" = {
      proxyPass = "http://authentik/outpost.goauthentik.io";
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
        proxy_set_header Set-Cookie $auth_cookie;
        auth_request_set $auth_cookie $upstream_http_set_cookie;
        proxy_pass_request_body off;
        proxy_set_header Content-Length "";
      '';
    };
    locations."@goauthentik_proxy_signin" = {
      extraConfig = ''
        internal;
        proxy_set_header Set-Cookie $auth_cookie;
        return 302 /outpost.goauthentik.io/start?rd=$request_uri;
      '';
    };
  };
}
