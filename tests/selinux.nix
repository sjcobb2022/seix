{
  pkgs,
  self,
  ...
}:
pkgs.testers.nixosTest {
  name = "selinux";

  nodes.machine = {
    imports = [
      self.nixosModules.default
    ];

    nixpkgs.overlays = [
      self.overlays.default
    ];

    security.selinux.enable = true;
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("multi-user.target")

    machine.succeed("getenforce")

    machine.succeed("${pkgs.hello}/bin/hello")
  '';
}
