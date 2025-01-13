import SwiftUI
import SnapKit
import CoreData

struct Training {
    let date: String
    let timeInMinutes: String
    let intensity: Int
}

final class RecentTrainingsViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Trainings"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor.systemYellow
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.alwaysBounceVertical = true
        table.isScrollEnabled = true
        return table
    }()
    
    private var trainings: [Training] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RecentTrainingCell.self, forCellReuseIdentifier: RecentTrainingCell.identifier)
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        setupLayout()
        loadTrainingsFromCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTrainingsFromCoreData()
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func loadTrainingsFromCoreData() {
        let workouts = CoreDataManager.shared.fetchWorkouts()
        
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateFormat = "dd.MM.yyyy"
        
        trainings = workouts.map { workout in
            let dateString: String
            if let date = workout.date {
                dateString = formatter.string(from: date)
            } else {
                dateString = "No date"
            }
            let timeString = workout.time ?? "00:00"
            let intensityValue = Int(workout.intensivity)
            
            return Training(
                date: dateString,
                timeInMinutes: timeString,
                intensity: intensityValue
            )
        }
        
        tableView.reloadData()
    }


}

extension RecentTrainingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return trainings.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecentTrainingCell.identifier,
            for: indexPath
        ) as? RecentTrainingCell else {
            return UITableViewCell()
        }
        cell.configure(with: trainings[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

final class RecentTrainingCell: UITableViewCell {
    
    static let identifier = "RecentTrainingCellIdentifier"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let intensityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let firstDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    private let secondDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(firstDivider)
        containerView.addSubview(timeLabel)
        containerView.addSubview(secondDivider)
        containerView.addSubview(intensityLabel)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        firstDivider.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(firstDivider.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        secondDivider.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        intensityLabel.snp.makeConstraints { make in
            make.top.equalTo(secondDivider.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(with training: Training) {
        dateLabel.text = "Date :  \(training.date)"
        timeLabel.text = "Time :  \(training.timeInMinutes)"
        intensityLabel.text = "Intensity :  \(training.intensity)"
    }
}

struct RecentTrainingsViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> RecentTrainingsViewController {
        return RecentTrainingsViewController()
    }
    
    func updateUIViewController(_ uiViewController: RecentTrainingsViewController, context: Context) {
    }
}

struct HomeView: View {
    @State private var forSheet: Bool = false
    @State private var selectedDates: Set<Date> = []
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    
    private var calendar: Calendar = {
        var cal = Calendar.autoupdatingCurrent
        cal.firstWeekday = 2
        cal.locale = Locale.autoupdatingCurrent
        cal.timeZone = TimeZone.autoupdatingCurrent
        return cal
    }()
    
    private let availableYears = Array(2020...2030)
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 7)
    private var months: [String] {
        calendar.monthSymbols
    }
    
    var body: some View {
        VStack {
            Text("Hey, name!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.yellow)
                .padding(.top, 16)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            calendarSection
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            
            buttonsSection
                .padding(.horizontal, 24)
            
            Spacer()
        }
        .onAppear { loadSelectedDates() }
        .sheet(isPresented: $forSheet, onDismiss: {
                loadSelectedDates()
            }) {
                NavigationView {
                    RecentTrainingsViewControllerRepresentable()
                        .navigationBarTitleDisplayMode(.inline)
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.black)
            }
            .background(Color.black.ignoresSafeArea())
    }
    
    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            monthYearPicker
                .padding(.horizontal)
                .padding(.bottom, 10)
            
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 293)
                .foregroundColor(Color(red: 28/255, green: 40/255, blue: 51/255))
                .overlay(
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(weekdaySymbolsAlignedToStartOfWeek, id: \.self) { weekday in
                            Text(weekday)
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                        }
                        
                        ForEach(Array(generateDays().enumerated()), id: \.offset) { _, day in
                            if let day = day {
                                calendarDayView(day: day)
                            } else {
                                Spacer()
                            }
                        }
                    }
                    .padding(16)
                )
        }
    }
    private var monthYearPicker: some View {
        HStack {
            Text("Trainings in")
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            HStack(spacing: 10) {
                Picker("Select Month", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) {
                        Text(months[$0 - 1]).tag($0)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 125, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(red: 28/255, green: 40/255, blue: 51/255))
                )
                .accentColor(.yellow)
                
                Picker("Select Year", selection: $selectedYear) {
                    ForEach(availableYears, id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 85, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(red: 28/255, green: 40/255, blue: 51/255))
                )
                .accentColor(.white)
            }
        }
    }
    
    private var buttonsSection: some View {
        VStack(spacing: 15) {
            Button(action: {
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 120)
                        .foregroundColor(.yellow)
                    Text("Start exercise")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                }
            }
            
            Button(action: {
                forSheet = true
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 69)
                        .foregroundColor(Color(red: 28/255, green: 40/255, blue: 51/255))
                    
                    Text("Recent Trainings")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func generateDays() -> [Int?] {
        let components = DateComponents(year: selectedYear, month: selectedMonth)
        guard let startOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth)
        else {
            return []
        }
        
        let days = Array(range)
        let weekdayOfFirstDay = calendar.component(.weekday, from: startOfMonth)
        let offset = (weekdayOfFirstDay - calendar.firstWeekday + 7) % 7
        
        return Array(repeating: nil, count: offset) + days
    }
    
    private func isToday(_ day: Int) -> Bool {
        let today = calendar.dateComponents([.day, .month, .year], from: Date())
        return (today.day == day && today.month == selectedMonth && today.year == selectedYear)
    }
    private var weekdaySymbolsAlignedToStartOfWeek: [String] {
        let symbols = calendar.shortWeekdaySymbols
        let startIndex = calendar.firstWeekday - 1
        return Array(symbols[startIndex...]) + Array(symbols[..<startIndex])
    }
    
    private func isDaySelected(_ day: Int) -> Bool {
        guard let date = dateFromDay(day) else { return false }
        return selectedDates.contains(date)
    }
    private func dateFromDay(_ day: Int) -> Date? {
        let components = DateComponents(year: selectedYear, month: selectedMonth, day: day)
        return calendar.date(from: components)
    }
    
    private func loadSelectedDates() {
        let workouts = CoreDataManager.shared.fetchWorkouts()
        let truncatedDates = workouts.compactMap { workout -> Date? in
            guard let date = workout.date else { return nil }
            return calendar.startOfDay(for: date)
        }
        selectedDates = Set(truncatedDates)
    }

    
    private func calendarDayView(day: Int) -> some View {
        let isWorkoutDay = isDaySelected(day)
        return ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, dash: isToday(day) ? [8, 8] : []))
                .frame(width: 33, height: 33)
                .foregroundColor(.yellow)
            
            Circle()
                .frame(width: 31, height: 31)
                .foregroundColor(isWorkoutDay ? .yellow : .black)
            
            Text("\(day)")
                .foregroundColor(isWorkoutDay ? .black : .white)
                .fontWeight(.bold)
        }
        
    }
    
}

