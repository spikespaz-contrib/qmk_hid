# Rename to `default.nix` if desired.
{ sourceRoot ? ../., lib, rustPlatform, pkg-config, systemd }:
let manifest = lib.importTOML "${sourceRoot}/Cargo.toml";
in rustPlatform.buildRustPackage {
  strictDeps = true;
  pname = manifest.package.name;
  version = manifest.package.version;
  cargoLock.lockFile = "${sourceRoot}/Cargo.lock";
  src = lib.cleanSource sourceRoot;

  buildInputs = [ systemd ];
  nativeBuildInputs = [ pkg-config ];

  checkFlags = [
    # test doesn't compile
    "--skip=src/lib.rs"
  ];

  meta = {
    inherit (manifest.package) description homepage;
    license = with lib.licenses; [ bsd3 ];
    platforms = lib.platforms.unix;
    mainProgram = manifest.package.name;
  };
}
