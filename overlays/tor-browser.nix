self: super: {
  tor-browser = super.unstable.tor-browser-bundle-bin.override {
    mediaSupport = true;
    pulseaudioSupport = true;
  };
}

