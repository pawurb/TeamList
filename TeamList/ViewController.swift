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

let DATA_URL = "https://www.elpassion.com/about-us/"

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
      return self.filteredByKnownStatus(members: membersList, filterValue: FilterValues(rawValue: filterValue)!)
    }.bindTo(tableView.rx.items(
        cellIdentifier: MemberCell.reuseIdentifier(),
        cellType: MemberCell.self)) { (_, member: Member, cell) in
          cell.setup(member: member)
    }.disposed(by: disposeBag)

    members.asObservable()
    .subscribe(onNext: { membersList in
      let allCount = membersList.count
      let knownCount = self.filteredByKnownStatus(members: membersList, filterValue: .Known).count
      let unknownCount = allCount - knownCount
      self.filterTabs.setTitle("All (\(allCount))", forSegmentAt: FilterValues.All.rawValue)
      self.filterTabs.setTitle("Known (\(knownCount))", forSegmentAt: FilterValues.Known.rawValue)
      self.filterTabs.setTitle("Unknown (\(unknownCount))", forSegmentAt: FilterValues.Unknown.rawValue)
    }).disposed(by: disposeBag)

    tableView.rx.modelSelected(Member.self)
    .subscribe(onNext: { member in
      let toggledMember = member.toggledIsKnown()
      guard let index = self.members.value.index(where: { $0.imageUrl == member.imageUrl }) else { return }
      self.members.value[index] = toggledMember
    }).disposed(by: disposeBag)
    
    refresh()
  }

  func refresh() {
    let refresherView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    refresherView.translatesAutoresizingMaskIntoConstraints = false
    refresherView.startAnimating()
    view.addSubview(refresherView)
    refresherView.snp.makeConstraints({ make in
      make.centerX.equalTo(view.snp.centerX)
      make.centerY.equalTo(view.snp.centerY)
      make.width.equalTo(100)
      make.height.equalTo(100)
    })

    RxAlamofire.requestString(.get, DATA_URL)
    .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    .map({ (res, html) -> [Member] in
      if let doc = HTML(html: html, encoding: .utf8) {
        return doc.css(".team-member").flatMap({ (node) in
          return Member(node: node)
        })
      } else {
        return []
      }
    }).observeOn(MainScheduler.instance).do(onNext: { _ in
      refresherView.removeFromSuperview()
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

  func filteredByKnownStatus(members: [Member], filterValue: FilterValues) -> [Member] {
    return members.filter({ member in
      switch(filterValue) {
      case .All:
        return true
      case .Known:
        return member.known
      case .Unknown:
        return !member.known
      }
    })
  }
}

