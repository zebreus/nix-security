{ callPackage, pkgs, ... }:

let
  oldBluez = callPackage ./oldBluez {};
in {
  inherit (pkgs) bluez;
  bluelog = callPackage ./bluelog { };
  blueranger = callPackage ./blueranger {  inherit oldBluez; };
  bluesnarfer = callPackage ./bluesnarfer { };
  bluez-hcidump = oldBluez;
  btscanner = callPackage ./btscanner { };
}