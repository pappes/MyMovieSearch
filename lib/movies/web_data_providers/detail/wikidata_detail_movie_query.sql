# -- manual query runner = https://query.wikidata.org/

# -- Wikidata Media Types & QIDs (P31/P279*)

# -- When querying media via IMDb IDs, Wikidata items typically fall into these hierarchies. Using wdt:P279* (subclass of) ensures that if an item is labeled as a "Slasher Film," it is still caught by the "Film" (Q11424) filter.


# -- 1. Motion Picture & Video Variations
# -- Feature Film (wd:Q11424): The standard cinematic movie, Includes feature films, slasher films, documentaries, etc.
# -- Television Movie (wd:Q506240): Movies produced specifically for TV.
# -- Silent Film (wd:Q226730): Historic cinema.
# -- Direct-to-video (wd:Q120243801): Movies that skipped theatrical release.
# -- Television Special (wd:Q4414442): One-off events (e.g., The Star Wars Holiday Special).
# -- Documentary Film (wd:Q93204): Non-fiction cinema.


# -- 2. Television & Episodic Content
# -- Miniseries (wd:Q125922): Limited series (e.g., Chernobyl).
# -- Animated Film (wd:Q11073): Used for Pixar, Disney, etc.
# -- Animated Series (wd:Q581714): Cartoon shows.
# -- Soap Opera (wd:Q474441): Long-running daytime dramas.
# -- Television Series (wd:Q5398426): The general bucket for shows.
# -- Television Episode (wd:Q19830628): Individual entries (IMDb tt IDs for specific episodes).
# -- Web Series (wd:Q2031124): Content produced for YouTube, Netflix, etc.

# -- 3. Modern & Short-Form Media
# -- Music Video (wd:Q193916): Used for music-based tt IDs.
# -- Play (wd:Q40446): Theatrical productions.
# -- Concert Film (wd:): Filmed live performances.
# -- Musical (wd:Q2743): Musical theater.
# -- Opera (wd:Q1344): Classical performance.
# -- Short Film (wd:Q24862): Usually under 40 minutes.
# -- Video Game (wd:Q7889): IMDb tracks games (e.g., The Last of Us has tt IDs for the game and the show).


#  -- (SAMPLE(?isMovie) AS ?isMovie)
#  -- (SAMPLE(?isTV) AS ?isTV)
#  -- (SAMPLE(?isSilent) AS ?isSilent)
#  -- (SAMPLE(?isDirect) AS ?isDirect)
#  -- (SAMPLE(?isSpecial) AS ?isSpecial)
#  -- (SAMPLE(?isDoc) AS ?isDoc)
#  -- (SAMPLE(?isMiniseries) AS ?isMiniseries)
#  -- (SAMPLE(?isAnimated) AS ?isAnimated)
#  -- (SAMPLE(?isAnimatedSeries) AS ?isAnimatedSeries)
#  -- (SAMPLE(?isSoapOpera) AS ?isSoapOpera)
#  -- (SAMPLE(?isSeries) AS ?isSeries)
#  -- (SAMPLE(?isEpisode) AS ?isEpisode)
#  -- (SAMPLE(?isWebSeries) AS ?isWebSeries)
#  -- (SAMPLE(?isMusicVideo) AS ?isMusicVideo)
#  -- (SAMPLE(?isPlay) AS ?isPlay)
#  -- (SAMPLE(?isConcert) AS ?isConcert)
#  -- (SAMPLE(?isMusical) AS ?isMusical)
#  -- (SAMPLE(?isOpera) AS ?isOpera)
#  -- (SAMPLE(?isShort) AS ?isShort)
#  -- (SAMPLE(?isVideoGame) AS ?isVideoGame)


#  -- # Flags for URL logic
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q11424 } AS ?isMovie)    # Film
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q506240 } AS ?isTV)      # TV Movie
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q226730 } AS ?isSilent)   # Silent Film
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q120243801 } AS ?isDirect)# Direct-to-Video
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q4414442 } AS ?isSpecial) # TV Special
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q93204 } AS ?isDoc)       # Documentary
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q125922 } AS ?isMiniseries) # Miniseries
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q11073 } AS ?isAnimated)  # Animated Film
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q581714 } AS ?isAnimatedSeries) # Animated Series
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q474441 } AS ?isSoapOpera) # Soap Opera
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q5398426 } AS ?isSeries)  # TV Series
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q19830628 } AS ?isEpisode) # TV Episode
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q2031124 } AS ?isWebSeries)# Web Series
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q193916 } AS ?isMusicVideo) # Music Video
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q40446 } AS ?isPlay)      # Play
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q120243801 } AS ?isConcert)# Concert Film
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q2743 } AS ?isMusical)    # Musical
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q1344 } AS ?isOpera)      # Opera
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q24862 } AS ?isShort)    # Short Film
#  -- BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q7889 } AS ?isVideoGame) # Video Game







