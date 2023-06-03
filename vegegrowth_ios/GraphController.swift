//
//  GraphControllerViewController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/02.
//

import UIKit
import Charts

class GraphController: UIViewController {

    public var vege_text: String!
    public var vege_id: String!
    
    private var graph_class: GraphClass!
        
    @IBOutlet weak var graphview: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // クラスの生成
        vege_id = vege_id_dict[vege_text]!
        graph_class = GraphClass(vege_id: vege_id)
        set_linegraph()
    }
    
    // グラフの描画メソッド
    func set_linegraph() {
        var entries: [ChartDataEntry] = []
        for (i, y_data) in y_datas.enumerated() {
            entries.append(ChartDataEntry(x: Double(i), y: Double(y_data)))
        }
        let dataset = LineChartDataSet(entries: entries)
        dataset.lineWidth = 5
        dataset.drawCirclesEnabled = true
        dataset.circleRadius = 4
        dataset.circleColors = [UIColor.lightGray]
        graphview.data = LineChartData(dataSet: dataset)
        
        // x軸のラベルを下に設定
        graphview.xAxis.labelPosition = .bottom
        // x軸のグリッド線非表示
        graphview.xAxis.drawGridLinesEnabled = false
        graphview.xAxis.drawAxisLineEnabled = false
        // y軸を0始まりに
        graphview.leftAxis.axisMinimum = 0.0
        // 右側のy軸を非表示
        graphview.rightAxis.enabled = false
        
        
    }
    
    private func get_graph() {
        var vegelength_list = graph_class.get_usergraph_list(vege_id: vege_id)
    }
    
    let y_datas: [Int] = [10,20,30,40,50,60]
}
