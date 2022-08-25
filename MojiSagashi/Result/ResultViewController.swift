//
//  ResultViewController.swift
//  MojiSagashi
//
//  Created by 村中令 on 2022/08/21.
//

import UIKit
import GoogleMobileAds

class ResultViewController: UIViewController {
    @IBOutlet weak private var backButton: UIButton!

    @IBOutlet weak private var titleCurrentDateLabel: UILabel!
    @IBOutlet weak private var titleCharacterTypeLabel: UILabel!
    @IBOutlet weak private var titleArrayCountLabel: UILabel!
    @IBOutlet weak private var titleFontSizeLabel: UILabel!
    @IBOutlet weak private var titleTimerResultLabel: UILabel!
    @IBOutlet weak private var titleMissCountLabel: UILabel!
    @IBOutlet weak private var resultCurrentDateLabel: UILabel!
    @IBOutlet weak private var resultCharacterTypeLabel: UILabel!
    @IBOutlet weak private var resultArrayCountLabel: UILabel!
    @IBOutlet weak private var resultFontSizeLabel: UILabel!
    @IBOutlet weak private var resultTimerResultLabel: UILabel!
    @IBOutlet weak private var resultMissCountLabel: UILabel!

    @IBOutlet weak private var textCopyButton: UIButton!

    // MARK: - 広告関係のプロパティ
    @IBOutlet weak private var bannerView: GADBannerView!

    private var requiredResultScreenTransition: RequiredResultScreenTransition
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAdBannar()
        configureViewTitleText()
        configureViewResultText()
        configureViewBackButton()
        configureViewCopyButton()
    }

    required init?(coder: NSCoder, _ requiredResultScreenTransition: RequiredResultScreenTransition) {
        self.requiredResultScreenTransition = requiredResultScreenTransition
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBAction func copyText(_ sender: Any) {
        copyText()
    }

    // MARK: - 広告関係のメソッド
    private func configureAdBannar() {
        // GADBannerViewのプロパティを設定
        bannerView.adUnitID = "\(GoogleAdID.bannerID)"
        bannerView.rootViewController = self
        // 広告読み込み
        bannerView.load(GADRequest())
    }

    private func configureViewTitleText() {
        let currentDate = NSLocalizedString("titleCurrentDateLabel", comment: "")
        let characterType = NSLocalizedString("titleCharacterTypeLabel", comment: "")
        let arrayCount = NSLocalizedString("titleArrayCountLabel", comment: "")
        let fontSize = NSLocalizedString("titleFontSizeLabel", comment: "")
        let timerResult = NSLocalizedString("titleTimerResultLabel", comment: "")
        let missCount = NSLocalizedString("titleMissCountLabel", comment: "")
        titleCurrentDateLabel.text = currentDate
        titleCharacterTypeLabel.text = characterType
        titleArrayCountLabel.text = arrayCount
        titleFontSizeLabel.text = fontSize
        titleTimerResultLabel.text = timerResult
        titleMissCountLabel.text = missCount
    }

    private func configureViewResultText(

    ){
        let decimalTimer = floorf((requiredResultScreenTransition.timerResult! * 100)) / 100

        let currentDate = "\(DateFormatter.string(date: Date()))"
        let characterType = "\(requiredResultScreenTransition.gameTypeCharacter)"
        let arrayCount = "\(requiredResultScreenTransition.arrayCount)"
        let fontSize = "\(requiredResultScreenTransition.fontSize)"
        let timerResult = "\(decimalTimer)"
        let missCount = "\(String(describing: requiredResultScreenTransition.missCount!))"

        resultCurrentDateLabel.text = currentDate
        resultCharacterTypeLabel.text = characterType
        resultArrayCountLabel.text = arrayCount
        resultFontSizeLabel.text = fontSize
        resultTimerResultLabel.text = timerResult
        resultMissCountLabel.text = missCount
    }

    private func copyText() {
        let titlecurrentDate = NSLocalizedString("titleCurrentDateLabel", comment: "")
        let titlecharacterType = NSLocalizedString("titleCharacterTypeLabel", comment: "")
        let titlearrayCount = NSLocalizedString("titleArrayCountLabel", comment: "")
        let titlefontSize = NSLocalizedString("titleFontSizeLabel", comment: "")
        let titletimerResult = NSLocalizedString("titleTimerResultLabel", comment: "")
        let titlemissCount = NSLocalizedString("titleMissCountLabel", comment: "")

        let decimalTimer = floorf((requiredResultScreenTransition.timerResult! * 100)) / 100
        let  resultcurrentDate = "\(DateFormatter.string(date: Date()))"
        let  resultcharacterType = "\(requiredResultScreenTransition.gameTypeCharacter)"
        let  resultarrayCount = "\(requiredResultScreenTransition.arrayCount)"
        let  resultfontSize = "\(requiredResultScreenTransition.fontSize)"
        let  resulttimerResult = "\(decimalTimer)"
        let  resultmissCount = "\(String(describing: requiredResultScreenTransition.missCount!))"

        UIPasteboard.general.string =
"""
\(titlecurrentDate):\(resultcurrentDate)
\(titlecharacterType):\(resultcharacterType)
\(titlearrayCount):\(resultarrayCount)
\(titlefontSize):\(resultfontSize)
\(titletimerResult):\(resulttimerResult)
\(titlemissCount):\(resultmissCount)
\(titlecurrentDate):\(resultcurrentDate)
"""
    }

    private func configureViewBackButton() {
        backButton.layer.borderWidth = 3
        backButton.layer.borderColor = UIColor.init(named: "string")?.cgColor
        backButton.layer.cornerRadius = 10
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        backButton.setTitle(NSLocalizedString("backTextButton", comment: ""), for: .normal)
        backButton.setTitleColor(UIColor.init(named: "string"), for: .normal)
        backButton.setTitleColor(.gray, for: .disabled)
    }
    private func configureViewCopyButton() {
        textCopyButton.layer.borderWidth = 3
        textCopyButton.layer.borderColor = UIColor.init(named: "string")?.cgColor
        textCopyButton.layer.cornerRadius = 10
        textCopyButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textCopyButton.setTitle(NSLocalizedString("resultCopyButtonText", comment: ""), for: .normal)
        textCopyButton.setTitleColor(UIColor.init(named: "string"), for: .normal)

        textCopyButton.setTitleColor(.gray, for: .disabled)
    }
}

extension DateFormatter {
    static func string(date: Date) -> String {
        /// DateFomatterクラスのインスタンス生成
        let dateFormatter = DateFormatter()
        if NSLocalizedString("languageCode", comment: "") == "ja" {
            /// カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")

            /// 変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
            dateFormatter.dateFormat = "yyyy-M-d H:m"
            let string = dateFormatter.string(from: date)
            return string
        } else {
            /// カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.timeZone = TimeZone(identifier:  "America/Santiago")

            /// 変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
            dateFormatter.dateFormat = "yyyy-M-d"
            let string = dateFormatter.string(from: date)
            return string
        }
    }
}
