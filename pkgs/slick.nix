{ stdenv, lib, openssl, pkgconfig, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "slick";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "nbari";
    repo = pname;
    rev = version;
    sha256 = "sha256-GM9OHnySc3RVkfaK7yMf1LqpGdz3emq2H/3tSAph4jw=";
  };

  buildInputs = [ openssl pkgconfig ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "sha256-2WxFprq+AcXGXDMjMQvqKTkeWQEWM/z2Fz6qYPtSFGw=";

  meta = with lib; {
    description = "Async ZSH prompt";
    homepage = "https://github.com/nbari/slick";
    license = licenses.bsd3;
  };
}
