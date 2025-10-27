
import SwiftUI
import Combine

struct PlantReminder: Identifiable {
    let id = UUID()
    var name: String
    var room: String
    var light: String
    var wateringDays: String
    var waterAmount: String
    var isWatered: Bool = false
}

class ReminderViewModel: ObservableObject {
    @Published var reminders: [PlantReminder] = []
    
    func addReminder(_ reminder: PlantReminder) {
        reminders.append(reminder)
    }
    
    // ✅ ADD THIS LINE:
    var allRemindersCompleted: Bool {
        return !reminders.isEmpty && reminders.allSatisfy { $0.isWatered }
    }
}

struct SetReminder: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ReminderViewModel
    
    
    @State private var plantName = ""
    @State private var room = "Bedroom"
    @State private var light = "Full sun"
    @State private var wateringDays = "Every day"
    @State private var waterAmount = "20–50 ml"
    @State private var navigateToToday = false // 🔹 add this at the top of your SetReminder struct

    // Options for dropdowns
    let roomOptions = ["Bedroom", "Living Room", "Office", "Kitchen"]
    let lightOptions = ["Full sun", "Partial sun", "Shade", "Indirect"]
    let wateringOptions = ["Every day", "Every 2 days", "Every 3 days", "Weekly"]
    let waterAmountOptions = ["20–50 ml", "50–100 ml", "100–150 ml", "150–200 ml"]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                // HEADER
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                        
                    }
                    Spacer()
                    Text("Set Reminder")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        let newReminder = PlantReminder(
                            name: plantName.isEmpty ? "Unknown Plant" : plantName,
                            room: room,
                            light: light,
                            wateringDays: wateringDays,
                            waterAmount: waterAmount
                        )
                        viewModel.addReminder(newReminder)
                        navigateToToday = true // ✅ navigate after adding
                    }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                            .frame(width: 38, height: 38)
                            .background(Color.green)
                            .clipShape(Circle())
                            .navigationBarBackButtonHidden(true)
 }

                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // FORM
                VStack(spacing: 20) {
                    TextField("Plant Name | Pothos", text: $plantName)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                    
                    // Room and Light grouped
                    VStack(spacing: 0) {
                        PickerRow(icon: "paperplane", title: "Room", selection: $room, options: roomOptions)
                        Divider()
                            .background(Color.gray.opacity(0.3))
                            .padding(.leading, 50)
                        PickerRow(icon: "sun.max", title: "Light", selection: $light, options: lightOptions)
                    }
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                    
                    // Watering Days and Water grouped
                    VStack(spacing: 0) {
                        PickerRow(icon: "drop", title: "Watering Days", selection: $wateringDays, options: wateringOptions)
                        Divider()
                            .background(Color.gray.opacity(0.3))
                            .padding(.leading, 50)
                        PickerRow(icon: "drop", title: "Water", selection: $waterAmount, options: waterAmountOptions)
                        NavigationLink("", destination: TodayReminder(viewModel: viewModel), isActive: $navigateToToday)
                            .hidden()
 }
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

// Reusable Picker Row
struct PickerRow: View {
    var icon: String = ""
    var title: String
    @Binding var selection: String
    var options: [String]
    
    var body: some View {
        HStack(spacing: 12) {
            if !icon.isEmpty {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .frame(width: 25)
            }
            
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 16))
            
            Spacer()
            Menu {
                ForEach(options, id: \.self) { option in
                    Button {
                        selection = option
                    } label: {
                        Text(option)
                            .foregroundColor(selection == option ? .white : .gray)
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(selection.isEmpty ? "Select option" : selection)
                        .foregroundColor(selection.isEmpty ? .gray : .white)
                        .font(.system(size: 16))
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 11))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)

    }
}

#Preview {
    SetReminder(viewModel: ReminderViewModel())
}


