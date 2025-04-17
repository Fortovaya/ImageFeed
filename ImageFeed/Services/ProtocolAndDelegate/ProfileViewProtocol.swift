//
//  ProfileView.swift
//  ImageFeed
//
//  Created by Алина on 13.04.2025.
//
import Foundation

protocol ProfileViewProtocol: AnyObject {
    func updateProfileDetails(name: String, login: String, bio: String)
    func updateAvatar(with url: URL)
    func resetToDefaultProfileData()
}
