//query string https://www.imdb.com/find?s=tt&ref_=fn_al_tt_mr&q=wonder%20woman

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  '''
{"source": "imdb", "title": "1234", "type": "movie", "year": "2016", "language": "foreign",
"languages": ["Marathi"], "genres": ["Drama"], "keywords": ["terror"], 
"description": "1234 is a movie starring some people. On India's Independence Day, a few people have a party.", 
"userRating": "6.5", "userRatingCount": "10", "imageUrl": "https://m.media-amazon.com/images/M/MV5BMDMyOD...XkEyXkFqcGdeQXVyMTc4OTM4NjE@._V1_.jpg", "related": {}}

'''
];

const intermediateMapList = [
  {
    '@context': 'http://schema.org',
    '@type': 'Movie',
    'url': '/title/tt7602562/',
    'name': '1234',
    'image':
        'https://m.media-amazon.com/images/M/MV5BMDMyOD...XkEyXkFqcGdeQXVyMTc4OTM4NjE@._V1_.jpg',
    'genre': 'Drama',
    'actor': [
      {
        '@type': 'Person',
        'url': '/name/nm2487587/',
        'name': 'Abhijeet Chavhan'
      },
      {
        '@type': 'Person',
        'url': '/name/nm3874318/',
        'name': 'Kishore Chougule'
      },
      {'@type': 'Person', 'url': '/name/nm5794167/', 'name': 'Tejaa Deokar'},
      {'@type': 'Person', 'url': '/name/nm4391467/', 'name': 'Arun Kadam'}
    ],
    'director': {
      '@type': 'Person',
      'url': '/name/nm4940617/',
      'name': 'Milind Arun Kavde'
    },
    'description':
        "1234 is a movie starring some people. On India's Independence Day, a few people have a party.",
    'datePublished': '2016-08-05',
    'creator': {'@type': 'Organization', 'url': '/company/co0813120/'},
    'keywords': ['terror'],
    'aggregateRating': {
      '@type': 'AggregateRating',
      'ratingCount': 10,
      'bestRating': '10.0',
      'worstRating': '1.0',
      'ratingValue': '6.5'
    },
    'trailer': {
      '@type': 'VideoObject',
      'name': '1234 (2016) Trailer',
      'embedUrl': '/video/imdb/vi962903577',
      'thumbnail': {
        '@type': 'ImageObject',
        'contentUrl':
            'https://m.media-amazon.com/images/M/MV5BYjgwNjBmZjgtYTdiOS00ZDM4LWIxY2YtOGJmYmQ4MzlhOWIyXkEyXkFqcGdeQXRyYW5zY29kZS13b3JrZmxvdw@@._V1_.jpg'
      },
      'thumbnailUrl':
          'https://m.media-amazon.com/images/M/MV5BYjgwNjBmZjgtYTdiOS00ZDM4LWIxY2YtOGJmYmQ4MzlhOWIyXkEyXkFqcGdeQXRyYW5zY29kZS13b3JrZmxvdw@@._V1_.jpg',
      'description': "On India's Independence Day, a few people have a party.",
      'uploadDate': '2020-07-31T09:13:47Z'
    },
    'language': LanguageType.foreign,
    'languages': ['Marathi'],
    'related': [],
    'ratingCount': '10',
    'ratingValue': '6.5',
    'id': 'tt7602562'
  }
];

const imdbJsonSampleInner = '''
<script type="application/ld+json">{
  "@context": "http://schema.org",
  "@type": "Movie",
  "url": "/title/tt7602562/",
  "name": "1234",
  "image": "https://m.media-amazon.com/images/M/MV5BMDMyOD...XkEyXkFqcGdeQXVyMTc4OTM4NjE@._V1_.jpg",
  "genre": "Drama",
  "actor": [
    {
      "@type": "Person",
      "url": "/name/nm2487587/",
      "name": "Abhijeet Chavhan"
    },
    {
      "@type": "Person",
      "url": "/name/nm3874318/",
      "name": "Kishore Chougule"
    },
    {
      "@type": "Person",
      "url": "/name/nm5794167/",
      "name": "Tejaa Deokar"
    },
    {
      "@type": "Person",
      "url": "/name/nm4391467/",
      "name": "Arun Kadam"
    }
  ],
  "director": {
    "@type": "Person",
    "url": "/name/nm4940617/",
    "name": "Milind Arun Kavde"
  },
  "description": "1234 is a movie starring some people. On India\u0027s Independence Day, a few people have a party.",
  "datePublished": "2016-08-05",
  "creator": {
    "@type": "Organization",
    "url": "/company/co0813120/"
  },
  "keywords": "terror",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingCount": 10,
    "bestRating": "10.0",
    "worstRating": "1.0",
    "ratingValue": "6.5"
  },
  "trailer": {
    "@type": "VideoObject",
    "name": "1234 (2016) Trailer",
    "embedUrl": "/video/imdb/vi962903577",
    "thumbnail": {
      "@type": "ImageObject",
      "contentUrl": "https://m.media-amazon.com/images/M/MV5BYjgwNjBmZjgtYTdiOS00ZDM4LWIxY2YtOGJmYmQ4MzlhOWIyXkEyXkFqcGdeQXRyYW5zY29kZS13b3JrZmxvdw@@._V1_.jpg"
    },
    "thumbnailUrl": "https://m.media-amazon.com/images/M/MV5BYjgwNjBmZjgtYTdiOS00ZDM4LWIxY2YtOGJmYmQ4MzlhOWIyXkEyXkFqcGdeQXRyYW5zY29kZS13b3JrZmxvdw@@._V1_.jpg",
    "description": "On India\u0027s Independence Day, a few people have a party.",
    "uploadDate": "2020-07-31T09:13:47Z"
  }
}</script>
''';

const imdbHtmlSampleInner = '''

    <div class="txt-block">
    <h4 class="inline">Language:</h4>
        <a href="/search/title?title_type=feature&primary_language=mr&sort=moviemeter,asc&ref_=tt_dt_dt"
>Marathi</a>
    </div>


    <div class="txt-block">
    <h4 class="inline">Release Date:</h4> 5 August 2016 (India)
    <span class="see-more inline">
      <a href="releaseinfo?ref_=tt_dt_dt"
>See more</a>&nbsp;&raquo;
    </span>
    </div>



    <div class="imdbRating" itemtype="http://schema.org/AggregateRating" itemscope="" itemprop="aggregateRating">
        <div class="ratingValue">
            <strong title="6.5 based on 10 user ratings"><span itemprop="ratingValue">6.5</span></strong>
            <span class="grey">/</span><span class="grey" itemprop="bestRating">10</span>
        </div>
        <a href="/title/tt7602562/ratings?ref_=tt_ov_rt"><span class="small" itemprop="ratingCount">10</span></a>
    </div>

                        
''';

const imdbHtmlSampleStart = ' <!DOCTYPE html> <html     <head>';
const imdbHtmlSampleMiddle = ' </head> <body id="styleguide-v2" class="fixed">';
const imdbHtmlSampleEnd = ' </body> </html>';
const imdbHtmlSampleFull =
    '$imdbHtmlSampleStart $imdbJsonSampleInner $imdbHtmlSampleMiddle $imdbHtmlSampleInner $imdbHtmlSampleEnd';

Future<Stream<String>> streamImdbHtmlOfflineData(dynamic dummy) {
  return Future.value(emitImdbHtmlSample(dummy));
}

Stream<String> emitImdbHtmlSample(_) async* {
  yield imdbHtmlSampleFull;
}
