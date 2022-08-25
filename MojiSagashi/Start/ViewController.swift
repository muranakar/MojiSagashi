//
//  ViewController.swift
//  MojiSagashi
//
//  Created by 村中令 on 2022/08/21.
//


// segumentedControlに関して
// https://majintools.com/2018/10/12/segment/
import UIKit

class ViewController: UIViewController {
    var valueArray: [String] = []
    var selectedArray: [String] = ["1"]
    var pickerViewRow: Int = 0
    var characterType: CharacterType = .number
    @IBOutlet weak private var foriPadLabel: UILabel!
    @IBOutlet weak private var textSizeSampleLabel: UILabel!
    @IBOutlet weak private var textSizeSlider: UISlider!
    @IBOutlet weak private var pickerView: UIPickerView!
    @IBOutlet weak private var segumentedControl: UISegmentedControl!
    @IBOutlet weak private var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        valueArray = Character.loadNumbers()
        initPickerViewValue()
        initTextSizeValueAndConfigureViewTextSizeLabel()
        configureViewForiPadLabel()
        configureSelectedArray()
        configureViewSlide()
        configureViewSegumentedControl()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pickerView.selectRow(pickerViewRow, inComponent: 0, animated: true)
        configureViewButtonText()
    }

    @IBAction private func changeTextViewFontSize(_ sender: UISlider) {
        let senderValue = sender.value
        let senderValueInt = Int(senderValue)
        let senderValueCGFloat = CGFloat(senderValueInt)
        textSizeSampleLabel.text = "\(NSLocalizedString("textSize", comment: "")):\(senderValueCGFloat)"
        textSizeSampleLabel.font = UIFont.systemFont(ofSize: senderValueCGFloat)
        TextSizeRepository.save(textSize: senderValueInt)
    }

    @IBAction func changeCharacter(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            valueArray = Character.loadNumbers()
            characterType = .number
            selectedArray = Array(valueArray.prefix(pickerViewRow + 1))
        case 1:
            let languageCode = NSLocalizedString("languageCode", comment: "")
            if languageCode == "ja" {
                valueArray = Character.loadJapaneseLetter()
            } else {
                valueArray = Character.loadEnglishLetter()
            }
            characterType = .letter
            selectedArray = Array(valueArray.prefix(pickerViewRow + 1))
        default:
            fatalError()
        }
        pickerView.reloadAllComponents()
    }

    @IBAction func startGame(_ sender: Any) {
        performSegue(withIdentifier: "game", sender: nil)
    }
    private func initTextSizeValueAndConfigureViewTextSizeLabel() {
        if TextSizeRepository.load() == nil {
            TextSizeRepository.save(textSize: 30)
        }
        let textSize = TextSizeRepository.load()!
        print(textSize)
        textSizeSampleLabel.font = UIFont.systemFont(ofSize: CGFloat(textSize))
        textSizeSampleLabel.text = "\(NSLocalizedString("textSize", comment: "")):\(textSize)"
    }

    private func initPickerViewValue() {
        if let pickerViewRowSample = PickerViewRow.load() {
            pickerViewRow = pickerViewRowSample
        } else {
            PickerViewRow.save(row: 29)
            pickerViewRow = 29
        }
    }

    private func configureSelectedArray() {
        selectedArray = []
        for value in valueArray {
            if valueArray.firstIndex(of: value)! <= PickerViewRow.load()! {
                selectedArray.append(value)
            }
        }
    }

    private func configureViewForiPadLabel() {
        foriPadLabel.text = NSLocalizedString("iPadAttention", comment: "")
        if DeviceType.isIPhone() {
            foriPadLabel.isHidden = true
        } else if DeviceType.isIPad() {
            foriPadLabel.isHidden = false
        }
    }

    private func configureViewLabel() {
        let textSizeInt = TextSizeRepository.load() ?? 30
        let textSizeFloat = Float(textSizeInt)
        textSizeSampleLabel.font = textSizeSampleLabel.font.withSize(CGFloat(textSizeFloat))
        textSizeSampleLabel.text = "Aa [Size:\(textSizeInt)]"
    }

    private func configureViewSlide() {
        if let textSize = TextSizeRepository.load()  {
            textSizeSlider.value =  Float(textSize) + 0.1
        } else {
            textSizeSlider.value = 100
        }

    }

    private func configureViewSegumentedControl() {
        // セグメントのフォントと文字色の設定
        segumentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "HiraKakuProN-W3", size: 20.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.init(named: "string")!
            ], for: .normal)
        segumentedControl.setTitle(NSLocalizedString("characterTypeNumber", comment: ""), forSegmentAt: 0)
        segumentedControl.setTitle(NSLocalizedString("characterTypeLetter", comment: ""), forSegmentAt: 1)
    }

    private func configureViewButtonText() {
        startButton.layer.borderWidth = 3
        startButton.layer.borderColor = UIColor.init(named: "string")?.cgColor
        startButton.layer.cornerRadius = 10
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        startButton.setTitle(NSLocalizedString("startButton", comment: ""), for: .normal)
        startButton.setTitleColor(UIColor.init(named: "string"), for: .normal)
        startButton.setTitleColor(.gray, for: .disabled)
    }
}

extension ViewController {
    @IBSegueAction
    func makeGameVC(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> GameViewController? {
        return GameViewController(coder: coder, valueArray: selectedArray,gameType: characterType.string())
    }

    @IBAction
    func backToViewController(segue: UIStoryboardSegue) {
    }
}
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return valueArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return valueArray[row]
    }

}
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        PickerViewRow.save(row: row)
        pickerViewRow = row
        configureSelectedArray()
    }

}


