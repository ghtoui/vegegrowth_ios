//
//  GraphControllerViewController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/02.
//

import UIKit
import Charts

class GrowthManageController: UIViewController,
                              UIScrollViewDelegate{
    
    let y_datas: [Int] = [10,20,30,40,50,60]
    
    @IBOutlet weak var slideimg: UIImageView!
    @IBOutlet weak var graphview: LineChartView!
    
    public var vege_text: String!
    public var vege_id: String!

    private var graph_class: GraphClass!
    private var slideshow_class: SlideshowClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // クラスの生成
        vege_id = vege_id_dict[vege_text]!
        
        graph_class = GraphClass(vege_id: vege_id)
        
        slideshow_class = SlideshowClass(vege_id: vege_id)
        if slideshow_class.get_imgurl_list() != [] {
            slideimg.image = slideshow_class.get_showimg()
        }
        
        // swipe処理を行う準備
        // 右スワイプを準備
        let right_swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe_gesture(_:)))
        right_swipe.direction = .right
        slideimg.addGestureRecognizer(right_swipe)
        // 左スワイプを準備
        let left_swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe_gesture(_:)))
        left_swipe.direction = .left
        slideimg.addGestureRecognizer(left_swipe)
        
        set_linegraph()
    }
    
    // グラフの描画メソッド
    func set_linegraph() {
        let datas = graph_class.get_usergraph_list()
        // グラフに描画するデータに変換
        var entries: [ChartDataEntry] = []
        var date_list: [String] = []
        for item in datas {
            entries.append(ChartDataEntry(x: Double(item.x), y: Double(item.vege_length)))
            date_list.append(item.date)
        }
        
        // グラフ描画
        
        let dataset = LineChartDataSet(entries: entries)
        dataset.lineWidth = 5
        dataset.drawCirclesEnabled = true
        dataset.circleRadius = 4
        dataset.circleColors = [UIColor.lightGray]
        graphview.data = LineChartData(dataSet: dataset)
        
        // グラフの設定
        // x軸オブジェクトを取得
        let xaxis = graphview.xAxis
        // x軸のラベルを下に設定
        xaxis.labelPosition = .bottom
        // x軸のグリッド線非表示
        xaxis.drawGridLinesEnabled = false
        xaxis.drawAxisLineEnabled = false
        
        // x軸ラベルを日付にする
    
        // X軸のラベルに日付を表示するためのFormatterを設定
        let formatter = ChartFormatter(date_list: date_list)
        xaxis.valueFormatter = formatter
        // X軸のラベルの数を設定, データと同じ数にする必要あり
        xaxis.labelCount = datas.count/2
        // 1.0で固定
        xaxis.granularity = 1.0
        
        // y軸を0始まりに
        graphview.leftAxis.axisMinimum = 0.0
        // 右側のy軸を非表示
        graphview.rightAxis.enabled = false
        
        // 境界線を利用して、スライドショーに表示されている画像と関連させる
        let index = slideshow_class.get_currentindex()
        let limitLine_x = ChartLimitLine(limit: datas[index].vege_length)
        let limitLine_y = ChartLimitLine(limit: Double(index))
        
        // 境界線を全て削除しないと、一生追加される
        graphview.leftAxis.removeAllLimitLines()
        graphview.xAxis.removeAllLimitLines()
        
        graphview.leftAxis.addLimitLine(limitLine_x)
        graphview.xAxis.addLimitLine(limitLine_y)
    }
    
    // スワイプされた時の処理
    @objc func swipe_gesture(_ gesture: UISwipeGestureRecognizer) {
        // フリックが終わった時の処理
        let direction = gesture.direction
        if (direction == .left) {
            // 左方向
            slideshow_class.show_next_img()
            slideimg.image = slideshow_class.get_showimg()
        } else if (direction == .right) {
            // 右方向
            slideshow_class.show_prev_img()
            slideimg.image = slideshow_class.get_showimg()
        }
        // グラフ更新
        set_linegraph()
    }
    
}
private class ChartFormatter: NSObject, IAxisValueFormatter {
    private let xAxisValues: [String]
    init (date_list: [String]) {
        xAxisValues = date_list
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        return xAxisValues[index]
    }
}
