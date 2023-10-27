//
//  CalendarViewController.swift
//  donforgetMAP
//
//  Created by 김우섭 on 2023/07/07.
//

import UIKit
import FSCalendar
import CoreLocation

// ToDoListCellDelegate protocol, ToDo 목록 셀에서 체크박스와 삭제 버튼을 처리하기 위한 메서드 정의
protocol ToDoListCellDelegate: AnyObject {
    func todoItemCheckboxTapped(_ cell: ToDoListCell)
    func deleteButtonTapped(_ cell: ToDoListCell)
    func mappinTapped(_ cell: ToDoListCell)
}

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let todoManager = TodoManager.shared
    var selectedDate: Date?
    private var selectedTodoItems: [TodoManager.Todo] = []
    
    var locationManager = CLLocationManager()
    
    // MARK: - UI 구현 코드
    
    // 앱 이름을 표시하는 타이틀 레이블
    private let calendarTitle: UILabel = {
        let calendarTitle = UILabel()
        calendarTitle.text = "까먹지MAP"
        calendarTitle.textColor = .primaryColor1
        calendarTitle.font = UIFont(name: "Kyobo Handwriting 2019", size: 30)
        return calendarTitle
    }()
    
    // 현재 월과 년도를 표시하는 헤더 레이블을 위한 날짜 포매터
    private let headerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }()
    
    // 현재 월과 년도를 표시하는 헤더 레이블
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareR", size: 16)
        label.textColor = .primaryColor1
        label.text = headerDateFormatter.string(from: Date())
        return label
    }()
    
    // 설정 화면으로 이동하기 위한 설정 버튼
    private let setttingButton: UIButton = {
        let setttingButton = UIButton()
        setttingButton.setImage(UIImage(named: "setting"), for: .normal)
        return setttingButton
    }()
    
    // 캘린더 뷰 하단에 라인을 표시하는 뷰
    private let boarderLine: UIView = {
        let boarderLine = UIView()
        boarderLine.layer.borderWidth = 0.2
        boarderLine.layer.borderColor = UIColor.primaryColor2.cgColor
        return boarderLine
    }()
    
    // 새로운 ToDo 아이템을 추가하기 위한 플러스 버튼
    private let plusAddButton: UIButton = {
        let plusAddButton = UIButton()
        plusAddButton.setImage(UIImage(named: "plusAddButton"), for: .normal)
        return plusAddButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor4
        
        // UserDefaults에서 Todo 데이터를 로드합니다.
        todoManager.loadTodoData()
        
        // 초기 데이터를 설정하고 테이블 뷰와 코멘트 레이블의 가시성을 조정
        // 선택된 날짜를 로드합니다.
        selectedDate = Date() // 기본 선택 날짜를 현재 날짜로 설정
        updateSelectedTodoItemsAndReloadTableView()
        
        // 캘린더 UI를 구성하고 초기화합니다.
        calendarUIConfigure()
        calendarViewConfigure()
        calendarViewOnboarding()
        
        // 캘린더 뷰의 delegate와 dataSource를 현재 뷰 컨트롤러로 설정
        calendarView.delegate = self
        calendarView.dataSource = self
        
        // 테이블 뷰의 delegate와 dataSource를 현재 뷰 컨트롤러로 설정
        tableView.dataSource = self
        tableView.delegate = self
                
        let indexPath = IndexPath(row: selectedTodoItems.count - 1, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? ToDoListCell {
            cell.delete.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateSelectedTodoItemsAndReloadTableView()
        tableView.reloadData()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        print("리로드 끝")
    }
    
    // 앱을 처음 실행할 때 나타나는 온보딩 설정
    private func calendarViewOnboarding() {
        tableView.isHidden = false // 테이블 뷰를 보여줍니다.
        commentLabel.isHidden = true  // 코멘트 레이블을 숨깁니다.
        tableView.reloadData() // 테이블 뷰를 리로드합니다.
    }
    
    // MARK: - 데이터 관리
    
    private func updateSelectedTodoItemsAndReloadTableView() {
        guard let selectedDate = selectedDate else {
            selectedTodoItems = []
            toggleTableViewAndCommentLabelVisibility()
            tableView.reloadData()
            return
        }
        
        // 선택된 날짜에 따라 'selectedTodoItems'를 업데이트합니다.
        selectedTodoItems = todoManager.todoItems(for: selectedDate)
        
        // 변경 사항을 반영하기 위해 테이블 뷰를 리로드합니다.
        toggleTableViewAndCommentLabelVisibility()
        tableView.reloadData()
    }
    // MARK: - 버튼 액션
    
    @objc func plusAddButtonTapped() {
        if let selectedDate = selectedDate {
            
            // 빈 문자열로 "todo" 필드를 가지고 새로운 Todo 아이템을 추가하고 위치 정보를 함께 저장합니다.
            todoManager.addNewTodoItem(todo: "", isDone: false, date: selectedDate, lat: 0.0, lng: 0.0)
            
            // 업데이트된 Todo 아이템들을 가져와서 테이블 뷰를 리로드합니다.
            updateSelectedTodoItemsAndReloadTableView()
            
            // 이벤트 점들을 업데이트하기 위해 캘린더 뷰를 리로드합니다.
            calendarView.reloadData()
            
            // selectedTodoItems의 인덱스를 가져옴.
            let indexPath = IndexPath(row: selectedTodoItems.count - 1, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? ToDoListCell {
                cell.textField.becomeFirstResponder() // 새로운 텍스트필드에 초점을 맞춤
                cell.textField.isUserInteractionEnabled = true
            }
            // 확인 메시지
            print("plusAddButton is tapped.")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 테이블 뷰에서 행을 선택할 때 호출됩니다. (예: 셀을 탭)
        
        // 텍스트 필드에 입력된 내용을 UserDefaults에 저장합니다.
        if let indexPath = tableView.indexPathForSelectedRow {
            let todoItem = selectedTodoItems[indexPath.row]
            todoManager.updateTodoItem(todoItem)
        }
    }
    
    // 설정 버튼을 눌러 설정 화면으로 이동하는 함수
    @objc func setttingButtonTapped() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let settingVC = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController else { return }
        settingVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    private func toggleTableViewAndCommentLabelVisibility() {
        // 선택된 Todo 아이템이 없을 경우 테이블 뷰를 숨기고, 코멘트 레이블을 보여줍니다.
        if selectedTodoItems.isEmpty {
            tableView.isHidden = true
            commentLabel.isHidden = false
        } else {
            // 선택된 Todo 아이템이 있을 경우 테이블 뷰를 보여주고, 코멘트 레이블을 숨깁니다.
            tableView.isHidden = false
            commentLabel.isHidden = true
        }
    }
    
    private func dateToString(date: Date) -> String {
        // 날짜를 문자열로 변환하는 함수입니다.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // MARK: - UI Auto Layout
    
    // 캘린더 UI를 구성하는 함수
    private func calendarUIConfigure() {
        
        // 캘린더 타이틀 레이블 추가
        view.addSubview(calendarTitle)
        calendarTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            calendarTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarTitle.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // 헤더 레이블 추가
        view.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: calendarTitle.bottomAnchor, constant: -10),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // 보더 라인 추가
        view.addSubview(boarderLine)
        boarderLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boarderLine.bottomAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            boarderLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boarderLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boarderLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // 설정 버튼 추가
        view.addSubview(setttingButton)
        setttingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setttingButton.topAnchor.constraint(equalTo: calendarTitle.topAnchor),
            setttingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            setttingButton.heightAnchor.constraint(equalToConstant: 60),
            setttingButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        // 할 일 추가 버튼 추가
        view.addSubview(plusAddButton)
        plusAddButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusAddButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            plusAddButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            plusAddButton.heightAnchor.constraint(equalToConstant: 40),
            plusAddButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        plusAddButton.addTarget(self, action: #selector(plusAddButtonTapped), for: .touchUpInside)
        setttingButton.addTarget(self, action: #selector(setttingButtonTapped), for: .touchUpInside)
    }
    
    // 캘린더 뷰를 설정
    private func calendarViewConfigure() {
        // 캘린더 뷰의 배경색을 설정합니다.
        calendarView.backgroundColor = .primaryColor4
        
        // 캘린더 뷰의 위치 설정합니다.
        calendarView.locale = Locale(identifier: "us_US")
        
        // 캘린더 뷰의 첫 번째 요일을 월요일로 설정합니다.
        calendarView.firstWeekday = 2
        
        // 현재 월의 날짜만 표시합니다.
        calendarView.placeholderType = .none
        
        // 캘린더 뷰의 스크롤을 가능하게 합니다.
        calendarView.scrollEnabled = true
        
        // 헤더 뷰를 비웁니다.
        calendarView.scrollDirection = .horizontal
        
        // Clear the header view
        calendarView.appearance.headerTitleColor = .clear
        
        // 헤더 뷰의 화살표를 제거합니다.
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // 주말 텍스트 색상을 설정합니다.
        calendarView.appearance.weekdayTextColor = .primaryColor1
        calendarView.appearance.titleWeekendColor = .primaryColor1
        
        // 주말 폰트를 설정합니다.
        calendarView.appearance.weekdayFont = UIFont(name: "Kyobo Handwriting 2019", size: 17)
        
        // 각 날짜의 색상을 설정합니다.
        calendarView.appearance.titleDefaultColor = .gray.withAlphaComponent(0.7)
        
        // 각 날짜의 폰트를 설정합니다.
        calendarView.appearance.titleFont = UIFont(name: "NanumSquareR", size: 17)
        
        // 선택된 날짜의 색상을 설정합니다.
        calendarView.appearance.selectionColor = .primaryColor1.withAlphaComponent(0.3)
        
        // 오늘 날짜의 색상을 설정합니다.
        calendarView.appearance.todayColor = .primaryColor1.withAlphaComponent(0.3)
        
        // 이벤트 점들의 기본 색상을 설정합니다.
        calendarView.appearance.eventDefaultColor = .primaryColor1
        
        // 이벤트 점들의 위치를 설정합니다.
        calendarView.appearance.eventOffset = CGPoint(x: 0, y: -30)
    }
}

// MARK: - FSCalendar, CalendarViewController extension

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    // 현재 페이지(월)이 변경되었을 때 호출되며, 헤더 레이블을 새로운 월과 연도로 업데이트합니다.
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendarView.currentPage
        headerLabel.text = headerDateFormatter.string(from: currentPage)
    }
    
    // 날짜가 선택되었을 때 호출되며, 선택된 날짜와 해당 날짜에 대한 할 일 항목 목록을 업데이트합니다.
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date // 선택된 날짜 업데이트
        headerLabel.text = headerDateFormatter.string(from: date) // 헤더 레이블 업데이트
        updateSelectedTodoItemsAndReloadTableView()  // 선택된 할 일 항목 업데이트 및 테이블 뷰 리로드
    }
    
}

extension CalendarViewController: FSCalendarDelegateAppearance {
    // 일요일의 기본 텍스트 색상을 설정합니다.
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 1 { // Sunday
            return .red
        } else {
            return .black
        }
    }
    
    // 선택된 날짜의 배경색을 설정합니다.
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return appearance.selectionColor
    }
    
    // 선택된 날짜의 테두리 색상을 설정합니다.
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return UIColor.primaryColor1.withAlphaComponent(1.0)
    }
    
    // 날짜에 표시될 이벤트 점의 개수를 설정합니다.
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return todoManager.todoItems(for: date).count
    }
}

