//
//  PlayerLeaderboardVC.swift
//  Leaderboard
//
//  Created by Amin
//

import UIKit

class PlayerLeaderboardVC: UIViewController {
    
    var cellName: String { "Cell" }
    
    @IBOutlet var headerContainer: UIView!
    @IBOutlet var headerTop: NSLayoutConstraint!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var tableViewContainer: UIView!
    @IBOutlet var tableViewContainerTop: NSLayoutConstraint!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshControlShouldRefresh(_:)), for: .valueChanged)
        return control
    }()
    
    var viewModel: PlayerLeaderboardVM!
    var top3PlayersVC: Top3PlayersVC?
    
    var headerHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.observeDidSelectPlayer { [weak self] player in
            self?.showPlayerProfile(for: player)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshLeaderboard()
    }
    
    @objc func refreshControlShouldRefresh(_ sender: UIRefreshControl) {
        refreshLeaderboard()
    }
    
    func setupUI() {
        headerHeight = tableViewContainerTop.constant
        headerContainer.backgroundColor = .white
        
        let nib = UINib(nibName: "LeaderboardPlayerCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellName)
        
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        
        tableView.tableFooterView = UIView()
        
        tableViewContainer.addShadow()
        
        loadingIndicator.tintColor = brandColor
    }
    
    func refreshUI() {
        loadingIndicator.stopAnimating()
        refreshControl.endRefreshing()
        
        func showTop3Players() {
            tableViewContainerTop.constant = headerHeight
            headerTop.constant = 0
            headerContainer.isHidden = false
            self.headerContainer.alpha = 1
            
            UIView.animate(withDuration: 0.27) {
                self.view.layoutIfNeeded()
            }
            
            top3PlayersVC = top3PlayersVC ?? Top3PlayersVC(nibName: "Top3PlayersVC", bundle: nil)
            self.embed(top3PlayersVC!, inside: headerContainer)
            
            let vm = Top3PlayersVM(with: viewModel.top3Players)
                .observeDidSelect { [weak self] in
                    do {
                        try self?.viewModel.didSelectTop3Player(at: $0)
                    } catch {
                        print(error)
                    }
                }
            top3PlayersVC?.setup(with: vm)
            top3PlayersVC?.updateUI()
        }
        
        func hideTop3Players() {
            headerContainer.isHidden = true
            tableViewContainerTop.constant = 0
            
            guard let vc = top3PlayersVC else { return }
            self.removeChild(vc)
            
            top3PlayersVC = nil
        }
        
        if viewModel.top3Players.isEmpty {
            hideTop3Players()
        } else {
            showTop3Players()
        }
        
        tableViewContainer.isHidden = false
        
        if viewModel.listPlayers.isEmpty == false {
            reloadTableView()
        } else if let messageText = viewModel.messageText {
            messageLabel.isHidden = false
            messageLabel.text = messageText
        }
    }
    
    func refreshLeaderboard() {
        messageLabel.isHidden = true
        
        if viewModel.listPlayers.isEmpty {
            headerContainer.isHidden = true
            tableViewContainer.isHidden = true
            
            loadingIndicator.startAnimating()
        }
        
        viewModel.load { [weak self] in
            DispatchQueue.main.async {
                self?.refreshUI()
            }
        }
    }
    
}

extension PlayerLeaderboardVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! LeaderboardPlayerCell
        
        let cellVM = viewModel.listPlayers[indexPath.row]
        cell.setup(viewModel: cellVM)
        
        return cell
    }
    
}

extension PlayerLeaderboardVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            try viewModel.didSelectListPlayer(at: indexPath.row)
        } catch {
            print(error)
        }
    }
    
}

extension PlayerLeaderboardVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard headerContainer.isHidden == false else { return }
        
        let change = scrollView.contentOffset.y
        
        if change > 0 {
            if tableViewContainerTop.constant > 0 {
                let listY = max(0, tableViewContainerTop.constant - change)
                let headerY = max(-headerHeight/3, headerTop.constant - change/3)
                
                listShouldScroll(headerY: headerY, listY: listY)
            }
        } else if change < 0 {
            if tableViewContainerTop.constant < headerHeight {
                let listY = min(headerHeight, tableViewContainerTop.constant - change)
                let headerY = min(0, headerTop.constant - change/3)
                
                listShouldScroll(headerY: headerY, listY: listY)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if tableViewContainerTop.constant < headerHeight/2 {
            listShouldScroll(headerY: -headerContainer.bounds.height/3, listY: 0)
        } else {
            listShouldScroll(headerY: 0, listY: headerHeight)
        }
    }
    
    func listShouldScroll(headerY: CGFloat, listY: CGFloat) {
        guard headerContainer.isHidden == false else { return }
        
        self.tableViewContainerTop.constant = listY
        self.headerTop.constant = headerY
        
        let percent = listY/headerHeight
        self.headerContainer.alpha = percent
    }
    
}

extension PlayerLeaderboardVC {
    
    func reloadTableView() {
        let currentPlayerIndex = viewModel.listPlayers.firstIndex { $0.isCurrentPlayer }
        
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: currentPlayerIndex ?? 0, section: 0),
                              at: .top,
                              animated: false)
        tableView.layoutIfNeeded()
        tableView.scrollToRow(at: IndexPath(row: currentPlayerIndex ?? 0, section: 0),
                              at: .top,
                              animated: false)
        
        guard let currentPlayerIndex = currentPlayerIndex,
              let indexPathsToAnimate = tableView.indexPathsForVisibleRows?.filter({ $0.row > currentPlayerIndex })
        else { return }
        
        for indexPath in indexPathsToAnimate {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.alpha = 0
        }
        
        var counter = 0
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { [weak self] timer in
            guard let _weakSelf = self else { timer.invalidate(); return }
            
            if counter < indexPathsToAnimate.count {
                let indexPath = indexPathsToAnimate[counter]
                
                DispatchQueue.main.async {
                    let cell = _weakSelf.tableView.cellForRow(at: indexPath) as? LeaderboardPlayerCell
                    cell?.animateWithDropDownEffect()
                }
                
                counter += 1
            } else {
                timer.invalidate()
                
                let indexPath = IndexPath(row: currentPlayerIndex, section: 0)
                
                DispatchQueue.main.async {
                    let cell = _weakSelf.tableView.cellForRow(at: indexPath) as? LeaderboardPlayerCell
                    cell?.animateContentChanges()
                }
            }
        }
    }
    
    func showPlayerProfile(for player: LeaderboardPlayerVM) {
        let vc = PlayerProfileVC(nibName: "PlayerProfileVC", bundle: nil)
        vc.viewModel = .init(playerDetails: .init(id: player.id,
                                                  name: player.fullNameText,
                                                  imageURL: player.url),
                             provider: Providers.playerStatistics)
        
        self.show(vc, sender: nil)
    }
    
}