//import SwiftUI
//import Combine
//
//struct PlantReminder: Identifiable {
//    let id = UUID()
//    var name: String
//    var room: String
//    var light: String
//    var wateringDays: String
//    var waterAmount: String
//    var isWatered: Bool = false
//}
//
//class ReminderViewModel: ObservableObject {
//    @Published var reminders: [PlantReminder] = []
//    
//    func addReminder(_ reminder: PlantReminder) {
//        reminders.append(reminder)
//        
//        // ✅ SCHEDULE NOTIFICATION
//        NotificationManager.shared.scheduleNotification(for: reminder)
//    }
//    
//    var allRemindersCompleted: Bool {
//        return !reminders.isEmpty && reminders.allSatisfy { $0.isWatered }
//    }
//    
//    // ✅ DELETE REMINDER AND CANCEL NOTIFICATION
//    func deleteReminder(_ reminder: PlantReminder) {
//        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
//            reminders.remove(at: index)
//            
//            // Cancel notification
//            NotificationManager.shared.cancelNotification(for: reminder.id)
//        }
//    }
//}
//
//struct SetReminder: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var viewModel: ReminderViewModel
//    
//    @State private var plantName = ""
//    @State private var room = "Bedroom"
//    @State private var light = "Full sun"
//    @State private var wateringDays = "Every day"
//    @State private var waterAmount = "20–50 ml"
//    @State private var navigateToToday = false
//
//    let roomOptions = ["Bedroom", "Living Room", "Office", "Kitchen"]
//    let lightOptions = ["Full sun", "Partial sun", "Shade", "Indirect"]
//    let wateringOptions = ["Every day", "Every 2 days", "Every 3 days", "Weekly"]
//    let waterAmountOptions = ["20–50 ml", "50–100 ml", "100–150 ml", "150–200 ml"]
//    
//    var body: some View {
//        ZStack {
//            Color.black.ignoresSafeArea()
//            
//            VStack(spacing: 25) {
//                
//                // HEADER
//                HStack {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "xmark")
//                            .foregroundColor(.white)
//                            .font(.system(size: 20))
//                    }
//                    Spacer()
//                    Text("Set Reminder")
//                        .foregroundColor(.white)
//                        .font(.headline)
//                    Spacer()
//                    Button(action: {
//                        let newReminder = PlantReminder(
//                            name: plantName.isEmpty ? "Unknown Plant" : plantName,
//                            room: room,
//                            light: light,
//                            wateringDays: wateringDays,
//                            waterAmount: waterAmount
//                        )
//                        viewModel.addReminder(newReminder)  // ✅ This will schedule notification
//                        navigateToToday = true
//                    }) {
//                        Image(systemName: "checkmark")
//                            .foregroundColor(.white)
//                            .font(.system(size: 18, weight: .semibold))
//                            .frame(width: 38, height: 38)
//                            .background(Color.green)
//                            .clipShape(Circle())
//                            .navigationBarBackButtonHidden(true)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top, 10)
//                
//                // FORM
//                VStack(spacing: 20) {
//                    TextField("Plant Name | Pothos", text: $plantName)
//                        .padding()
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(15)
//                        .foregroundColor(.white)
//                    
//                    VStack(spacing: 0) {
//                        PickerRow(icon: "paperplane", title: "Room", selection: $room, options: roomOptions)
//                        Divider()
//                            .background(Color.gray.opacity(0.3))
//                            .padding(.leading, 50)
//                        PickerRow(icon: "sun.max", title: "Light", selection: $light, options: lightOptions)
//                    }
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(15)
//                    
//                    VStack(spacing: 0) {
//                        PickerRow(icon: "drop", title: "Watering Days", selection: $wateringDays, options: wateringOptions)
//                        Divider()
//                            .background(Color.gray.opacity(0.3))
//                            .padding(.leading, 50)
//                        PickerRow(icon: "drop", title: "Water", selection: $waterAmount, options: waterAmountOptions)
//                        NavigationLink("", destination: TodayReminder(viewModel: viewModel), isActive: $navigateToToday)
//                            .hidden()
//                    }
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(15)
//                }
//                .padding(.horizontal)
//                
//                Spacer()
//            }
//        }
//    }
//}
//
//struct PickerRow: View {
//    var icon: String = ""
//    var title: String
//    @Binding var selection: String
//    var options: [String]
//    
//    var body: some View {
//        HStack(spacing: 12) {
//            if !icon.isEmpty {
//                Image(systemName: icon)
//                    .foregroundColor(.white)
//                    .font(.system(size: 18))
//                    .frame(width: 25)
//            }
//            
//            Text(title)
//                .foregroundColor(.white)
//                .font(.system(size: 16))
//            
//            Spacer()
//            Menu {
//                ForEach(options, id: \.self) { option in
//                    Button {
//                        selection = option
//                    } label: {
//                        Text(option)
//                            .foregroundColor(selection == option ? .white : .gray)
//                    }
//                }
//            } label: {
//                HStack(spacing: 6) {
//                    Text(selection.isEmpty ? "Select option" : selection)
//                        .foregroundColor(selection.isEmpty ? .gray : .white)
//                        .font(.system(size: 16))
//                    Image(systemName: "chevron.down")
//                        .foregroundColor(.white)
//                        .font(.system(size: 11))
//                }
//            }
//        }
//        .padding(.horizontal, 16)
//        .padding(.vertical, 14)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarHidden(true)
//    }
//}
//
//#Preview {
//    SetReminder(viewModel: ReminderViewModel())
//}
