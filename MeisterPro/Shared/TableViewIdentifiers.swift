//
//  File.swift
//  MeisterPro
//
//  Created by Apple Macbook on 15/02/2021.
//

import UIKit

enum SFSymbols : String {
    case welcomeVC = "bell"
    case taskVC = "checkmark.circle"
    case projectVC = "pencil.and.outline"
    case checklistVC = "text.badge.minus"
}

enum FireBaseConstant {
    static let projectTable = "Projects"
    static let taskTable = "Tasks"
    static let checklistTable = "CheckLists"
    static let InfoCollectionName =  "Info"
    
    enum Project {
        static let title = "Project"
        static let sender = "Sender"
        static let time = "Date"
    }
    enum Task {
        static let title = "Task"
        static let sender  = "Sender"
        static let time = "Date"
    }
    enum Checklist {
        static let title = "CheckList"
        static let sender  = "Sender"
        static let time = "Date"
        static let check = "Condition"
    }
    enum InfoVC {
        static let Background = "Background"
        static let Profile = "Profile"
        static let Sender = "Sender"
    }
}

enum TableViewIdentifiers {
    static let taskID = "TaskCell"
    static let checklistID = "CheckListCell"
    static let projectID = "ProjectCell"
    static let projectCellID = "MSProjectCell"
}

enum Storage {
    static let Quotes = [
        """
        Great things in business are never done by one person. They're done by a team of people.
        - Steve Jobs
        """,
        """
        My favorite things in life don't cost any money. It's really clear that the most precious resource we all have is time.
        - Steve Jobs
        """,
        """
        Stay hungry, stay foolish.
        - Steve Jobs
        """,
        """
        The only way to do great work is to love what you do. If you haven’t found it yet, keep looking. Don’t settle. As with all matters of the heart, you’ll know when you find it. And, like any great relationship, it just gets better and better as the years roll on. So keep looking until you find it. Don’t settle.
        - Steve Jobs
        """,
        """
        All our dreams can come true, if we have the courage to pursue them.
        – Walt Disney
        """ ,
        """
        The secret of getting ahead is getting started.
        – Mark Twain
        """
        ,
        """
        Don’t limit yourself. Many people limit themselves to what they think they can do. You can go as far as your mind lets you. What you believe, remember, you can achieve.
        – Mary Kay Ash
        """,
        """
        The best time to plant a tree was 20 years ago. The second best time is now.
        – Chinese Proverb
        """,
        """
        Only the paranoid survive.
        – Andy Grove
        """,
        """
        It’s hard to beat a person who never gives up.
        – Babe Ruth
        """,
        """
        I wake up every morning and think to myself, how far can I push this company in the next 24 hours.
        – Leah Busque
        """,
        """
        If people are doubting how far you can go, go so far that you can’t hear them anymore.
        – Michele Ruiz
        """,
        """
        We need to accept that we won’t always make the right decisions, that we’ll screw up royally sometimes – understanding that failure is not the opposite of success, it’s part of success.
        – Arianna Huffington
        """,
        """
        The Harder You Work, The Luckier You Get.
        - Gary player
        """
    ]
}

enum Category {
    case checkList, taskList, projectList, profile
}
