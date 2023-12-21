//
//  NewsTableViewCell.swift
//  News_Demo
//
//  Created by Jamal Ahamad on 04/02/20.
//  Copyright © 2020 Jamal Ahamad. All rights reserved.
//

import UIKit

protocol ViewMoreDelegate: class {
    func viewMoreButtonSelected(cell: NewsTableViewCell)
}

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAuther: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPublishedAt: UILabel!
    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var imgViewNews: UIImageView!
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var viewMoreButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDescriptionHeight: NSLayoutConstraint!
    var isViewMoreSelected = false
    weak var viewMoreDelegate: ViewMoreDelegate?
    var selctedIndex = 0
    
    var viewMoreheight: CGFloat {
        if self.lblDiscription.isTruncated {
            return 30
        } else {
            return 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpCellUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewMoreButtonHeight.constant = 30
        self.imgViewNews.image = nil
        self.lblAuther.text = ""
        self.lblTitle.text = ""
        self.lblPublishedAt.text = ""
        self.lblDiscription.text = ""
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpCellUI() {
        self.btnViewMore.clipsToBounds = true
        if isViewMoreSelected {
            self.lblDiscription.numberOfLines = 0
            self.lblDescriptionHeight.constant = self.lblDiscription.lblHeight
        } else {
            self.lblDescriptionHeight.constant = 45
            self.lblDiscription.numberOfLines = 2
        }
    }
    
    func setNewsData(newsModel: Articles? = nil, dbModel: NewsCoreDataModel? = nil) {
        if let nmodel = newsModel {
            self.lblAuther.text = nmodel.author
            self.lblTitle.text = nmodel.title
            self.lblPublishedAt.text = nmodel.publishedAt
            self.lblDiscription.text = nmodel.desc
        }
        
        if let dmodel = dbModel {
            self.lblAuther.text = dmodel.author
            self.lblTitle.text = dmodel.title
            self.lblPublishedAt.text = dmodel.publishedAt
            self.lblDiscription.text = dmodel.desc
            self.imgViewNews.image = UIImage(data: (dmodel.urlToImage ?? nil)!)
        }
    }
    
    @IBAction func viewMoreButtonClicked(_ sender: UIButton) {
        self.selctedIndex = self.tag
        self.isViewMoreSelected = !self.isViewMoreSelected
        if isViewMoreSelected {
            self.lblDiscription.numberOfLines = 0
        } else {
            self.lblDiscription.numberOfLines = 2
        }
        if self.viewMoreDelegate != nil {
            self.viewMoreDelegate?.viewMoreButtonSelected(cell: self)
        }
    }

}
