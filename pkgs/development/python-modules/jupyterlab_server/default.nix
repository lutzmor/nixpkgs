{ lib
, buildPythonPackage
, fetchPypi
, jsonschema
, pythonOlder
, requests
, pytestCheckHook
, pyjson5
, Babel
, jupyter_server
, openapi-core
, pytest-tornasync
, ruamel-yaml
, strict-rfc3339
}:

buildPythonPackage rec {
  pname = "jupyterlab_server";
  version = "2.10.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fb84a5813d6d836ceda773fb2d4e9ef3c7944dbc1b45a8d59d98641a80de80a";
  };

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml
  '';

  propagatedBuildInputs = [ requests jsonschema pyjson5 Babel jupyter_server ];

  checkInputs = [
    openapi-core
    pytestCheckHook
    pytest-tornasync
    ruamel-yaml
    strict-rfc3339
  ];

  pytestFlagsArray = [ "--pyargs" "jupyterlab_server" ];

  disabledTests = [
    # AttributeError: 'SpecPath' object has no attribute 'paths'
    "test_get_listing"
    "test_get_settings"
    "test_get_federated"
    "test_listing"
    "test_patch"
    "test_patch_unicode"
    "test_get_theme"
    "test_delete"
    "test_get_non_existant"
    "test_get"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "JupyterLab Server";
    homepage = "https://jupyter.org";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
