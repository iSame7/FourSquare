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
    
    struct ViewModel {
        let tips: [Int]
    }
    
    override func awakeFromNib() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 99
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        tableView.layoutIfNeeded()
        tableView.frame = CGRect(x: 0, y: 0, width: targetSize.width , height: 1)
        return tableView.contentSize
    }
    
    func setup(with viewModel: ViewModel, tipSelectionHandler: @escaping TipSelectionHandler) {
//        tableView.reloadData()
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipCell") as! TipTableViewCell
        cell.setup(with: TipTableViewCell.ViewModel(userImageURL: "", createdAt: "", tipText: ""))
        return cell
    }
}
