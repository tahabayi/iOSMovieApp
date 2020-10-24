//
//  MovieCellCollectionViewCell.swift
//  iOSMovieApp
//
//  Created by Taha Metin Bayi on 23.10.2020.
//  Copyright © 2020 Taha Metin Bayi. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
