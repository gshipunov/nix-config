{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "slick";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "nbari";
    repo = pname;
    rev = version;
    sha256 = "033ecd2696bfd59fd959eb95f66875a45e5aec54";
  };

  cargoSha256 = lib.fakeSha256;

  meta = with lib; {
    description = "Async ZSH prompt";
    homepage = "https://github.com/nbari/slick";
    license = licenses.bsd3;
  };
}
