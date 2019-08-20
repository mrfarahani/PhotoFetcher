
# PhotoFetcher

`PhotoFetcher` is a sample iOS app that fetches images from Flickr and displays them on a `UICollectionView`. 


## Features
- [x] Pure Swift 5
- [x] No third-party libraries

## Design & Architecture    

The project is a single page application and is implemented with **MVVM** design pattern for a more reliable, testable and cleaner codebase.

The project consists of several layers: Data models, Networking, Image Service, and Scenes (UI). 

The only layer that contains UI-related code is the Scene layer. The project also contains a collection of tests suits for non-UI layers. 

The project is designed to be easy to maintain and adopt new features and requirements in the future. For example if a new Image provider service (e.g. Tumblr) is required it will be implemented in the service layer and no UI-related code will be touched and it will be adopted by changing a single line of client code. 

The network layer uses `URLCache` to enable a simple caching system to improve application performance and avoid downloding the same image every time the cell is reused.

The views and collection view controller are created using storyboards. 

The collection view controller contains a search bar and a collection view to display the search results. Search actions are triggered both on tapping search button and scrolling to the end of the collection view which provides an indefinite scrolling experience. If an error occurs (e.g. no network connection) the related error is passed to the controller using completion handlers and displayed to the user using an alert message. This controller is backed by a view model to handle most of the view related logics. 

Flickr contains many duplicated images and therefore it's very likely if they appear on the collection view.

The collection view data source is implemented in the controller and the data is provided by the view model. The view model handles search events triggered from view controller and passes the fetched data to the controller.

