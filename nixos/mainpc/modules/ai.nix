{ pkgs, unstable, ...}: {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    openFirewall = true;
  };
  services.open-webui = {
    enable = true;
    openFirewall = true;
    environment = {
      # NLTK_DATA = "/home/hallow/.cache/nltk";
      # DATA_DIR = "/home/hallow/.cache/nltk";
    };
    
  };
}
