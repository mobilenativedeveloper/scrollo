//
//  Api.swift
//  scrollo
//
//  Created by Artem Strelnik on 22.06.2022.
//

import SwiftUI

let API_URL = "http://scrollo.matreshkavpn.com"

//MARK: Signin
let API_AUTH = "/api/v1/auth/login/email"
//MARK: Signup
let API_SEND_CONFIRM_CODE = "/api/v1/auth/email-confirmation/start"
let API_CHECK_EMAIL = "/api/v1/user/check-email/"
let API_CHECK_LOGIN = "/api/v1/user/check-login/"
let API_EMAIL_CONFIRM = "/api/v1/auth/email-confirmation/confirm"
let API_SIGN_UP = "/api/v1/auth/sign-in/email-confirmation"

//MARK: Add Post
let API_ADD_POST = "/api/v1/post/"
//MARK: Get user posts
let API_USER_GET_POST = "/api/v1/post/user/"

let API_GET_FEED_POST = "/api/v1/post/feed"
let API_USER_FIND = "/api/v1/user/finding/"
let API_URL_LIKE = "/api/v1/post/like/"
let API_URL_DISLIKE = "/api/v1/post/dislike/"

//MARK: Comments
let API_GET_COMMENTS = "/api/v1/post/comments/"
let API_URL_ADD_COMMENT = "/api/v1/post/comment/"
let API_URL_ADD_REPLY_COMMENT = "/api/v1/post/comment-reply"
let API_LIKE_COMMENT = "/api/v1/post/comment/like"
let API_LIKE_REMOVE_COMMENT = "/api/v1/post/comment/like/"
let API_REPLY_LIKE = "/api/v1/post/comment-reply/like"

//MARK: Get user
let API_GET_USER = "/api/v1/user/"

//MARK: Edit user
let API_EDIT_USER = "/api/v1/user/"
let API_UPDATE_USER_BACKGROUND = "/api/v1/user/background"
let API_UPDATE_USER_AVATAR = "/api/v1/user/avatar"
//MARK: Change profile on lock or unlock
let API_USER_SWITCH_TYPE = "/api/v1/user/switch-type"
//MARK: Change password
let API_CHANGE_PASSWORD = "/api/v1/user/password"
let API_COMPARE_OLD_PASSWORD = "/api/v1/user/compare-old-password"
//MARK: Notifications settings
let API_NOTIFY_SETTINGS = "/api/v1/user/notification-settings"
//MARK: Confidentiality settings
let API_CONFIDENTIALITY = "/api/v1/user/confidentiality"

let API_CHECK_FOLLOW_ON_USER = "/api/v1/follow/followed-on-him/"
let API_FOLLOW_ON_USER = "/api/v1/follow/"
