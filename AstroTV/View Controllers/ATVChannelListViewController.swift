//
//  ATVChannelListViewController.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/3/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class ATVChannelListViewController: ATVBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sortOrderButton: UIButton!
    
    
    var channelList = [ATVChannel]()
    var showingChannel = [ATVChannel]()
    var isLoading = false
    var isAsc = true {
        didSet {
            
            self.sortOrderButton.setTitle(isAsc ? "▲" : "▼", for: .normal)
        }
    }
    
    var favoritesUtils: ATVFavoritesUtils? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let identifier: String
        
        let gIDSignin = GIDSignIn.sharedInstance()!
        if let user = gIDSignin.currentUser {
            
            identifier = user.userID!
        } else {
            
            identifier = FBSDKAccessToken.current().userID!
        }
        
        self.favoritesUtils = ATVFavoritesUtils(identifier: identifier)
        
        let filePath = ATVFavoritesUtils.filePath(identifier: identifier).stringByDeletingPathExtension + "sort.plist"
        ATVNetworkUtils.sharedInstance.s3DownloadFile(filePath.lastPathComponent, filePath: filePath) { (result) in

            self.loadSortInfo(filePath: filePath)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadSortInfo(filePath: String) {
        
        if FileManager.default.fileExists(atPath: filePath), let sortInfo = NSDictionary(contentsOfFile: filePath) {
            
            self.sortSegmentedControl.selectedSegmentIndex = sortInfo[kSortMode] as! Int
            self.isAsc = sortInfo[kSortAsc] as! Bool
        
        }
        
        self.loadChannelList()
    }
    
    private func saveSortInfo() {
        
        let filePath = ATVFavoritesUtils.filePath(identifier: self.favoritesUtils!.identifier).stringByDeletingPathExtension + "sort.plist"
        let dictInfo = NSDictionary(dictionary: [kSortMode: self.sortSegmentedControl.selectedSegmentIndex, kSortAsc: self.isAsc])
        dictInfo.write(toFile: filePath, atomically: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            ATVNetworkUtils.sharedInstance.s3UploadFile(filePath.lastPathComponent, filePath: filePath, completionHandler: { (_) in
                
            })
        }
    }
    
    // MARK: - Action
    @IBAction func sortTypeChange(_ sender: Any) {
        
        self.resetOrder()
    }
    
    @IBAction func sortOrderAction(_ sender: Any) {
        
        self.isAsc = !self.isAsc
        self.resetOrder()
    }
    
    // MARK: - Loading
    private func loadChannelList() {
        
        self.showLoading(with: "Loading...")
        
        ATVNetworkUtils.sharedInstance.request(api: .getChannelList) { (response, code) in
            
            self.hideLoading()
            
            if let response = response {
                
                if let responseCode = response.responseCode, let code = HTTPCode(rawValue: responseCode), code == .success {
                    
                    self.channelList.removeAll()
                    if let channelList: [ATVChannel] = response.nestedObjectArray(arrayName: "channels") {
                        
                        self.channelList.append(contentsOf: channelList)
                        self.resetOrder()
                    }
                    
                    
                } else {
                    
                    self.showAlert(title: "Error", message: response.responseMessage ?? "Cannot complete request, please try later", buttonTitles: "Ok", completeHandler: nil)
                }
                
                self.tableView.reloadData()
                
            } else {
                
                self.showAlert(title: nil, message: "Cannot complete request, please try later", buttonTitles: "Ok", completeHandler: nil)
            }
            
        }
        
    }
    
    private func resetOrder() {
        
        self.showingChannel.removeAll()
        self.tableView.reloadData()
        
        let isSortByName = self.sortSegmentedControl.selectedSegmentIndex == 0
        
        self.channelList.sort { (channelA, channelB) -> Bool in
            
            if self.favoritesUtils!.check(with: channelA.channelId!) {
                
                return true
            }
            
            let result: Bool
            if isSortByName {
                
                let compare = channelA.channelTitle!.compare(channelB.channelTitle!)
                result = self.isAsc ? compare == .orderedAscending : compare == .orderedDescending
            } else {
                
                result = self.isAsc ? channelA.channelId! < channelB.channelId! : channelA.channelId! > channelB.channelId!
            }
            
            return result
            
        }
        
        self.loadChannelDetail()
        
        self.saveSortInfo()
    }
    
    private func loadChannelDetail() {
        
        self.isLoading = true
        self.showLoading(with: "Loading channel detail")
        
        let maxChannelPerRequest = Int(self.tableView.bounds.height / kChannelHeight) + 1
        let remaining = self.channelList.count - self.showingChannel.count
        let loadCount = maxChannelPerRequest > remaining ? remaining : maxChannelPerRequest
        let targetIndex = self.showingChannel.count + loadCount
        let channelNeedLoads = self.channelList[self.showingChannel.count..<targetIndex]
        let ids: [String] = channelNeedLoads.map {
            
            String($0.channelId!)
        }
        
        ATVNetworkUtils.sharedInstance.request(api: .getChannels, parameters: ["channelId" : ids.joined(separator: ",")]) { (response, code) in
            
            if let response = response {
                
                if let responseCode = response.responseCode, let code = HTTPCode(rawValue: responseCode), code == .success {
                    
                    if let channelList: [ATVChannel] = response.nestedObjectArray(arrayName: "channel") {
                        
                        channelList.forEach({ (nChannel) in
                            
                            if let index = self.channelList.index(where: { $0.channelId! == nChannel.channelId! }) {
                                
                                self.channelList[index] = nChannel
                            }
                            
                        })
                        
                        self.tableView.beginUpdates()
                        
                        var oldIndex = self.showingChannel.count
                        
                        let sortedList = self.channelList[self.showingChannel.count..<targetIndex]
                        self.showingChannel.append(contentsOf: sortedList)
                        let addIndexPaths: [IndexPath] = sortedList.map({ (_) -> IndexPath in
                            
                            let indexPath = IndexPath(row: oldIndex, section: 0)
                            oldIndex += 1
                            
                            return indexPath
                        })
                        
                        self.tableView.insertRows(at: addIndexPaths, with: UITableViewRowAnimation.left)
                        
                        self.tableView.endUpdates()
                    }
                    
                } else {
                    
                    self.showAlert(title: "Error", message: response.responseMessage ?? "Cannot complete request, please try later", buttonTitles: "Ok", completeHandler: nil)
                }
                
                
            } else {
                
                self.showAlert(title: nil, message: "Cannot complete request, please try later", buttonTitles: "Ok", completeHandler: nil)
            }
        }
        
        self.isLoading = false
        self.hideLoading()
    }
    
    
    @IBAction func logoutAction(_ sender: Any) {
        
        let filePath = ATVFavoritesUtils.filePath(identifier: self.favoritesUtils!.identifier).stringByDeletingPathExtension + "sort.plist"
        do {
            try FileManager.default.removeItem(atPath: filePath)
        } catch {
            
        }
        
        self.favoritesUtils?.clear()
        self.favoritesUtils = nil
        
        
        FBSDKLoginManager().logOut()
        GIDSignIn.sharedInstance().signOut()
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ATVChannelListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.showingChannel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ATVChannelTableViewCell", for: indexPath) as! ATVChannelTableViewCell
        cell.delegate = self
        
        let channel = self.showingChannel[indexPath.row]
        cell.channel = channel
        
        return cell
    }
    
}

extension ATVChannelListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return kChannelHeight
    }
}

extension ATVChannelListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            self.loadChannelDetail()
        }
    }
}

extension ATVChannelListViewController: ATVChannelTableViewCellDelegate {
    
    func channelTableviewCellDidPressFavorite(_ cell: ATVChannelTableViewCell) {
     
        self.favoritesUtils?.addOrRemove(with: cell.channel!.channelId!)
        
        self.tableView.reloadRows(at: [self.tableView.indexPath(for: cell)!], with: UITableViewRowAnimation.none)
    }
    
    func channelTableviewCellIsFavorited(_ cell: ATVChannelTableViewCell) -> Bool {
     
        return self.favoritesUtils!.check(with: cell.channel!.channelId!)
    }
}


