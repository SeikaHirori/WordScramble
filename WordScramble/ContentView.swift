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
    
    @State var errorTitle: String = ""
    @State var errorMessage: String = ""
    @State var showingError: Bool = false
    
    @State private var counter_Words: Int = 0
    @State private var counter_Letters: Int = 0
    
    var body: some View {
        Part_2_Implementation(usedWords: $usedWords,
                              rootWord: $rootWord,
                              newWord: $newWord,
                              errorTitle: $errorTitle,
                              errorMessage: $errorMessage,
                              showingError: $showingError,
                              counter_Words: $counter_Words,
                              counter_Letters: $counter_Letters
        )
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
    
    // Show error messages
    @Binding var errorTitle: String
    @Binding var errorMessage: String
    @Binding var showingError: Bool
    
    // Challenge #3
    // Score Counter
    @Binding var counter_Words: Int
    @Binding var counter_Letters: Int
    
    // Debugging
    @State var counter_changes:Int = 0
    
    var body: some View {
        NavigationView {
            List {
                
                // Challenge #3
                Section("Score of") {
                    HStack(alignment: .center) {
                        Text("Valid words:")
                        Spacer()
                        Text("\(counter_Words)")
                    }
                    
                    HStack(alignment: .center) {
                        Text("Letter count:")
                        Spacer()
                        Text(" \(counter_Letters)")
                    }
                }
                
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                .padding()
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit {
                addNewWord()
            }
            .onAppear() {
                startGame()
            }
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            // Challenge #2
            .toolbar {
                Button("New word :3", action: newGameSession)
                    .newWord()
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
        
        // Challenge #1
        guard isLessThanOrEqualTo_3_Letters(word: answer) else {
            wordError(title: "Word is too short", message: "Needs to be more than 3 letters :'[")
            return
        }
        
        // Challenge #1
        guard isSameAsRootWord(word: answer) else {
            wordError(title: "Same word!", message: "It can't be the same as root word :'[")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original :'[")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word is not recognized", message: "You can't make  them up >:[")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
        
        // Challenge #3
        counter_Words += 1
        counter_Letters += answer.count
        
    }
    
    
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                
                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"
                
                // If we are here everything has worked, so we can exit
                return
            }
        }
        
        // If were are *here* then there was a problem – trigger a crash and report the error
        let errorMessage: String = "Could not load start.txt from bundle"
        fatalError(errorMessage)
    }
    
    // Challenge #2
    func newGameSession() {
        startGame()
        
        // Challenge #3
        // Reset properties
        usedWords = []
        counter_Words = 0
        counter_Letters = 0
        
    }
    
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker:UITextChecker = UITextChecker()
        let range:NSRange = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        let output: Bool = misspelledRange.location == NSNotFound
        return output
    }
    
    // Challenge #1
    func isLessThanOrEqualTo_3_Letters(word: String) -> Bool {
        let minimum_letter_count:Int = 4
        
        let word_count: Int = word.count
        
        if word_count < minimum_letter_count {
            return false
        }
            
        return true
    }
    
    // Challenge #1
    func isSameAsRootWord(word: String) -> Bool {
        return word != rootWord
    }
    
    
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    
    // Debugging only
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

extension View {
    func newWord() -> some View {
        modifier(New_Word())
    }
}

struct New_Word: ViewModifier {
    func body(content: Content) -> some View {
        content
            
            .padding(5)
            .background(Color.white)
            .foregroundColor(Color.primary)
            .clipShape(Capsule())
    }
}
