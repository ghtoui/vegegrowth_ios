//
//  GrowthController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/15.
//

import UIKit

var vege_text_list = [String]()

class GrowthController: UIViewController,
                        UIImagePickerControllerDelegate,
                        UINavigationControllerDelegate,
                        UIScrollViewDelegate{

    @IBOutlet weak var imgview: UIImageView!

    var vege_text = ""
    var index = 0
    private var vege_id = ""
    private var img_class: ImgClass = ImgClass(vege_id: "")
    private var slide_show_class: SlideshowClass = SlideshowClass(vege_text: "")
    private var vege_manager = VegeManagerClass()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // クラス生成
        vege_id = vege_manager.get_unique_id(index: index, vege_text: vege_text)
        img_class = ImgClass(vege_id: vege_id)
        slide_show_class = SlideshowClass(vege_text: vege_text)

        // タイトル変更(タップしたラベルを反映する)
        // navigationcontrollerを使っている
        navigationItem.title = vege_text
    }

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

    func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let img_data = img_class.take_img(picker, didFinishPickingMediaWithInfo: info)
        imgview.image = img_data
    }

    @IBAction func loadbutton_click(_ sender: Any) {
        let file_name = vege_id + "_" + String(vege_text_list.count - 1)
        let img_data = img_class.load_img(file_name: file_name)
        imgview.image = img_data
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
