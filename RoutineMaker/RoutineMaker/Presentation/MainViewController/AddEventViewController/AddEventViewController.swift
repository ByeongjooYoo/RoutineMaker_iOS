//
//  AddEventViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/07.
//

import UIKit

class AddEventViewController: UIViewController {
    @IBOutlet weak var eventInputStackView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        placeholderSetting(descriptionTextView)
    }
    
    @IBAction func tappedCancelBarButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

private extension AddEventViewController {
    func setLayout() {
        eventInputStackView.layer.cornerRadius = 10
        titleTextField.addLeftPadding(12)
        titleTextField.layer.cornerRadius = 10
        descriptionTextView.layer.cornerRadius = 10
    }
}

extension AddEventViewController: UITextViewDelegate {
    private func placeholderSetting(_ textView: UITextView) {
        textView.delegate = self
        textView.text = "내용"
        textView.textColor = UIColor.systemGray4
        textView.textContainer.lineFragmentPadding = 12
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray4 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeholderSetting(textView)
        }
    }
}

