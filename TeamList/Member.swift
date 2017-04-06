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
  var known: Bool = false
}

let k_known_people = "knownPeople"

extension Member {
  init?(node: XMLElement) {
    guard let name = node.css(".member-name").first?.text else { return nil }
    guard let imageUrl = URL(string: (node.css(".member-img img").first?["src"]!)!) else { return nil }

    self.name = name
    self.imageUrl = imageUrl
  }

  static func setupKnownPeopleStorage() {
    let defaults = UserDefaults.standard
    defaults.set([], forKey: k_known_people)
  }

  func toggleIsKnown() {
    let defaults = UserDefaults.standard
    var currentlyKnown = [String]()
    let imageUrlString = imageUrl.absoluteString
    if let known = defaults.object(forKey: k_known_people) as? [String] {
      currentlyKnown = known
    } else {
      Member.setupKnownPeopleStorage()
      currentlyKnown = []
    }

    let isKnown: Bool = currentlyKnown.contains(where: { (imageUrlParam: String) -> Bool in
      return imageUrlString == imageUrlParam
    })

    var newKnownArray = [String]()

    if(isKnown) {
      newKnownArray = currentlyKnown.filter({ (imageUrlParam) -> Bool in
        imageUrlParam != imageUrlString
      })
    } else {
      newKnownArray = currentlyKnown + [imageUrlString]
    }

    defaults.set(newKnownArray, forKey: k_known_people)
    print(newKnownArray)
  }
}
