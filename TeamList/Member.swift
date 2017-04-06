//
//  Member.swift
//  TeamList
//
//  Created by Pawel Urbanek on 06/04/2017.
//  Copyright © 2017 Pawel Urbanek. All rights reserved.
//

import Foundation
import Kanna

struct Member {
  let name: String
  let imageUrl: URL
}

extension Member {
  init?(node: XPathObject) {
    guard let name = node.css(".member-name").first?.text else { return nil }
    guard let imageUrl = URL(string: node.css(".member-img img").first?["src"])? else { return nil }

    self.name = name
    self.imageUrl = imageUrl
  }
}
