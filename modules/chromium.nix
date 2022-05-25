{config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # (ungoogled-chromium.override { enableVaapi = true; })
    chromium
  ];

  nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland  --force-dark-mode --enable-features=WebUIDarkMode";

  programs.chromium = {
    enable = true;
    extensions = [
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # privacy badger
      "ekhagklcjbdpajgpjgmbionohlpdbjgc" # zotero connector
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
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
      "DefaultSearchProviderEnabled" = true;
      "DefaultSearchProviderSearchURL" = "https://duckduckgo.com/?q={searchTerms}";
      "SearchSuggestEnable" = false;
    };
  };
}
