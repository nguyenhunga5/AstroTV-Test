//
//  ATVChannelTableViewCell.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/3/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit

protocol ATVChannelTableViewCellDelegate {
    
    func channelTableviewCellDidPressFavorite(_ cell: ATVChannelTableViewCell)
    func channelTableviewCellIsFavorited(_ cell: ATVChannelTableViewCell) -> Bool
    
}

class ATVChannelTableViewCell: UITableViewCell {

    @IBOutlet weak var channelLogoImageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var delegate: ATVChannelTableViewCellDelegate?
    
    var channel: ATVChannel? {
        
        didSet {
            
            self.channelTitleLabel.text = channel?.channelTitle
            self.eventNameLabel.text = ""
            self.eventTimeLabel.text = ""
            self.loadingIndicatorView.startAnimating()
            
            self.imageView?.image = nil
            if let channel = channel {
                
                if let favorited = self.delegate?.channelTableviewCellIsFavorited(self), favorited {
                    
                    self.favoriteButton.setImage(#imageLiteral(resourceName: "favorited"), for: .normal)
                } else {
                    
                    self.favoriteButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
                }
                
                if let channelExts = channel.channelExtRef, let imagePath = channelExts.first?.value, let url = URL(string: imagePath) {
                    
                    self.channelLogoImageView.setImage(with: url, placeholderImage: nil)
                }
                
                let updateEvent = {(event: ATVEvent) -> Void in
                    
                    self.eventNameLabel.text = event.programmeTitle!
                    self.eventTimeLabel.text = Date.fromString(event.displayDateTime!, format: kEventDateFormat)?.toString(with: kEventDisplayFormat)
                    self.loadingIndicatorView.stopAnimating()
                }
                
                if channel.needUpdateEvent() {
                    
                    ATVNetworkUtils.sharedInstance.getEvent(forChannel: channel, completionHandler: { (event) in
                        
                        if let event = event {
                            
                            updateEvent(event)
                        }
                        
                    })
                } else {
                    
                    updateEvent(channel.currentEvent!)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        
        self.delegate?.channelTableviewCellDidPressFavorite(self)
    }
    

}
