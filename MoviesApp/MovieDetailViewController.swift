//
//  MovieDetailViewController.swift
//  MoviesApp
//
//  Created by Hemal on 02/05/20.
//  Copyright © 2020 Hemal. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var moviesData :MovieResult?
    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var movieOverView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovieDetails()
    }
    
    //MARK: - load data
    private func loadMovieDetails() {
        movieOverView.text = moviesData?.overview
        
        if let imageEndPath = moviesData?.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/original/\(imageEndPath)")
            self.moviePoster.kf.setImage(with: url)
        }
        
        if let movieID = moviesData?.id {
                _ = NetworkAccess.fetchData(req: MovieDetailRequest(movieID: "\(movieID)"),completionHandler: { [weak self] (result) in
                    guard let self = self else {return}
                    switch result {
                    case .success(let movieDetail):
                        
                        print(movieDetail)
                    case .cancel(let cancelError):
                        print(cancelError!)
                    case .failure(let error):
                        print(error!)
                    }
                })
        }
        
    }
}
