SELECT 
  ?actorIMDB
  (SAMPLE(?actorLabel) AS ?actorName)
  (GROUP_CONCAT(DISTINCT ?genderLabel; separator=", ") AS ?genders)
  (MIN(?dob) AS ?birthDate)
  (MAX(?dod) AS ?deathDate)
  
  # --- IMAGE URLS ---
  (SAMPLE(?imageHighRes) AS ?highResPhoto) # Original Full Quality
  (SAMPLE(?imageLowRes) AS ?lowResPhoto)   # 300px Thumbnail

  # --- DYNAMIC FQDN URL GENERATION ---
  (SAMPLE(?letterboxdURL) AS ?letterboxdLink) # P6119
  (SAMPLE(?omdbURL) AS ?omdbLink)             # P12644
  (SAMPLE(?tvdbURL) AS ?theTVDBLink)          # P4835
  (SAMPLE(?tmdbURL) AS ?tmdbLink)             # P2949
  (SAMPLE(?plexURL) AS ?plexLink)             # P12854
  (SAMPLE(?threadsURL) AS ?threadsLink)       # P11892
  (SAMPLE(?prabookURL) AS ?prabookLink)       # P3368
  (SAMPLE(?nndbURL) AS ?nndbLink)             # P3845
  (SAMPLE(?tvdotcomURL) AS ?tvDotComLink)     # P2638
  (SAMPLE(?twitterURL) AS ?twitterLink)       # P2002

WHERE {
  # 1. INPUT: IMDb Person (NM) IDs
  VALUES ?actorIMDB { 
    "nm0000206" "nm0000106" "nm0000151" "nm0405103" "nm0000158" 
  }
  
  # 2. MATCH: Find the Wikidata item via the Person IMDb ID (P345)
  ?actor wdt:P345 ?actorIMDB.
  
  # 3. CORE DATA
  # --- CORE DATA ---
  OPTIONAL { ?actor wdt:P21 ?gender. }
  OPTIONAL { ?actor wdt:P569 ?dob. }
  OPTIONAL { ?actor wdt:P570 ?dod. }

  # --- IMAGE LOGIC ---
  OPTIONAL { 
    ?actor wdt:P18 ?photo. 
    # Extract filename from the Wikidata URI
    BIND(REPLACE(STR(?photo), "http://commons.wikimedia.org/wiki/Special:FilePath/", "") AS ?fileName)
    # URL encode spaces to underscores (required for Wikimedia URLs)
    BIND(REPLACE(?fileName, " ", "_") AS ?safeFileName)
    # Generate MD5 hash of the filename to find the directory structure
    BIND(STR(MD5(?safeFileName)) AS ?hash)
    
    # Construct High Res (Original)
    BIND(CONCAT("https://upload.wikimedia.org/wikipedia/commons/", SUBSTR(?hash, 1, 1), "/", SUBSTR(?hash, 1, 2), "/", ?safeFileName) AS ?imageHighRes)
    
    # Construct Low Res (300px Thumbnail)
    BIND(CONCAT("https://upload.wikimedia.org/wikipedia/commons/thumb/", SUBSTR(?hash, 1, 1), "/", SUBSTR(?hash, 1, 2), "/", ?safeFileName, "/300px-", ?safeFileName) AS ?imageLowRes)
  }
  
  # 4. FQDN CONSTRUCTION
  OPTIONAL { ?actor wdt:P6119 ?lbx. BIND(CONCAT("https://letterboxd.com/person/", ?lbx, "/") AS ?letterboxdURL) }
  OPTIONAL { ?actor wdt:P12644 ?omdb. BIND(CONCAT("https://www.omdb.org/person/", ?omdb, "/") AS ?omdbURL) }
  OPTIONAL { ?actor wdt:P4835 ?tvdb. BIND(CONCAT("https://thetvdb.com/person/", ?tvdb) AS ?tvdbURL) }
  OPTIONAL { ?actor wdt:P2949 ?tmdb. BIND(CONCAT("https://www.themoviedb.org/person/", ?tmdb) AS ?tmdbURL) }
  OPTIONAL { ?actor wdt:P12854 ?plex. BIND(CONCAT("https://watch.plex.tv/person/", ?plex) AS ?plexURL) }
  OPTIONAL { ?actor wdt:P11892 ?thID. BIND(CONCAT("https://www.threads.net/user/", ?thID) AS ?threadsURL) }
  OPTIONAL { ?actor wdt:P3368 ?pra. BIND(CONCAT("https://prabook.com/web/person-view.html?profileId=", ?pra) AS ?prabookURL) }
  OPTIONAL { ?actor wdt:P3845 ?nndb. BIND(CONCAT("http://www.nndb.com/people/", ?nndb, "/") AS ?nndbURL) }
  OPTIONAL { ?actor wdt:P2638 ?tvd. BIND(CONCAT("http://www.tv.com/people/", ?tvd, "/") AS ?tvdotcomURL) }
  OPTIONAL { ?actor wdt:P2002 ?twt. BIND(CONCAT("https://twitter.com/", ?twt) AS ?twitterURL) }

  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
}
GROUP BY ?actorIMDB
ORDER BY ?actorName