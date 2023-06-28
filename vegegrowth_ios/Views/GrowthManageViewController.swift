//
//  GraphControllerViewController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/02.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

class GrowthManageViewController: UIViewController {
    
    @IBOutlet weak var slideImg: UIImageView!
    @IBOutlet weak var graphLabel: UILabel!
    @IBOutlet weak var graphView: LineChartView!
    
    private var rightSwipe: UISwipeGestureRecognizer!
    private var leftSwipe: UISwipeGestureRecognizer!
    
    private var viewModel: GrowthManageViewModelType = GrowthManageViewModel()
    private let disposeBag = DisposeBag()
    
    private var currentIndex: Int!
    private var vegeText: String

    private var graph_class: GraphClass!
    private var slideshow_class: SlideshowClass!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // swipe処理を行う準備
        // 右スワイプを準備
        rightSwipe = UISwipeGestureRecognizer()
        rightSwipe.direction = .right
        slideImg.addGestureRecognizer(rightSwipe)
        
        // 左スワイプを準備
        leftSwipe = UISwipeGestureRecognizer()
        leftSwipe.direction = .left
        slideImg.addGestureRecognizer(leftSwipe)
        
        bind()
        viewModel.inputs.vegeText.accept(vegeText)
    }
    
    init?(coder: NSCoder, vegeText: String) {
        self.vegeText = vegeText
        super.init(coder: coder)
        print(vegeText)
        // タイトル変更(タップしたラベルを反映する)
        // navigationcontrollerを使っている
        navigationItem.title = vegeText
        self.vegeText = vegeText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.outputs.slideImg
            .drive(slideImg.rx.image)
            .disposed(by: disposeBag)
        
        rightSwipe.rx.event
            .subscribe(onNext: { [weak self] gesture in
                let direction = gesture.direction
                if (direction == .right) {
                    // 右方向
                    self?.viewModel.inputs.rightSwipe.accept(())
                }
            })
            .disposed(by: disposeBag)
        leftSwipe.rx.event
            .subscribe(onNext: { [weak self] gesture in
                let direction = gesture.direction
                if (direction == .left) {
                    // 左方向
                    self?.viewModel.inputs.leftSwipe.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.slideImg
            .drive(slideImg.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.outputs.currentIndex
            .subscribe(onNext: { [weak self] index in
                self?.currentIndex = index
                self?.updateLineChart()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.hiddenLabel
            .drive(graphLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    // グラフの描画メソッド
    // データの取得はViewModelがやるべき
    func updateLineChart() {
        let datas = viewModel.outputs.getDatas()
//        datas = [VegeLengthObject(date: "2000-01-01",
//            vegeLength: 3,
//            x:0
//        ),VegeLengthObject(date: "2000-01-02",
//            vegeLength: 3,
//            x:1
//        ),VegeLengthObject(date: "2000-01-01",
//            vegeLength: 3,
//            x:2
//        )]
        
        // グラフに描画するデータに変換
        var entries: [ChartDataEntry] = []
        var date_list: [String] = []
        for item in datas {
            entries.append(ChartDataEntry(x: Double(item.x), y: Double(item.vegeLength)))
            date_list.append(item.date)
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
        xaxis.labelCount = datas.count/2
        if datas.count / 2 == 0 {
            xaxis.labelCount = 1
        }
        // 1.0で固定
        xaxis.granularity = 1.0
        // X軸のラベルに日付を表示するためのFormatterを設定
        let formatter = ChartFormatter(date_list: date_list)
        xaxis.valueFormatter = formatter
    
        graphView.highlightPerTapEnabled = false
        
        // y軸を0始まりに
        graphView.leftAxis.axisMinimum = 0.0
        // 右側のy軸を非表示
        graphView.rightAxis.enabled = false
        
        
        // 境界線を利用して、スライドショーに表示されている画像と関連させる
//        let index = slideshow_class.getCurrentIndex()
        let limitLine_x = ChartLimitLine(limit: datas[currentIndex].vegeLength)
        let limitLine_y = ChartLimitLine(limit: Double(currentIndex))

        // 境界線を全て削除しないと、一生追加される
        graphView.leftAxis.removeAllLimitLines()
        graphView.xAxis.removeAllLimitLines()

        graphView.leftAxis.addLimitLine(limitLine_x)
        graphView.xAxis.addLimitLine(limitLine_y)
    }
    
}

private class ChartFormatter: NSObject, IAxisValueFormatter {
    private let xAxisValues: [String]
    init (date_list: [String]) {
        xAxisValues = date_list
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if index >= 0 && index < xAxisValues.count {
            return xAxisValues[index]
        }
        
        return ""
    }
}
