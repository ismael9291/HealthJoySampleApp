//
//  GiphyObject.swift
//  HealthJoyApp
//
//  Created by Ismael Zavala on 6/23/22.
//

import Foundation

// MARK: - GiphyObject
struct GiphyObject: Codable {
    let data: [Datum]
    let pagination: Pagination
    let meta: Meta
}

// MARK: - Datum
struct Datum: Codable {
    let type: TypeEnum
    let id: String?
    let url: String?
    let slug: String?
    let bitlyGIFURL, bitlyURL: String?
    let embedURL: String?
    let username: String?
    let source: String?
    let title: String?
    let rating: String?
    let contentURL, sourceTLD: String?
    let sourcePostURL: String?
    let isSticker: Int
    let importDatetime, trendingDatetime: String?
    let images: Images?
    let analyticsResponsePayload: String?
    let analytics: Analytics
    let user: User?

    enum CodingKeys: String, CodingKey {
        case type, id, url, slug
        case bitlyGIFURL = "bitly_gif_url"
        case bitlyURL = "bitly_url"
        case embedURL = "embed_url"
        case username, source, title, rating
        case contentURL = "content_url"
        case sourceTLD = "source_tld"
        case sourcePostURL = "source_post_url"
        case isSticker = "is_sticker"
        case importDatetime = "import_datetime"
        case trendingDatetime = "trending_datetime"
        case images
        case analyticsResponsePayload = "analytics_response_payload"
        case analytics , user
    }
}

// MARK: - Analytics
struct Analytics: Codable {
    let onload, onclick, onsent: Onclick
}

// MARK: - Onclick
struct Onclick: Codable {
    let url: String?
}

// MARK: - Images
struct Images: Codable {
    let original: FixedHeight
    let downsized, downsizedLarge, downsizedMedium: The480_WStill
    let downsizedSmall: DownsizedSmall
    let downsizedStill: The480_WStill
    let fixedHeight, fixedHeightDownsampled, fixedHeightSmall: FixedHeight
    let fixedHeightSmallStill, fixedHeightStill: The480_WStill
    let fixedWidth, fixedWidthDownsampled, fixedWidthSmall: FixedHeight
    let fixedWidthSmallStill, fixedWidthStill: The480_WStill
    let looping: Looping
    let originalStill: The480_WStill
    let originalMp4, preview: DownsizedSmall

    enum CodingKeys: String, CodingKey {
        case original, downsized
        case downsizedLarge = "downsized_large"
        case downsizedMedium = "downsized_medium"
        case downsizedSmall = "downsized_small"
        case downsizedStill = "downsized_still"
        case fixedHeight = "fixed_height"
        case fixedHeightDownsampled = "fixed_height_downsampled"
        case fixedHeightSmall = "fixed_height_small"
        case fixedHeightSmallStill = "fixed_height_small_still"
        case fixedHeightStill = "fixed_height_still"
        case fixedWidth = "fixed_width"
        case fixedWidthDownsampled = "fixed_width_downsampled"
        case fixedWidthSmall = "fixed_width_small"
        case fixedWidthSmallStill = "fixed_width_small_still"
        case fixedWidthStill = "fixed_width_still"
        case looping
        case originalStill = "original_still"
        case originalMp4 = "original_mp4"
        case preview
    }
}

// MARK: - The480_WStill
struct The480_WStill: Codable {
    let height, width, size: String?
    let url: String?
}

// MARK: - DownsizedSmall
struct DownsizedSmall: Codable {
    let height, width, mp4Size: String?
    let mp4: String?

    enum CodingKeys: String, CodingKey {
        case height, width
        case mp4Size = "mp4_size"
        case mp4
    }
}

// MARK: - FixedHeight
struct FixedHeight: Codable {
    let height, width, size: String?
    let url: String?
    let mp4Size: String?
    let mp4: String?
    let webpSize: String?
    let webp: String?
    let frames, hash: String?

    enum CodingKeys: String, CodingKey {
        case height, width, size, url
        case mp4Size = "mp4_size"
        case mp4
        case webpSize = "webp_size"
        case webp, frames, hash
    }
}

// MARK: - Looping
struct Looping: Codable {
    let mp4Size: String?
    let mp4: String?

    enum CodingKeys: String, CodingKey {
        case mp4Size = "mp4_size"
        case mp4
    }
}

enum TypeEnum: String, Codable {
    case gif = "gif"
}

// MARK: - User
struct User: Codable {
    let avatarURL: String?
    let bannerImage, bannerURL: String?
    let profileURL: String?
    let username: String?
    let displayName, userDescription: String?
    let instagramURL: String?
    let websiteURL: String?
    let isVerified: Bool

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case bannerImage = "banner_image"
        case bannerURL = "banner_url"
        case profileURL = "profile_url"
        case username
        case displayName = "display_name"
        case userDescription = "description"
        case instagramURL = "instagram_url"
        case websiteURL = "website_url"
        case isVerified = "is_verified"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let status: Int
    let msg, responseID: String?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case responseID = "response_id"
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let totalCount, count, offset: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
}
