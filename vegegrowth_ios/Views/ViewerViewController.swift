//
//  ViewerViewController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/07/15.
//

import UIKit
import Charts

class ViewerViewController: BaseManageViewController {
    private var model: BrowseData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // コンストラクタではなくて、ここでモデルを挿入しないと反映されない
        viewModel.inputs.setModelData(model: model)
    }
    
    init?(coder: NSCoder, model: BrowseData) {
        super.init(coder: coder)
        // タイトル変更(タップしたラベルを反映する)
        // navigationcontrollerを使っている
        viewModel = ViewerViewModel()
        self.model = model
        let vegeText = model.name
        navigationItem.title = vegeText
        
        self.vegeText = vegeText
        self.model = model
    }
    
    override func updateLineChart() {
        let dataLength = model.date.count
        // グラフに描画するデータに変換
        var entries: [ChartDataEntry] = []
        var dateList: [String] = []
        for i in 0 ..< dataLength {
            let x = model.x[i]
            let vegeLength = model.vegeLength[i]
            let date = model.date[i]
            entries.append(ChartDataEntry(x: Double(x), y: Double(vegeLength)))
            dateList.append(date)
        }
        
        // グラフ描画
        let dataset = LineChartDataSet(entries: entries)
        dataset.lineWidth = 5
        dataset.drawCirclesEnabled = true
        dataset.circleRadius = 4
        dataset.circleColors = [UIColor.lightGray]
        graphView.data = LineChartData(dataSet: dataset)
        
        // グラフの設定
        // x軸オブジェクトを取得
        let xaxis = graphView.xAxis
        // x軸のラベルを下に設定
        xaxis.labelPosition = .bottom
        // x軸のグリッド線非表示
        xaxis.drawGridLinesEnabled = false
        xaxis.drawAxisLineEnabled = false
        
        // x軸ラベルを日付にする
        // X軸のラベルの数を設定
        xaxis.setLabelCount(3, force: true)
        
        
        // X軸のラベルに日付を表示するためのFormatterを設定
        let formatter = ChartFormatter(dateList: dateList)
        xaxis.valueFormatter = formatter
        
        // グラフにタッチ不可能にする
        graphView.highlightPerTapEnabled = false
        graphView.highlightPerDragEnabled = false
        
        // y軸を0始まりに
        graphView.leftAxis.axisMinimum = 0.0
        // 右側のy軸を非表示
        graphView.rightAxis.enabled = false
        
        // 境界線を利用して、スライドショーに表示されている画像と関連させる
        //                let index = slideshow_class.getCurrentIndex()
        let limitLine_x = ChartLimitLine(limit: model.vegeLength[currentIndex])
        let limitLine_y = ChartLimitLine(limit: Double(currentIndex))
        
        //        let limitLine_x = ChartLimitLine(limit: 0)
        //        let limitLine_y = ChartLimitLine(limit: 0)
        // 境界線を全て削除しないと、一生追加される
        graphView.leftAxis.removeAllLimitLines()
        graphView.xAxis.removeAllLimitLines()
        
        graphView.leftAxis.addLimitLine(limitLine_x)
        graphView.xAxis.addLimitLine(limitLine_y)
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
