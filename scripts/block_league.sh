#!/usr/bin/env bash
set -euo pipefail

MARKER_START="BLOCK_LEAGUE start (Prep to touch grass.)"
MARKER_END="BLOCK_LEAGUE end (Touch grass now.)"
BACKUP="/etc/hosts.backup.$(date +%Y%m%d-%H%M%S)"

DOMAINS=( # v2, update and add more if I find anything I am missing.
  riotgames.com www.riotgames.com
  riotgames.com news.riotgames.com support.riotgames.com
  playvalorant.com www.playvalorant.com
  wildrift.leagueoflegends.com
  leagueoflegends.com www.leagueoflegends.com
  lolesports.com www.lolesports.com
  auth.riotgames.com account.riotgames.com
  login.riotgames.com api.riotgames.com
  download.riotgames.com downloads.riotcdn.net
  riotcdn.net assets.riotcdn.net
  static.riotgames.com content.riotgames.com
  na.leagueoflegends.com euw.leagueoflegends.com eune.leagueoflegends.com pbe.leagueoflegends.com update-account.riotgames.com
  https://support-leagueoflegends.riotgames.com/
)

echo "Backup /etc/hosts -> $BACKUP - we want no issues later"
sudo cp /etc/hosts "$BACKUP"

TMP="$(mktemp)"
if grep -qF "$MARKER_START" /etc/hosts; then
  awk -v s="$MARKER_START" -v e="$MARKER_END" '
    $0==s {skip=1}
    !skip {print}
    $0==e {skip=0}
  ' /etc/hosts | sudo tee "$TMP" >/dev/null
else
  cat /etc/hosts | sudo tee "$TMP" >/dev/null
fi

{
  echo ""
  echo "$MARKER_START"
  for d in "${DOMAINS[@]}"; do
    echo "0.0.0.0 $d"
    echo "::1 $d"
  done
  echo "$MARKER_END"
} | sudo tee -a "$TMP" >/dev/null

echo "update: /etc/hosts"
sudo cp "$TMP" /etc/hosts
rm -f "$TMP"

echo "flush DNS cache after update: do not forget."
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder || true

echo "Removing League/Riot files. They better not be back."
sudo rm -rf "/Applications/League of Legends.app" \
            "/Applications/Riot Client.app" || true

# user wise Riot data
rm -rf "$HOME/Library/Application Support/Riot Games" \
       "$HOME/Library/Preferences/com.riotgames"* \
       "$HOME/Library/Caches/com.riotgames"* || true

# Testing, cuz all good devs must
echo "If timeout, we good"
curl -I https://riotgames.com --max-time 5 && echo "Reachable -_-" || echo "Naisu"


echo "Dunzo (Not the delivery app, I have been saying this from before that existed)"
echo "ToDo: Screentime block for riot mobile + give Pakhi pin"
