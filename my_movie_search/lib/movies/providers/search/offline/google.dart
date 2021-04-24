import 'dart:async';

//query string https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&q=wonder&safe=off&key=<key>
//json format
//title = title (Year) - Source
//pagemap.metatags.pageid = unique key
//undefined = year
//pagemap.metatags.og:type = title type
//pagemap.metatags.og:image = image url
//pagemap.aggregaterating.ratingvalue = userRating
//pagemap.aggregaterating.ratingcount = userRatingCount

/*

{kind: customsearch#search, url: 
{type: application/json, template: https://www.googleapis.com/customsearch/v1?q={searchTerms}&num={count?}&start={startIndex?}&lr={language?}&safe={safe?}&cx={cx?}&sort={sort?}&filter={filter?}&gl={gl?}&cr={cr?}&googlehost={googleHost?}&c2coff={disableCnTwTranslation?}&hq={hq?}&hl={hl?}&siteSearch={siteSearch?}&siteSearchFilter={siteSearchFilter?}&exactTerms={exactTerms?}&excludeTerms={excludeTerms?}&linkSite={linkSite?}&orTerms={orTerms?}&relatedSite={relatedSite?}&dateRestrict={dateRestrict?}&lowRange={lowRange?}&highRange={highRange?}&searchType={searchType}&fileType={fileType?}&rights={rights?}&imgSize={imgSize?}&imgType={imgType?}&imgColorType={imgColorType?}&imgDominantColor={imgDominantColor?}&alt=json}, queries: 
{request: [{title: Google Custom Search - 123, totalResults: 519000, searchTerms: 123, count: 10, startIndex: 1, inputEncoding: utf8, outputEncoding: utf8, safe: off, cx: 821cd5ca4ed114a04}], nextPage: [{title: Google Custom Search - 123, totalResults: 519000, searchTerms: 123, count: 10, startIndex: 11, inputEncoding: utf8, outputEncoding: utf8, safe: off, cx: 821cd5ca4ed114a04}]}, context: 
{title: Imdb_title}, searchInformation: 
{searchTime: 0.246441, formattedSearchTime: 0.25, totalResults: 519000, formattedTotalResults: 519,000}, items: [
  
  {kind: customsearch#result, title: The Taking of Pelham 123 (2009) - Denzel Washington as Walter ..., htmlTitle: The Taking of Pelham <b>123</b> (2009) - Denzel Washington as Walter ..., 
  link: https://www.imdb.com/title/tt1111422/characters/nm0000243, display
  Link: www.imdb.com, snippet: The Taking of Pelham 123 (2009) Denzel Washington as Walter Garber., htmlSnippet: The Taking of Pelham <b>123</b> (2009) Denzel Washington as Walter Garber., cacheId: vyPe8sIWwcYJ,
   formattedUrl: https://www.imdb.com/title/tt1111422/characters/nm0000243, htmlFormattedUrl: https://www.imdb.com/title/tt1111422/characters/nm0000243, pagemap: 
{cse_thumbnail: [{src: https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSNNVNYHuLcRHNRVNWqnNsft9AEwx9iVGcJazEZ0aG-ghfMtmDoMP5JL-1s, width: 163, height: 310}], 
metatags: [{pagetype: title, apple-itunes-app: app-id=342792525, app-argument=imdb:///title/tt1111422?src=mdot, subpagetype: characters, 
og:image: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg, theme-color: #000000, 
og:type: video.movie, og:site_name: IMDb, og:title: The Taking of Pelham 123 (2009) - IMDb, pageid: tt1111422, title: The Taking of Pelham 123 (2009) - IMDb, 
og:description: The Taking of Pelham 123 (2009) Denzel Washington as Walter Garber, fb:app_id: 115109575169727, og:url: http://www.imdb.com/title/tt1111422/characters/nm0000243, request_id: GTXX18P858S1VABWAQRQ}], 
cse_image: [{src: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg}]}}, 

{kind: customsearch#result, title: The Taking of Pelham 123 (2009) - Goofs - IMDb, htmlTitle: The Taking of Pelham <b>123</b> (2009) - Goofs - IMDb, 
link: https://www.imdb.com/title/tt1111422/goofs, display
Link: www.imdb.com, snippet: The Taking of Pelham 123 (2009) Goofs on IMDb: Mistakes, Errors in geography, 
Spoilers and more..., htmlSnippet: The Taking of Pelham <b>123</b> (2009) Goofs on IMDb: Mistakes, Errors in geography, <br>
Spoilers and more..., cacheId: HDdtcgePGK0J,
 formattedUrl: https://www.imdb.com/title/tt1111422/goofs, htmlFormattedUrl: https://www.imdb.com/title/tt1111422/goofs, pagemap: 
{cse_thumbnail: [{src: https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSNNVNYHuLcRHNRVNWqnNsft9AEwx9iVGcJazEZ0aG-ghfMtmDoMP5JL-1s, width: 163, height: 310}], 
metatags: [{pagetype: title, apple-itunes-app: app-id=342792525, app-argument=imdb:///title/tt1111422?src=mdot, subpagetype: goofs, 
og:image: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg, theme-color: #000000, 
og:type: video.movie, og:site_name: IMDb, og:title: The Taking of Pelham 123 (2009) - IMDb, pageid: tt1111422, title: The Taking of Pelham 123 (2009) - IMDb, 
og:description: The Taking of Pelham 123 (2009) Goofs on IMDb: Mistakes, Errors in geography, Spoilers and more..., fb:app_id: 115109575169727, og:url: http://www.imdb.com/title/tt1111422/goofs, request_id: CJ3AQW29R7QE9RSY1033}], 
cse_image: [{src: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg}]}}, 

{kind: customsearch#result, title: The Taking of Pelham 123 - Awards - IMDb, htmlTitle: The Taking of Pelham <b>123</b> - Awards - IMDb, 
link: https://www.imdb.com/title/tt1111422/awards, display
Link: www.imdb.com, snippet: Nominee EDA Special Mention Award, Remake That Shouldnt Have Been Made
. ALMA Awards 2009. Nominee ALMA Award, Actor in Film Luis Guzmán ..., htmlSnippet: Nominee EDA Special Mention Award, Remake That Shouldn&#39;t Have Been Made<br>
. ALMA Awards 2009. Nominee ALMA Award, Actor in Film Luis Guzmán&nbsp;..., cacheId: FDTFX0vWFLkJ,
 formattedUrl: https://www.imdb.com/title/tt1111422/awards, htmlFormattedUrl: https://www.imdb.com/title/tt1111422/awards, pagemap: 
{cse_thumbnail: [{src: https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSNNVNYHuLcRHNRVNWqnNsft9AEwx9iVGcJazEZ0aG-ghfMtmDoMP5JL-1s, width: 163, height: 310}], 
metatags: [{pagetype: title, apple-itunes-app: app-id=342792525, app-argument=imdb:///title/tt1111422?src=mdot, subpagetype: awards, 
og:image: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg, theme-color: #000000, 
og:type: video.movie, og:site_name: IMDb, og:title: The Taking of Pelham 123 - IMDb, pageid: tt1111422, title: The Taking of Pelham 123 - IMDb, 
og:description: The Taking of Pelham 123 Awards and Nominations, fb:app_id: 115109575169727, og:url: http://www.imdb.com/title/tt1111422/awards, request_id: RSKKQ9WSFA2SKWHC8899}], 
cse_image: [{src: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg}]}}, 

{kind: customsearch#result, title: The Taking of Pelham 123 (2009) - IMDb, htmlTitle: The Taking of Pelham <b>123</b> (2009) - IMDb, 
link: https://www.imdb.com/title/tt1111422/, display
Link: www.imdb.com, snippet: The Taking of Pelham 123 (2009) ... Armed men hijack a New York City subway 
train, holding the passengers hostage in return for a ransom, and turning an ..., htmlSnippet: The Taking of Pelham <b>123</b> (2009) ... Armed men hijack a New York City subway <br>
train, holding the passengers hostage in return for a ransom, and turning an&nbsp;..., cacheId: e1JIfjxtQqoJ,
 formattedUrl: https://www.imdb.com/title/tt1111422/, htmlFormattedUrl: https://www.imdb.com/title/tt1111422/, pagemap: 
{cse_thumbnail: [{src: https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSNNVNYHuLcRHNRVNWqnNsft9AEwx9iVGcJazEZ0aG-ghfMtmDoMP5JL-1s, width: 163, height: 310}], 
aggregaterating: [{ratingvalue: 6.4, reviewcount: 353 user, ratingcount: 187,891, bestrating: 10}], 
metatags: [{pagetype: title, apple-itunes-app: app-id=342792525, app-argument=imdb:///title/tt1111422?src=mdot, subpagetype: main, 
og:image: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg, theme-color: #000000, 
og:type: video.movie, og:site_name: IMDb, og:title: The Taking of Pelham 123 (2009) - IMDb, pageid: tt1111422, title: The Taking of Pelham 123 (2009) - IMDb, 
og:description: Directed by Tony Scott.  With Denzel Washington, John Travolta, Luis Guzmán, Victor Gojcaj. Armed men hijack a New York City subway train, holding the passengers hostage in return for a ransom, and turning an ordinary days work for dispatcher Walter Garber into a face-off with the mastermind behind the crime., 
fb:app_id: 115109575169727, og:url: http://www.imdb.com/title/tt1111422/, request_id: 03M570BDG92RQS7A326N}], 
cse_image: [{src: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg}]}}, 

{kind: customsearch#result, title: The Taking of Pelham 123 (2009) - Soundtracks - IMDb, htmlTitle: The Taking of Pelham <b>123</b> (2009) - Soundtracks - IMDb, 
link: https://www.imdb.com/title/tt1111422/soundtrack, display
Link: www.imdb.com, snippet: The Taking of Pelham 123 (2009) SoundTracks on IMDb: Memorable quotes and 
exchanges from movies, TV series and more..., htmlSnippet: The Taking of Pelham <b>123</b> (2009) SoundTracks on IMDb: Memorable quotes and <br>
exchanges from movies, TV series and more..., cacheId: u6113VAii10J,
 formattedUrl: https://www.imdb.com/title/tt1111422/soundtrack, htmlFormattedUrl: https://www.imdb.com/title/tt1111422/soundtrack, pagemap: 
{cse_thumbnail: [{src: https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSNNVNYHuLcRHNRVNWqnNsft9AEwx9iVGcJazEZ0aG-ghfMtmDoMP5JL-1s, width: 163, height: 310}], 
metatags: [{pagetype: title, apple-itunes-app: app-id=342792525, app-argument=imdb:///title/tt1111422?src=mdot, subpagetype: soundtrack, 
og:image: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg, theme-color: #000000, 
og:type: video.movie, og:site_name: IMDb, og:title: The Taking of Pelham 123 (2009) - IMDb, pageid: tt1111422, title: The Taking of Pelham 123 (2009) - IMDb, 
og:description: The Taking of Pelham 123 (2009) SoundTracks on IMDb: Memorable quotes and exchanges from movies, TV series and more..., fb:app_id: 115109575169727, 
og:url: http://www.imdb.com/title/tt1111422/soundtrack, request_id: 5M967Y9QGCQFZJ7K1PQD}], 
cse_image: [{src: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg}]}}, 

{kind: customsearch#result, title: The Taking of Pelham 123 (2009) - Trivia - IMDb, htmlTitle: The Taking of Pelham <b>123</b> (2009) - Trivia - IMDb, 
link: https://www.imdb.com/title/tt1111422/trivia, display
Link: www.imdb.com, snippet: The Taking of Pelham 123 (2009) Trivia on IMDb: Cameos, Mistakes, Spoilers 
and more..., htmlSnippet: The Taking of Pelham <b>123</b> (2009) Trivia on IMDb: Cameos, Mistakes, Spoilers <br>
and more..., cacheId: fF_Vl2s0B3kJ,
 formattedUrl: https://www.imdb.com/title/tt1111422/trivia, htmlFormattedUrl: https://www.imdb.com/title/tt1111422/trivia, pagemap: 
{cse_thumbnail: [{src: https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSNNVNYHuLcRHNRVNWqnNsft9AEwx9iVGcJazEZ0aG-ghfMtmDoMP5JL-1s, width: 163, height: 310}], 
metatags: [{pagetype: title, apple-itunes-app: app-id=342792525, app-argument=imdb:///title/tt1111422?src=mdot, subpagetype: trivia, 
og:image: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg, theme-color: #000000, 
og:type: video.movie, og:site_name: IMDb, og:title: The Taking of Pelham 123 (2009) - IMDb, pageid: tt1111422, title: The Taking of Pelham 123 (2009) - IMDb, 
og:description: The Taking of Pelham 123 (2009) Trivia on IMDb: Cameos, Mistakes, Spoilers and more..., fb:app_id: 115109575169727, 
og:url: http://www.imdb.com/title/tt1111422/trivia, request_id: 2JXSSR1W7J7JEPEFYH3Q}], 
cse_image: [{src: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg}]}}, 

{kind: customsearch#result, title: "Victoria" Doll 123 (TV Episode 2016) - IMDb, htmlTitle: &quot;Victoria&quot; Doll <b>123</b> (TV Episode 2016) - IMDb, 
link: https://www.imdb.com/title/tt5267180/, display
Link: www.imdb.com, snippet: Doll 123 Poster. Upon the death of King William IV, his 18-year-old niece, 
Princess Alexandrina Victoria of Kent, inherits the throne as Queen, and finds 
herself ..., htmlSnippet: Doll <b>123</b> Poster. Upon the death of King William IV, his 18-year-old niece, <br>
Princess Alexandrina Victoria of Kent, inherits the throne as Queen, and finds <br>
herself&nbsp;..., cacheId: GcCcZQAtnIMJ,
 formattedUrl: https://www.imdb.com/title/tt5267180/, htmlFormattedUrl: https://www.imdb.com/title/tt5267180/, pagemap: 
{cse_thumbnail: [{src: https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSIgTMdIhdqz3jOT9bQemliOCngSP99499yXQImpi0tJS-JIkQCTV-Cjfg, width: 163, height: 310}], 
aggregaterating: [{ratingvalue: 8.4, reviewcount: 3 user, ratingcount: 888, bestrating: 10}], 
metatags: [{pagetype: title, apple-itunes-app: app-id=342792525, app-argument=imdb:///title/tt5267180?src=mdot, subpagetype: main, 
og:image: https://m.media-amazon.com/images/M/MV5BMDE5MmEzYTctMjE3MS00MTJjLWE2ZjctMWFlMmZiZGFiYmNhXkEyXkFqcGdeQXVyNTM3MDMyMDQ@._V1_UY1200_CR485,0,630,1200_AL_.jpg, theme-color: #000000, 
og:type: video.episode, og:site_name: IMDb, og:title: "Victoria" Doll 123 (TV Episode 2016) - IMDb, pageid: tt5267180, title: "Victoria" Doll 123 (TV Episode 2016) - IMDb, 
og:description: Directed by Tom Vaughan.  With Tommy Knight, Adrian Schiller, Daniela Holtz, Paul Rhys. Upon the death of King William IV, his 18-year-old niece, Princess Alexandrina Victoria of Kent, inherits the throne as Queen, and finds herself tested by new responsibilities and conflicted loyalties., 
fb:app_id: 115109575169727, og:url: http://www.imdb.com/title/tt5267180/, request_id: H3MTYR7BN379YT6YHQ7A}], 
cse_image: [{src: https://m.media-amazon.com/images/M/MV5BMDE5MmEzYTctMjE3MS00MTJjLWE2ZjctMWFlMmZiZGFiYmNhXkEyXkFqcGdeQXVyNTM3MDMyMDQ@._V1_UY1200_CR485,0,630,1200_AL_.jpg}]}}, 

{kind: customsearch#result, title: The Taking of Pelham 123 (2009) - User Reviews - IMDb, htmlTitle: The Taking of Pelham <b>123</b> (2009) - User Reviews - IMDb, 
link: https://www.imdb.com/title/tt1111422/reviews, display
Link: www.imdb.com, snippet: The Taking of Pelham 123 (2009) on IMDb: Movies, TV, Celebs, and more..., htmlSnippet: The Taking of Pelham <b>123</b> (2009) on IMDb: Movies, TV, Celebs, and more..., cacheId: FbEqzgmX0VMJ,
 formattedUrl: https://www.imdb.com/title/tt1111422/reviews, htmlFormattedUrl: https://www.imdb.com/title/tt1111422/reviews, pagemap: 
{cse_thumbnail: [{src: https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSNNVNYHuLcRHNRVNWqnNsft9AEwx9iVGcJazEZ0aG-ghfMtmDoMP5JL-1s, width: 163, height: 310}], 
metatags: [{pagetype: title, apple-itunes-app: app-id=342792525, app-argument=imdb:///title/tt1111422?src=mdot, subpagetype: reviews, 
og:image: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg, theme-color: #000000, 
og:type: video.movie, og:site_name: IMDb, og:title: The Taking of Pelham 123 (2009) - IMDb, pageid: tt1111422, title: The Taking of Pelham 123 (2009) - IMDb, 
og:description: The Taking of Pelham 123 (2009) on IMDb: Movies, TV, Celebs, and more..., fb:app_id: 115109575169727, og:url: http://www.imdb.com/title/tt1111422/reviews, request_id: PFTYYAE2JJ0WZNK6M08P}], 
cse_image: [{src: https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_UY1200_CR90,0,630,1200_AL_.jpg}]}}, 

{kind: customsearch#result, title: Chelmsford 123 (TV Series 1988–1990) - IMDb, htmlTitle: Chelmsford <b>123</b> (TV Series 1988–1990) - IMDb, 
link: https://www.imdb.com/title/tt0094432/, display
Link: www.imdb.com, snippet: With Jimmy Mulville, Rory McGrath, Philip Pope, Howard Lew Lewis. Sitcom set 
in the town of Chelmsford, but in the year AD 123. The show mainly revolves ..., htmlSnippet: With Jimmy Mulville, Rory McGrath, Philip Pope, Howard Lew Lewis. Sitcom set <br>
in the town of Chelmsford, but in the year AD <b>123</b>. The show mainly revolves&nbsp;..., cacheId: of7R9nziCfwJ,
 formattedUrl: https://www.imdb.com/title/tt0094432/, htmlFormattedUrl: https://www.imdb.com/title/tt0094432/, pagemap: 
{cse_thumbnail: [{src: https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRiqq11Eb75ijr1D6PNIWyen4EKpstoYaZFsHx8mkwHer-1-0y-dpw9Oa0, width: 163, height: 310}], 
aggregaterating: [{ratingvalue: 8.0, reviewcount: 14 user, ratingcount: 256, bestrating: 10}], 
metatags: [{pagetype: title, apple-itunes-app: app-id=342792525, app-argument=imdb:///title/tt0094432?src=mdot, subpagetype: main, 
og:image: https://m.media-amazon.com/images/M/MV5BMjM3MjMxNjE5Nl5BMl5BanBnXkFtZTgwNDg4OTc1NDE@._V1_UY1200_CR485,0,630,1200_AL_.jpg, theme-color: #000000, 
og:type: video.tv_show, og:site_name: IMDb, og:title: Chelmsford 123 (TV Series 1988–1990) - IMDb, pageid: tt0094432, title: Chelmsford 123 (TV Series 1988–1990) - IMDb, 
og:description: With Jimmy Mulville, Rory McGrath, Philip Pope, Howard Lew Lewis. Sitcom set in the town of Chelmsford, but in the year AD 123. The show mainly revolves around the power struggle between the newly appointed Roman Governor of Britain, Aulus Paulinus, and the scheming local British chieftain Badvoc., 
fb:app_id: 115109575169727, og:url: http://www.imdb.com/title/tt0094432/, request_id: 8HGBDB0WYYJ3TX4CCR9X}], 
cse_image: [{src: https://m.media-amazon.com/images/M/MV5BMjM3MjMxNjE5Nl5BMl5BanBnXkFtZTgwNDg4OTc1NDE@._V1_UY1200_CR485,0,630,1200_AL_.jpg}]}}, 

{kind: customsearch#result, title: "Adam-12" Log 123: Courtroom (TV Episode 1969) - Full Cast ..., htmlTitle: &quot;Adam-12&quot; Log <b>123</b>: Courtroom (TV Episode 1969) - Full Cast ..., 
link: https://www.imdb.com/title/tt0505296/fullcredits, display
Link: www.imdb.com, snippet: "Adam-12" Log 123: Courtroom (TV Episode 1969) cast and crew credits, 
including actors, actresses, directors, writers and more., htmlSnippet: &quot;Adam-12&quot; Log <b>123</b>: Courtroom (TV Episode 1969) cast and crew credits, <br>
including actors, actresses, directors, writers and more., cacheId: qCGjqU4jsRUJ,
 formattedUrl: https://www.imdb.com/title/tt0505296/fullcredits, htmlFormattedUrl: https://www.imdb.com/title/tt0505296/fullcredits, pagemap: 
{cse_thumbnail: [{src: https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTJyGOl_qLWiOLkqYtpMKls-XwD6D-j-VMbSW4gEZ_HwpCdH3h6x4eF6g, width: 163, height: 310}], 
metatags: [{pagetype: title, apple-itunes-app: app-id=342792525, app-argument=imdb:///title/tt0505296?src=mdot, subpagetype: fullcredits, 
og:image: https://m.media-amazon.com/images/M/MV5BNjZkMDUwYjYtZTY1Ny00MGNiLTkxNjUtMWE2YzgyOTM4Mzc3XkEyXkFqcGdeQXVyNjIyMzMxMTk@._V1_UY1200_CR485,0,630,1200_AL_.jpg, theme-color: #000000, 
og:type: video.episode, og:site_name: IMDb, og:title: "Adam-12" Log 123: Courtroom (TV Episode 1969) - IMDb, pageid: tt0505296, title: "Adam-12" Log 123: Courtroom (TV Episode 1969) - IMDb, 
og:description: "Adam-12" Log 123: Courtroom (TV Episode 1969) cast and crew credits, including actors, actresses, directors, writers and more., fb:app_id: 115109575169727, 
og:url: http://www.imdb.com/title/tt0505296/fullcredits, request_id: W3DQNQ87MSKQ6B7BFWKC}], 

cse_image: [{src: https://m.media-amazon.com/images/M/MV5BNjZkMDUwYjYtZTY1Ny00MGNiLTkxNjUtMWE2YzgyOTM4Mzc3XkEyXkFqcGdeQXVyNjIyMzMxMTk@._V1_UY1200_CR485,0,630,1200_AL_.jpg}]}}]}(0, none)




        "cse_image": [
          {
            "src": "https://m.media-amazon.com/images/M/MV5BMjA0MzYzNzY3OV5BMl5BanBnXkFtZTcwMzM4ODM4NA@@._V1_UX630_CR0,0,630,1200_AL_.jpg"
          }
        ]
      }
    }
*/
final googleMoviesJsonSearchInner = r'''
    {
      "kind": "customsearch#result",
      "title": "Wonder (2017) - IMDb",
      "htmlTitle": "\u003cb\u003eWonder\u003c/b\u003e (2017) - IMDb",
      "link": "https://www.imdb.com/title/tt2543472/",
      "displayLink": "www.imdb.com",
      "snippet": "Wonder (2017) ... Based on the New York Times bestseller, this movie tells the \nincredibly inspiring and heartwarming story of August Pullman, a boy with facial ...",
      "htmlSnippet": "\u003cb\u003eWonder\u003c/b\u003e (2017) ... Based on the New York Times bestseller, this movie tells the \u003cbr\u003e\nincredibly inspiring and heartwarming story of August Pullman, a boy with facial&nbsp;...",
      "cacheId": "NA7QsSC4NvsJ",
      "formattedUrl": "https://www.imdb.com/title/tt2543472/",
      "htmlFormattedUrl": "https://www.imdb.com/title/tt2543472/",
      "pagemap": {
        "cse_thumbnail": [
          {
            "src": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHDQE1-siBfEo2n75j_rkTvNhXtwlrdAzLhYs3JOXWnVyfTm9PP81DU4o",
            "width": "163",
            "height": "310"
          }
        ],
        "aggregaterating": [
          {
            "ratingvalue": "8.0",
            "reviewcount": "515 user",
            "ratingcount": "144,501",
            "bestrating": "10"
          }
        ],
        "metatags": [
          {
            "pagetype": "title",
            "apple-itunes-app": "app-id=342792525, app-argument=imdb:///title/tt2543472?src=mdot",
            "subpagetype": "main",
            "og:image": "https://m.media-amazon.com/images/M/MV5BYjFhOWY0OTgtNDkzMC00YWJkLTk1NGEtYWUxNjhmMmQ5ZjYyXkEyXkFqcGdeQXVyMjMxOTE0ODA@._V1_UY1200_CR74,0,630,1200_AL_.jpg",
            "theme-color": "#000000",
            "og:type": "video.movie",
            "og:site_name": "IMDb",
            "og:title": "Wonder (2017) - IMDb",
            "pageid": "tt2543472",
            "title": "Wonder (2017) - IMDb",
            "og:description": "Directed by Stephen Chbosky.  With Jacob Tremblay, Owen Wilson, Izabela Vidovic, Julia Roberts. Based on the New York Times bestseller, this movie tells the incredibly inspiring and heartwarming story of August Pullman, a boy with facial differences who enters the fifth grade, attending a mainstream elementary school for the first time.",
            "fb:app_id": "115109575169727",
            "og:url": "http://www.imdb.com/title/tt2543472/",
            "request_id": "D70D64XY7YPNCXPNN9JC"
          }
        ],
        "cse_image": [
          {
            "src": "https://m.media-amazon.com/images/M/MV5BYjFhOWY0OTgtNDkzMC00YWJkLTk1NGEtYWUxNjhmMmQ5ZjYyXkEyXkFqcGdeQXVyMjMxOTE0ODA@._V1_UY1200_CR74,0,630,1200_AL_.jpg"
          }
        ]
      }
    },
    {
      "kind": "customsearch#result",
      "title": "Wonder Woman (2017) - IMDb",
      "htmlTitle": "\u003cb\u003eWonder\u003c/b\u003e Woman (2017) - IMDb",
      "link": "https://www.imdb.com/title/tt0451279/",
      "displayLink": "www.imdb.com",
      "snippet": "Wonder Woman (2017) ... When a pilot crashes and tells of conflict in the outside \nworld, Diana, an Amazonian warrior in training, leaves home to fight a war, ...",
      "htmlSnippet": "\u003cb\u003eWonder\u003c/b\u003e Woman (2017) ... When a pilot crashes and tells of conflict in the outside \u003cbr\u003e\nworld, Diana, an Amazonian warrior in training, leaves home to fight a war,&nbsp;...",
      "cacheId": "mKYgdkwiyX8J",
      "formattedUrl": "https://www.imdb.com/title/tt0451279/",
      "htmlFormattedUrl": "https://www.imdb.com/title/tt0451279/",
      "pagemap": {
        "cse_thumbnail": [
          {
            "src": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGudNOtD98QBwOx7uh2ibxEVikCVDW6S7rzZtE-dKXyG3pfrmid6oseoo",
            "width": "163",
            "height": "310"
          }
        ],
        "aggregaterating": [
          {
            "ratingvalue": "7.4",
            "reviewcount": "2,387 user",
            "ratingcount": "576,215",
            "bestrating": "10"
          }
        ],
        "metatags": [
          {
            "pagetype": "title",
            "apple-itunes-app": "app-id=342792525, app-argument=imdb:///title/tt0451279?src=mdot",
            "subpagetype": "main",
            "og:image": "https://m.media-amazon.com/images/M/MV5BMTYzODQzYjQtNTczNC00MzZhLTg1ZWYtZDUxYmQ3ZTY4NzA1XkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_UY1200_CR90,0,630,1200_AL_.jpg",
            "theme-color": "#000000",
            "og:type": "video.movie",
            "og:site_name": "IMDb",
            "og:title": "Wonder Woman (2017) - IMDb",
            "pageid": "tt0451279",
            "title": "Wonder Woman (2017) - IMDb",
            "og:description": "Directed by Patty Jenkins.  With Gal Gadot, Chris Pine, Robin Wright, Lucy Davis. When a pilot crashes and tells of conflict in the outside world, Diana, an Amazonian warrior in training, leaves home to fight a war, discovering her full powers and true destiny.",
            "fb:app_id": "115109575169727",
            "og:url": "http://www.imdb.com/title/tt0451279/",
            "request_id": "JK8E1KYS509DRTB0WEZY"
          }
        ],
        "cse_image": [
          {
            "src": "https://m.media-amazon.com/images/M/MV5BMTYzODQzYjQtNTczNC00MzZhLTg1ZWYtZDUxYmQ3ZTY4NzA1XkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_UY1200_CR90,0,630,1200_AL_.jpg"
          }
        ]
      }
    },
    {
      "kind": "customsearch#result",
      "title": "Wonder Woman 1984 (2020) - IMDb",
      "htmlTitle": "\u003cb\u003eWonder\u003c/b\u003e Woman 1984 (2020) - IMDb",
      "link": "https://www.imdb.com/title/tt7126948/",
      "displayLink": "www.imdb.com",
      "snippet": "Directed by Patty Jenkins. With Gal Gadot, Chris Pine, Kristen Wiig, Pedro Pascal\n. Diana must contend with a work colleague and businessman, whose desire ...",
      "htmlSnippet": "Directed by Patty Jenkins. With Gal Gadot, Chris Pine, Kristen Wiig, Pedro Pascal\u003cbr\u003e\n. Diana must contend with a work colleague and businessman, whose desire&nbsp;...",
      "cacheId": "kaAHwDRqN1sJ",
      "formattedUrl": "https://www.imdb.com/title/tt7126948/",
      "htmlFormattedUrl": "https://www.imdb.com/title/tt7126948/",
      "pagemap": {
        "cse_thumbnail": [
          {
            "src": "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcS_cMp1DxHj9j70SiL0dKsqvQJkPhGWvKxwwFdSLs2QXXw0_AxWHHxI-E0U",
            "width": "163",
            "height": "310"
          }
        ],
        "aggregaterating": [
          {
            "ratingvalue": "5.4",
            "reviewcount": "6,323 user",
            "ratingcount": "172,717",
            "bestrating": "10"
          }
        ],
        "metatags": [
          {
            "pagetype": "title",
            "apple-itunes-app": "app-id=342792525, app-argument=imdb:///title/tt7126948?src=mdot",
            "subpagetype": "main",
            "og:image": "https://m.media-amazon.com/images/M/MV5BYTlhNzJjYzYtNGU3My00ZDI5LTgzZDUtYzllYjU1ZmU0YTgwXkEyXkFqcGdeQXVyMjQwMDg0Ng@@._V1_UY1200_CR90,0,630,1200_AL_.jpg",
            "theme-color": "#000000",
            "og:type": "video.movie",
            "og:site_name": "IMDb",
            "og:title": "Wonder Woman 1984 (2020) - IMDb",
            "pageid": "tt7126948",
            "title": "Wonder Woman 1984 (2020) - IMDb",
            "og:description": "Directed by Patty Jenkins.  With Gal Gadot, Chris Pine, Kristen Wiig, Pedro Pascal. Diana must contend with a work colleague and businessman, whose desire for extreme wealth sends the world down a path of destruction, after an ancient artifact that grants wishes goes missing.",
            "fb:app_id": "115109575169727",
            "og:url": "http://www.imdb.com/title/tt7126948/",
            "request_id": "D4H5BF068WPE1VN245V6"
          }
        ],
        "cse_image": [
          {
            "src": "https://m.media-amazon.com/images/M/MV5BYTlhNzJjYzYtNGU3My00ZDI5LTgzZDUtYzllYjU1ZmU0YTgwXkEyXkFqcGdeQXVyMjQwMDg0Ng@@._V1_UY1200_CR90,0,630,1200_AL_.jpg"
          }
        ]
      }
    },
    {
      "kind": "customsearch#result",
      "title": "To the Wonder (2012) - IMDb",
      "htmlTitle": "To the \u003cb\u003eWonder\u003c/b\u003e (2012) - IMDb",
      "link": "https://www.imdb.com/title/tt1595656/",
      "displayLink": "www.imdb.com",
      "snippet": "Directed by Terrence Malick. With Ben Affleck, Olga Kurylenko, Javier Bardem, \nRachel McAdams. After falling in love in Paris, Marina and Neil come to ...",
      "htmlSnippet": "Directed by Terrence Malick. With Ben Affleck, Olga Kurylenko, Javier Bardem, \u003cbr\u003e\nRachel McAdams. After falling in love in Paris, Marina and Neil come to&nbsp;...",
      "cacheId": "XqgsByctnvUJ",
      "formattedUrl": "https://www.imdb.com/title/tt1595656/",
      "htmlFormattedUrl": "https://www.imdb.com/title/tt1595656/",
      "pagemap": {
        "cse_thumbnail": [
          {
            "src": "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRPvQt_oTnSdE-ZtW0UGwrOo_N0qYO4a6CNzCgGLPFkdZCDuq91U0DcnqM",
            "width": "163",
            "height": "310"
          }
        ],
        "aggregaterating": [
          {
            "ratingvalue": "5.9",
            "reviewcount": "160 user",
            "ratingcount": "27,288",
            "bestrating": "10"
          }
        ],
        "metatags": [
          {
            "pagetype": "title",
            "apple-itunes-app": "app-id=342792525, app-argument=imdb:///title/tt1595656?src=mdot",
            "subpagetype": "main",
            "og:image": "https://m.media-amazon.com/images/M/MV5BMTAwNzk1NjM2ODZeQTJeQWpwZ15BbWU3MDE1MjQwMjk@._V1_UY1200_CR90,0,630,1200_AL_.jpg",
            "theme-color": "#000000",
            "og:type": "video.movie",
            "og:site_name": "IMDb",
            "og:title": "To the Wonder (2012) - IMDb",
            "pageid": "tt1595656",
            "title": "To the Wonder (2012) - IMDb",
            "og:description": "Directed by Terrence Malick.  With Ben Affleck, Olga Kurylenko, Javier Bardem, Rachel McAdams. After falling in love in Paris, Marina and Neil come to Oklahoma, where problems arise. Their church's Spanish-born pastor struggles with his faith, while Neil encounters a woman from his childhood.",
            "fb:app_id": "115109575169727",
            "og:url": "http://www.imdb.com/title/tt1595656/",
            "request_id": "6BHWBSK3SKVSD09ETFFK"
          }
        ],
        "cse_image": [
          {
            "src": "https://m.media-amazon.com/images/M/MV5BMTAwNzk1NjM2ODZeQTJeQWpwZ15BbWU3MDE1MjQwMjk@._V1_UY1200_CR90,0,630,1200_AL_.jpg"
          }
        ]
      }
    },
    {
      "kind": "customsearch#result",
      "title": "The Wonder Years (TV Series 1988–1993) - IMDb",
      "htmlTitle": "The \u003cb\u003eWonder\u003c/b\u003e Years (TV Series 1988–1993) - IMDb",
      "link": "https://www.imdb.com/title/tt0094582/",
      "displayLink": "www.imdb.com",
      "snippet": "The Wonder Years ... Kevin Arnold recalls growing up during the late 60s and \nearly 70s; the turbulent social times make the transition from child to adult \nunusually ...",
      "htmlSnippet": "The \u003cb\u003eWonder\u003c/b\u003e Years ... Kevin Arnold recalls growing up during the late 60s and \u003cbr\u003e\nearly 70s; the turbulent social times make the transition from child to adult \u003cbr\u003e\nunusually&nbsp;...",
      "cacheId": "xey0FQdId-8J",
      "formattedUrl": "https://www.imdb.com/title/tt0094582/",
      "htmlFormattedUrl": "https://www.imdb.com/title/tt0094582/",
      "pagemap": {
        "cse_thumbnail": [
          {
            "src": "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSCf7swSl0V-5CcUMnKhSaDGOLgJOvY6g7bLOIZ8orSIsAM73AX9ajYCNfo",
            "width": "163",
            "height": "310"
          }
        ],
        "aggregaterating": [
          {
            "ratingvalue": "8.3",
            "reviewcount": "116 user",
            "ratingcount": "34,395",
            "bestrating": "10"
          }
        ],
        "metatags": [
          {
            "pagetype": "title",
            "apple-itunes-app": "app-id=342792525, app-argument=imdb:///title/tt0094582?src=mdot",
            "subpagetype": "main",
            "og:image": "https://m.media-amazon.com/images/M/MV5BMWRhYjZjOTQtOGNiNC00MTQ0LWE2MTYtMTQxYzEwNDE3NjYyXkEyXkFqcGdeQXVyNTA4NzY1MzY@._V1_UY1200_CR114,0,630,1200_AL_.jpg",
            "theme-color": "#000000",
            "og:type": "video.tv_show",
            "og:site_name": "IMDb",
            "og:title": "The Wonder Years (TV Series 1988–1993) - IMDb",
            "pageid": "tt0094582",
            "title": "The Wonder Years (TV Series 1988–1993) - IMDb",
            "og:description": "Created by Carol Black, Neal Marlens.  With Fred Savage, Dan Lauria, Daniel Stern, Alley Mills. Kevin Arnold recalls growing up during the late 60s and early 70s; the turbulent social times make the transition from child to adult unusually interesting.",
            "fb:app_id": "115109575169727",
            "og:url": "http://www.imdb.com/title/tt0094582/",
            "request_id": "ZJ85N8B7F7GC70X3MP1K"
          }
        ],
        "cse_image": [
          {
            "src": "https://m.media-amazon.com/images/M/MV5BMWRhYjZjOTQtOGNiNC00MTQ0LWE2MTYtMTQxYzEwNDE3NjYyXkEyXkFqcGdeQXVyNTA4NzY1MzY@._V1_UY1200_CR114,0,630,1200_AL_.jpg"
          }
        ]
      }
    },
    {
      "kind": "customsearch#result",
      "title": "Wonder Boys (2000) - IMDb",
      "htmlTitle": "\u003cb\u003eWonder\u003c/b\u003e Boys (2000) - IMDb",
      "link": "https://www.imdb.com/title/tt0185014/",
      "displayLink": "www.imdb.com",
      "snippet": "Directed by Curtis Hanson. With Michael Douglas, Tobey Maguire, Frances \nMcDormand, Robert Downey Jr.. An English Professor tries to deal with his wife ...",
      "htmlSnippet": "Directed by Curtis Hanson. With Michael Douglas, Tobey Maguire, Frances \u003cbr\u003e\nMcDormand, Robert Downey Jr.. An English Professor tries to deal with his wife&nbsp;...",
      "cacheId": "IPDXnZPX2ooJ",
      "formattedUrl": "https://www.imdb.com/title/tt0185014/",
      "htmlFormattedUrl": "https://www.imdb.com/title/tt0185014/",
      "pagemap": {
        "cse_thumbnail": [
          {
            "src": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFyC45l3dpEWV5cdI2dd_bkGG22caKYi_lwesQIKNfxmF_8UaLt23PwqBQ",
            "width": "163",
            "height": "310"
          }
        ],
        "aggregaterating": [
          {
            "ratingvalue": "7.2",
            "reviewcount": "352 user",
            "ratingcount": "61,553",
            "bestrating": "10"
          }
        ],
        "metatags": [
          {
            "pagetype": "title",
            "apple-itunes-app": "app-id=342792525, app-argument=imdb:///title/tt0185014?src=mdot",
            "subpagetype": "main",
            "og:image": "https://m.media-amazon.com/images/M/MV5BZGFlZDI5OGMtMmVhMS00NTQxLTgzZmEtZDJlMGVjNWViZThmXkEyXkFqcGdeQXVyMTAwMzUyOTc@._V1_UY1200_CR91,0,630,1200_AL_.jpg",
            "theme-color": "#000000",
            "og:type": "video.movie",
            "og:site_name": "IMDb",
            "og:title": "Wonder Boys (2000) - IMDb",
            "pageid": "tt0185014",
            "title": "Wonder Boys (2000) - IMDb",
            "og:description": "Directed by Curtis Hanson.  With Michael Douglas, Tobey Maguire, Frances McDormand, Robert Downey Jr.. An English Professor tries to deal with his wife leaving him, the arrival of his editor who has been waiting for his book for seven years, and the various problems that his friends and associates involve him in.",
            "fb:app_id": "115109575169727",
            "og:url": "http://www.imdb.com/title/tt0185014/",
            "request_id": "QYSC3N8Z10C3FW28E1YW"
          }
        ],
        "cse_image": [
          {
            "src": "https://m.media-amazon.com/images/M/MV5BZGFlZDI5OGMtMmVhMS00NTQxLTgzZmEtZDJlMGVjNWViZThmXkEyXkFqcGdeQXVyMTAwMzUyOTc@._V1_UY1200_CR91,0,630,1200_AL_.jpg"
          }
        ]
      }
    },
    {
      "kind": "customsearch#result",
      "title": "Wonder Woman (TV Series 1975–1979) - IMDb",
      "htmlTitle": "\u003cb\u003eWonder\u003c/b\u003e Woman (TV Series 1975–1979) - IMDb",
      "link": "https://www.imdb.com/title/tt0074074/",
      "displayLink": "www.imdb.com",
      "snippet": "Diana Prince investigating a strange alien force in a small suburban community, \nis seen whirling into Wonder Woman by a young boy. 8.0.",
      "htmlSnippet": "Diana Prince investigating a strange alien force in a small suburban community, \u003cbr\u003e\nis seen whirling into \u003cb\u003eWonder\u003c/b\u003e Woman by a young boy. 8.0.",
      "cacheId": "dmW6vTHbtB0J",
      "formattedUrl": "https://www.imdb.com/title/tt0074074/",
      "htmlFormattedUrl": "https://www.imdb.com/title/tt0074074/",
      "pagemap": {
        "cse_thumbnail": [
          {
            "src": "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQySfdcjsPOd3N0q99vFhD1pEOW8kUwFvxuIU9nQWolFYYoaRJyJ2ctstQ",
            "width": "163",
            "height": "310"
          }
        ],
        "aggregaterating": [
          {
            "ratingvalue": "7.1",
            "reviewcount": "51 user",
            "ratingcount": "7,181",
            "bestrating": "10"
          }
        ],
        "metatags": [
          {
            "pagetype": "title",
            "apple-itunes-app": "app-id=342792525, app-argument=imdb:///title/tt0074074?src=mdot",
            "subpagetype": "main",
            "og:image": "https://m.media-amazon.com/images/M/MV5BZjAxYTcxMDUtZTRmMi00NTk3LThkZTItNGNlZTQ3NWRhMjY5XkEyXkFqcGdeQXVyNjExODE1MDc@._V1_UY1200_CR107,0,630,1200_AL_.jpg",
            "theme-color": "#000000",
            "og:type": "video.tv_show",
            "og:site_name": "IMDb",
            "og:title": "Wonder Woman (TV Series 1975–1979) - IMDb",
            "pageid": "tt0074074",
            "title": "Wonder Woman (TV Series 1975–1979) - IMDb",
            "og:description": "Created by William Moulton Marston, Stanley Ralph Ross.  With Lynda Carter, Lyle Waggoner, Tom Kratochvil, Richard Eastham. The adventures of the greatest of the female superheroes.",
            "fb:app_id": "115109575169727",
            "og:url": "http://www.imdb.com/title/tt0074074/",
            "request_id": "AET0Y6SBC9N81X1PH435"
          }
        ],
        "cse_image": [
          {
            "src": "https://m.media-amazon.com/images/M/MV5BZjAxYTcxMDUtZTRmMi00NTk3LThkZTItNGNlZTQ3NWRhMjY5XkEyXkFqcGdeQXVyNjExODE1MDc@._V1_UY1200_CR107,0,630,1200_AL_.jpg"
          }
        ]
      }
    },
    {
      "kind": "customsearch#result",
      "title": "Wonder Woman 1984 (2020) - User Reviews - IMDb",
      "htmlTitle": "\u003cb\u003eWonder\u003c/b\u003e Woman 1984 (2020) - User Reviews - IMDb",
      "link": "https://www.imdb.com/title/tt7126948/reviews",
      "displayLink": "www.imdb.com",
      "snippet": "Wonder Woman 1984 (2020) on IMDb: Movies, TV, Celebs, and more...",
      "htmlSnippet": "\u003cb\u003eWonder\u003c/b\u003e Woman 1984 (2020) on IMDb: Movies, TV, Celebs, and more...",
      "cacheId": "-x4SYcpwT_MJ",
      "formattedUrl": "https://www.imdb.com/title/tt7126948/reviews",
      "htmlFormattedUrl": "https://www.imdb.com/title/tt7126948/reviews",
      "pagemap": {
        "cse_thumbnail": [
          {
            "src": "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcS_cMp1DxHj9j70SiL0dKsqvQJkPhGWvKxwwFdSLs2QXXw0_AxWHHxI-E0U",
            "width": "163",
            "height": "310"
          }
        ],
        "metatags": [
          {
            "pagetype": "title",
            "apple-itunes-app": "app-id=342792525, app-argument=imdb:///title/tt7126948?src=mdot",
            "subpagetype": "reviews",
            "og:image": "https://m.media-amazon.com/images/M/MV5BYTlhNzJjYzYtNGU3My00ZDI5LTgzZDUtYzllYjU1ZmU0YTgwXkEyXkFqcGdeQXVyMjQwMDg0Ng@@._V1_UY1200_CR90,0,630,1200_AL_.jpg",
            "theme-color": "#000000",
            "og:type": "video.movie",
            "og:site_name": "IMDb",
            "og:title": "Wonder Woman 1984 (2020) - IMDb",
            "pageid": "tt7126948",
            "title": "Wonder Woman 1984 (2020) - IMDb",
            "og:description": "Wonder Woman 1984 (2020) on IMDb: Movies, TV, Celebs, and more...",
            "fb:app_id": "115109575169727",
            "og:url": "http://www.imdb.com/title/tt7126948/reviews",
            "request_id": "EWWS8JMCR0B41DCTNPH7"
          }
        ],
        "cse_image": [
          {
            "src": "https://m.media-amazon.com/images/M/MV5BYTlhNzJjYzYtNGU3My00ZDI5LTgzZDUtYzllYjU1ZmU0YTgwXkEyXkFqcGdeQXVyMjQwMDg0Ng@@._V1_UY1200_CR90,0,630,1200_AL_.jpg"
          }
        ]
      }
    },
    {
      "kind": "customsearch#result",
      "title": "Shawn Mendes: In Wonder (2020) - IMDb",
      "htmlTitle": "Shawn Mendes: In \u003cb\u003eWonder\u003c/b\u003e (2020) - IMDb",
      "link": "https://www.imdb.com/title/tt13276386/",
      "displayLink": "www.imdb.com",
      "snippet": "Shawn Mendes: In Wonder (2020) · Videos · Photos · Cast · Storyline · User \nReviews · Frequently Asked Questions · Details · Contribute to This Page.",
      "htmlSnippet": "Shawn Mendes: In \u003cb\u003eWonder\u003c/b\u003e (2020) &middot; Videos &middot; Photos &middot; Cast &middot; Storyline &middot; User \u003cbr\u003e\nReviews &middot; Frequently Asked Questions &middot; Details &middot; Contribute to This Page.",
      "cacheId": "Dgqd-JC-zX0J",
      "formattedUrl": "https://www.imdb.com/title/tt13276386/",
      "htmlFormattedUrl": "https://www.imdb.com/title/tt13276386/",
      "pagemap": {
        "cse_thumbnail": [
          {
            "src": "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQIsmlIB1OE0AM1ECBBvNQ7MHIU23qN02D1D6WfnJwY0FEKyU3YF6-39waL",
            "width": "163",
            "height": "310"
          }
        ],
        "aggregaterating": [
          {
            "ratingvalue": "6.5",
            "reviewcount": "53 user",
            "ratingcount": "1,628",
            "bestrating": "10"
          }
        ],
        "metatags": [
          {
            "pagetype": "title",
            "apple-itunes-app": "app-id=342792525, app-argument=imdb:///title/tt13276386?src=mdot",
            "subpagetype": "main",
            "og:image": "https://m.media-amazon.com/images/M/MV5BNDRkMGM5YTQtOGMzZS00ZGJiLTg5YWMtYjg4NTcyZTk0MzAzXkEyXkFqcGdeQXVyMTI0OTAwOTgy._V1_UY1200_CR90,0,630,1200_AL_.jpg",
            "theme-color": "#000000",
            "og:type": "video.movie",
            "og:site_name": "IMDb",
            "og:title": "Shawn Mendes: In Wonder (2020) - IMDb",
            "pageid": "tt13276386",
            "title": "Shawn Mendes: In Wonder (2020) - IMDb",
            "og:description": "Directed by Grant Singer.  With Shawn Mendes, Camila Cabello, Evan A. Dunn. A portrait of singer/songwriter Shawn Mendes' life, chronicling the past few years of his rise and journey.",
            "fb:app_id": "115109575169727",
            "og:url": "http://www.imdb.com/title/tt13276386/",
            "request_id": "1KTHQMT4V446CAACD5FY"
          }
        ],
        "cse_image": [
          {
            "src": "https://m.media-amazon.com/images/M/MV5BNDRkMGM5YTQtOGMzZS00ZGJiLTg5YWMtYjg4NTcyZTk0MzAzXkEyXkFqcGdeQXVyMTI0OTAwOTgy._V1_UY1200_CR90,0,630,1200_AL_.jpg"
          }
        ]
      }
    },
    {
      "kind": "customsearch#result",
      "title": "Wonder Woman (TV Movie 2011) - IMDb",
      "htmlTitle": "\u003cb\u003eWonder\u003c/b\u003e Woman (TV Movie 2011) - IMDb",
      "link": "https://www.imdb.com/title/tt1740828/",
      "displayLink": "www.imdb.com",
      "snippet": "Directed by Jeffrey Reiner. With Pedro Pascal, Adrianne Palicki, Cary Elwes, \nElizabeth Hurley. It's the modern day, and being Wonder Woman is complicated.",
      "htmlSnippet": "Directed by Jeffrey Reiner. With Pedro Pascal, Adrianne Palicki, Cary Elwes, \u003cbr\u003e\nElizabeth Hurley. It&#39;s the modern day, and being \u003cb\u003eWonder\u003c/b\u003e Woman is complicated.",
      "cacheId": "CaFHJ9WA7HYJ",
      "formattedUrl": "https://www.imdb.com/title/tt1740828/",
      "htmlFormattedUrl": "https://www.imdb.com/title/tt1740828/",
      "pagemap": {
        "cse_thumbnail": [
          {
            "src": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRC4veF2ZFbtPwdfqkA2Lligh1FzzTXhEP05xkOs6uXRjJicYXUnOd9Dkw",
            "width": "163",
            "height": "310"
          }
        ],
        "aggregaterating": [
          {
            "ratingvalue": "4.3",
            "reviewcount": "32 user",
            "ratingcount": "1,928",
            "bestrating": "10"
          }
        ],
        "metatags": [
          {
            "pagetype": "title",
            "apple-itunes-app": "app-id=342792525, app-argument=imdb:///title/tt1740828?src=mdot",
            "subpagetype": "main",
            "og:image": "https://m.media-amazon.com/images/M/MV5BMjA0MzYzNzY3OV5BMl5BanBnXkFtZTcwMzM4ODM4NA@@._V1_UX630_CR0,0,630,1200_AL_.jpg",
            "theme-color": "#000000",
            "og:type": "video.movie",
            "og:site_name": "IMDb",
            "og:title": "Wonder Woman (TV Movie 2011) - IMDb",
            "pageid": "tt1740828",
            "title": "Wonder Woman (TV Movie 2011) - IMDb",
            "og:description": "Directed by Jeffrey Reiner.  With Pedro Pascal, Adrianne Palicki, Cary Elwes, Elizabeth Hurley. It's the modern day, and being Wonder Woman is complicated. Diana is leading a triple life - running a large corporation out of costume and fighting crime in costume in one identity.",
            "fb:app_id": "115109575169727",
            "og:url": "http://www.imdb.com/title/tt1740828/",
            "request_id": "4KNMWBRVQGK88C6G7CX6"
          }
        ],
        "cse_image": [
          {
            "src": "https://m.media-amazon.com/images/M/MV5BMjA0MzYzNzY3OV5BMl5BanBnXkFtZTcwMzM4ODM4NA@@._V1_UX630_CR0,0,630,1200_AL_.jpg"
          }
        ]
      }
    }
''';
final googleMoviesJsonSearchPrefix = r'''
    {
  "kind": "customsearch#search",
  "url": {
    "type": "application/json",
    "template": "https://www.googleapis.com/customsearch/v1?q={searchTerms}&num={count?}&start={startIndex?}&lr={language?}&safe={safe?}&cx={cx?}&sort={sort?}&filter={filter?}&gl={gl?}&cr={cr?}&googlehost={googleHost?}&c2coff={disableCnTwTranslation?}&hq={hq?}&hl={hl?}&siteSearch={siteSearch?}&siteSearchFilter={siteSearchFilter?}&exactTerms={exactTerms?}&excludeTerms={excludeTerms?}&linkSite={linkSite?}&orTerms={orTerms?}&relatedSite={relatedSite?}&dateRestrict={dateRestrict?}&lowRange={lowRange?}&highRange={highRange?}&searchType={searchType}&fileType={fileType?}&rights={rights?}&imgSize={imgSize?}&imgType={imgType?}&imgColorType={imgColorType?}&imgDominantColor={imgDominantColor?}&alt=json"
  },
  "queries": {
    "request": [
      {
        "title": "Google Custom Search - wonder",
        "totalResults": "3280000",
        "searchTerms": "wonder",
        "count": 10,
        "startIndex": 1,
        "inputEncoding": "utf8",
        "outputEncoding": "utf8",
        "safe": "off",
        "cx": "821cd5ca4ed114a04"
      }
    ],
    "nextPage": [
      {
        "title": "Google Custom Search - wonder",
        "totalResults": "3280000",
        "searchTerms": "wonder",
        "count": 10,
        "startIndex": 11,
        "inputEncoding": "utf8",
        "outputEncoding": "utf8",
        "safe": "off",
        "cx": "821cd5ca4ed114a04"
      }
    ]
  },
  "context": {
    "title": "Imdb_title"
  },
  "searchInformation": {
    "searchTime": 0.673036,
    "formattedSearchTime": "0.67",
    "totalResults": "3280000",
    "formattedTotalResults": "3,280,000"
  },
  "items": [
    ''';
