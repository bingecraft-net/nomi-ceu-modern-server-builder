set -e

# expect mods to be downloaded already
FROM_MODS=ncm-0.1.4-mods.zip

[[ ! -a $FROM_MODS ]] && {
  echo missing $FROM_MODS
  false
}

# install forge server template
FORGE_VERSION=1.20.1-47.2.21
[[ ! -d forge-server-template-$FORGE_VERSION ]] && {
  curl -sL \
    --fail-with-body \
    -o forge-$FORGE_VERSION-installer.jar \
    https://maven.minecraftforge.net/net/minecraftforge/forge/$FORGE_VERSION/forge-$FORGE_VERSION-installer.jar
  java -jar forge-$FORGE_VERSION-installer.jar --installServer forge-server-template-$FORGE_VERSION \
  && rm forge-$FORGE_VERSION-installer.jar.log \
  ; rm forge-$FORGE_VERSION-installer.jar
}

# download pack
[[ ! -d nomi-ceu-modern-0.1.4.zip.d ]] && {
  curl -sL \
    --fail-with-body \
    -o nomi-ceu-modern-0.1.4.zip \
    https://github.com/Nomi-CEu/Nomi-CEu-Modern/releases/download/v0.1.4/Nomi-CEu-Modern-0.1.4.zip
  unzip -d nomi-ceu-modern-0.1.4.zip.d nomi-ceu-modern-0.1.4.zip \
  ; rm nomi-ceu-modern-0.1.4.zip
}

# copy forge server template
cp -r forge-server-template-$FORGE_VERSION server

# add server args
sed -si 's/"$@"$/nogui "$@"/' server/run.sh

# install pack to server
cp -r nomi-ceu-modern-0.1.4.zip.d/overrides/* server

# install pre-downloaded mods to server
unzip -d server/mods ncm-0.1.4-mods.zip

# remove client-side prism instance mods
rm \
  server/mods/citresewn-1.20.1-5.jar \
  server/mods/oculus-mc1.20.1-1.6.15a.jar
