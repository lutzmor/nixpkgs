{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "mmctl";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mmctl";
    rev = "v${version}";
    sha256 = "sha256-DhkBiczQ+4iwoufHMuy6Fn3a4q7gvkKGXTfLcUCCKis=";
  };

  vendorSha256 = null;

  checkPhase = "make test";

  meta = with lib; {
    description = "A remote CLI tool for Mattermost";
    homepage = "https://github.com/mattermost/mmctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ ppom ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
