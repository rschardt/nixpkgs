{ stdenv, intltool, fetchurl, vala
, pkgconfig, gtk3, glib
, wrapGAppsHook, itstool, gnupg, libsoup
, gnome3, gpgme
, libsecret, avahi, p11-kit, openssh }:

let
  pname = "seahorse";
  version = "3.29.92";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1037ckkylnc1swjcsrv8c6y8x4wlcd9g68cb6y4j50krif5505m4";
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [ pkgconfig vala intltool itstool wrapGAppsHook ];
  buildInputs = [
    gtk3 glib gnome3.gcr
    gnome3.gsettings-desktop-schemas gnupg
    gnome3.defaultIconTheme gpgme
    libsecret avahi libsoup p11-kit
    openssh
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Seahorse;
    description = "Application for managing encryption keys and passwords in the GnomeKeyring";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
