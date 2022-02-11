//
//  AddEventViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/07.
//

import UIKit

protocol AddEventViewDelegate: AnyObject {
    func didAddEvent(event: Event)
}

class AddEventViewController: UIViewController {
    @IBOutlet weak var eventInputStackView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    weak var delegate: AddEventViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        placeholderSetting(descriptionTextView)
        configureInputField()
    }
    
    //빈화면을 클릭 시 키보드 or DatePicker가 내려가게 해주는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @IBAction func tappedAddBarButtton(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text else { return }
        guard let description = descriptionTextView.text else { return }
        let event = Event(title: title, description: description, completion: false)
        print(event)
        
        self.delegate?.didAddEvent(event: event)
        dismiss(animated: true, completion: nil)
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
        addBarButton.isEnabled = false
    }
    
    private func configureInputField() {
        descriptionTextView.delegate = self
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    func validateInputField() {
        addBarButton.isEnabled = !(titleTextField.text?.isEmpty ?? true) && !descriptionTextView.text.isEmpty
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
    
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}

