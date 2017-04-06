//
//  ViewController.swift
//  TeamList
//
//  Created by Pawel Urbanek on 06/04/2017.
//  Copyright © 2017 Pawel Urbanek. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Alamofire
import RxAlamofire
import Kanna

class ViewController: UIViewController {
  private let disposeBag = DisposeBag()
  @IBOutlet weak var tableView: UITableView!
  var members: Variable<[Member]> = Variable([])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    view.rx.tapGesture().when(.recognized)
    .subscribe(onNext: { [weak self] _ in
      self?.refresh()
    }).disposed(by: disposeBag)

    members.asObservable().bindTo(tableView.rx.items(
        cellIdentifier: "Cell",
        cellType: UITableViewCell.self)) { (_, member: Member, cell) in
          cell.textLabel?.text = member.name
    }.disposed(by: disposeBag)
    refresh()
  }

  func refresh() {
    RxAlamofire.requestString(.get, "https://www.elpassion.com/about-us/")
    .map({ (res, html) -> [Member] in
      if let doc = HTML(html: html, encoding: .utf8) {
        return doc.css(".team-member").flatMap({ (node) in
          return Member(node: node)
        })
      } else {
        return []
      }
    }).bindTo(members)
    .disposed(by: disposeBag)
  }
}
