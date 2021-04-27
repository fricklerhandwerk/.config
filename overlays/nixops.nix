self: super: {
  nixops = (import (fetchTarball {
    url = "https://github.com/NixOS/nixops/archive/1ed5a091bc52de6c91319f446f833018a1cb326e.tar.gz";
    sha256 = "1fx17qv9cl7hz7322zh4xlg02xn7bwwjj82cdcvqpsjf83crz3xi";
  })).default;
}
