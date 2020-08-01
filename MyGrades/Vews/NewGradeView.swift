//
//  NewGradeView.swift
//  MyGrades
//
//  Created by Valentin Perignon on 01/08/2020.
//  Copyright © 2020 Valentin Perignon. All rights reserved.
//

import SwiftUI

struct NewGradeView: View {
  // MARK: Environment
  
  @Environment(\.presentationMode) var presentationMode
  
  // MARK: Properties
  
  @ObservedObject var subject: Subject
  
  @State private var name: String = ""
  @State private var value: String = "0.0"
  @State private var coefficient: Double = 1
  
  @State private var showAlert = false
  
  // MARK: Body
  
  var body: some View {
    VStack {
      // ----- Title
      VStack {
        HStack {
          Text("New Grade")
            .font(.largeTitle)
            .fontWeight(.bold)
          Spacer()
        }
        HStack {
          Text("Add a new grade to \(subject.name)")
            .font(.callout)
          Spacer()
        }
      }
      .padding([.horizontal, .bottom])
      .padding(.top, 60)
      .background(Color.mgPurpleLight)
      .padding(.bottom, 22)
      
      // ----- Form
      
      VStack {
        // Name
        FormTextFieldView(keyboardType: .default, title: "Grade Name", textValue: $name)
          .padding(.bottom, 10)
        
        // Value
        FormTextFieldView(keyboardType: .decimalPad, title: "Value", textValue: $value)
          .padding(.bottom, 10)
        
        // Coefficient
        FormStepperView(
          title: "Coefficient",
          value: $coefficient,
          incrementAction: {
            self.coefficient += 0.5
          },
          decrementAction: {
            if self.coefficient > 0.5 {
              self.coefficient -= 0.5
            }
          }
        )
          .padding(.bottom, 10)
        
        
        // Button
        FormButtonView(label: "Add the Grade") {
          guard !self.name.isEmpty else {
            self.showAlert.toggle()
            return
          }
          
          self.subject.addGrade(name: name, value: Double(value)!, coefficient: coefficient)
          self.presentationMode.wrappedValue.dismiss()
        }
      }
      
      Spacer()
    }
    .alert(isPresented: $showAlert) {
      Alert(
        title: Text("Something went wrong"),
        message: Text("The grade must have a title"),
        dismissButton: .default(Text("OK"))
      )
    }
  }
}

struct NewGradeView_Previews: PreviewProvider {
  static var previews: some View {
    NewGradeView(subject: Subject(name: "Anglais", color: .red, coefficient: 3))
  }
}
