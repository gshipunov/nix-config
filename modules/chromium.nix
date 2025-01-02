{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    chromium
  ];

  nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland  --force-dark-mode --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-features=VaapiVideoDecoder,VaapiVideoEncoder,CanvasOopRasterization,WebUIDarkMode";

  programs.chromium = {
    enable = true;
    extensions = [
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # privacy badger
      "ekhagklcjbdpajgpjgmbionohlpdbjgc" # zotero connector
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      # "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock lite
      "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsorblock
    ];
    extraOpts = {
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "TranslateEnabled" = false;
      "AutofillAddressEnabled" = false;
      "AutofillCreditCardEnabled" = false;
      "AutoplayAllowed" = false;
      "DefaultNotificationSetting" = 2;
      "BackgroundModeEnabled" = false;
      # "DefaultSearchProviderEnabled" = true;
      # "DefaultSearchProviderSearchURL" = "https://google.com/search?q={searchTerms}";
      # "DefaultSearchProviderSearchURL" = "https://duckduckgo.com/?q={searchTerms}";
      "SearchSuggestEnable" = false;
    };
  };
}
