// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Manually import controllers
import HelloController from "controllers/hello_controller"
import CommentsController from "controllers/comments_controller"
import CommentsToggleController from "controllers/comments_toggle_controller"
import ImagePreviewController from "controllers/image_preview_controller"
import LikesController from "controllers/likes_controller"
import ModalController from "controllers/modal_controller"
import TubesCursorController from "controllers/tubes_cursor_controller"

// New controllers from _head.html.haml refactoring
import TimeUpdatesController from "controllers/time_updates_controller"
import LocaleSwitcherController from "controllers/locale_switcher_controller"
import AvatarPreviewController from "controllers/avatar_preview_controller"
import AosController from "controllers/aos_controller"

// Register controllers
application.register("hello", HelloController)
application.register("comments", CommentsController)
application.register("comments-toggle", CommentsToggleController)
application.register("image-preview", ImagePreviewController)
application.register("likes", LikesController)
application.register("modal", ModalController)
application.register("tubes-cursor", TubesCursorController)

// Register new controllers
application.register("time-updates", TimeUpdatesController)
application.register("locale-switcher", LocaleSwitcherController)
application.register("avatar-preview", AvatarPreviewController)
application.register("aos", AosController)
