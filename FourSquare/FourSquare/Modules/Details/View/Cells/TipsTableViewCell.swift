//
//  TipesTableViewCell.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 10/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

typealias TipSelectionHandler = (() -> Void)
class TipsTableViewCell: UITableViewCell {
    @IBOutlet weak var tableView: UITableView!
    var selectedTipClosure: TipSelectionHandler?
    private var viewModel: ViewModel?
    
    struct ViewModel {
        let tips: [TipItem]
    }
    
    override func awakeFromNib() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 99
    }
    
    // resize cell according to table view size
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        tableView.layoutIfNeeded()
        tableView.frame = CGRect(x: 0, y: 0, width: targetSize.width , height: 1)
        return tableView.contentSize
    }
    
    func setup(with viewModel: ViewModel, tipSelectionHandler: @escaping TipSelectionHandler) {
        self.viewModel = viewModel
        tableView.reloadData()
        self.selectedTipClosure = tipSelectionHandler
    }
}

extension TipsTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTipClosure?()
    }
}

extension TipsTableViewCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.tips.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipCell") as! TipTableViewCell
        
        if let tip = viewModel?.tips[indexPath.row], let user = tip.user, let userPhoto = user.photo {
            cell.setup(with: TipTableViewCell.ViewModel(userName: user.firstName ?? "--", userImageURL: "\(userPhoto.prefix)500x500\(userPhoto.suffix)", createdAt: Double(tip.createdAt ?? "-")?.getDateStringFromUTC() ?? "-", tipText: tip.text ?? "--"))
        }
        return cell
    }
}
