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
  let known: Bool
}

let k_known_people = "knownPeople"

extension Member {
  init?(node: XMLElement) {
    guard let name = node.css(".member-name").first?.text else { return nil }
    guard let imageUrl = URL(string: (node.css(".member-img img").first?["src"]!)!) else { return nil }

    self.name = name
    self.imageUrl = imageUrl
    self.known = Member.isKnown(imageUrlString: imageUrl.absoluteString)
  }

  static func isKnown(imageUrlString: String) -> Bool {
    let currentlyKnown = currentlyKnownMaker()

    return currentlyKnown.contains(where: { (imageUrlParam: String) -> Bool in
      return imageUrlString == imageUrlParam
    })
  }

  static func currentlyKnownMaker() -> [String] {
    let defaults = UserDefaults.standard

    if let known = defaults.object(forKey: k_known_people) as? [String] {
      return known
    } else {
      defaults.set([], forKey: k_known_people)
      return []
    }
  }

  func toggledIsKnown() -> Member {
    let defaults = UserDefaults.standard
    let imageUrlString = imageUrl.absoluteString
    let currentlyKnown = Member.currentlyKnownMaker()
    let isKnown = Member.isKnown(imageUrlString: imageUrlString)

    var newKnownArray = [String]()

    if(isKnown) {
      newKnownArray = currentlyKnown.filter({ (imageUrlParam) -> Bool in
        imageUrlParam != imageUrlString
      })
    } else {
      newKnownArray = currentlyKnown + [imageUrlString]
    }

    defaults.set(newKnownArray, forKey: k_known_people)

    return Member(name: name, imageUrl: imageUrl, known: !known)
  }
}
