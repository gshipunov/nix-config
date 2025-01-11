{
  lib,
  ...
}:
{
  options.oxalab.wg =
    with lib;
    lib.mkOption {
      default = [ ];
      type = types.listOf (
        types.submodule {
          options = {
            # general network stuff
            networkName = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            CIDRs = mkOption {
              type = types.nullOr (types.listOf types.str);
              default = null;
            };

            hosts = mkOption {
              default = { };
              type = types.attrsOf (
                types.submodule {
                  options = {

                    enable = mkOption {
                      type = types.bool;
                      default = true;
                    };
                    address = mkOption {
                      type = types.listOf types.str;
                      default = null;
                    };
                    publicKey = mkOption {
                      type = types.str;
                      default = null;
                    };
                    privateKeyFile = mkOption {
                      type = types.path;
                      default = null;
                    };

                    endpoint.enable = mkOption {
                      type = types.bool;
                      default = false;
                    };
                    endpoint.endpoint = mkOption {
                      type = types.nullOr types.str;
                      default = null;
                    };
                    endpoint.port = mkOption {
                      type = types.nullOr types.int;
                      default = null;
                    };
                    endpoint.publicIface = mkOption {
                      type = types.nullOr types.str;
                      default = null;
                    };

                    endpoint.extraPeers = mkOption {
                      default = [ ];
                      type = types.listOf (
                        types.submodule {
                          options = {
                            address = mkOption {
                              type = types.listOf types.str;
                              default = [ ];
                            };
                            publicKey = mkOption {
                              type = types.nullOr types.str;
                              default = null;
                            };
                          };
                        }
                      );
                    };
                  };
                }
              );
            };
          };
        }
      );
    };
}
