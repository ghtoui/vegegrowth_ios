//
//  ViewerViewController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/07/15.
//

import UIKit

class ViewerViewController: BaseManageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    init?(coder: NSCoder, model: BrowseData) {
        super.init(coder: coder)
        // タイトル変更(タップしたラベルを反映する)
        // navigationcontrollerを使っている
        viewModel = ViewerViewModel()
        let vegeText = model.name
        navigationItem.title = vegeText
        self.vegeText = vegeText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
