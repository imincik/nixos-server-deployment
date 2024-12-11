{ stdenv
, lib
, python3Packages
}:

stdenv.mkDerivation {
  pname = "website";
  version = "0.1.0";

  src = ./.;

  unpackPhase = "true";

  nativeBuildInputs = with python3Packages; [ markdown ];

  buildPhase = ''
    mkdir build
    python3 -m markdown $src/src/index.md > build/index.html
  '';

  installPhase = ''
    mkdir -p $out
    cp build/* $out/
  '';

  meta = with lib; {
    description = "Example website";
    homepage = "https://github.com/imincik/nixos-server-deployment";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ imincik ];
  };
}
