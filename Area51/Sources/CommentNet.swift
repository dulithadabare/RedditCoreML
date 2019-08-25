//
//  CommentNetModel.swift
//  Area51
//
//  Created by Dulitha Dabare on 8/25/19.
//

import Foundation

//
//  ViewController.swift
//  CommentNetTest
//
//  Created by Dulitha Dabare on 8/1/19.
//  Copyright © 2019 Dulitha Dabare. All rights reserved.
//

import UIKit
import CoreML
import NaturalLanguage


class CommentNet {
    
    static let shared  = CommentNet()
    let commentNetModel = CommentNetV2()
    var wordToIndex : [String : Double] = [:]
    let maxLen = 54
    var unkownWordIndex : Double = 400001
    @IBOutlet weak var textView: UITextView!

    private init() {
        getWordIndices()
    }
    
    func predict( inputString: String) -> Bool {

        if let predictedResult = predictLabel(forString: inputString) {
            switch predictedResult {

            case .troll:
                return false

            case .feedback:
                return true
            }
            
        }
        return true
        
    }
    
    func predictLabel(forString inputString : String ) -> PredictionResult? {
        
        do {
            let accelerationsMultiArray = try MLMultiArray(shape:[54,1,1], dataType:MLMultiArrayDataType.double)
            
            let inputIndices = sentenceToIndex(fromString: inputString)
            
            for (index, element) in inputIndices.enumerated() {
                accelerationsMultiArray[index] = NSNumber(value: element)
            }
            let hiddenStatesMultiArray = try MLMultiArray(shape: [128], dataType: MLMultiArrayDataType.double)
            for index in 0..<128 {
                hiddenStatesMultiArray[index] = NSNumber(integerLiteral: 0)
            }
        
            let input =  CommentNetV2Input(input1: accelerationsMultiArray,
                                           bidirectional_1_h_in: hiddenStatesMultiArray,
                                           bidirectional_1_c_in: hiddenStatesMultiArray,
                                           bidirectional_1_h_in_rev: hiddenStatesMultiArray,
                                           bidirectional_1_c_in_rev: hiddenStatesMultiArray,
                                           bidirectional_2_h_in: hiddenStatesMultiArray,
                                           bidirectional_2_c_in: hiddenStatesMultiArray,
                                           bidirectional_2_h_in_rev: hiddenStatesMultiArray,
                                           bidirectional_2_c_in_rev: hiddenStatesMultiArray)
            let predictionOutput = try commentNetModel.prediction(input: input)
            
            let threshold = NSNumber(value: 0.5)
            
            let isTroll = threshold.compare(predictionOutput.output1[0]) == ComparisonResult.orderedAscending
            
            return isTroll ? PredictionResult.troll : PredictionResult.feedback
            
        } catch {
            print(error.localizedDescription)
        }

        return nil
    }

    
    func getWordIndices() {
        
        guard let contentArray = readFile(fileName: "gloveWordIndex", fileType: "txt") else {
            return
        }
        
        for line in contentArray {
            let wordIndex = line.components(separatedBy: " ")
            wordToIndex[wordIndex[0]] = Double(wordIndex[1])
            
        }
        
        unkownWordIndex = Double(wordToIndex.count) + 1.0
        
        
    }
    
    func sentenceToIndex(fromString inputString: String ) -> [Double] {
        
        var indexArray: [Double] = Array(repeating: 0.0, count: maxLen)
        
        let words = inputString.components(separatedBy: " ")
        
        for (index, word) in words.enumerated() {
            
            if index >= maxLen {
                break
            }
            
            if let wordIndex = wordToIndex[word] {
                indexArray[index] = wordIndex
            } else {
                indexArray[index] = unkownWordIndex
            }
            
        }
        
        
        return indexArray
        
    }
    
    func readFile(fileName: String, fileType: String) -> [String]? {
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                var data = try String(contentsOf: fileUrl, encoding: .utf8)
                //                let content = try String(contentsOf: fileUrl)
                data = data.trimmingCharacters(in: .whitespacesAndNewlines)
                let content = data.components(separatedBy: .newlines)
                return content
            } catch {
                // Handle error here
            }
        }
        
        return nil
    }
    
    // example: read file.txt
    
    enum PredictionResult {
        
        case troll
        case feedback
    }
    
}

