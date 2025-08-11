{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "et-bembo";
  version = "unstable-2018-04-11";

  src = fetchFromGitHub {
    owner = "DavidBarts";
    repo = "ET_Bembo";
    rev = "b1824ac5bee3f54ef1ce88c9d6c7850f6c869818";
    hash = "sha256-9G0Umcu5dkwx+mh0k5vPS3nIBdStlR0wBkDVzahVBwg=";
  };

  buildPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp $src/* $out/share/fonts/truetype
  '';

  meta = {
    description = "";
    homepage = "https://github.com/DavidBarts/ET_Bembo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "et-bembo";
    platforms = lib.platforms.all;
  };
}
