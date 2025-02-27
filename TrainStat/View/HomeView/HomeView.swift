import UIKit
import SnapKit
import SwiftUI

struct Training {
    let date: String
    let timeInMinutes: Int
    let intensity: Int
}

final class RecentTrainingsViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent trainings"
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

    private func loadTrainingsFromCoreData() {
        let manager = CoreDataManager.shared
        let workoutEntities = manager.fetchWorkouts()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        self.trainings = workoutEntities.map { workout in
            let dateString: String
            if let date = workout.date {
                dateString = formatter.string(from: date)
            } else {
                dateString = "No date"
            }
            
            let timeInMinutes = Int(workout.time ?? "0") ?? 0
            let intensityValue = Int(workout.intensivity)
            
            return Training(
                date: dateString,
                timeInMinutes: timeInMinutes,
                intensity: intensityValue
            )
        }
        tableView.reloadData()
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }


    private func fetchLastWorkoutDateFromCoreData() -> Date? {
        let manager = CoreDataManager.shared
        let workouts = manager.fetchWorkouts()
        let sorted = workouts.sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
        return sorted.first?.date
    }
}

extension RecentTrainingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        let training = trainings[indexPath.row]
        cell.configure(with: training)
        
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
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(firstDivider.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        secondDivider.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        intensityLabel.snp.makeConstraints { make in
            make.top.equalTo(secondDivider.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(with training: Training) {
        dateLabel.text = "Date :  \(training.date)"
        timeLabel.text = "Time (min) :  \(training.timeInMinutes)"
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


private enum Constant {
    static let bigCircleSize: CGFloat = 33
    static let smallCircleSize: CGFloat = 31
    static let startExerciseButtonHeight: CGFloat = 120
    static let recentTrainingsButtonHeight: CGFloat = 69
    static let elementSpacing: CGFloat = 15
    static let horizontalPadding: CGFloat = 24
    static let calendarHeight: CGFloat = 293
    static let pickerSize: CGSize = CGSize(width: 120, height: 100)
    static let cornerRadius: CGFloat = 20
    static let overlayPadding: CGFloat = 16
    static let buttonFontSize: CGFloat = 30
}

// MARK: - HomeView SUI

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
    private let columns = Array(repeating: GridItem(.flexible(), spacing: Constant.elementSpacing), count: 7)
    private var months: [String] {
        calendar.monthSymbols
    }
    
    var body: some View {
        VStack {
            header
                .padding(.horizontal, Constant.horizontalPadding)
                .padding(.bottom, 7)
            
            calendarSection
                .padding(.horizontal, Constant.horizontalPadding)
                .padding(.bottom, 30)
            
            buttonsSection
                .padding(.horizontal, Constant.horizontalPadding)
            
            Spacer()
        }
        .sheet(isPresented: $forSheet) {
            NavigationView {
                RecentTrainingsViewControllerRepresentable()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationBackground(.black)
        }


        .background(Color.black.ignoresSafeArea())
        .onAppear {
            loadSelectedDates()
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: Constant.elementSpacing) {
            Text("Hey, name!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(yellowColor)
            
            Text("Ready for action?")
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: Constant.elementSpacing) {
            monthYearPicker
                .padding(.horizontal)
                .padding(.bottom, 10)
            
            RoundedRectangle(cornerRadius: Constant.cornerRadius)
                .frame(height: Constant.calendarHeight)
                .foregroundColor(systemDarkBlueColor)
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
                                    .onTapGesture {
                                        toggleDaySelection(day: day)
                                    }
                            } else {
                                Spacer()
                            }
                        }
                    }
                    .padding(Constant.overlayPadding)
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
                    ForEach(1...12, id: \.self) { month in
                        Text(months[month - 1]).tag(month)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 125, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(systemDarkBlueColor)
                )
                .accentColor(yellowColor)
                
                Picker("Select Year", selection: $selectedYear) {
                    ForEach(availableYears, id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 85, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(systemDarkBlueColor)
                )
                .accentColor(.white)
            }
        }
    }
    private func calendarDayView(day: Int) -> some View {
        let isSelected = isDaySelected(day)
        return ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, dash: isToday(day) ? [8, 8] : []))
                .frame(width: Constant.bigCircleSize, height: Constant.bigCircleSize)
                .foregroundColor(yellowColor)
            Circle()
                .frame(width: Constant.smallCircleSize, height: Constant.smallCircleSize)
                .foregroundColor(isSelected ? yellowColor : .black)
            
            Text("\(day)")
                .foregroundColor(isSelected ? .black : .white)
                .fontWeight(.bold)
        }
    }
    
    // MARK: - ButtonSection
    
    private var buttonsSection: some View {
        VStack(spacing: Constant.elementSpacing) {
            Button(action: {
                print("Start exercise tapped")
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: Constant.cornerRadius)
                        .frame(height: Constant.startExerciseButtonHeight)
                        .foregroundColor(yellowColor)
                    Text("Start exercise")
                        .fontWeight(.bold)
                        .font(.system(size: Constant.buttonFontSize))
                        .foregroundColor(.black)
                }
            }
            
            Button(action: { forSheet = true }) {
                ZStack {
                    RoundedRectangle(cornerRadius: Constant.cornerRadius)
                        .frame(height: Constant.recentTrainingsButtonHeight)
                        .foregroundColor(systemDarkBlueColor)
                    Text("Recent Trainings")
                        .fontWeight(.bold)
                        .font(.system(size: Constant.buttonFontSize))
                        .foregroundColor(.white)
                }
            }
        }
    }
    private func generateDays() -> [Int?] {
        let components = DateComponents(year: selectedYear, month: selectedMonth)
        guard let startOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
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
    
    private func toggleDaySelection(day: Int) {
        guard let date = dateFromDay(day) else { return }
        if selectedDates.contains(date) {
            removeWorkout(for: date)
        } else {
            saveWorkout(for: date)
        }
    }
    
    private func saveWorkout(for date: Date) {
        let manager = CoreDataManager.shared
        let workout = WorkoutEntity(context: manager.persistentContainer.viewContext)
        workout.id = UUID()
        workout.date = date
        
        do {
            try manager.save()
            selectedDates.insert(date)
        } catch {
            print("Failed to save workout: \(error)")
        }
    }
    
    private func removeWorkout(for date: Date) {
        let manager = CoreDataManager.shared
        let workouts = manager.fetchWorkouts().filter {
            $0.date != nil && Calendar.current.isDate($0.date!, inSameDayAs: date)
        }
        for w in workouts {
            manager.deleteWorkout(w)
        }
        selectedDates.remove(date)
    }
    
    private func loadSelectedDates() {
        let manager = CoreDataManager.shared
        let workouts = manager.fetchWorkouts()
        let dates = workouts.compactMap { $0.date }
        self.selectedDates = Set(dates)
    }
}

//#Preview {
//    HomeView()
//}

