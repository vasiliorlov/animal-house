//
//  AHCell.swift
//  Animal House
//
//  Created by iMac on 16.06.16.
//  Copyright © 2016 Vasili Orlov House. All rights reserved.
//

import UIKit

class AHCell: UITableViewCell {

   
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!

    
    @IBOutlet var descriptionView: UIView!
    @IBOutlet var photoView: UIView!
    
    @IBOutlet var photoImageView: UIImageView!
    var isPhotoView:Bool = true {
        
        didSet {
            print(nameLabel.text ," isPhotoView = ",isPhotoView )
            if isPhotoView ==  false {
                //hide photo
                    UIView.transitionFromView(photoView,
                    toView: descriptionView,
                    duration: 1.0,
                    options: [UIViewAnimationOptions.TransitionFlipFromLeft , UIViewAnimationOptions.ShowHideTransitionViews],
                    completion:nil)
                    } else {
                //
                //    //show photo
                    UIView.transitionFromView(descriptionView,
                    toView: photoView,
                    duration: 1.0,
                    options: [UIViewAnimationOptions.TransitionFlipFromRight , UIViewAnimationOptions.ShowHideTransitionViews],
                    completion: nil)
                    }
              //  setNeedsDisplay()
            }
        }
        
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
