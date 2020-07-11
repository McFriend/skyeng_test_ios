//
//  TableViewCell.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import UIKit
import RxSwift
class TableViewCell: UITableViewCell {
    var _viewModel: ViewModelProtocol?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }

    func initialSetup()
    {
        adjustUI()
        configureConstraints()
    }
    
    func adjustUI()
    {
        selectionStyle = .none
    }
    
    func configureConstraints()
    {
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        _viewModel?.bag = DisposeBag()
    }
}

extension UITableViewCell {
    var typeName: String {
        return String(describing: type(of: self))
    }
    
    static var typeName: String {
        return String(describing: self)
    }
}
