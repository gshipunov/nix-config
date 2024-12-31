{ gcc12Stdenv
, lib
, cmake
, ccache
, glfw
, glm
, magic-vlsi
, mbedtls
, freetype
, dbus
, capstone
, openssl
, pkg-config
, lld
, libGL
, wrapQtAppsHook
, fetchFromGitHub
}:
gcc12Stdenv.mkDerivation rec {
  pname = "imhex";
  version = "1.26.2";

  src = fetchFromGitHub {
    owner = "WerWolv";
    repo = "ImHex";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-H2bnRByCUAltngmVWgPW4vW8k5AWecOAzwtBKsjbpTw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lld
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    # "-DCMAKE_INSTALL_PREFIX="/usr""
    "-DCMAKE_C_COMPILER_LAUNCHER=ccache"
    "-DCMAKE_CXX_COMPILER_LAUNCHER=ccache"
    "-DCMAKE_C_FLAGS=-fuse-ld=lld"
    "-DCMAKE_CXX_FLAGS=-fuse-ld=lld"
    "-DCMAKE_OBJC_COMPILER_LAUNCHER=ccache"
    "-DCMAKE_OBJCXX_COMPILER_LAUNCHER=ccache"

    # looks like the cmake here tries to be "helpful"...
    "-DFREETYPE_LIBRARY=${freetype.dev}"
    "-DFREETYPE_INCLUDE_DIRS=${freetype.dev}"
    "-DOPENGL_opengl_LIBRARY=${libGL.dev}"
    "-DOPENGL_glx_LIBRARY=${libGL.dev}"
    "-DOPENGL_INCLUDE_DIR=${libGL.dev}"
    "-DMBEDTLS_LIBRARY=${mbedtls}"
    "-DMBEDTLS_INCLUDE_DIRS=${mbedtls}"
    "-DMBEDX509_LIBRARY=${mbedtls}"
    "-DMBEDCRYPTO_LIBRARY=${mbedtls}"

    "-DCMAKE_PREFIX_PATH=${glfw}"
    "-DCMAKE_LIBRARY_PATH=${magic-vlsi}"
    "-DCMAKE_PREFIX_PATH=${dbus.dev}"
  ];

  BuildInputs = [
    ccache
    glfw
    glm
    magic-vlsi
    mbedtls
    freetype
    dbus
    openssl
    capstone
    libGL
  ];
}