final googleMoviesJsonSearchSuffix = r'''
  ]
}
''';
final googleMoviesJsonSearchEmpty = r'''
{
  "kind": "customsearch#search",
  "url": {
    "type": "application/json",
    "template": "https://www.googleapis.com/customsearch/v1?q={searchTerms}&num={count?}&start={startIndex?}&lr={language?}&safe={safe?}&cx={cx?}&sort={sort?}&filter={filter?}&gl={gl?}&cr={cr?}&googlehost={googleHost?}&c2coff={disableCnTwTranslation?}&hq={hq?}&hl={hl?}&siteSearch={siteSearch?}&siteSearchFilter={siteSearchFilter?}&exactTerms={exactTerms?}&excludeTerms={excludeTerms?}&linkSite={linkSite?}&orTerms={orTerms?}&relatedSite={relatedSite?}&dateRestrict={dateRestrict?}&lowRange={lowRange?}&highRange={highRange?}&searchType={searchType}&fileType={fileType?}&rights={rights?}&imgSize={imgSize?}&imgType={imgType?}&imgColorType={imgColorType?}&imgDominantColor={imgDominantColor?}&alt=json"
  },
  "queries": {
    "request": [
      {
        "title": "Google Custom Search - therearenoresultszzzz",
        "searchTerms": "therearenoresultszzzz",
        "count": 10,
        "startIndex": 1,
        "inputEncoding": "utf8",
        "outputEncoding": "utf8",
        "safe": "off",
        "cx": "821cd5ca4ed114a04"
      }
    ]
  },
  "searchInformation": {
    "searchTime": 0.429584,
    "formattedSearchTime": "0.43",
    "totalResults": "0",
    "formattedTotalResults": "0"
  },
  "spelling": {
    "correctedQuery": "therearenoresults zzz",
    "htmlCorrectedQuery": "\u003cb\u003e\u003ci\u003etherearenoresults zzz\u003c/i\u003e\u003c/b\u003e"
  }
}
''';
final googleMoviesJsonSearchError = r'''
{
  "error": {
    "code": 400,
    "message": "Request contains an invalid argument.",
    "errors": [
      {
        "message": "Request contains an invalid argument.",
        "domain": "global",
        "reason": "badRequest"
      }
    ],
    "status": "INVALID_ARGUMENT"
  }
}
''';

final googleMoviesJsonSearchFull =
    ' $googleMoviesJsonSearchPrefix $googleMoviesJsonSearchInner $googleMoviesJsonSearchSuffix';

Stream<String> streamGoogleMoviesJsonOfflineData(String dummy) {
  return emitGoogleMoviesJsonOfflineData(dummy);
}

Stream<String> emitGoogleMoviesJsonOfflineData(String dummy) async* {
  yield googleMoviesJsonSearchFull;
}

Stream<String> emitGoogleMoviesJsonEmpty(String dummy) async* {
  yield googleMoviesJsonSearchEmpty;
}

Stream<String> emitGoogleMoviesJsonError(String dummy) async* {
  yield googleMoviesJsonSearchError;
}
