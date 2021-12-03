//
//  Requests.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 27/11/2021.
//

import Foundation
import Kanna



@MainActor
func fetchPostList(page: Int) async -> Result<[Post], AppError> {
    let url = URL(string: "\(Defaults.URLConfig.host)/page/\(page)")!
    let urlRequest = URLRequest(url: url)
    var postList = [Post]()
    
    guard let result = try? await URLSession.shared.data(for: urlRequest),
          let doc = try? HTML(html: result.0, encoding: .utf8)
    else {
        return .failure(.requestFail)
    }
    
    guard let posts = doc.body?.xpath("//div[@id='content']//article") else {
        return .failure(.parseFail)
    }
    
    
    posts.forEach { post in
        guard let id = post["id"],
              let title = post.xpath("//header[@class='entry-header']//h1//a").first?.content,// title
              let detailUrl = post.xpath("//header[@class='entry-header']//h1//a").first?["href"],
              let entryContent = post.xpath("//div[@class='entry-content']").first,
              let content = entryContent.content,
              let cover = entryContent.xpath("//p//img").first?["src"], //cover
              let publisher = entryContent.xpath("//a").first?.content, // publication date
              let downloadUrl = entryContent.xpath("//a")[1]["href"] // download url
        else {
            return
        }
        
        var code = ""
        var pubDate = ""
        
        let components = content
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\t", with: "")
            .components(separatedBy: "\n")
        components.forEach {
            if $0.contains("出版时间") {
                if let pubDateStr = $0.components(separatedBy: "：").last {
                    pubDate = pubDateStr
                }
            } else if $0.contains("提取码") {
                if let codeStr = $0.components(separatedBy: "：").last {
                    code = codeStr
                }
            }
        }
        
        postList.append(.init(id: id,
                              cover: cover,
                              title: title,
                              pubDate: pubDate,
                              publisher: publisher,
                              downloadLink: downloadUrl,
                              downloadCode: code,
                              detailUrl: detailUrl))
        
    }
    
    return .success(postList)
}


@MainActor
func fetchPostDetail(post: Post) async -> Result<String, AppError> {
    let url = URL(string: "\(post.detailUrl)")!
    let urlRequest = URLRequest(url: url)
    
    
    guard let result = try? await URLSession.shared.data(for: urlRequest),
          let doc = try? HTML(html: result.0, encoding: .utf8)
    else {
        return .failure(.requestFail)
    }
    
    guard let components = doc.body?.xpath("//div[@id='page']//div[@id='content']//article//div[@class='entry-content']//p") else {
        return .failure(.parseFail)
    }
    
    let detail = components
        .dropFirst()
        .compactMap(\.content)
        .joined(separator: "\n")
    
    return .success(detail)
}
