{ callPackage, pkgs, ... }:

{
  inherit (pkgs) afflib apktool cabextract chkrootkit dcfldd ddrescue;
  autopsy = callPackage ./autopsy { };
  bulk-extrator = callPackage ./bulk-extrator { };
  bytecode-viewer = callPackage ./bytecode-viewer { };
  creddump7 = callPackage ./creddump7 { };
  dc3dd = callPackage ./dc3dd { };
  dumpzilla = callPackage ./dumpzilla { };
}
