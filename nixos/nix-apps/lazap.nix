{ stdenv, hello, openssl }:
stdenv.mkDerivation {
  # ...
  # things used in the build go in here
  nativeBuildInputs = [ hello ];
  # libraries used by the resulting program go in here
  buildInputs = [ openssl ];
}
