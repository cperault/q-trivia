//
//  CategoryModel.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

struct CategoryModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    
    var categoryName: String {
        return getCategoryNameAndIcon(categoryName: name)[0]
    }
    var categoryIcon: String {
        return getCategoryNameAndIcon(categoryName: name)[1]
    }
    var categoryID: String {
        return getCategoryNameAndIcon(categoryName: name)[2]
    }
}

func getCategoryNameAndIcon(categoryName: String) -> [String] {
    var name: String
    var icon: String
    var categoryID: String
    
    switch categoryName {
    case "General Knowledge":
        name = categoryName
        icon = "category-knowledge"
        categoryID = "9"
    case "Entertainment: Books":
        name = "Books"
        icon = "category-books"
        categoryID = "10"
    case "Entertainment: Comics":
        name = "Comics"
        icon = "category-comics"
        categoryID = "29"
    case "Entertainment: Cartoon & Animations":
        name = "Cartoons & Animations"
        icon = "category-cartoons-and-animations"
        categoryID = "32"
    case "Entertainment: Film":
        name = "Films"
        icon = "category-film"
        categoryID = "11"
    case "Entertainment: Japanese Anime & Manga":
        name = "Japanese Anime & Manga"
        icon = "category-anime"
        categoryID = "31"
    case "Entertainment: Music":
        name = "Music"
        icon = "category-music"
        categoryID = "12"
    case "Entertainment: Musicals & Theatres":
        name = "Musicals & Theatres"
        icon = "category-musicals-and-theatres"
        categoryID = "13"
    case "Entertainment: Television":
        name = "Television"
        icon = "category-television"
        categoryID = "14"
    case "Entertainment: Video Games":
        name = "Video Games"
        icon = "category-video-games"
        categoryID = "15"
    case "Entertainment: Board Games":
        name = "Board Games"
        icon = "category-board-games"
        categoryID = "16"
    case "Science: Gadgets":
        name = "Gadgets"
        icon = "category-gadgets"
        categoryID = "30"
    case "Science & Nature":
        name = categoryName
        icon = "category-science-and-nature"
        categoryID = "17"
    case "Science: Computers":
        name = "Computers"
        icon = "category-computers"
        categoryID = "18"
    case "Science: Mathematics":
        name = "Math"
        icon = "category-math"
        categoryID = "19"
    case "Mythology":
        name = categoryName
        icon = "category-mythology"
        categoryID = "20"
    case "Sports":
        name = categoryName
        icon = "category-sports"
        categoryID = "21"
    case "Geography":
        name = categoryName
        icon = "category-geography"
        categoryID = "22"
    case "History":
        name = categoryName
        icon = "category-history"
        categoryID = "23"
    case "Politics":
        name = categoryName
        icon = "category-politics"
        categoryID = "24"
    case "Art":
        name = categoryName
        icon = "category-art"
        categoryID = "25"
    case "Celebrities":
        name = categoryName
        icon = "category-celebrities"
        categoryID = "26"
    case "Animals":
        name = categoryName
        icon = "category-animals"
        categoryID = "27"
    case "Vehicles":
        name = categoryName
        icon = "category-vehicles"
        categoryID = "28"
    default:
        name = "Oops..."
        icon = "category-placeholder"
        categoryID = "0"
    }
    
    return [name, icon, categoryID]
}

struct CategoryAPIResponse: Codable {
    let trivia_categories: [CategoryModel]
}
