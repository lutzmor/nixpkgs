{ lib
, buildPythonPackage
, fetchFromGitHub

# propagates
, django
, jwcrypto
, requests
, oauthlib

# tests
, djangorestframework
, pytest-django
, pytest-xdist
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-oauth-toolkit";
  version = "1.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = version;
    sha256 = "sha256-TOrFxQULwiuwpVFqRwRkfTW+GRudLNy6F/gIjUYjZhI=";
  };

  postPatch = ''
    sed -i '/cov/d' tox.ini
  '';

  propagatedBuildInputs = [
    django
    jwcrypto
    oauthlib
    requests
  ];

  DJANGO_SETTINGS_MODULE = "tests.settings";

  checkInputs = [
    djangorestframework
    pytest-django
    pytest-xdist
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # Failed to get a valid response from authentication server. Status code: 404, Reason: Not Found.
    "test_response_when_auth_server_response_return_404"
  ];

  meta = with lib; {
    description = "OAuth2 goodies for the Djangonauts";
    homepage = "https://github.com/jazzband/django-oauth-toolkit";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mmai ];
  };
}
