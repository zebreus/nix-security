{ stdenv, lib, makeWrapper, fetchzip, symlinkJoin, callPackage, testdisk, imagemagick, openjfx8, jdk8, findutils, ... }:

let
  version = "4.18.0";
  sleuthkit-jni = callPackage ./sleuthkit-jni.nix { };
  openjdk8-fx = symlinkJoin {
    name = "jdk-jfx8";
    paths = [ ];
    postBuild = ''
      cp -r ${jdk8.jre}/* $out/
      chmod -R +rw $out
      cp -r ${openjfx8}/rt/lib/* $out/lib/openjdk/jre/lib
    '';
  };
in
stdenv.mkDerivation {
  name = "autopsy";
  inherit version;

  buildInputs = [ makeWrapper findutils ];

  src = fetchzip {
    url = "https://github.com/sleuthkit/autopsy/releases/download/autopsy-${version}/autopsy-${version}.zip";
    sha256 = "fgPGX8BI0O0SzpSLkIp1mG6RSwWvOe/f4ZuFhU0Bel4=";
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

    wrapProgram $out/bin/autopsy --add-flags "--jdkhome ${openjdk8-fx}" --prefix LD_LIBRARY_PATH : ${sleuthkit-jni}/lib --prefix PATH : ${lib.makeBinPath [ testdisk imagemagick ]}
  '';
}
