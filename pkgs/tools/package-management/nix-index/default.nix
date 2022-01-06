{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "unstable-2021-11-13";

  src = fetchFromGitHub {
    owner = "bennofs";
    repo = "nix-index";
    rev = "2b0773a7bd1252714285c0bcf591747db47e157e";
    sha256 = "sha256-eP/o0GdZYSAE6MEi07uMkvuTb0Rxq4LZRGMERipE8oE=";
  };

  cargoSha256 = "sha256-CPxpL5qWCC34cA5th45NATzBtrDbpf4R2rGVhaqQEGo=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl curl ]
    ++ lib.optional stdenv.isDarwin Security;

  doCheck = !stdenv.isDarwin;

  postInstall = ''
    mkdir -p $out/etc/profile.d
    cp ./command-not-found.sh $out/etc/profile.d/command-not-found.sh
    substituteInPlace $out/etc/profile.d/command-not-found.sh \
      --replace "@out@" "$out"
  '';

  meta = with lib; {
    description = "A files database for nixpkgs";
    homepage = "https://github.com/bennofs/nix-index";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ bennofs ncfavier ];
  };
}
