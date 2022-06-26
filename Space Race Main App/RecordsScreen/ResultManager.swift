//
//  ResultManager.swift
//  Space Race Main App
//
//  Created by Shemets on 21.06.22.
//

import Foundation

class ResultsManager {
    
    
    static func saveResults(result: GameResults) {
        let documentsUrl = documentsUrl()
        let resultURL = documentsUrl?.appendingPathComponent("result")
        guard let resultURL = resultURL else {
            return
        }
        if !FileManager.default.fileExists(atPath: resultURL.path) {
            FileManager.default.createFile(atPath: resultURL.path, contents: nil, attributes: nil)
        }
        if let handle = try? FileHandle(forWritingTo: resultURL) {
            var array: [GameResults] = loadData() ?? []
            array.append(result)
            let resultDataArray = try? JSONEncoder().encode(array)
            handle.write(resultDataArray ?? Data()) // adding content

            handle.closeFile() // closing the file
        }
    }
    
    static func loadData() -> [GameResults]? {
        let documentsUrl = documentsUrl()
        let resultURL = documentsUrl?.appendingPathComponent("result")
        guard let resultURL = resultURL else {
            return nil
        }
        guard let content = try? FileHandle(forReadingAtPath: resultURL.path)?.readToEnd() else {
            return nil
        }
        guard let result = try? JSONDecoder().decode([GameResults].self, from: content) else {
            return nil
        }
        return result
    }
    static func checkFiles() -> Bool {
        let fileManager = FileManager.default
        let url = documentsUrl()
        guard let url = url else {
            assertionFailure("url is nil")
            return false
        }
        let fileNames = try? fileManager.contentsOfDirectory(atPath: url.path)
        guard let fileNames = fileNames else {
            return false
        }
        return !fileNames.isEmpty
    }
    
    static func documentsUrl() -> URL? {
        let fileManager = FileManager.default
        let url = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return url
    }
}
 
