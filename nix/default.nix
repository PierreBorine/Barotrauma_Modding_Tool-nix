{
  lib,
  fetchFromGitHub,
  fetchzip,
  stdenvNoCC,
  dearpygui,
  pyinstaller,
  tkinter,
  colorama,
  pyyaml,
  requests,
  pyperclip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "barotrauma-modding-tool";
  version = "0.2.0";

  src = ../.;
  # src = fetchFromGitHub {
  #   owner = "themanyfaceddemon";
  #   repo = "Barotrauma_Modding_Tool";
  #   rev = version;
  #   hash = "sha256-G6WT3yZNPGL64GfnzbQ8C6t3kOCkguidZ1OPJVxI52g=";
  # };

  release = fetchzip {
    url = "https://github.com/themanyfaceddemon/Barotrauma_Modding_Tool/releases/download/${version}/linux-64bit.zip";
    hash = "sha256-h1ZTaXyapAuzCqpH5wGIXXnD7jxa7q4RtovweWiQkJI=";
  };

  nativeBuildInputs = [pyinstaller];

  buildInputs = [
    tkinter
    colorama
    dearpygui
    pyyaml
    requests
    pyperclip
  ];

  buildPhase = ''
    pyinstaller main.py --add-data=Data:Data
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/main/main $out/bin/${pname}
    cp -r dist/main/_internal $out/bin

    # Required directory. This is a dirty fix, it doesn't get
    # built here, but appears when built on other OSes.
    cp -r ${release}/main/_internal/_tk_data $out/bin/_internal

    runHook postInstall
  '';

  meta = {
    description = "Barotrauma mod loader tool";
    homepage = "https://github.com/themanyfaceddemon/Barotrauma_Modding_Tool";
    license = lib.licenses.gpl3Only;
    mainProgram = pname;
    platforms = lib.platforms.all;
  };
}
