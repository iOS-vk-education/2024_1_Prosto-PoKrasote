import SwiftUI
import SnapKit
import CoreData

struct Training {
    let date: String
    let timeInMinutes: String
    let intensity: Int
}

//HOME VIEW
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
        ZStack {
            gradient1.ignoresSafeArea()
            
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome back,")
                            .font(.title3)
                            .foregroundColor(.white)
                        Text("Max Verstappen")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: {
                        showingSettings.toggle()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showingSettings) {
                        Text("Settings screen")
                            .font(.title)
                    }
                }
                .padding(.top, 40)
                .padding(.horizontal, 24)
                CalendarSection()
                    .padding(.horizontal, 24)
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(green1)
                        .frame(height: 200)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Training for you")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        Text("Arm day")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(white1)
                                .frame(width: 80, height: 32)
                            Text("Medium")
                                .foregroundColor(green2)
                                .fontWeight(.medium)
                        }
                        .padding(.top, 50)
                    }
                    .padding(.leading, 16)
                    .padding(.top, 16)
                    HStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 100, height: 120)
                            .cornerRadius(12)
                            .padding(.trailing, 16)
                            .padding(.top, 32)
                    }
                }
                .padding(.horizontal, 24)
                ExerciseTapeSection()
                    .padding(.top, 12)
                    .padding(.horizontal, 24)
                yourProgressSection
                    .padding(.top, 5)
                    .padding(.horizontal, 24)
                Spacer()
            }
        }
    }
    private var yourProgressSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(green1)
                .frame(height: 150)
            HStack{
                VStack(alignment: .leading, spacing: 5) {
                    Text("Your")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Progress")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Button(action: {
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: 80, height: 32)
                            Text("Watch")
                                .foregroundColor(green2)
                        }
                    }
                }
                
                Spacer()
                HStack(alignment: .bottom, spacing: 8) {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 20, height: 40)
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 20, height: 60)
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 20, height: 80)
                }
            }
            .padding()
        }
    }

}

//TAPE EXERCIZE
struct ExerciseTapeSection: View {
    @State private var selectedCategory: String = "Muscle"
    let categoriesTraining: [String] = ["Muscle", "Cardio", "Running", "Pilates"]
    
    struct Workout: Identifiable {
        var id = UUID()
        var name: String
        var image: String
        var difficulty: String
    }
    
    let workoutCategory: [String: [Workout]] = [
        "Muscle": [
            Workout(name: "Chest Day", image: "c", difficulty: "Hard"),
            Workout(name: "Back Day",  image: "b", difficulty: "Medium"),
            Workout(name: "Arm Day",   image: "a", difficulty: "Medium")
        ],
        "Cardio": [
            Workout(name: "HIIT",      image: "h",  difficulty: "Hard"),
            Workout(name: "Bicycle",   image: "bi", difficulty: "Easy"),
            Workout(name: "Treadmill", image: "tr", difficulty: "Medium")
        ],
        "Running": [
            Workout(name: "Interval Running", image: "y", difficulty: "Medium"),
            Workout(name: "Long Distance",    image: "b", difficulty: "Hard"),
            Workout(name: "Trail Running",    image: "v", difficulty: "Medium")
        ],
        "Pilates": [
            Workout(name: "Pilates Beginner",     image: "r", difficulty: "Easy"),
            Workout(name: "Pilates Intermediate", image: "w", difficulty: "Medium"),
            Workout(name: "Pilates Advanced",     image: "t", difficulty: "Hard")
        ]
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categoriesTraining, id: \.self) { category in
                        Text(category)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(selectedCategory == category ? green2 : white1)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(selectedCategory == category ? white1 : green2)
                            .clipShape(Capsule())
                            .onTapGesture {
                                selectedCategory = category
                            }
                    }
                }
            }
            
            if let choosenWorkouts = workoutCategory[selectedCategory] {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(choosenWorkouts) { workout in
                            ZStack {
                                Rectangle()
                                    .fill(green1)
                                    .frame(width: 150, height: 120)
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(workout.name)
                                        .fontWeight(.semibold)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .minimumScaleFactor(0.8)
                                        .frame(width: 130, alignment: .leading)
                                    
                                    Text(workout.difficulty)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(green2)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(white1)
                                        .clipShape(Capsule())
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(width: 140, height: 100, alignment: .topLeading)
                            }
                        }
                    }
                    .padding(.vertical, 8)
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
}

//CALENDAR

struct CalendarSection: View {
    @FetchRequest(
        entity: WorkoutEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: true)]
    )
    var workouts: FetchedResults<WorkoutEntity>
    @State private var calendarState: Date = Date()
    
    var visitedDates: [Date] {
        workouts.compactMap { $0.date }
    }
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(datesGenerate(from: calendarState, daysInPast: 30, daysInFuture: 100), id: \.self) { date in
                        dayItem(date).id(date)
                    }
                }
            }
            .onAppear {
                scrollViewProxy.scrollTo(calendarState, anchor: .leading)
            }
        }
    }
}

extension CalendarSection {
    func datesGenerate(from startDate: Date, daysInPast: Int, daysInFuture: Int) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        for i in stride(from: daysInPast, through: 1, by: -1) {
            if let pastDate = calendar.date(byAdding: .day, value: -i, to: startDate) {
                dates.append(pastDate)
            }
        }
        dates.append(startDate)
        for i in 1...daysInFuture {
            if let futureDate = calendar.date(byAdding: .day, value: i, to: startDate) {
                dates.append(futureDate)
            }
        }
        return dates
    }
    
    private var shortWeekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }
    
    private var dayNumberFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }
    
    func dayItem(_ date: Date) -> some View {
        let weekdayString = shortWeekdayFormatter.string(from: date)
        let dayString = dayNumberFormatter.string(from: date)
        let isToday = Calendar.current.isDateInToday(date)
        
        return VStack(spacing: 4) {
            Text(weekdayString)
                .font(.caption)
                .fontWeight(.medium)
            Text(dayString)
                .font(.headline)
                .fontWeight(.bold)
            Circle()
                .fill(visitedDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) ? Color.white : Color.clear)
                .frame(width: 5, height: 5)
                .padding(.top, 2)
        }
        .frame(width: 50, height: 80)
        .foregroundColor(.white)
        .background(
            Capsule()
                .fill(green1)
                .overlay(
                    Capsule()
                        .stroke(Color.white, lineWidth: isToday ? 3 : 1)
                )
        )
        .padding(.horizontal, 6)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 16")
            .preferredColorScheme(.dark)
    }
}