// MARK: - Table View Extension

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    // 테이블 뷰의 섹션에 표시할 행의 개수를 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTodoItems.count
    }
    
    // 테이블 뷰의 각 행에 대한 셀을 구성하고 반환합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // "ToDoListCell" 식별자를 가진 재사용 가능한 셀을 가져옵니다.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as! ToDoListCell
        cell.delegate = self
        
        // 선택된 할 일 항목 배열에서 해당 인덱스에 위치한 항목을 가져옵니다.
        let todoItem = selectedTodoItems[indexPath.row]
        cell.configure(todoItem: todoItem) // 할 일 목록 셀을 구성하는 함수 호출
        // 텍스트 필드의 텍스트와 속성 설정
        cell.textField.text = selectedTodoItems[indexPath.row].todo
        if todoItem.isDone {
            // 만약 isDone이 true라면, 텍스트에 취소선 속성을 추가합니다.
            let attributedString = NSAttributedString(string: todoItem.todo, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            cell.textField.attributedText = attributedString
        } else {
            // 만약 isDone이 false라면, 취소선 속성을 제거하고 일반적인 텍스트로 설정합니다.
            let plainText = NSAttributedString(string: todoItem.todo)
            cell.textField.attributedText = plainText
        }
        
        return cell
    }
    
    // 테이블 뷰의 셀 편집 스타일이 변경되었을 때 호출되며, 셀을 삭제하는 경우 할 일 항목을 삭제합니다.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 선택된 할 일 항목 배열에서 해당 인덱스에 위치한 항목을 가져옵니다.
            let todoItem = selectedTodoItems[indexPath.row] // 할 일 항목 삭제
            todoManager.deleteTodoItem(todoItemID: todoItem.id) // 선택된 할 일 항목 업데이트 및 테이블 뷰 리로드
            updateSelectedTodoItemsAndReloadTableView() // 캘린더 뷰 리로드하여 이벤트 점들을 업데이트합니다.
            calendarView.reloadData()
        }
    }
    
    // 테이블 뷰의 각 행의 높이를 반환합니다.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: - ToDoListCellDelegate Extension

