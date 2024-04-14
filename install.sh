set -e

# download pack and expect mods to be downloaded already
PACK_VERSION=v6
PACK_ZIP=nomi-ceu-modern-$PACK_VERSION.zip
PACK_DIR=nomi-ceu-modern-$PACK_VERSION.d
PACK_MODS_ZIP=nomi-ceu-modern-$PACK_VERSION-mods.zip
[[ ! -d $PACK_DIR ]] && {
  curl -sLO https://github.com/bingecraft-net/nomi-ceu-modern-zip/releases/download/$PACK_VERSION/$PACK_ZIP
  unzip -d $PACK_DIR $PACK_ZIP
  rm $PACK_ZIP
}

[[ ! -a $PACK_MODS_ZIP ]] && {
  echo missing $PACK_MODS_ZIP 
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

# copy forge server template
cp -r forge-server-template-$FORGE_VERSION server

# add server args
sed -si 's/"$@"$/nogui "$@"/' server/run.sh

# install pack to server
cp -r $PACK_DIR/overrides/* server

# install pre-downloaded mods to server
unzip -nd server/mods $PACK_MODS_ZIP

# remove client-side prism instance mods
rm \
  server/mods/citresewn-*.jar \
  server/mods/emi-*.jar \
  server/mods/emi_loot-*.jar \
  server/mods/oculus-*.jar

# install default server properties and whitelist
cp server.properties server
cp whitelist.json server

# link backups
ln -s ../../nomi-ceu-modern-backups server/backups

# unpack latest world backup
backup=$(ls -Av server/backups/*.zip | tail -1)
unzip -d server $backup
