//
//  ViewController.swift
//  TeamList
//
//  Created by Pawel Urbanek on 06/04/2017.
//  Copyright © 2017 Pawel Urbanek. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import Alamofire
import RxAlamofire
import Kanna

class ViewController: UIViewController {
  private let disposeBag = DisposeBag()
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.rx.tapGesture().when(.recognized)
    .subscribe(onNext: { [weak self] _ in
      self?.viewTapped()
    }).disposed(by: disposeBag)
  }

  func viewTapped() {
    RxAlamofire.requestString(.get, "https://www.elpassion.com/about-us/")
    .subscribe(onNext: { (res, html) in
      if let doc = HTML(html: html, encoding: .utf8) {
        for member in doc.css(".team-member")  {
          print(member.css(".member-name")[0].text!)
          print(member.css(".member-img img")[0]["src"]!)
        }
      }

    }).disposed(by: disposeBag)
    print("tap")
  }
}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =  UITableViewCell(style: .default, reuseIdentifier: "cell")
    cell.detailTextLabel?.text = "hello"
    return cell
  }
}
