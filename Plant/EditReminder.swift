
import SwiftUI

struct EditReminder: View {
   @ObservedObject var viewModel: ReminderViewModel
   @Binding var reminder: PlantReminder
   @Environment(\.presentationMode) var presentationMode
   
   // all my Options for dropdowns
   let roomOptions = ["Bedroom", "Living Room", "Office", "Kitchen"]
   let lightOptions = ["Full sun", "Partial sun", "Shade", "Indirect"]
   let wateringOptions = ["Every day", "Every 2 days", "Every 3 days", "Weekly"]
   let waterAmountOptions = ["20–50 ml", "50–100 ml", "100–150 ml", "150–200 ml"]

   var body: some View {
       ZStack {
           Color.black.ignoresSafeArea()
           
           VStack(spacing: 25) {
               // Header
               HStack {
                   Button(action: {
                       presentationMode.wrappedValue.dismiss() //closes
                   }) {
                       Image(systemName: "xmark")///xMark apple UI name
                           .foregroundColor(.white)
                   }
                   Spacer()
                   Text("Edit Reminder")
                       .foregroundColor(.white)
                       .font(.headline)
                   Spacer()
                   Button(action: {
                       // Save changes
                       if let index = viewModel.reminders.firstIndex(where: { $0.id == reminder.id }) {
                           viewModel.reminders[index] = reminder
                       }
                       presentationMode.wrappedValue.dismiss()
                   }) {
                       Image(systemName: "checkmark.circle.fill")
                           .foregroundColor(.green)
                           .font(.system(size: 24))
                   }
               }
               .padding(.horizontal)
               
               // Form
               VStack(spacing: 20) {
                   TextField("Plant Name", text: $reminder.name)
                       .padding()
                       .background(Color.gray.opacity(0.15))
                       .cornerRadius(10)
                       .foregroundColor(.white)
                   
                   PickerRow(title: "Room", selection: $reminder.room, options: roomOptions)
                   PickerRow(title: "Light", selection: $reminder.light, options: lightOptions)
                   PickerRow(title: "Watering Days", selection: $reminder.wateringDays, options: wateringOptions)
                   PickerRow(title: "Water Amount", selection: $reminder.waterAmount, options: waterAmountOptions)
               }
               .padding(.horizontal)
               
               Spacer()
               
               // Delete Button
               Button(action: {
                   if let index = viewModel.reminders.firstIndex(where: { $0.id == reminder.id }) {
                       viewModel.reminders.remove(at: index)
                   }
                   presentationMode.wrappedValue.dismiss()
               }) {
                   Text("Delete Reminder")
                       .foregroundColor(.white)
                       .bold()
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.red)
                       .cornerRadius(15)
                       .padding(.horizontal)
               }
               
               Spacer()
           }
       }
   }
}
