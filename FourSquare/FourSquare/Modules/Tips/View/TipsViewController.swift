//
//  TipsViewController.swift
//  FourSquare
//
//  Created Sameh Mabrouk on 10/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//
//  Template generated by Sameh Mabrouk https://github.com/iSame7
//

import UIKit

class TipsViewController: UIViewController, TipsViewable {
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: ViewModel?
    var presenter: TipsPresenting?
    var headerView: VenueUITableHeaderView?
    let screenWidth = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpHeader()
        setUpTableView()
    }
    
    func setUpHeader() {
        headerView = VenueUITableHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 500), backAction: { [weak self] in
            self?.presenter?.dismiss()
        })
        if let presenter = presenter , let viewModel = viewModel {
            headerView?.configure(with: presenter.buildVenueTableHeaderViewModel(title: viewModel.title, description: viewModel.description, imageURL: viewModel.venuImageURL))
        }
    }
    
    func setUpTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 99
        tableView.contentInset  = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
        tableView.addSubview(headerView!)
        
        tableView.tableFooterView = UIView()
        
    }
    
}

// MARK:- UITableViewDataSource
extension TipsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.tips.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipCell") as! TipTableViewCell
        if let presenter = presenter, let tip = viewModel?.tips[indexPath.row], let user = tip.user, let userPhoto = user.photo {
            cell.setup(with: presenter.buildTipTableCellViewModel(userName: user.firstName ?? "--", userImageURL: "\(userPhoto.prefix)500x500\(userPhoto.suffix)", createdAt: Double(tip.createdAt ?? 0).getDateStringFromUTC(), tipText: tip.text ?? "--"))
        }
        return cell
    }
}

// MARK: - StoryboardInstantiatable
extension TipsViewController: StoryboardInstantiatable {
    static var storyboardName: String {
        return "MapViewController"
    }
    static var instantiateType: StoryboardInstantiateType {
        return .identifier("TipsViewController")
    }
}

extension TipsViewController {
    struct ViewModel {
        let venuImageURL: String?
        let tips: [TipItem]
        let title: String
        let description: String
    }
    
    func update(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UIScrollViewDelegate
extension TipsViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if headerView != nil {
            let yPos: CGFloat = -scrollView.contentOffset.y
            
            if yPos > 0 {
                var imgRect: CGRect? = headerView?.frame
                imgRect?.origin.y = scrollView.contentOffset.y
                imgRect?.size.height = screenWidth/2 + yPos  - screenWidth/2
                headerView?.frame = imgRect!
                self.tableView.sectionHeaderHeight = (imgRect?.size.height)!
                
            }
        }
    }
}
