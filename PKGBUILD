# Maintainer: David B. Adrian <dawidh.adrian AT gmail DOT com>
# _pkgname=zest
_pkgname=fluttertest
pkgname=$_pkgname-recipes-git
pkgver=v0.5.5
pkgrel=1
pkgdesc="A recipe app"
url="https://github.com/dbadrian/fluttertest"
arch=('x86_64')
license=('-')
makedepends=('git' 'flutter' 'libsecret')
# source=("$_pkgname::git+git@github.com:dbadrian/fluttertest.git")
source=("git+https://github.com/dbadrian/fluttertest.git")
sha1sums=('SKIP')

provides=('zest')
# conflicts=('zest')

# pkgver() {
#     cd "$srcdir/$_pkgname"
#     git describe --tags | sed 's/_/./g;s/-/+/g' 
# }

prepare() {
    cd "$srcdir/$_pkgname"
    # git checkout $pkgver
}

build() {
    # cd "$srcdir/$_pkgname/frontend"
    cd "$srcdir/$_pkgname"
    flutter pub get
    flutter pub add dev:build_runner
    flutter packages pub run build_runner build
    flutter --disable-analytics
    flutter config --enable-linux-desktop
    flutter build linux --release
}

package() {
    # cd "$srcdir/$_pkgname/frontend/build/linux/x64/release/bundle"
    cd "$srcdir/$_pkgname/build/linux/x64/release/bundle"

    install -dm755 "${pkgdir}/opt/${_pkgname}"
    install -dm755 "${pkgdir}/usr/bin"

    cp -r * "$pkgdir/opt/$_pkgname/"
	ln -s "/opt/$_pkgname/$_pkgname" $pkgdir/usr/bin/$_pkgname
}
