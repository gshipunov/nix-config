{ stdenv, lib, cmake, openssl, pkgconfig, wrapQtAppsHook, fetchFromGithub }:
stdenv.mkDerivation rec {
  pname = "imhex";
  version = "1.24.3";

  src = fetchFromGithub {
    owner = "WerWolv";
    repo = "ImHex";
    rev = "v${version}";
    sha256 = lib.fakeSha256;
  };

  nativeBuildInputs = [
    cmake
  ];
}
