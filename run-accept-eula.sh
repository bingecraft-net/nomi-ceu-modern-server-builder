export JAVA_HOME=/usr/lib/jvm/java-17-openjdk

cd server && ./run.sh ; cd -
grep EULA server/logs/latest.log && ./accept-eula.sh && cd server && ./run.sh
