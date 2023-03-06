//
//  ContentView.swift
//  WordScramble
//
//  Created by Seika Hirori on 3/5/23.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord: String = ""
    @State private var newWord: String = ""
    
    var body: some View {
        Part_2_Implementation(usedWords: $usedWords,
                              rootWord: $rootWord,
                              newWord: $newWord)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Part_2_Implementation: View {
    @Binding var usedWords: [String]
    @Binding var rootWord: String
    @Binding var newWord: String
    
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
    
    let people:[String] = ["Finn", "Leia", "Luke", "Rey"]
    
    var body: some View {
        
        List {
            Section("List Time :D"){
            
                Text("Top Static Row")
                
                ForEach (people, id: \.self) { item in
                    Text(item)
                }
                
                Text("Bottom Static Row")
            }
            
            Section("Word Time :O") {
                Text(wordTime())
                
            }
            
            Section("Speeling time, G00d?") {
                Text(using_UIKit_time())
            }
        }
    }
    
    func load_file() {
        if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
            // we found the file in our bundle!
            if let fileContents = try? String(contentsOf: fileURL) {
                // we loaded the file into a string!
            }
        }
    }
    
    func wordTime() -> String {
        var output:String
        
        let input = " a b c "
        let letters_removed_WhiteSpaces = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        
        
        let letter = letters_removed_WhiteSpaces.randomElement()
        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        output = trimmed!
    
        
        return output
    }
    
    func using_UIKit_time() -> String {
        
        // Step #1
        let word:String = "Swift"
        let checker:UITextChecker = UITextChecker()
        
        // Step #2
        // This is a bridge between Swift and Objective-C as Objective-C will understand how Swift handles strings
        let range = NSRange(location: 0, length: word.utf16.count)
        
        // Step #3
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        var allGood:Bool {
            misspelledRange.location == NSNotFound
        }
        
        switch allGood {
        case true:
            return "GOOD TO GO!"
        case false:
            return "ripp :'("
        }
    }
}
