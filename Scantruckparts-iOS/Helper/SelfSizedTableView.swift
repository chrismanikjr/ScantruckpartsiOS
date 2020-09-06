//
//  SelfSizedTableView.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 8/27/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {

  var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
      super.reloadData()
      self.invalidateIntrinsicContentSize()
      self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        setNeedsLayout()
        layoutIfNeeded()
      let height = min(contentSize.height, maxHeight)
      return CGSize(width: contentSize.width, height: height)
    }
}
