import UIKit

class ToDoListCell: UITableViewCell {
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mappin: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    // 셀 동작을 처리하기 위한 델리게이트
    weak var delegate: ToDoListCellDelegate?
    // 셀과 연결된 Todo 항목
    var todoItem: TodoManager.Todo?
        
    // 메서드는 할 일 항목을 받아와서 셀의 UI를 설정합니다.
    func configure(todoItem: TodoManager.Todo) {
        self.todoItem = todoItem // 셀의 todoItem 속성 설정.
        backgroundColor = .primaryColor4
        // 텍스트 필드의 delegate를 뷰 컨트롤러(self)로 설정합니다.
        textField.delegate = self
        
        // 체크박스 이미지와 텍스트 필드를 'isDone' 속성에 따라 업데이트합니다.
        boxUpdateUI(isDone: todoItem.isDone)
        
        // 사용자 상호작용 비활성화
        textField.isUserInteractionEnabled = false
        
        // 텍스트 필드에 할 일을 표시합니다.
        textField.text = todoItem.todo
        
        // 텍스트 필드 내용이 변경될 때마다 셀의 텍스트를 업데이트하기 위해 타겟을 추가합니다.
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Todo 항목이 유효한 위치를 가지고 있는지 확인하고 mappin 버튼 이미지 설정
        print("this is my lat and lng--" + String(todoItem.lat.rounded()) + "/" + String(todoItem.lng.rounded()))
        if (todoItem.lat.rounded() != 0.0 && todoItem.lng.rounded() != 0.0) {
            print("clear")
            mappin.setImage(UIImage(named: "mappin2"), for: .normal)
        } else {
            mappin.setImage(UIImage(named: "unmappin2"), for: .normal)
            print("no")
        }
    }
    
    // 셀에 길게 누름 제스처를 추가하여 길게 눌린 제스처를 감지합니다.
    private lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        return gestureRecognizer
    }()
    
    // 셀의 길게 누름 제스처를 처리하는 메서드입니다.
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            // 텍스트 필드의 사용자 상호작용을 활성화하고, 수정을 시작하기 위해 텍스트 필드를 첫 번째 응답자로 만듦
            textField.isUserInteractionEnabled = true
            textField.becomeFirstResponder()
            // 길게 눌린 경우 삭제 버튼을 보여줍니다.
            delete.isHidden = false
        } else if gestureRecognizer.state == .cancelled {
            delete.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .primaryColor4
        checkBox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        // 셀에 롱 프레스 제스처 추가
        addGestureRecognizer(longPressGestureRecognizer)
        // 초기에는 삭제 버튼을 숨김
        delete.isHidden = true
    }
    
    // 셀의 내용을 주어진 Todo 항목과 일치하도록 재설정하는 메서드
    func reset(with todoItem: TodoManager.Todo) {
        textField.text = todoItem.todo
        boxUpdateUI(isDone: todoItem.isDone)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // 텍스트 필드에 내용이 변경될 때마다 Todo 내용을 업데이트하는 메서드
    @objc func textFieldDidChange(_ textField: UITextField) {
        todoItem?.todo = textField.text ?? ""
        
        // 업데이트된 할 일을 UserDefaults에 저장합니다.
        if let updatedTodoItem = todoItem {
            TodoManager.shared.updateTodoItem(updatedTodoItem)
        }
    }
    // 체크박스를 탭했을 때의 액션 메서드
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        // todoItem의 'isDone' 속성을 토글
        todoItem?.isDone.toggle()
        // 델리게이트를 통해 체크박스 탭 이벤트를 알림
        delegate?.todoItemCheckboxTapped(self)
        
        // 'isDone' 속성에 따라 변경된 UI 업데이트
        boxUpdateUI(isDone: todoItem?.isDone ?? false)
        
        // 업데이트된 Todo를 UserDefaults에 저장
        if let updatedTodoItem = todoItem {
            TodoManager.shared.updateTodoItem(updatedTodoItem)
        }
    }
    
    // 삭제 버튼을 탭했을 때의 액션 메서드
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        // todoItem을 todoItems 배열에서 삭제
        if let todoItem = todoItem {
            TodoManager.shared.deleteTodoItem(todoItemID: todoItem.id) 
        }
        
        // 델리게이트를 통해 삭제 버튼 탭 이벤트를 알림
        delegate?.deleteButtonTapped(self)
    }
    
    // mappin 버튼을 탭했을 때의 액션 메서드
    @IBAction func mappinTapped(_ sender: UIButton) {
        
        delegate?.mappinTapped(self)
        
    }
    
    
    // 'isDone' 속성에 따라 UI 업데이트
    func boxUpdateUI(isDone: Bool) {
        // 'isDone' 속성에 따라 체크박스 이미지 설정
        checkBox.isSelected = isDone
        
        if isDone {
            // 'doneCheckbox' 이미지를 설정하고 완료된 항목을 나타내기 위해 텍스트 필드에 밑줄 추가
            checkBox.setImage(UIImage(named: "doneCheckbox"), for: .selected)
            
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: textField.text ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            textField.attributedText = attributeString
        } else {
            // 'checkBox' 이미지를 설정하고 미완료 항목의 텍스트 필드에 밑줄을 제거
            checkBox.setImage(UIImage(named: "checkBox"), for: .normal)
            let plainText = NSAttributedString(string: textField.text ?? "")
            textField.attributedText = plainText
        }
    }
    
    func mappinUpdateUI(isMappin: Bool) {
        
        mappin.isSelected = isMappin
        
        if isMappin {
            mappin.setImage(UIImage(named: "mappin2"), for: .selected)
        } else {
            mappin.setImage(UIImage(named: "unmappin2"), for: .selected)
            mappin.isHidden = true
        }
    }
    
    
}
// UITextFieldDelegate를 처리하기 위한 익스텐션
extension ToDoListCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 키보드의 Return 키를 누르면 텍스트 필드의 편집 종료하고 삭제 버튼 숨김
        textField.resignFirstResponder()
        delete.isHidden = true
        return true
    }
}
