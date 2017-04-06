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

class ViewController: UIViewController {
  private let disposeBag = DisposeBag()
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.rx.tapGesture().when(.recognized)
    .subscribe(onNext: self.viewTapped)
    .disposed(by: disposeBag)
  }

  func viewTapped(_: Any) {
    print("tap")
  }

}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell(style: .default, reuseIdentifier: "cell")
  }
}
