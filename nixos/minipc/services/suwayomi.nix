{
  services.suwayomi-server = {
    enable = true;
    openFirewall = true;
    settings.server = {
      port = 4567;
      extensionRepos = ["https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"];
    };
  };
}
