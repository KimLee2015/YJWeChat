//
//  TSMessageViewController.swift
//  TSWeChat
//
//  Created by Lee on 11/5/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

class TSMessageViewController: UIViewController {
  @IBOutlet fileprivate weak var listTableView: UITableView!
  fileprivate var itemDataSouce = [MessageModel]()
  var actionFloatView: TSMessageActionFloatView!

  // MARK: - life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "微信"
    self.view.backgroundColor = UIColor.viewBackgroundColor
    self.navigationItem.rightButtonAction(TSAsset.Barbuttonicon_add.image) { (Void) -> Void in
      self.actionFloatView.hide(!self.actionFloatView.isHidden)
    }
    //Init ActionFloatView
    self.actionFloatView = TSMessageActionFloatView()
    self.actionFloatView.delegate = self
    self.view.addSubview(self.actionFloatView)
    self.actionFloatView.snp.makeConstraints { (make) -> Void in
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
    }
    //Init listTableView
    self.listTableView.ts_registerCellNib(TSMessageTableViewCell.self)
    self.listTableView.estimatedRowHeight = 65
    self.listTableView.tableFooterView = UIView()
    
    self.fetchData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.actionFloatView.hide(true)
  }
  
  deinit {
    log.verbose("deinit")
  }
  
  // MARK: - private
  fileprivate func fetchData() {
    guard let JSONData = Data.ts_dataFromJSONFile("message") else { return }
    let jsonObject = JSON(data: JSONData)
    if jsonObject != JSON.null {
      var list = [MessageModel]()
      for dict in jsonObject["data"].arrayObject! {
        guard let model = TSMapper<MessageModel>().map(JSON: dict as! [String : Any]) else { continue }
        list.insert(model, at: list.count)
      }
      // 插入更多重复数据
      self.itemDataSouce.insert(contentsOf: list, at: 0)
      self.itemDataSouce.insert(contentsOf: list, at: 0)
      self.itemDataSouce.insert(contentsOf: list, at: 0)
      self.itemDataSouce.insert(contentsOf: list, at: 0)
      self.listTableView.reloadData()
    }
  }
}

extension TSMessageViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.itemDataSouce.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: TSMessageTableViewCell = tableView.ts_dequeueReusableCell(TSMessageTableViewCell.self)
    cell.setCellContnet(self.itemDataSouce[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.listTableView.estimatedRowHeight
  }
}

extension TSMessageViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
    let viewController = TSChatViewController.ts_initFromNib() as! TSChatViewController
    viewController.messageModel = self.itemDataSouce[indexPath.row]
    self.ts_pushAndHideTabbar(viewController)
  }
}

extension TSMessageViewController: ActionFloatViewDelegate {
  func floatViewTapItemIndex(_ type: ActionFloatViewItemType) {
    log.info("floatViewTapItemIndex:\(type)")
    switch type {
    case .groupChat:
      break
    case .addFriend:
      break
    case .scan:
      break
    case .payment:
      break
    }
  }
}

