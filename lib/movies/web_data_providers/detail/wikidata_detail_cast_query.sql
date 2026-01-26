SELECT 
  ?movieIMDB
  (SAMPLE(?movieLabel) AS ?movieName)
  ?actorIMDB
  (SAMPLE(?actorLabel) AS ?actorName)
  (GROUP_CONCAT(DISTINCT ?genderLabel; separator=", ") AS ?genders)
  (MIN(?dob) AS ?birthDate)
  (MAX(?dod) AS ?deathDate)
  (GROUP_CONCAT(DISTINCT ?charName; separator=", ") AS ?characterNames)


  # --- IMAGE URLS ---
  (SAMPLE(?imageHighRes) AS ?highResPhoto) # Original Full Quality
  (SAMPLE(?imageLowRes) AS ?lowResPhoto)   # 300px Thumbnail

  
  # --- DYNAMIC FQDN URL GENERATION FOR PERSONS ---
  (SAMPLE(?letterboxdURL) AS ?letterboxdLink) # P6119
  (SAMPLE(?omdbURL) AS ?omdbLink)             # P12644 
  (SAMPLE(?tvdbURL) AS ?theTVDBLink)          # P4835 
  (SAMPLE(?tmdbURL) AS ?tmdbLink)             # P2949 
  (SAMPLE(?plexURL) AS ?plexLink)             # P12854 
  (SAMPLE(?threadsURL) AS ?threadsLink)       # P11892
  (SAMPLE(?prabookURL) AS ?prabookLink)       # P3368 / P3365
  (SAMPLE(?nndbURL) AS ?nndbLink)             # P3845
  (SAMPLE(?tvdotcomURL) AS ?tvDotComLink)     # P2638
  (SAMPLE(?twitterURL) AS ?twitterLink)       # P2002
  (SAMPLE(?facebookURL) AS ?facebookLink)     # P2003
  (SAMPLE(?instagramURL) AS ?instagramLink)   # P2008

WHERE {
  # 1. INPUT: IMDb Movie IDs
  VALUES ?movieIMDB { 
    "tt13443470" "tt0133093" "tt0110912" "tt0111161" "tt0068646" "tt0108052" 
    "tt0167260" "tt0137523" "tt0080684" "tt0114709" "tt0468569" 
  }
  
  # 2. MATCH: Movie to Actor
  ?movie wdt:P345 ?movieIMDB.
  ?movie p:P161 ?castStatement.
  ?castStatement ps:P161 ?actor.
  
  # 3. CHARACTER NAMES (Qualifiers)
  OPTIONAL { 
    ?castStatement pq:P453 ?character. 
    ?character rdfs:label ?charName. FILTER(LANG(?charName) = "en")
  }

  # 4. CORE ACTOR DATA
  # --- CORE DATA ---
  OPTIONAL { ?actor wdt:P345 ?actorIMDB. }
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

  
  # 5. FQDN CONSTRUCTION (PERSON-SPECIFIC PROPERTIES)
  OPTIONAL { ?actor wdt:P6119 ?lbx. BIND(CONCAT("https://letterboxd.com/person/", ?lbx, "/") AS ?letterboxdURL) }
  OPTIONAL { ?actor wdt:P12644 ?omdb. BIND(CONCAT("https://www.omdb.org/person/", ?omdb, "/") AS ?omdbURL) }
  OPTIONAL { ?actor wdt:P4835 ?tvdb. BIND(CONCAT("https://thetvdb.com/person/", ?tvdb) AS ?tvdbURL) }
  OPTIONAL { ?actor wdt:P2949 ?tmdb. BIND(CONCAT("https://www.themoviedb.org/person/", ?tmdb) AS ?tmdbURL) }
  OPTIONAL { ?actor wdt:P12854 ?plex. BIND(CONCAT("https://watch.plex.tv/person/", ?plex) AS ?plexURL) }
  OPTIONAL { ?actor wdt:P11892 ?th. BIND(CONCAT("https://www.threads.net/user/", ?th) AS ?threadsURL) }
  OPTIONAL { ?actor wdt:P3845 ?nndb. BIND(CONCAT("http://www.nndb.com/people/", ?nndb, "/") AS ?nndbURL) }
  
  # Legacy & Socials
  OPTIONAL { ?actor wdt:P2638 ?tvd. BIND(CONCAT("http://www.tv.com/people/", ?tvd, "/") AS ?tvdotcomURL) }
  OPTIONAL { ?actor wdt:P2002 ?twt. BIND(CONCAT("https://twitter.com/", ?twt) AS ?twitterURL) }
  OPTIONAL { ?actor wdt:P2003 ?fb. BIND(CONCAT("https://www.facebook.com/", ?fb) AS ?facebookURL) }
  OPTIONAL { ?actor wdt:P2008 ?ig. BIND(CONCAT("https://www.instagram.com/", ?ig) AS ?instagramURL) }

  # Prabook (P3368 or P3365 logic)
  OPTIONAL { 
    { ?actor wdt:P3368 ?praID. } UNION { ?actor wdt:P3365 ?praID. }
    BIND(CONCAT("https://prabook.com/web/person-view.html?profileId=", ?praID) AS ?prabookURL) 
  }

  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
}
GROUP BY ?movieIMDB ?actorIMDB
ORDER BY ?movieIMDB ?actorName
