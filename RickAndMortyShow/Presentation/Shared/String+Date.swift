//
//  String+Date.swift
//  RickAndMortyShow
//
//  Created by Sumit Gosai on 13/05/26.
//

import Foundation

extension String {

    func formattedDate() -> String {

        let inputFormatter =
            ISO8601DateFormatter()

        inputFormatter.formatOptions = [

            .withInternetDateTime,
            .withFractionalSeconds
        ]

        guard let date =
            inputFormatter.date(
                from: self
            ) else {

            return self
        }

        let outputFormatter =
            DateFormatter()

        outputFormatter.dateFormat =
            "dd MMM yyyy"
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short

        return outputFormatter.string(
            from: date
        )
    }
}
