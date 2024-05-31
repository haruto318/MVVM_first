//
//  TimeLineViewController.swift
//  MVVM_first
//
//  Created by 濱野遥斗 on 2024/05/31.
//

import Foundation
import UIKit
import SafariServices

final class TimeLineViewController: UIViewController {
    
    fileprivate var viewModel: UserListViewModel!
    fileprivate var tableView: UITableView!
    fileprivate var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView .dataSource = self
        tableView.register(TimeLineCell.self,
                           forCellReuseIdentifier: "TimeLineCell")
        view.addSubview(tableView)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueDidChange(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        viewModel = UserListViewModel()
        viewModel.stateDidUpdate = {[weak self] state in
            switch state {
            case .loading:
               self?.tableView.isUserInteractionEnabled = false
                break
            case .finish:
                self?.tableView.isUserInteractionEnabled = true
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                break
            case .error(let error):
                self?.tableView.isUserInteractionEnabled = true
                self?.refreshControl.endRefreshing()
                
                let alertController = UIAlertController(title: error.localizedDescription,
                                                        message: nil,
                                                        preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK",
                                                style: .cancel,
                                                handler: nil)
                alertController.addAction(alertAction)
                self?.present(alertController, animated: true, completion: nil)
                break
            }
        }
        
        viewModel.getUsers()
    }
    
    @objc func refreshControlValueDidChange(sender: UIRefreshControl) {
        viewModel.getUsers()
    }
}

extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return viewModel.usersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        if let timelineCell = tableView.dequeueReusableCell(withIdentifier:
            "TimeLineCell") as? TimeLineCell {
     
            let cellViewModel = viewModel.cellViewModels[indexPath.row]
            timelineCell.setNickName(nickName: cellViewModel.nickName)
            
            cellViewModel.downloadImage { (progress) in
                switch progress {
                case .loading(let image):
                    timelineCell.setIcon(icon: image)
                    break
                case .finish(let image):
                    timelineCell.setIcon(icon: image)
                    break
                case .error:
                    break
                }
            }
            return timelineCell
        }
        
        fatalError()
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
 
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let webURL = cellViewModel.webURL
        let webViewController = SFSafariViewController(url: webURL)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
