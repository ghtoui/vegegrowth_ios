//
//  GrowthController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/15.
//

import UIKit

class GrowthController: UIViewController,
                        UIImagePickerControllerDelegate,
                        UINavigationControllerDelegate,
                        UIScrollViewDelegate {

    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var slideimg: UIImageView!
    
    public var vege_text :String!
    private var index :Int!
    private var vege_id: String!
    private var graph_items: [VegeLengthObject]!
    
    // クラス
    private var img_class: ImgClass!
    private var slide_show: SlideshowClass!
    private var vege_manager: VegemanagerClass!
    private var graph_class: GraphClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // クラスの生成
        // 野菜の名前に紐づけられたユニークIDを取得する
        vege_id = vege_id_dict[vege_text]!
        
        img_class = ImgClass(vege_id: vege_id)
        slide_show = SlideshowClass(vege_id: vege_id)
        graph_class = GraphClass(vege_id: vege_id)
        
        if slide_show.get_imgurl_list() != [] {
            slideimg.image = slide_show.get_showimg()
        }
        // vege_text_listの取得
        if UserDefaults.standard.object(forKey: vege_id) != nil {
            vege_text_list = UserDefaults.standard.object(forKey: vege_id) as! [String]
        }

        // タイトル変更(タップしたラベルを反映する)
        // navigationcontrollerを使っている
        navigationItem.title = vege_text
        
        // swipe処理を行う準備
        // 右スワイプを準備
        let right_swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe_gesture(_:)))
        right_swipe.direction = .right
        slideimg.addGestureRecognizer(right_swipe)
        // 左スワイプを準備
        let left_swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe_gesture(_:)))
        left_swipe.direction = .left
        slideimg.addGestureRecognizer(left_swipe)
        graph_items = graph_class.get_usergraph_list(vege_id: vege_id)
    }

    // 撮影ボタンが押された時の処理
    @IBAction func takebutton_click(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let image_picker = UIImagePickerController()
            image_picker.sourceType = .camera
            image_picker.delegate = self
            self.present(image_picker, animated: true, completion: nil)
        } else {
            print("カメラが無いです")
        }
    }
    
    // 写真撮影処理
    // takebutton_clickが押されたら処理する
    func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let img_data = img_class.take_img(picker, didFinishPickingMediaWithInfo: info)
        imgview.image = img_data
        slide_show.set_imgurl_list()
    }
    
    // スワイプされた時の処理
    @objc func swipe_gesture(_ gesture: UISwipeGestureRecognizer) {
        // フリックが終わった時の処理
        let direction = gesture.direction
        if (direction == .left) {
            // 左方向
            slide_show.show_next_img()
            slideimg.image = slide_show.get_showimg()
        } else if (direction == .right) {
            // 右方向
            slide_show.show_prev_img()
            slideimg.image = slide_show.get_showimg()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "graphviewsegue" {
            if let destinationVC = segue.destination as? GraphController {
                destinationVC.vege_text = vege_text
            }
        }
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
