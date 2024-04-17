{ stdenv, lib, makeWrapper, fetchzip, callPackage, testdisk, imagemagick, jdk19, findutils, ... }:

let
  version = "4.21.0";
  sleuthkit-jni = callPackage ./sleuthkit-jni.nix { };

  jdk = jdk19.override (lib.optionalAttrs stdenv.isLinux {
    enableJavaFX = true;
  });
in
stdenv.mkDerivation {
  name = "autopsy";
  inherit version;

  buildInputs = [ makeWrapper findutils jdk ];

  src = fetchzip {
    url = "https://github.com/sleuthkit/autopsy/releases/download/autopsy-${version}/autopsy-${version}.zip";
    sha256 = "32iOQA3+ykltCYW/MpqCVxyhh3mm6eYzY+t0smAsWRw=";
  };

  installPhase = ''
    mkdir -p $out
    #rm -rf autopsy/7-Zip
    rm -rf autopsy/aLeapp
    #rm -rf autopsy/ESEDatabaseView
    #rm -rf autopsy/ewfexport_exec
    #rm -rf autopsy/gstreamer
    rm -rf autopsy/iLeapp
    #rm -rf autopsy/ImageMagick*
    #rm autopsy/markmckinnon/*.exe
    #rm autopsy/markmckinnon/*_macos
    #rm -rf autopsy/photorec_exec
    rm -rf autopsy/plaso
    #rm -rf autopsy/rr
    #rm -rf autopsy/rr-full
    #rm -rf autopsy/solr*
    #rm -rf autopsy/Tesseract-OCR
    #rm -rf autopsy/tsk_logical_imager
    #rm -rf autopsy/Volatility
    rm -rf autopsy/yara/*.exe

    cp -r * $out/

    cp ${sleuthkit-jni}/share/java/*.jar $out/autopsy/modules/ext/

    chmod +x $out/bin/autopsy
    find $out -name 'bin' -type d | xargs chmod -R a+x 

    find . -name "*.dll" -delete

    sed -i 's;APPNAME=`basename "$PRG"`;APPNAME=autopsy;g' $out/bin/autopsy

    wrapProgram $out/bin/autopsy --add-flags "--jdkhome ${jdk}" --prefix LD_LIBRARY_PATH : ${sleuthkit-jni}/lib --prefix PATH : ${lib.makeBinPath [ testdisk imagemagick jdk ]}
  '';
}