SELECT 
  ?movieIMDB
  (?movieLabel AS ?movieName)
  (?movieDescription AS ?descriptions)
# --- NEW: TYPE IDENTIFICATION ---
  (GROUP_CONCAT(DISTINCT ?typeLabel; separator=", ") AS ?contentTypes)
  (GROUP_CONCAT(DISTINCT ?typeQID; separator=" ") AS ?typeQIDs)
  (GROUP_CONCAT(DISTINCT ?networkLabel; separator=", ") AS ?networkLabels)
  
  (SAMPLE(?certLabel) AS ?rating)
  (MIN(?startDate) AS ?firstAired)
  (MAX(?endDate) AS ?lastAired)
  (MIN(?runtime) AS ?averageRuntime)
  
# --- DYNAMIC FQDN URL GENERATION ---
  (SAMPLE(?tmdbURL) AS ?tmdbLink)
  (SAMPLE(?tvdbSeriesURL) AS ?theTVDBLink)
  (SAMPLE(?tvdbMovieURL) AS ?theTVDBMovieLink)
  (SAMPLE(?networkLabel) AS ?originalNetwork)
  (SAMPLE(?kymURL) AS ?knowYourMemeLink)
  (SAMPLE(?filmAffinityURL) AS ?filmAffinityLink)
  (SAMPLE(?metacriticURL) AS ?metacriticLink)
  (SAMPLE(?netflixURL) AS ?netflixLink)
  (SAMPLE(?rtURL) AS ?rottenTomatoesLink)
  (SAMPLE(?tvTropesURL) AS ?tvTropesLink)
  (SAMPLE(?twitterURL) AS ?twitterLink)
  (SAMPLE(?youtubeURL) AS ?youtubeLink)
  (SAMPLE(?facebookURL) AS ?facebookLink)
  (SAMPLE(?letterboxdURL) AS ?letterboxdLink)
  (SAMPLE(?lezWatchURL) AS ?lezWatchLink)
  (SAMPLE(?plexURL) AS ?plexLink)
  (SAMPLE(?ratingGraphURL) AS ?ratingGraphLink)
  (SAMPLE(?tvMazeURL) AS ?tvMazeLink)
  


WHERE {
# INPUT: Your list of IMDb IDs
  VALUES ?movieIMDB { 
    "tt000" 
  }
  
# MATCH: Find the Wikidata item
  ?movie wdt:P345 ?movieIMDB.

# Fetch english label for the movie
OPTIONAL {
?movie rdfs:label ?movieLabel.
FILTER(LANG(?movieLabel) = "en")
}
  
# IDENTIFY TYPE: Check if its a Movie or TV Series for path logic
# --- TYPE LOGIC ---
  ?movie wdt:P31 ?type.
  
# strip URL from movie type ID
BIND(REPLACE(STR(?type), "^.*/", "") AS ?typeQID)

# Flags for URL logic
  BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q11424 } AS ?isMovie)    # Film
  BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q5398426 } AS ?isSeries)  # TV Series
  BIND(EXISTS { ?movie wdt:P31/wdt:P279* wd:Q19830628 } AS ?isEpisode) # TV Episode
# DATA EXTRACTION & FQDN CONSTRUCTION
  
# TMDb: Uses separate properties for Movie (P4947) and TV (P4983)
  OPTIONAL { ?movie wdt:P4947 ?tmdbID_M. }
  OPTIONAL { ?movie wdt:P4983 ?tmdbID_S. }
  BIND(IF(BOUND(?tmdbID_M), CONCAT("https://www.themoviedb.org/movie/", ?tmdbID_M),
       IF(BOUND(?tmdbID_S), CONCAT("https://www.themoviedb.org/tv/", ?tmdbID_S), "")) AS ?tmdbURL)

