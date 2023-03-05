//
//  ContentView.swift
//  WordScramble
//
//  Created by Seika Hirori on 3/5/23.
//

import SwiftUI

struct ContentView: View {
    @State private var helloWorld:String = "Hello world. Part 1 :3"
    
    var body: some View {
        Part_1_Overview(hello_world: $helloWorld)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Part_2_Implementation: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world! Part 2 :3")
        }
        .padding()

    }
}

struct Part_1_Overview: View {
    @Binding var hello_world:String
    
    var body: some View {
        VStack {
//            List {
//                Section("Section 1") {
//                    Text("Hello Mail")
//                    Text("Hello bob")
//                }
//
//                Section ("Section 2") {
//                    ForEach(1..<4) {
//                        Text("Hello new person #\($0) :3")
//                    }
//                }
//
//                Section("Section 3") {
//                    Text("Bye Mail")
//                    Text("Bye everyone :3")
//                }
//            }
//            .padding()
//            .listStyle(.grouped)
            
            List(0..<5) {
                Text("That is step \($0)")
            }
        }
    }
}
