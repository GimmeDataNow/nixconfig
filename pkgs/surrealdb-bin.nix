{ stdenv, fetchzip, autoPatchelfHook, glibc, gcc-unwrapped }: stdenv.mkDerivation rec {
  pname = "surrealdb-bin";
  version = "3.0.1";

  src = fetchzip {
    url = "https://github.com/surrealdb/surrealdb/releases/download/v${version}/surreal-v${version}.linux-amd64.tgz";
    sha256 = "GLYSCONiL4QlW654G11mBsgB37p86sICKLaXcKZ9XmA=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ glibc gcc-unwrapped ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 surreal $out/bin
    runHook postInstall
  '';
}