extension CalendarViewController: ToDoListCellDelegate {
    
    func mappinTapped(_ cell: ToDoListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        TodoManager.tappedTodoId = cell.todoItem?.id ?? ""
    }
    
    // 할 일 목록 셀에서 체크박스를 탭했을 때 처리합니다.
    func todoItemCheckboxTapped(_ cell: ToDoListCell) {
        // 셀의 인덱스 경로를 가져옵니다.
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        // 할 일 항목의 'isDone' 상태를 업데이트합니다.
        selectedTodoItems[indexPath.row].isDone = cell.checkBox.isSelected
        
        // 업데이트된 할 일 항목을 저장합니다.
        todoManager.updateTodoItem(selectedTodoItems[indexPath.row])
        
        //위치가 설정되어 있지 않으면 리턴
        if (!(selectedTodoItems[indexPath.row].isLocationSet)) {
            return
        }
        
        if selectedTodoItems[indexPath.row].isDone {
            for region in locationManager.monitoredRegions {
              guard
                let circularRegion = region as? CLCircularRegion,
                circularRegion.identifier == selectedTodoItems[indexPath.row].id
              else { continue }
              locationManager.stopMonitoring(for: circularRegion)
            }
        } else {
            let location = CLLocationCoordinate2D(latitude: selectedTodoItems[indexPath.row].lat, longitude: selectedTodoItems[indexPath.row].lng)
            let region = CLCircularRegion(center: location, radius: 300.0, identifier: TodoManager.tappedTodoId)
            region.notifyOnEntry = true
            region.notifyOnExit = true

            locationManager.startMonitoring(for: region)
        }
        
        // 이벤트 점들을 업데이트하기 위해 캘린더 뷰를 리로드합니다.
        calendarView.reloadData()
    }
    
