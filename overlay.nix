final: prev: {
  systemd = prev.systemd.override {
    withSelinux = true;
  };
}
