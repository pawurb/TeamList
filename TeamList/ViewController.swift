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
import SnapKit

enum FilterValues: Int {
  case All = 0
  case Known = 1
  case Unknown = 2
}

class ViewController: UIViewController {
  private let disposeBag = DisposeBag()
  @IBOutlet weak var tableView: UITableView!
  var members: Variable<[Member]> = Variable([])
  let filterTabs: UISegmentedControl = UISegmentedControl(items: ["All", "Known", "Unknown"])

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabs()
    tableView.register(MemberCell.self, forCellReuseIdentifier: MemberCell.reuseIdentifier())
    tableView.rowHeight = 150
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0)

    Observable.combineLatest(members.asObservable(), filterTabs.rx.value) { ($0, $1) }
    .map { (membersList, filterValue) in
        return membersList.filter({ member in
          if filterValue == FilterValues.All.rawValue {
            return true
          } else if filterValue == FilterValues.Unknown.rawValue {
            return !member.known
          } else {
            return member.known
          } 
        })
    }.bindTo(tableView.rx.items(
        cellIdentifier: MemberCell.reuseIdentifier(),
        cellType: MemberCell.self)) { (_, member: Member, cell) in
          cell.setup(member: member)
    }.disposed(by: disposeBag)

    tableView.rx.itemSelected.subscribe(onNext: { [unowned self] _ in
      if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
        self.tableView.deselectRow(at: selectedIndexPath, animated: true)
        let toggledMember = self.members.value[selectedIndexPath.row].toggledIsKnown()
        self.members.value[selectedIndexPath.row] = toggledMember
      }
    }).disposed(by: disposeBag)

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

  func setupTabs() {
    view.addSubview(filterTabs)
    filterTabs.translatesAutoresizingMaskIntoConstraints = false
    filterTabs.selectedSegmentIndex = 0
    filterTabs.snp.makeConstraints({ make in
      make.top.equalTo(view.snp.top).offset(20)
      make.bottom.equalTo(tableView.snp.top)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
    })
  }
}

