//
//  HomeViewController.swift
//  News_Demo
//
//  Created by Jamal Ahamad on 04/02/20.
//  Copyright © 2020 Jamal Ahamad. All rights reserved.
//

import UIKit
import Reachability

class HomeViewController: UIViewController {
    var viewModel: NewsViewModel?
    var newsModelArray = [Articles]()
    var dbModelArray = [NewsCoreDataModel]()
    var dbManager = DataBaseManager()
    @IBOutlet weak var segmentControler: UISegmentedControl!
    @IBOutlet weak var tbleViewNewsFeed: UITableView!
    let reachability = try! Reachability()
    var totalEntries = 100
    var pageNumber = 1
    var language = "en"
    var pageSize = "20"
    var dbMngr = DataBaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NewsViewModel()
        LoadingOverlay.shared.showOverlay(view: self.view)
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
          try reachability.startNotifier()
        }catch{
          print("could not start reachability notifier")
        }
        self.getNewsData(pages: "\(self.pageNumber)", language: language, pageSize: self.pageSize, isFilter: false)
    }
    
    func setUpUI() {
        self.tbleViewNewsFeed.register(UINib(nibName: "\(NewsTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(NewsTableViewCell.self)")
        self.tbleViewNewsFeed.estimatedRowHeight = 88.0
        self.tbleViewNewsFeed.rowHeight = UITableView.automaticDimension
        self.tbleViewNewsFeed.dataSource = self
        self.tbleViewNewsFeed.delegate = self
        for i in 0..<languageTitleRray.count {
            self.segmentControler.setTitle(languageTitleRray[i].0.rawValue.capitalized, forSegmentAt: i)
        }
    }


    func getNewsData(pages: String, language: String, pageSize: String, isFilter: Bool) {
        viewModel?.getNewsData(pages: pages, language: language, pageSize: pageSize, completion: { (newsModelArray, error) in
            
            if error == nil {
                if let arra = newsModelArray {
                    DispatchQueue.main.async {
                        if isFilter {
                            self.newsModelArray = arra.articles!
                        } else {
                            if self.newsModelArray.count < self.totalEntries {
                                self.newsModelArray += arra.articles!
                                self.pageSize = "\(self.newsModelArray.count)"
                                self.dbMngr.deleteData()
                                self.dbMngr.saveData(newsFeeds: self.newsModelArray)
                            }
                        }
                        self.tbleViewNewsFeed.reloadData()
                        LoadingOverlay.shared.hideOverlayView()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.dbModelArray = self.dbManager.fetchData()
                    self.tbleViewNewsFeed.reloadData()
                    LoadingOverlay.shared.hideOverlayView()
                }
                print("error: \(String(describing: error?.localizedDescription))")
            }
            
        })
    }
    
    @IBAction func segmentControllerAction(_ sender: UISegmentedControl) {
        self.getNewsData(pages: "\(self.pageNumber)", language: languageTitleRray[sender.selectedSegmentIndex].1, pageSize: "\(self.newsModelArray.count)", isFilter: true)
        self.language = languageTitleRray[sender.selectedSegmentIndex].1
        LoadingOverlay.shared.showOverlay(view: self.view)
    }
    
    @objc func reachabilityChanged(note: Notification) {

      let reachability = note.object as! Reachability

      switch reachability.connection {
      case .wifi:
          print("Reachable via WiFi")
      case .cellular:
          print("Reachable via Cellular")
      case .unavailable:
        self.showAlert(title: "Alert", message: "No Internet Connection") { (flag) in
            if flag {
                self.getNewsData(pages: "\(self.pageNumber)", language: self.language, pageSize: self.pageSize, isFilter: false)
            }
        }
      case .none:
        break
        }
    }
    
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reachability.stopNotifier()
               NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.newsModelArray.count > 0 {
            return self.newsModelArray.count

        } else if self.dbModelArray.count > 0 {
          return self.dbModelArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbleViewNewsFeed.dequeueReusableCell(withIdentifier: "\(NewsTableViewCell.self)", for: indexPath) as? NewsTableViewCell
        cell?.tag = indexPath.row
        cell?.tag = indexPath.row
        cell?.viewMoreDelegate = self
        
        if self.newsModelArray.count > 0 {
            cell?.setNewsData(newsModel: (self.newsModelArray[indexPath.row]))
            self.viewModel?.downLoadImage(urlStr: self.newsModelArray[indexPath.row].urlToImage ?? "", completion: { (imgData) in
                DispatchQueue.main.async() {
                    if cell?.tag == indexPath.row{
                        cell?.imgViewNews.image = UIImage(data: imgData)
                    }
                }
            })
        } else if self.dbModelArray.count > 0{
            cell?.setNewsData(newsModel: nil, dbModel: self.dbModelArray[indexPath.row])
        }
        
        if cell?.selctedIndex == indexPath.row {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                 cell?.viewMoreButtonHeight.constant = cell?.viewMoreheight ?? 30
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.newsModelArray.count - 1 {
            self.getNewsData(pages: "\(pageNumber)", language: self.language, pageSize: "20", isFilter: false)
        }
    }

}

extension HomeViewController: ViewMoreDelegate {
    func viewMoreButtonSelected(cell: NewsTableViewCell) {
        if cell.isViewMoreSelected {
            cell.lblDiscription.numberOfLines = 0
            cell.lblDescriptionHeight.constant = cell.lblDiscription.lblHeight
            
        } else {
            cell.lblDiscription.numberOfLines = 2
            cell.lblDescriptionHeight.constant = 45
        }
        self.tbleViewNewsFeed.reloadData()
    }
}

