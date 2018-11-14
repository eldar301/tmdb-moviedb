# tmdb-moviedb
## Приложение для поиска фильмов ##

### Архитектура ###
Используется [VIPER](https://medium.com/@smalam119/viper-design-pattern-for-ios-application-development-7a9703902af6):

<img src="https://www.objc.io/images/issue-13/2014-06-07-viper-wireframe-76305b6d.png" height="300" />

* View отвечает за отображение данных (фильмы, актеры, обзоры)
* Presenter - за предоставление данных для View в удобном виде
* Router - за переходы между сценами (поиск -> детальное отображение, обзор -> поиск по категориям и другие)
* Interactor - осуществляет API-запросы к TMDb
* Entity - объекты модели, которые возвращает Interactor для Presenter

### The Movie Database API ###
Используется [API v3](https://developers.themoviedb.org/3/getting-started/introduction)
### Библиотеки ###
Для преобразования данных из формата JSON в объекты модели используется [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper)

Для преобразования RAW-данных в JSON - [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

Для HTTP-запросов - [Alamofire](https://github.com/Alamofire/Alamofire)

Для скачивания и кэширования изображений - [SDWebImage](https://github.com/SDWebImage/SDWebImage)

<img src="https://thumbs.gfycat.com/WetOrneryKentrosaurus-size_restricted.gif" height="500" />
