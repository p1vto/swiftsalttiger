//
//  Parser.swift
//  SwiftSaltTiger
//
//  Created by iMac on 2021/11/30.
//

import Foundation
import Kanna

struct Parser {
    static func parseIntoPostList(doc: HTMLDocument) throws -> [Post] {
        guard let posts = doc.body?.xpath("//div[@id='content']//article") else {
            throw AppError.parseFail
        }
        
        var postList = [Post]()
        
        posts.forEach { post in
            guard let id = post["id"],
                  let title = post.xpath("//header[@class='entry-header']//h1//a").first?.content,// title
                  let detailUrl = post.xpath("//header[@class='entry-header']//h1//a").first?["href"],
                  let entryContent = post.xpath("//div[@class='entry-content']").first,
                  let content = entryContent.content,
                  let cover = entryContent.xpath("//p//img").first?["src"], // cover
                  let publisher = entryContent.xpath("//a").first?.content, // publisher
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
        
        return postList
    }
    
    
    
    static func parseIntoPostDetail(doc: HTMLDocument) throws -> String {
        guard let components = doc.body?.xpath("//div[@id='page']//div[@id='content']//article//div[@class='entry-content']//p") else {
            throw AppError.parseFail
        }
        
        let detail = components
            .dropFirst()
            .compactMap(\.content)
            .joined(separator: "\n")
        
        return detail
    }
}
