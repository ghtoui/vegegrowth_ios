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
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var clearBackground: UILabel!
    
    private var rightSwipe: UISwipeGestureRecognizer!
    private var leftSwipe: UISwipeGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!
    
    private var viewModel: GrowthManageViewModelType = GrowthManageViewModel()
    private let disposeBag = DisposeBag()
    
    private var currentIndex: Int!
    private var vegeText: String

    private var graph_class: GraphClass!
    private var slideshow_class: SlideshowClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialUISetting()
        
        // swipe処理を行う準備
        // 右スワイプを準備
        rightSwipe = UISwipeGestureRecognizer()
        rightSwipe.direction = .right
        slideImg.addGestureRecognizer(rightSwipe)
        
        // 左スワイプを準備
        leftSwipe = UISwipeGestureRecognizer()
        leftSwipe.direction = .left
        slideImg.addGestureRecognizer(leftSwipe)
        
        // タップを準備
        tapGesture = UITapGestureRecognizer()
        slideImg.addGestureRecognizer(tapGesture)
        
        bind()
        viewModel.inputs.vegeText.accept(vegeText)
//        popupImgView()
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
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.inputs.tapGesture.accept(())
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
        
        viewModel.outputs.isHiddenLabel
            .drive(graphLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isPopupImg
            .subscribe(onNext: { [weak self] isPopup in
                if (isPopup) {
                    self?.popupImgView()
                    self?.detailLabel.isHidden = isPopup
                    self?.clearBackground.isHidden = !isPopup
                } else {
                    self?.defaultImgView()
                    self?.detailLabel.isHidden = isPopup
                    self?.clearBackground.isHidden = !isPopup
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.detailLabelText
            .drive(detailLabel.rx.text)
            .disposed(by: disposeBag)
    }
    // グラフの描画メソッド
    // データの取得はViewModelがやるべき
    func updateLineChart() {
        let datas = viewModel.outputs.getDatas()
        
        // グラフに描画するデータに変換
        var entries: [ChartDataEntry] = []
        var dateList: [String] = []
        for item in datas {
            entries.append(ChartDataEntry(x: Double(item.x), y: Double(item.vegeLength)))
            dateList.append(item.date)
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
//        let index = slideshow_class.getCurrentIndex()
        let limitLine_x = ChartLimitLine(limit: datas[currentIndex].vegeLength)
        let limitLine_y = ChartLimitLine(limit: Double(currentIndex))

        // 境界線を全て削除しないと、一生追加される
        graphView.leftAxis.removeAllLimitLines()
        graphView.xAxis.removeAllLimitLines()

        graphView.leftAxis.addLimitLine(limitLine_x)
        graphView.xAxis.addLimitLine(limitLine_y)
        
        // ラベルの左右の余白(端が見切れないようにするため)
//        xaxis.spaceMin = 0.7
//        xaxis.spaceMax = 0.7
    }
    
    private func popupImgView() {
        let popupRect: CGRect = CGRect(x: 27, y: 239, width: 361, height: 393)
        slideImg.frame = popupRect
    }
    
    private func defaultImgView() {
        let defaultRect: CGRect = CGRect(x: 91, y: 580, width: 233, height: 246)
        slideImg.frame = defaultRect
    }
    
    private func initialUISetting() {
        detailLabel.layer.cornerRadius = 10
        detailLabel.clipsToBounds = true
        clearBackground.isHidden = true
    }
    
}

private class ChartFormatter: NSObject, IAxisValueFormatter {
    private let xAxisValues: [String]
    private let dateFormatter = DateFormatter()
    init (dateList: [String]) {
        xAxisValues = dateList
        dateFormatter.dateFormat = "MM/dd"
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if index >= 0 && index < xAxisValues.count {
            let date = xAxisValues[index]
            return date
        }
        
        return ""
    }
}
