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
    
    @State var counter_changes:Int = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        Text(word)
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit {
                addNewWord()
            }
        }
        .onChange(of: usedWords) { _ in
            debug_Print_Properties()}
        
        .onChange(of: rootWord) { _ in
            debug_Print_Properties()
        }
        .onChange(of: newWord) { _ in
            debug_Print_Properties()
        }
    }
    
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exit if the remaining string is empty
        guard answer.count > 0 else {return}
        
        // extra validation to come
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    
    
    
    
    
    
    func debug_Print_Properties() {
        counter_changes += 1
        let output_changes:String = """
        Something changed with the properties! Let's see :3
        Change counter: \(counter_changes)
        
        
        usedWords: \(usedWords)
        rootWord: \(rootWord)
        newWord: \(newWord)
        ---------- :3 ----------
        """
        print(output_changes)
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
