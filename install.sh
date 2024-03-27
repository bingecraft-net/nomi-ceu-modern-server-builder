set -e

# expect mods to be downloaded already
FROM_MODS=$HOME/.local/share/PrismLauncher/instances/Nomi-CEu-Modern-0.1.3b/minecraft/mods

[[ ! -d $FROM_MODS ]] && {
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
[[ ! -d nomi-ceu-modern-0.1.3b.zip.d ]] && {
  curl -sL \
    --fail-with-body \
    -o nomi-ceu-modern-0.1.3b.zip \
    https://github.com/Nomi-CEu/Nomi-CEu-Modern/releases/download/v0.1.3b/Nomi-CEu-Modern-0.1.3b.zip
  unzip -d nomi-ceu-modern-0.1.3b.zip.d nomi-ceu-modern-0.1.3b.zip \
  ; rm nomi-ceu-modern-0.1.3b.zip
}

# download patches
mkdir -p patches

[[ ! -a patches/effortlessbuilding-1.20.1-3.7-all.jar ]] && {
  curl -sL \
    --fail-with-body \
    -o patches/effortlessbuilding-1.20.1-3.7-all.jar \
    https://cdn.modrinth.com/data/DYtfQEYj/versions/BzwWTsxS/effortlessbuilding-1.20.1-3.7-all.jar
}

[[ ! -a patches/miniutilities-4.0.1.jar ]] && {
  curl -sL \
    --fail-with-body \
    -o patches/miniutilities-4.0.1.jar \
    https://github.com/Nomi-CEu/Nomi-CEu-Modern/raw/main/mods/miniutilities-4.0.1.jar
}

# copy forge server template
cp -r forge-server-template-$FORGE_VERSION server

# add server args
sed -si 's/"$@"$/nogui "$@"/' server/run.sh

# install pack to server
cp -r nomi-ceu-modern-0.1.3b.zip.d/overrides/* server

# install pre-downloaded mods to server
cp -r $FROM_MODS server

# downgrade effortlessbuilding
cp patches/effortlessbuilding-1.20.1-3.7-all.jar server/mods
rm server/mods/effortlessbuilding-1.20.1-3.8-all.jar

# patch miniutilities
cp patches/miniutilities-4.0.1.jar server/mods
rm server/mods/miniutilities-4.0.0.jar

# remove client-side prism instance mods
rm \
  server/mods/citresewn-1.20.1-5.jar \
  server/mods/oculus-mc1.20.1-1.6.15a.jar