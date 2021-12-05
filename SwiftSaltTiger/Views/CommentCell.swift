//
//  CommentCell.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 5/12/2021.
//

import Foundation
import SwiftUI

struct CommentCell: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(comment.author)
                .font(.system(size: 16, weight: .heavy))
                .tint(.black)
                
                
            
            Text(comment.date)
                .font(.system(size: 11, weight: .regular))
                .tint(.gray)
                
                
            
            Text(comment.content)
                .font(.system(size: 14))
                .tint(.black)
                .padding(.vertical)
                
                
            
            Divider()
        }
    }

}