    // 할 일 목록 셀에서 삭제 버튼을 탭했을 때 처리합니다.
    func deleteButtonTapped(_ cell: ToDoListCell) {
        // 셀의 인덱스 경로를 가져옵니다.
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        // 선택된 할 일 항목을 selectedTodoItems 배열에서 제거하고 테이블 뷰를 업데이트합니다.
        selectedTodoItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // 업데이트된 할 일 항목들을 저장합니다.
        todoManager.saveTodoData()
        
        // 이벤트 점들을 업데이트하기 위해 캘린더 뷰를 리로드합니다.
        calendarView.reloadData()
    }
}
// MARK: - UITextFieldDelegate
// 키보드의 "Enter" 키가 눌렸을 때 처리합니다.
extension CalendarViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드를 닫습니다.
        textField.isUserInteractionEnabled = false
        // 입력된 텍스트를 가져옵니다.
        guard let text = textField.text, !text.isEmpty else {
            return true // 시스템에게 리턴 키 처리를 허용하도록 true를 반환합니다.
        }
        
        // 텍스트 필드를 포함하는 셀의 인덱스 경로를 가져옵니다.
        guard let indexPath = tableView.indexPath(for: textField.superview as! ToDoListCell) else {
            return true  // 시스템에게 리턴 키 처리를 허용하도록 true를 반환합니다.
        }
        
        // 해당 할 일 항목을 새 텍스트로 업데이트하고 변경 사항을 저장합니다.
        var todoItem = selectedTodoItems[indexPath.row]
        todoItem.todo = text
        selectedTodoItems[indexPath.row] = todoItem
        updateSelectedTodoItemsAndReloadTableView()
        
        // 이벤트 점들을 업데이트하기 위해 캘린더 뷰를 리로드합니다.
        calendarView.reloadData()
        
        return true // 시스템에게 리턴 키 처리를 허용하도록 true를 반환합니다
    }
}
