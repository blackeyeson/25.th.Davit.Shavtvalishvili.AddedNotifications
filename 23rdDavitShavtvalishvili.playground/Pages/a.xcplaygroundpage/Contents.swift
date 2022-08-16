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

let apiKey = "4d5c910865a5edc352e68d5a59651d23"
let urlString1 = "https://api.themoviedb.org/3/tv/top_rated?api_key=\(apiKey)&language=en-US&page=1"
var urlString2 = ""
var urlString3 = ""
var id1 = 0


actor CustomEvent {


    func getRandomId() async -> Int {
        do {
            let url = URL(string: "https://api.themoviedb.org/3/tv/top_rated?api_key=\(apiKey)&language=en-US&page=1")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let arr = try JSONDecoder().decode(TopRatedData.self, from: data)
            let id = arr.results.randomElement()!.id
            id1 = id
            return id
        } catch { print(error); return 0 }
    }

    func getRandomThesameId() async -> Int {
        do {
            let url = URL(string: "https://api.themoviedb.org/3/tv/\(id1)/similar?api_key=\(apiKey)&language=en-US&page=1")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let arr = try JSONDecoder().decode(TopRatedData.self, from: data)
            let id = arr.results.randomElement()!.id
            id1 = id
            return id
        } catch { print(error); return 0 }
    }

    func getDeets() async -> [String] {
        do {
            let url = URL(string: "https://api.themoviedb.org/3/tv/\(id1)?api_key=\(apiKey)&language=en-US")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let deets = try JSONDecoder().decode(Details.self, from: data)
            var arr: [String] = []
            arr += [deets.name]; arr += [String(deets.last_episode_to_air.episode_number)]
            return arr
        } catch { print("err"); return ["err"] }
    }
}

let someEvent = CustomEvent()

DispatchQueue.global().async {
    Task {
        await print(someEvent.getRandomId())
        await print(someEvent.getRandomThesameId())
        await print(someEvent.getDeets())
    }
}
