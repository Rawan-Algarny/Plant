
import SwiftUI

struct TodayReminder: View {
    @ObservedObject var viewModel: ReminderViewModel
    @State private var selectedReminder: PlantReminder? = nil
    @State private var showSetReminder = false
    
    private var progress: Double {
        guard !viewModel.reminders.isEmpty else { return 0 }
        let wateredCount = viewModel.reminders.filter { $0.isWatered }.count
        return Double(wateredCount) / Double(viewModel.reminders.count)
    }

    var body: some View {
        //NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                // ✅ CONDITIONAL VIEW: Show AllDone if all completed
                if viewModel.allRemindersCompleted {
                    AllDone(viewModel: viewModel)
                } else {
                    // Your existing reminder list
                    VStack(alignment: .leading, spacing: 20) {
                        Text("My Plants 🌱")
                            .foregroundColor(.white)
                            .font(.system(size: 33, weight: .bold))
                            .padding(.horizontal)

                        Divider()
                            .background(Color.gray.opacity(0.5))
                            .padding(.horizontal)
                        
//                        Text("Your plants are waiting for a sip 💧")
//                            .foregroundColor(.white)
//                            .font(.system(size: 18))
//                            .padding(.horizontal)
//                        
//                        ProgressView(value: progress)
//                            .tint(.green)
//                            .padding(.horizontal)
//                            .scaleEffect(y: 3)
//
                        Text("\(viewModel.reminders.filter { $0.isWatered }.count) of your plant\(viewModel.reminders.filter { $0.isWatered }.count == 1 ? "" : "s") feel loved today 🌱")
                                                .foregroundColor(.white)
                                                .font(.headline)
                                                .padding(.top, 20)

                                            
                                            ProgressView(
                                                value: Double(viewModel.reminders.filter { $0.isWatered }.count),
                                                total: Double(max(viewModel.reminders.count, 1))
                                            )
                                            .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                            .padding(.horizontal)
                        // ✅ LIST WITH VISIBLE DIVIDERS
                        List {
                            ForEach(Array(viewModel.reminders.enumerated()), id: \.element.id) { index, reminder in
                                VStack(spacing: 0) {
                                    PlantRow(
                                        name: reminder.name,
                                        room: reminder.room,
                                        light: reminder.light,
                                        waterAmount: reminder.waterAmount,
                                        isWatered: Binding(
                                            get: { viewModel.reminders[index].isWatered },
                                            set: { viewModel.reminders[index].isWatered = $0 }
                                        ),
                                        onTap: {
                                            selectedReminder = reminder
                                        }
                                    )
                                    
                                    // ✅ VISIBLE DIVIDER
                                    if index < viewModel.reminders.count - 1 {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.5))
                                            .frame(height: 1)
                                            .padding(.top, 15)
                                            .padding(.bottom, 5)
                                    }
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        if let idx = viewModel.reminders.firstIndex(where: { $0.id == reminder.id }) {
                                            viewModel.reminders.remove(at: idx)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.black)
                        
                        // Floating add button
                        Button(action: {
                            showSetReminder = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 65, height: 65)
                                .background(Color.green)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .padding()
                                .padding(.trailing, 10)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .fullScreenCover(isPresented: $showSetReminder) {
                            SetReminder(viewModel: viewModel)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .fullScreenCover(item: $selectedReminder) { reminder in
                if let index = viewModel.reminders.firstIndex(where: { $0.id == reminder.id }) {
                    EditReminder(viewModel: viewModel, reminder: $viewModel.reminders[index])
                        .background(Color.black.ignoresSafeArea())
                }
            }
        }
    }
//}

struct PlantRow: View {
    var name: String
    var room: String
    var light: String
    var waterAmount: String
    @Binding var isWatered: Bool
    var onTap: () -> Void

    var body: some View {
        HStack {
            // Checkbox button
            Button(action: {
                isWatered.toggle()
            }) {
                Image(systemName: isWatered ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isWatered ? .green : .gray)
                    .font(.system(size: 22))
            }
            .buttonStyle(PlainButtonStyle())
            
            // Plant info
            VStack(alignment: .leading, spacing: 8) {
                Label(room, systemImage: "location.fill")
                    .foregroundColor(.gray)
                    .font(.callout)

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .foregroundColor(.white)
                        .font(.title3)

                    HStack(spacing: 10) {
                        Label(light, systemImage: "sun.max.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)

                        Label(waterAmount, systemImage: "drop.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    TodayReminder(viewModel: ReminderViewModel())
}
