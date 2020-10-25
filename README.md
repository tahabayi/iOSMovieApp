# iOSMovieApp
MovieListViewController.swift
- Implements movie listing page controller
- Controlls collection view to handle movie listing
- Implements grid view, list view switching button
- Implements search and filter movie titles by phrases

MovieDetailViewController.swift
- Implements movie detail page controller
- Controlls detatil page for title label, vote count label, description, add to favorite button, movie image etc.

Main.storyboard
- Implements movie list and and movie detail views

MovieCollectionViewCell.swift
- Keeps movie list cell views to edit their properties

Models.swift
- Implements MovieListResponse model to handle response data from api
- Implements Movie model to keep movie data fetched from server, also has add to favorites and remove from favorites functions.

Constants.swift
- Keeps urls of apis

FavoriteMovies.xcdatamodeld
- Model to storage favorite movies locally

AsyncImageView.swift
- Subclass of UIView in order to handle async image loading from server

![Grid View](https://raw.githubusercontent.com/tahabayi/iOSMovieApp/main/view-grid.png)
![List View](https://raw.githubusercontent.com/tahabayi/iOSMovieApp/main/view-list.png)
![Detail Page 1](https://raw.githubusercontent.com/tahabayi/iOSMovieApp/main/detail-page-1.png)
![Detail Page 2](https://raw.githubusercontent.com/tahabayi/iOSMovieApp/main/detail-page-2.png)