# TheTVDB Logic
# TheTVDB (P4835): One property, but path changes based on P31 type
  OPTIONAL { ?movie wdt:P4835 ?tvdbSeriesID. }
  BIND(IF(?isSeries || ?isEpisode , CONCAT("https://thetvdb.com/dereferrer/series/", ?tvdbSeriesID),
       IF(?isMovie , CONCAT("https://thetvdb.com/dereferrer/movie/", ?tvdbSeriesID), 
       CONCAT("https://thetvdb.com/dereferrer/series/", ?tvdbSeriesID))) AS ?tvdbSeriesURL)
  OPTIONAL { ?movie wdt:P12196 ?tvdbMovieID. }
  BIND(IF(?isSeries || ?isEpisode , CONCAT("https://thetvdb.com/dereferrer/series/", ?tvdbMovieID),
       IF(?isMovie , CONCAT("https://thetvdb.com/dereferrer/movie/", ?tvdbMovieID), 
       CONCAT("https://thetvdb.com/dereferrer/movies/", ?tvdbMovieID))) AS ?tvdbMovieURL)

# Static URL structures (Simple concatenation)
  OPTIONAL { ?movie wdt:P13484 ?kym. BIND(CONCAT("https://knowyourmeme.com/memes/", ?kym) AS ?kymURL) }
  OPTIONAL { ?movie wdt:P1712 ?metacritic. BIND(CONCAT("https://www.metacritic.com/", ?metacritic) AS ?metacriticURL) }
  OPTIONAL { ?movie wdt:P480 ?filmAffinity. BIND(CONCAT("https://www.filmaffinity.com/en/film", ?filmAffinity, ".html") AS ?filmAffinityURL) }
  OPTIONAL { ?movie wdt:P1874 ?nflx. BIND(CONCAT("https://www.netflix.com/title/", ?nflx) AS ?netflixURL) }
  OPTIONAL { ?movie wdt:P1258 ?rt. BIND(CONCAT("https://www.rottentomatoes.com/", ?rt) AS ?rtURL) }
  OPTIONAL { ?movie wdt:P6839 ?tvt. BIND(CONCAT("https://tvtropes.org/pmwiki/pmwiki.php/", ?tvt) AS ?tvTropesURL) }
  OPTIONAL { ?movie wdt:P2002 ?twt. BIND(CONCAT("https://twitter.com/", ?twt) AS ?twitterURL) }
  OPTIONAL { ?movie wdt:P1651 ?yt. BIND(CONCAT("https://www.youtube.com/watch?v=", ?yt) AS ?youtubeURL) }
  OPTIONAL { ?movie wdt:P2003 ?fb. BIND(CONCAT("https://www.facebook.com/", ?fb) AS ?facebookURL) }
  OPTIONAL { ?movie wdt:P3106 ?lbx. BIND(CONCAT("https://letterboxd.com/film/", ?lbx) AS ?letterboxdURL) }
  OPTIONAL { ?movie wdt:P7107 ?lw. BIND(CONCAT("https://lezwatchtv.com/show/", ?lw) AS ?lezWatchURL) }
  OPTIONAL { ?movie wdt:P11460 ?plex. BIND(CONCAT("https://app.plex.tv/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/", ?plex) AS ?plexURL) }
  OPTIONAL { ?movie wdt:P12544 ?rg. BIND(CONCAT("https://www.ratingraph.com/tv-shows/", ?rg) AS ?ratingGraphURL) }
  OPTIONAL { ?movie wdt:P8600 ?tvm. BIND(CONCAT("https://tvmaze.com/shows/", ?tvm) AS ?tvMazeURL) }

# Metadata
  OPTIONAL { ?movie wdt:P449 ?network. }
  OPTIONAL { ?movie p:P1657 [ ps:P1657 ?cert; pq:P17 wd:Q30 ]. }
  OPTIONAL { ?movie wdt:P577 ?startDate. }
  OPTIONAL { ?movie wdt:P582 ?endDate. }
  OPTIONAL { ?movie wdt:P2047 ?runtime. }

# 3. Label Service with Fallback Chain
# "en" is primary, mul = multiple, "[AUTO_LANGUAGE]" or others follow as fallbacks.

SERVICE wikibase:label {
  bd:serviceParam wikibase:language "en, mul, [AUTO_LANGUAGE], *".
    ?type rdfs:label ?typeLabel.
    ?cert rdfs:label ?certLabel.
    ?network rdfs:label ?networkLabel.
    ?movie rdfs:label ?movieLabel.
    ?movie schema:description ?movieDescription.
  }
}
GROUP BY ?movieIMDB ?movieLabel ?movieDescription
ORDER BY ?movieIMDB