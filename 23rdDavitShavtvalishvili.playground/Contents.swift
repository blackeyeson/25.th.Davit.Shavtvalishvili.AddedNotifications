import UIKit
import Foundation

struct TopRatedData: Codable {
    struct TopArray: Codable {
        let name: String
        let vote_average: Double
        let id: Int
    }
    let results: [TopArray]
}

struct Details: Codable {
    struct Episode: Codable {
        let episode_number: Int
    }
    let name: String
    let last_episode_to_air: Episode
}

let semaphore = DispatchSemaphore(value: 1)
let apiKey = "4d5c910865a5edc352e68d5a59651d23"
var id1 = 0


func getArray1() {
    semaphore.wait()
    if let url = URL(string: "https://api.themoviedb.org/3/tv/top_rated?api_key=\(apiKey)&language=en-US&page=1") {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let parsedJSON = try jsonDecoder.decode(TopRatedData.self, from: data)
                    id1 = parsedJSON.results.randomElement()!.id
                    print(id1)
                    semaphore.signal()
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}

func getArray2(id: Int) {
    semaphore.wait()
    if let url = URL(string: "https://api.themoviedb.org/3/tv/\(id1)/similar?api_key=\(apiKey)&language=en-US&page=1") {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let parsedJSON = try jsonDecoder.decode(TopRatedData.self, from: data)
                    id1 = parsedJSON.results.randomElement()!.id
                    print(id1)
                    semaphore.signal()
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}

func details(id: Int) {
    semaphore.wait()
    if let url = URL(string: "https://api.themoviedb.org/3/tv/\(id)?api_key=\(apiKey)&language=en-US") {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let parsedJSON = try jsonDecoder.decode(Details.self, from: data)
                    print(parsedJSON.name, parsedJSON.last_episode_to_air.episode_number)
                    semaphore.signal()
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}

getArray1()
getArray2(id: id1)
details(id: id1)
